class CLParser:
    def __init__(self, argv):
        self._argv = argv
        self._argc = len(argv)
        self._options = {}

        i = 1
        while i < self._argc:
            if self._argv[i].startswith("--"):
                option = self._argv[i][2:]
                values = []
                i += 1
                while i < self._argc and not self._argv[i].startswith("--"):
                    values.append(self._argv[i])
                    i += 1
                self._options[option] = values if values else [""]
            else:
                i += 1

    def get_option(self, option, default_value=None) -> list:
        if option in self._options:
            return self._options[option]
        return default_value

    def get_one_option(self, option, default_value=None) -> str:
        if option in self._options:
            return self._options[option][0]
        return default_value

    def has_option(self, option):
        return option in self._options

    def has_positional_argument(self, index):
        return index < self._argc

    def get_positional_argument(self, index):
        if not self.has_positional_argument(index):
            return ""
        return self._argv[index]

    def positional_arguments_count(self):
        return self._argc
