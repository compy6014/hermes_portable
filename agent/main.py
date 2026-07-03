#!/usr/bin/env python3

import sys

from runtime import Runtime


def main() -> int:

    runtime = Runtime()

    try:
        runtime.initialize()
        runtime.run()

    except KeyboardInterrupt:
        print("PortableHermes interrupted.")
        return 130

    except Exception as exc:
        print(f"Fatal error: {exc}")
        return 1

    finally:
        runtime.shutdown()

    return 0


if __name__ == "__main__":
    sys.exit(main())