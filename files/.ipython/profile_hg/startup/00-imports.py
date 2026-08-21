import logging

logger = logging.getLogger(__name__)

print("Custom imports:")

IMP_WARN = "\t!! Failed to import {0}. Is it installed?"

# numpy
try:
    import numpy as np  # noqa: F401

    print("\timporting numpy as np")
except ImportError as _:
    logger.warning(IMP_WARN.format("numpy"))

# matplotlib namespaces
try:
    import matplotlib as mpl  # noqa: F401

    print("\tmatplotlib as mpl")

    import matplotlib.pyplot as plt  # noqa: F401

    print("\timporting matplotlib.pyplot as plt")
except ImportError as _:
    logger.warning(IMP_WARN.format("matplotlib"))


# polars
try:
    import polars as pl  # noqa: F401

    print("\timporting polars as pl")
except ImportError as _:
    logger.warning(IMP_WARN.format("polars"))

# rich
try:
    from rich import pretty

    pretty.install()
    print("\timporting and installing rich")
except ImportError as _:
    logger.warning(IMP_WARN.format("rich"))
