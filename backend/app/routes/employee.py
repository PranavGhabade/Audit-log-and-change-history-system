from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.auth.authorization import require_manager_or_admin
from app.db.dependencies import get_database
from app.models.employee import Employee
from app.models.user import AppUser
from app.schemas.employee import EmployeeCreate, EmployeeResponse
from app.services.audit_context import set_audit_context


router = APIRouter(
    prefix="/employees",
    tags=["Employees"],
)


@router.get(
    "",
    response_model=list[EmployeeResponse],
)
def get_employees(
    db: Session = Depends(get_database),
):
    statement = select(Employee).order_by(Employee.employee_id)

    employees = db.scalars(statement).all()

    return employees


@router.post(
    "",
    response_model=EmployeeResponse,
    status_code=201,
)
def create_employee(
    employee_data: EmployeeCreate,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    try:
        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Created employee through FastAPI",
            client_id=None,
        )

        employee = Employee(
            name=employee_data.name,
            email=employee_data.email,
            department=employee_data.department,
            designation=employee_data.designation,
            salary=employee_data.salary,
            is_active=employee_data.is_active,
        )

        db.add(employee)
        db.commit()
        db.refresh(employee)

        return employee

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="An employee with this email already exists.",
        )

    except Exception:
        db.rollback()
        raise


@router.put("/{employee_id}", response_model=EmployeeResponse)
def update_employee(
    employee_id: int,
    employee_data: EmployeeCreate,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    employee = db.get(Employee, employee_id)

    if employee is None:
        raise HTTPException(
            status_code=404,
            detail="Employee not found",
        )

    try:
        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Updated employee through FastAPI",
            client_id=None,
        )

        employee.name = employee_data.name
        employee.email = employee_data.email
        employee.department = employee_data.department
        employee.designation = employee_data.designation
        employee.salary = employee_data.salary
        employee.is_active = employee_data.is_active

        db.commit()
        db.refresh(employee)

        return employee

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="An employee with this email already exists.",
        )

    except Exception:
        db.rollback()
        raise


@router.delete("/{employee_id}")
def delete_employee(
    employee_id: int,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    employee = db.get(Employee, employee_id)

    if employee is None:
        raise HTTPException(
            status_code=404,
            detail="Employee not found",
        )

    try:
        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Deleted employee through FastAPI",
            client_id=None,
        )

        db.delete(employee)
        db.commit()

        return {
            "message": "Employee deleted successfully",
            "employee_id": employee_id,
        }

    except Exception:
        db.rollback()
        raise