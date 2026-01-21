"""Entrypoint for python -m python_app."""

import os

from . import run


def main() -> None:
    port = int(os.environ.get("APP_PORT", "8080"))
    run(port)


if __name__ == "__main__":
    main()
