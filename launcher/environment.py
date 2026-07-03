import os

from launcher.paths import Paths


class Environment:

    def __init__(self):

        self.paths = Paths()

    def build(self):

        self.paths.ensure()

        env = os.environ.copy()

        #
        # Portable runtime
        #

        env["HOME"] = str(self.paths.project_root)

        env["XDG_CONFIG_HOME"] = str(self.paths.config)

        env["XDG_CACHE_HOME"] = str(self.paths.cache)

        env["XDG_STATE_HOME"] = str(self.paths.state)

        env["TMPDIR"] = str(self.paths.runtime)

        env["TEMP"] = str(self.paths.runtime)

        env["TMP"] = str(self.paths.runtime)

        #
        # Workspace
        #

        env["PORTABLE_HERMES_ROOT"] = str(self.paths.project_root)

        env["PORTABLE_HERMES_WORKSPACE"] = str(self.paths.workspace)

        return env
