from fastapi_template.util import get_random_int, get_random_string


def test_get_random_int() -> None:
    x = get_random_int(1, 10)
    assert x >= 1
    assert x <= 10


def test_get_random_string() -> None:
    x = get_random_string(10)
    assert len(x) == 10
