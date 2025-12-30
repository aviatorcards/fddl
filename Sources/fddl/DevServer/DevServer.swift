import Foundation
import NIOCore
import NIOPosix
import NIOHTTP1
import NIOWebSocket
import NIOExtras

/// Development server with live reload support
class DevServer {
    private let host: String
    private let port: Int
    private let documentRoot: URL
    private var group: MultiThreadedEventLoopGroup?
    private var channel: Channel?
    private var webSocketChannels: [ObjectIdentifier: Channel] = [:]
    private let webSocketLock = NSLock()

    init(host: String = "127.0.0.1", port: Int = 8080, documentRoot: URL) {
        self.host = host
        self.port = port
        self.documentRoot = documentRoot
    }

    func start() throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        self.group = group

        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                let config = NIOHTTPServerUpgradeConfiguration(
                    upgraders: [self.createWebSocketUpgrader()],
                    completionHandler: { context in
                        // HTTP upgrade completed, handler will be replaced by WebSocket handler
                    }
                )

                return channel.pipeline.configureHTTPServerPipeline(withServerUpgrade: config).flatMap {
                    channel.pipeline.addHandler(HTTPHandler(documentRoot: self.documentRoot, server: self))
                }
            }
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)

        let channel = try bootstrap.bind(host: host, port: port).wait()
        self.channel = channel

        print("🚀 Dev server running at http://\(host):\(port)")
        print("   Press Ctrl+C to stop")

        // Keep the server running
        try channel.closeFuture.wait()
    }

    func stop() throws {
        try channel?.close().wait()
        try group?.syncShutdownGracefully()
    }

    func notifyReload() {
        webSocketLock.lock()
        defer { webSocketLock.unlock() }

        for (_, channel) in webSocketChannels {
            let frame = WebSocketFrame(
                fin: true,
                opcode: .text,
                data: channel.allocator.buffer(string: "reload")
            )
            channel.writeAndFlush(frame, promise: nil)
        }
    }

    func addWebSocketChannel(_ channel: Channel) {
        webSocketLock.lock()
        defer { webSocketLock.unlock() }
        webSocketChannels[ObjectIdentifier(channel)] = channel
    }

    func removeWebSocketChannel(_ channel: Channel) {
        webSocketLock.lock()
        defer { webSocketLock.unlock() }
        webSocketChannels.removeValue(forKey: ObjectIdentifier(channel))
    }

    private func createWebSocketUpgrader() -> NIOWebSocketServerUpgrader {
        return NIOWebSocketServerUpgrader(
            shouldUpgrade: { channel, head in
                return channel.eventLoop.makeSucceededFuture(HTTPHeaders())
            },
            upgradePipelineHandler: { channel, req in
                let handler = WebSocketHandler(server: self)
                return channel.pipeline.addHandler(handler)
            }
        )
    }
}

/// Handles HTTP requests
final class HTTPHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart

    private let documentRoot: URL
    private let server: DevServer
    private var requestHead: HTTPRequestHead?

    init(documentRoot: URL, server: DevServer) {
        self.documentRoot = documentRoot
        self.server = server
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let request = unwrapInboundIn(data)

        switch request {
        case .head(let head):
            requestHead = head

        case .end:
            guard let head = requestHead else { return }
            serveFile(context: context, path: head.uri)
            requestHead = nil

        case .body:
            break
        }
    }

    private func serveFile(context: ChannelHandlerContext, path: String) {
        var filePath = path
        if filePath == "/" {
            filePath = "/index.html"
        }

        // Clean path
        filePath = filePath.split(separator: "?")[0].description

        let fileURL = documentRoot.appendingPathComponent(filePath)

        // Security check: ensure file is within documentRoot
        guard fileURL.path.hasPrefix(documentRoot.path) else {
            sendResponse(context: context, status: .forbidden, body: "Forbidden")
            return
        }

        // Try to read file
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            sendResponse(context: context, status: .notFound, body: "Not Found")
            return
        }

        do {
            var content = try String(contentsOf: fileURL, encoding: .utf8)

            // Inject live reload script for HTML files
            if filePath.hasSuffix(".html") {
                content = injectLiveReloadScript(into: content)
            }

            let contentType = mimeType(for: filePath)
            sendResponse(context: context, status: .ok, body: content, contentType: contentType)
        } catch {
            sendResponse(context: context, status: .internalServerError, body: "Error reading file")
        }
    }

    private func sendResponse(
        context: ChannelHandlerContext,
        status: HTTPResponseStatus,
        body: String,
        contentType: String = "text/html; charset=utf-8"
    ) {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: contentType)
        headers.add(name: "Content-Length", value: String(body.utf8.count))

        let head = HTTPResponseHead(version: .http1_1, status: status, headers: headers)
        context.write(wrapOutboundOut(.head(head)), promise: nil)

        var buffer = context.channel.allocator.buffer(capacity: body.utf8.count)
        buffer.writeString(body)
        context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }

    private func injectLiveReloadScript(into html: String) -> String {
        let script = """
        <script>
        (function() {
            const ws = new WebSocket('ws://' + location.host + '/ws');
            ws.onmessage = function(e) {
                if (e.data === 'reload') {
                    console.log('🔄 Reloading...');
                    location.reload();
                }
            };
            ws.onclose = function() {
                console.log('⚠️  Dev server connection lost. Retrying...');
                setTimeout(function() { location.reload(); }, 1000);
            };
            console.log('👀 Live reload connected');
        })();
        </script>
        """

        if let bodyIndex = html.range(of: "</body>", options: .caseInsensitive) {
            var modified = html
            modified.insert(contentsOf: script, at: bodyIndex.lowerBound)
            return modified
        }

        return html + script
    }

    private func mimeType(for path: String) -> String {
        if path.hasSuffix(".html") { return "text/html; charset=utf-8" }
        if path.hasSuffix(".css") { return "text/css; charset=utf-8" }
        if path.hasSuffix(".js") { return "application/javascript; charset=utf-8" }
        if path.hasSuffix(".json") { return "application/json; charset=utf-8" }
        if path.hasSuffix(".png") { return "image/png" }
        if path.hasSuffix(".jpg") || path.hasSuffix(".jpeg") { return "image/jpeg" }
        if path.hasSuffix(".gif") { return "image/gif" }
        if path.hasSuffix(".svg") { return "image/svg+xml" }
        if path.hasSuffix(".ico") { return "image/x-icon" }
        return "text/plain; charset=utf-8"
    }
}

/// Handles WebSocket connections for live reload
final class WebSocketHandler: ChannelInboundHandler {
    typealias InboundIn = WebSocketFrame
    typealias OutboundOut = WebSocketFrame

    private let server: DevServer

    init(server: DevServer) {
        self.server = server
    }

    func channelActive(context: ChannelHandlerContext) {
        server.addWebSocketChannel(context.channel)
    }

    func channelInactive(context: ChannelHandlerContext) {
        server.removeWebSocketChannel(context.channel)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let frame = unwrapInboundIn(data)

        switch frame.opcode {
        case .connectionClose:
            context.close(promise: nil)
        case .ping:
            let pongFrame = WebSocketFrame(
                fin: true,
                opcode: .pong,
                data: frame.data
            )
            context.writeAndFlush(wrapOutboundOut(pongFrame), promise: nil)
        default:
            break
        }
    }
}
