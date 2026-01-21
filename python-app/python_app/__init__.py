"""Minimal package for CI build and tests."""

__all__ = ["add", "__version__"]

__version__ = "0.1.0"


def add(a: int, b: int) -> int:
    """Return the sum of two integers."""
    return a + b
