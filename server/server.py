import asyncio
import websockets
import json
import random

connected_clients = []  # save all connected clients
token = 0
player_id = 0

def roll_dice():
    dice1 = random.randint(1, 6)
    dice2 = random.randint(1, 6)
    global token
    token = (token + 1) % len(connected_clients)

    return {"action":"roll_dice","dice1": dice1, "dice2": dice2}

async def handler(websocket):
    global player_id
    """New connection handler."""
    connected_clients.append(websocket)
    await asyncio.gather(
                    *[client.send(json.dumps({"action":"client_connected", "id": player_id})) for client in connected_clients]
                )
    await asyncio.gather(
                    websocket.send(json.dumps({"action":"client_connected", "id": player_id}) for i in range(0,len(connected_clients) - 1))
                )
    
    
    player_id += 1
    print(f"🔗 New client is connected: {websocket.remote_address}")

    try:
        async for message in websocket:
            print(f"📩 Message received: {message}")
            response = None
            data = json.loads(message)
            if data.get("action") == "roll_dice" and websocket == connected_clients[token]:
                print(websocket)
                response = json.dumps(roll_dice())
                print(response)
                # Send response to all connected clients
                await asyncio.gather(
                    *[client.send(response) for client in connected_clients]
                )
                await asyncio.gather(
                    *[client.send(json.dumps({"action": "change_token", "token" : token})) for client in connected_clients]
                )
            else:
                print(f"Unknown action: {data.get('action')}")
    except websockets.exceptions.ConnectionClosed:
        print(f"❌ Client {websocket.remote_address} is disconnected")
    finally:
        connected_clients.remove(websocket)

async def main():
    async with websockets.serve(handler, "", 8080):
        print("🟢 WebSocket server start on port 8080")
        await asyncio.Future()  # infinite loop

if __name__ == "__main__":
    asyncio.run(main())
