from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.db.dependencies import get_database
from app.models.order import Order
from app.models.user import AppUser
from app.schemas.order import OrderCreate, OrderResponse
from app.services.audit_context import set_audit_context
from app.auth.authorization import require_manager_or_admin


router = APIRouter(prefix="/orders", tags=["Orders"])


@router.get("", response_model=list[OrderResponse])
def get_orders(
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(get_current_user),
):
    statement = select(Order).order_by(Order.order_id)
    orders = db.scalars(statement).all()
    return orders


@router.post("", response_model=OrderResponse, status_code=201)
def create_order(
    order_data: OrderCreate,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    try:
        # Make sure the order belongs to the authenticated user.
        order = Order(
            user_id=current_user.user_id,
            product_id=order_data.product_id,
            quantity=order_data.quantity,
            total_amount=order_data.total_amount,
            status=order_data.status,
        )

        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Created order through FastAPI",
            client_id=None,
        )

        db.add(order)
        db.commit()
        db.refresh(order)

        return order

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=400,
            detail="Invalid product or order data.",
        )

    except Exception:
        db.rollback()
        raise


@router.put("/{order_id}", response_model=OrderResponse)
def update_order(
    order_id: int,
    order_data: OrderCreate,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    order = db.get(Order, order_id)

    if order is None:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    try:
        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Updated order through FastAPI",
            client_id=None,
        )

        order.product_id = order_data.product_id
        order.quantity = order_data.quantity
        order.total_amount = order_data.total_amount
        order.status = order_data.status

        db.commit()
        db.refresh(order)

        return order

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=400,
            detail="Invalid product or order data.",
        )

    except Exception:
        db.rollback()
        raise