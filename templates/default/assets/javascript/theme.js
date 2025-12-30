// Default theme JavaScript for fddl

document.addEventListener('DOMContentLoaded', function() {
    console.log('fddl site loaded successfully');

    // Add smooth scrolling to anchor links
    const links = document.querySelectorAll('a[href^="#"]');
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });

    // Add copy button to code blocks
    const codeBlocks = document.querySelectorAll('pre code');
    codeBlocks.forEach(block => {
        const button = document.createElement('button');
        button.textContent = 'Copy';
        button.className = 'copy-button';
        button.style.cssText = 'position: absolute; top: 5px; right: 5px; padding: 5px 10px; font-size: 12px;';

        const pre = block.parentElement;
        pre.style.position = 'relative';
        pre.appendChild(button);

        button.addEventListener('click', function() {
            navigator.clipboard.writeText(block.textContent).then(() => {
                button.textContent = 'Copied!';
                setTimeout(() => {
                    button.textContent = 'Copy';
                }, 2000);
            });
        });
    });
});
