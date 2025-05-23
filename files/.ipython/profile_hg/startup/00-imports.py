import logging

logger = logging.getLogger(__name__)

print("Custom imports:")

from pathlib import Path # noqa: F401, E402
print("\timporting Path from pathlib")

try:
    import polars as pl # noqa: F401
    print("\timporting polars as pl")
except ImportError:
    raise ImportError("Failed to import polars. Is it installed?")