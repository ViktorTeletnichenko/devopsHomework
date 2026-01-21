"""Minimal package for CI build and tests."""

__all__ = ["add", "__version__", "run"]

__version__ = "0.1.0"


def add(a: int, b: int) -> int:
    """Return the sum of two integers."""
    return a + b


def run(port: int) -> None:
    """Run a tiny HTTP server that reports the app version."""
    import http.server
    import socketserver

    class Handler(http.server.SimpleHTTPRequestHandler):
        def do_GET(self) -> None:  # noqa: N802
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(f"python-app {__version__}\\n".encode("utf-8"))

    with socketserver.TCPServer(("", port), Handler) as httpd:
        httpd.serve_forever()
