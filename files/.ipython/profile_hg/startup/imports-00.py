import logging

logger = logging.getLogger(__name__)

print("Custom imports:")

try:
    import polars as pl # noqa: F401
    print("\timporting polars as pl")
except ImportError:
    raise ImportError("Failed to import polars. Is it installed?")