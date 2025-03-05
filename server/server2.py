from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import json
import random
import uvicorn
from connection_manager import ConnectionManager
from game_logic import GameLogic

app = FastAPI()
token = 0
manager = ConnectionManager()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    global token
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_json()
            print(data)
            print(f"token  {manager.players[manager.active_connections[websocket]].id}")
            if data["action"] == "roll_dice" and manager.players[manager.active_connections[websocket]].id == token:
                response = GameLogic().roll_dice()
                await manager.broadcast(response)
            if data["action"] == "move_player":
                response = manager.players[token].move(data["steps"])
                await manager.broadcast(response)
            if data["action"] == "end_turn":
                token = (token + 1) % len(manager.active_connections)
                print(token)
                await manager.broadcast(json.dumps({"action": "change_turn", "player_id": token
                }))

    except WebSocketDisconnect:
        await manager.disconnect(websocket)
        

# uvicorn server2:app --host 0.0.0.0 --port 8000 --reload
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)