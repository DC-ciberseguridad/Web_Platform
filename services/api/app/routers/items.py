from fastapi import APIRouter

router = APIRouter(prefix="/items", tags=["items"])

@router.get("")
def list_items():
    return [
        {"id": 1, "name": "Item A"},
        {"id": 2, "name": "Item B"}
    ]