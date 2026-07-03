from pathlib import Path


class Paths:

    def __init__(self):

        self.project_root = Path(__file__).resolve().parent.parent

        self.config = self.project_root / "config"

        self.runtime = self.project_root / "runtime"

        self.state = self.project_root / "state"

        self.cache = self.project_root / "cache"

        self.logs = self.project_root / "logs"

        self.workspace = self.project_root / "workspace"

        self.vendor = self.project_root / "vendor"

        self.hermes = self.vendor / "hermes"

    def ensure(self):

        directories = (
            self.runtime,
            self.state,
            self.cache,
            self.logs,
            self.workspace,
        )

        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
