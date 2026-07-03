from config import Config
from llm import LLMClient
from hermes import HermesAgent
from memory import Memory
from sandbox import Sandbox
from tools import ToolManager


class Runtime:

    def __init__(self):

        self.config = Config()

        self.memory = Memory()

        self.sandbox = Sandbox(self.config)

        self.tools = ToolManager(self.config)

        self.llm = LLMClient(self.config)

        self.agent = HermesAgent(
            llm=self.llm,
            memory=self.memory,
            tools=self.tools,
            sandbox=self.sandbox,
        )

    def initialize(self):

        print("Initializing Runtime...")

        self.config.load()

        self.sandbox.initialize()

        self.tools.initialize()

    def run(self):

        print("Runtime started.")

        self.agent.start()

    def shutdown(self):

        print("Runtime shutdown.")