class CLParser:
    def __init__(self, argv):
        self._argv = argv
        self._argc = len(argv)
        self._options = {}

        for i in range(1, self._argc):
            if self._argv[i].startswith("--"):
                option = self._argv[i][2:]
                if i + 1 < self._argc and not self._argv[i + 1].startswith("--"):
                    self._options[option] = self._argv[i + 1]
                else:
                    self._options[option] = ""

    def get_option(self, option, default_value=None):
        if option in self._options:
            return self._options[option]
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

    def parse_string(self, str_val, type_):
        try:
            if type_ == 'STRING':
                return str_val
            elif type_ == 'INT':
                return int(str_val)
            elif type_ == 'FLOAT':
                return float(str_val)
            elif type_ == 'DOUBLE':
                return float(str_val)  # Python's float is double precision
            elif type_ == 'BOOL':
                return str_val.lower() == "true"
            elif type_ == 'LONG':
                return int(str_val)
            elif type_ == 'SHORT':
                return int(str_val)  # Python does not have short, so use int
            elif type_ == 'CHAR':
                return str_val[0]
            elif type_ == 'CHAR_PTR':
                return str_val
            elif type_ == 'CONST_CHAR_PTR':
                return str_val
            else:
                raise ValueError("Invalid type")
        except ValueError:
            raise ValueError(f"Invalid value for value: {str_val}")
