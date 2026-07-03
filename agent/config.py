import json
from pathlib import Path


class Config:

    def __init__(self):

        self.root = Path(__file__).resolve().parent.parent

        self.config_file = self.root / "config" / "portable.json"

        self.data = {}

    def load(self):

        if self.config_file.exists():

            with open(self.config_file, "r", encoding="utf-8") as fp:

                self.data = json.load(fp)

        else:

            self.data = {}