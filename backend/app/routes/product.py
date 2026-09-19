from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.db.dependencies import get_database
from app.models.product import Product
from app.models.user import AppUser
from app.schemas.product import ProductCreate, ProductResponse
from app.services.audit_context import set_audit_context
from app.auth.authorization import require_manager_or_admin


router = APIRouter(prefix="/products", tags=["Products"])


@router.get("", response_model=list[ProductResponse])
def get_products(
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(get_current_user),
):
    statement = select(Product).order_by(Product.product_id)
    products = db.scalars(statement).all()
    return products


@router.post("", response_model=ProductResponse, status_code=201)
def create_product(
    product_data: ProductCreate,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    try:
        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Created product through FastAPI",
            client_id=None,
        )

        product = Product(
            name=product_data.name,
            category=product_data.category,
            price=product_data.price,
            stock_quantity=product_data.stock_quantity,
            is_active=product_data.is_active,
        )

        db.add(product)
        db.commit()
        db.refresh(product)

        return product

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Product could not be created.",
        )

    except Exception:
        db.rollback()
        raise


@router.put("/{product_id}", response_model=ProductResponse)
def update_product(
    product_id: int,
    product_data: ProductCreate,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    product = db.get(Product, product_id)

    if product is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    try:
        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Updated product through FastAPI",
            client_id=None,
        )

        product.name = product_data.name
        product.category = product_data.category
        product.price = product_data.price
        product.stock_quantity = product_data.stock_quantity
        product.is_active = product_data.is_active

        db.commit()
        db.refresh(product)

        return product

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Product could not be updated.",
        )

    except Exception:
        db.rollback()
        raise


@router.delete("/{product_id}")
def delete_product(
    product_id: int,
    db: Session = Depends(get_database),
    current_user: AppUser = Depends(require_manager_or_admin),
):
    product = db.get(Product, product_id)

    if product is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    try:
        set_audit_context(
            db=db,
            user_id=current_user.user_id,
            reason="Deleted product through FastAPI",
            client_id=None,
        )

        db.delete(product)
        db.commit()

        return {
            "message": "Product deleted successfully",
            "product_id": product_id,
        }

    except Exception:
        db.rollback()
        raise