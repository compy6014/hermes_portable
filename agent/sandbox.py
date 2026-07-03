from pathlib import Path


class Sandbox:

    def __init__(self, config):

        self.config = config

        self.root = Path(__file__).resolve().parent.parent

        self.workspace = self.root / "workspace"

    def initialize(self):

        self.workspace.mkdir(parents=True, exist_ok=True)