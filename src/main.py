import sys
from rich import print


def main():
    print(sys.version)
    multiply(5, 4)


def multiply(a: int, b: int):
    print(a * b)


if __name__ == "__main__":
    main()
