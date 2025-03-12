from fastapi import APIRouter, Depends, status

router = APIRouter()

@router.get('/', tags=["lobby"])
def get_lobbies():
    return "return a list of lobby items"


@router.post('/', tags=["lobby"], status_code=status.HTTP_201_CREATED)
def create_lobby():
    return "create lobby item"


@router.patch('/{lobbyId}', tags=["lobby"])
def update_note(lobbyId: str):
    return f"update lobby item with id {lobbyId}"


@router.get('/{lobbyId}', tags=["lobby"])
def get_note(lobbyId: str):
    return f"get lobby item with id {lobbyId}"


@router.delete('/{lobbyId}', tags=["lobby"])
def delete_note(lobbyId: str):
    return f"delete lobby item with id {lobbyId}"