import asyncio
import websockets
import json
import random

connected_clients = set()  # save all connected clients

def roll_dice():
    dice1 = random.randint(1, 6)
    dice2 = random.randint(1, 6)

    return {"action":"roll_dice","dice1": dice1, "dice2": dice2}

async def handler(websocket):
    """New connection handler."""
    connected_clients.add(websocket)
    print(f"🔗 New client is connected: {websocket.remote_address}")

    try:
        async for message in websocket:
            print(f"📩 Message received: {message}")
            response = None
            data = json.loads(message)
            if data.get("action") == "roll_dice":
                result = roll_dice()
                response = json.dumps(result)
                print(response)
                # Send response to all connected clients
                await asyncio.gather(
                    *[client.send(response) for client in connected_clients]
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
