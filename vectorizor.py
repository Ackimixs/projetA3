from CLParser import CLParser
import sys


def main():
    parser = CLParser(sys.argv)
    print(parser.get_option("file", "Data_Arbre.csv"))


if __name__ == "__main__":
    main()
