import testinfra

def test_service_is_running_and_enabled(host):
    mongodb = host.service('mongod')
    assert mongodb.is_running
    assert mongodb.is_enabled
