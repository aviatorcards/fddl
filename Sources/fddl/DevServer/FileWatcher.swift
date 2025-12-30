import Foundation

/// Watches a directory for file changes and triggers rebuild
class FileWatcher {
    private let watchedDirectory: URL
    private var source: DispatchSourceFileSystemObject?
    private let queue = DispatchQueue(label: "dev.fddl.filewatcher")
    private var fileDescriptor: CInt = -1

    var onChange: (() -> Void)?

    init(directory: URL) {
        self.watchedDirectory = directory
    }

    func start() throws {
        let path = watchedDirectory.path

        // Open the directory
        fileDescriptor = open(path, O_EVTONLY)
        guard fileDescriptor >= 0 else {
            throw FileWatcherError.cannotOpenDirectory(path)
        }

        // Create dispatch source
        source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .extend, .delete, .rename],
            queue: queue
        )

        // Set up event handler
        source?.setEventHandler { [weak self] in
            self?.handleFileSystemEvent()
        }

        // Set up cancel handler to close file descriptor
        source?.setCancelHandler { [weak self] in
            if let fd = self?.fileDescriptor, fd >= 0 {
                close(fd)
            }
        }

        // Start monitoring
        source?.resume()

        print("👀 Watching for changes in: \(path)")
    }

    func stop() {
        source?.cancel()
        source = nil
    }

    private func handleFileSystemEvent() {
        // Debounce rapid file changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.onChange?()
        }
    }
}

enum FileWatcherError: LocalizedError {
    case cannotOpenDirectory(String)

    var errorDescription: String? {
        switch self {
        case .cannotOpenDirectory(let path):
            return "Cannot open directory for watching: \(path)"
        }
    }
}
