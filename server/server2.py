from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import json
import random
import uvicorn
from connection_manager import ConnectionManager
from game_logic import GameLogic

app = FastAPI()

manager = ConnectionManager()
game = GameLogic(manager.players)
token = 0
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    global token
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_json()
            #TODO: Вынести в отдельный hendler
            print(data)
            if data["action"] == "roll_dice" and manager.players[manager.active_connections[websocket]].id == token:
                response = json.dumps(game.roll_dice())
                await manager.broadcast(response)
            if data["action"] == "move_player":
                response = game.move_player(token, data["steps"])
                await manager.broadcast(json.dumps(response))
            if data["action"] == "end_turn" and manager.players[manager.active_connections[websocket]].id == token:
                token = game.players[((token + 1) % len(manager.active_connections))].id 
                await manager.broadcast(json.dumps({"action": "change_turn", "player_id": token
                }))
            if data["action"] == "cell_activate":
                response = game.cell_action(token)
                await manager.send_personal_message(json.dumps(response), websocket)
                # await manager.broadcast(json.dumps(response))
            if data["action"] == "accepted_offre":
                response = game.buy_property(token)
                await manager.broadcast(json.dumps(response))
            if data["action"] == "sell_property":
                response = game.sell_property(token, data["cell_id"])
                await manager.broadcast(json.dumps(response))

    except WebSocketDisconnect:
        await manager.disconnect(websocket)
        

# uvicorn server2:app --host 0.0.0.0 --port 8000 --reload
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)