class HermesAgent:

    def __init__(
        self,
        llm,
        memory,
        tools,
        sandbox,
    ):

        self.llm = llm

        self.memory = memory

        self.tools = tools

        self.sandbox = sandbox

    def start(self):

        print("Hermes Agent placeholder.")