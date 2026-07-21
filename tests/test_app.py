from app.app import create_app


def test_home_page():
    client = create_app().test_client()
    response = client.get("/")

    assert response.status_code == 200
    assert b"AWS Cloud Status Dashboard" in response.data


def test_health_endpoint():
    client = create_app().test_client()
    response = client.get("/health")
    payload = response.get_json()

    assert response.status_code == 200
    assert payload["status"] == "healthy"
    assert payload["service"] == "cloud-status-dashboard"
    assert "timestamp" in payload
