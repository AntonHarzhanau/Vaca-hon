from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import json
import random

app = FastAPI()

connected_clients = []  # Список подключенных клиентов
token = 0  # Индекс активного игрока
player_id = 0  # ID нового игрока


def roll_dice():
    """Функция броска кубиков и смены игрока"""
    global token
    dice1 = random.randint(1, 6)
    dice2 = random.randint(1, 6)
    
    if len(connected_clients) > 0:
        token = (token + 1) % len(connected_clients)  # Переход хода

    return {"action": "roll_dice", "dice1": dice1, "dice2": dice2}


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    global player_id
    global token
    await websocket.accept()

    # Присваиваем ID новому клиенту и добавляем его в список
    client_info = {"ws": websocket, "id": player_id}
    connected_clients.append(client_info)
    print(f"🔗 Новый клиент подключен: ID {player_id}")
    for i in range(len(connected_clients) - 1):
        client_connected_message = json.dumps({"action": "client_connected", "id": connected_clients[i]["id"]})
        await websocket.send_text(client_connected_message)
    # Рассылаем всем клиентам информацию о новом подключении
    client_connected_message = json.dumps({"action": "client_connected", "id": player_id})
    for client in connected_clients:
        await client["ws"].send_text(client_connected_message)

    player_id += 1  # Увеличиваем ID для следующего игрока

    try:
        while True:
            message = await websocket.receive_text()
            print(f"📩 Получено сообщение: {message}")

            data = json.loads(message)
            action = data.get("action")

            if action == "roll_dice":
                # Проверяем, может ли этот клиент бросать кости (он должен быть активным)
                if websocket == connected_clients[token]["ws"]:
                    print(f"🎲 Бросок кубиков от {connected_clients[token]['id']}")
                    
                    response = roll_dice()
                    response_json = json.dumps(response)

                    # Рассылаем всем клиентам результаты броска
                    for client in connected_clients:
                        await client["ws"].send_text(response_json)

                    # Сообщаем всем, чей ход
                    token_message = json.dumps({"action": "change_token", "token": token})
                    for client in connected_clients:
                        await client["ws"].send_text(token_message)
                else:
                    print(f"⛔ Игрок {connected_clients[token]['id']} не может бросать кости сейчас")
            else:
                print(f"⚠️ Неизвестное действие: {action}")

    except WebSocketDisconnect:
        print(f"❌ Клиент {client_info['id']} отключился")
        connected_clients.remove(client_info)  # Удаляем клиента из списка

        # Обновляем токен хода, если игрок отключился во время своей очереди
        if len(connected_clients) > 0 and token >= len(connected_clients):
            token = 0

        # Оповещаем оставшихся клиентов
        for client in connected_clients:
            await client["ws"].send_text(json.dumps({"action": "player_disconnected", "id": client_info["id"]}))

# uvicorn server:app --host 0.0.0.0 --port 8000 --reload
