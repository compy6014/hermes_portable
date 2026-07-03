import json

from launcher.paths import Paths


class PortableConfig:

    def __init__(self):

        self.paths = Paths()

        self.file = self.paths.config / "portable.json"

        self.data = {}

    def load(self):

        with open(self.file, encoding="utf-8") as fp:
            self.data = json.load(fp)

        return self.data
