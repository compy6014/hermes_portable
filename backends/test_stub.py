import os
import platform
from pathlib import Path


def main():

    print("\n==============================")
    print(" PortableHermes Test Backend ")
    print("==============================\n")

    print("[Backend] System info:")
    print("  OS:", platform.system())
    print("  Release:", platform.release())
    print("  Python:", platform.python_version())

    print("\n[Backend] Environment variables (portable):")

    keys = [
        "PORTABLE_HERMES_ROOT",
        "PORTABLE_HERMES_WORKSPACE",
        "XDG_CACHE_HOME",
        "XDG_STATE_HOME",
        "TMPDIR"
    ]

    for k in keys:
        print(f"  {k} = {os.environ.get(k)}")

    print("\n[Backend] Workspace check:")

    workspace = os.environ.get("PORTABLE_HERMES_WORKSPACE")

    if workspace:
        path = Path(workspace)
        path.mkdir(parents=True, exist_ok=True)

        test_file = path / "test_write.txt"
        test_file.write_text("PortableHermes test OK")

        print(f"  Wrote test file: {test_file}")

    print("\n[Backend] Test completed successfully.\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
