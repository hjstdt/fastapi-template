from src.main import multiply


def test_multiplication(capsys):
    multiply(5, 4)
    captured = capsys.readouterr()
    assert "20" in captured.out
