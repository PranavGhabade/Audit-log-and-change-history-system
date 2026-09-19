from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_login_success():
    response = client.post(
        "/auth/login",
        json={
            "username": "manager",
            "password": "ManagerTest123",
        },
    )

    assert response.status_code == 200
    data = response.json()
    assert data["username"] == "manager"
    assert data["role"] == "MANAGER"
    assert "access_token" in data


def test_login_failure():
    response = client.post(
        "/auth/login",
        json={
            "username": "manager",
            "password": "WrongPassword",
        },
    )

    assert response.status_code == 401


def test_employee_write_requires_authentication():
    response = client.post(
        "/employees",
        json={
            "name": "Pytest Employee",
            "email": "pytest.employee@example.com",
            "department": "Testing",
            "designation": "Tester",
            "salary": 30000,
            "is_active": True,
        },
    )

    assert response.status_code == 401


def test_product_write_requires_authentication():
    response = client.post(
        "/products",
        json={
            "name": "Pytest Product",
            "category": "Testing",
            "price": 100,
            "stock_quantity": 10,
            "is_active": True,
        },
    )

    assert response.status_code == 401


def test_employee_cannot_create_product():
    login_response = client.post(
        "/auth/login",
        json={
            "username": "employee1",
            "password": "EmployeeTest123",
        },
    )

    assert login_response.status_code == 200

    token = login_response.json()["access_token"]

    response = client.post(
        "/products",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "name": "Unauthorized Test Product",
            "category": "Testing",
            "price": 100,
            "stock_quantity": 5,
            "is_active": True,
        },
    )

    assert response.status_code == 403
    assert response.json()["detail"] == "Insufficient permissions"


def test_audit_integrity():
    login_response = client.post(
        "/auth/login",
        json={
            "username": "manager",
            "password": "ManagerTest123",
        },
    )

    assert login_response.status_code == 200

    token = login_response.json()["access_token"]

    response = client.get(
        "/audit/integrity",
        headers={"Authorization": f"Bearer {token}"},
    )

    assert response.status_code == 200

    data = response.json()

    assert data["is_valid"] is True
    assert data["first_invalid_audit_id"] is None