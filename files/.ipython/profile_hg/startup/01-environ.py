import os

print("Custom environment variables:")

os.environ["QT_QPA_PLATFORM"] = "xcb"
print(f"\t{os.environ['QT_QPA_PLATFORM']=}")

try:
    import ipdb # noqa: F401
    os.environ["PYTHONBREAKPOINT"] = "ipdb.set_trace"
    print(f"\t{os.environ['PYTHONBREAKPOINT']=}")
except ImportError:
    raise ImportError("Failed to import ipdb. Using defualt debugger.")
