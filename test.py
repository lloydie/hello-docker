def func(x):
    return x + 1

def test_docker():
    docker image ls
    return 0

def test_answer():
    assert func(3) == 4

def test_docker():
    assert docker_test() == 1
