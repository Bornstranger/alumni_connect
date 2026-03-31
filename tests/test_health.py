from rest_framework import status


def test_admin_url_exists(client):
    response = client.get("/admin/", follow=True)
    assert response.status_code == status.HTTP_200_OK


def test_api_root_returns_404(client):
    """API root has no default view yet, so it should 404."""
    response = client.get("/api/")
    assert response.status_code == status.HTTP_404_NOT_FOUND
