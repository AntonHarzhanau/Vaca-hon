extends Node

signal message_received(message: String)
signal connection_established()
signal connection_closed()

var websocket_url: String = "ws://127.0.0.1:8000/ws"
var websocket_peer: WebSocketPeer

func _ready() -> void:
	connect_to_server()

func connect_to_server() -> void:
	websocket_peer = WebSocketPeer.new()
	var err = websocket_peer.connect_to_url(websocket_url)
	if err != OK:
		print("Failed to connect to server: ", err)
		return
	set_process(true)

func _process(delta: float) -> void:
	if websocket_peer:
		websocket_peer.poll()
		var state = websocket_peer.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			emit_signal("connection_established")
			while websocket_peer.get_available_packet_count() > 0:
				var packet = websocket_peer.get_packet().get_string_from_utf8()
				var data = JSON.parse_string(packet)
				if data != null:
					emit_signal("message_received", data)
				else:
					print("Error parsing response from server")
		elif state == WebSocketPeer.STATE_CLOSED:
			print("Connection is closed")
			emit_signal("connection_closed")
			set_process(false)

func send_message(message: String) -> void:
	if websocket_peer and websocket_peer.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var err = websocket_peer.send_text(message)
		if err != OK:
			print("Error sending message: ", err)
		else:
			print("Message sent: ", message)
	else:
		print("WebSocket is not connected.")
