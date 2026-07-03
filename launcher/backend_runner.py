import os
import subprocess
from pathlib import Path

from launcher.paths import Paths
from launcher.config import PortableConfig
from launcher.environment import Environment


class BackendRunner:

    def __init__(self):

        self.paths = Paths()

        self.config = PortableConfig()

        self.env_builder = Environment()

    def load_config(self):

        data = self.config.load()

        return data

    def resolve_backend(self, config: dict) -> str:

        # Default backend if none defined
        return config.get("backend", "test_stub")

    def run(self):

        config = self.load_config()

        backend = self.resolve_backend(config)

        env = self.env_builder.build()

        backend_map = {

            "test_stub": self.run_test_stub,

            "hermes": self.run_hermes_placeholder,

            "llama_cpp": self.run_llama_cpp_placeholder,
        }

        if backend not in backend_map:

            raise Exception(f"Unknown backend: {backend}")

        return backend_map[backend](env)

    # ---------------------------------------------------------------------
    # BACKEND: TEST STUB
    # ---------------------------------------------------------------------

    def run_test_stub(self, env: dict):

        script = self.paths.project_root / "backends" / "test_stub.py"

        print("[Launcher] Running test backend...")

        return subprocess.call(
            ["python3", str(script)],
            env=env
        )

    # ---------------------------------------------------------------------
    # BACKEND: HERMES (placeholder)
    # ---------------------------------------------------------------------

    def run_hermes_placeholder(self, env: dict):

        print("[Launcher] Hermes backend not installed yet.")

        return 0

    # ---------------------------------------------------------------------
    # BACKEND: LLAMA.CPP (placeholder)
    # ---------------------------------------------------------------------

    def run_llama_cpp_placeholder(self, env: dict):

        print("[Launcher] llama.cpp backend not configured yet.")

        return 0
