extends Node
signal message_received(message)
signal connection_established()
signal connection_closed()

#var websocket_url: String = "ws://127.0.0.1:8000/ws"
var websocket_peer: WebSocketPeer
	

	
func connect_to_server(websocket_url:String) -> void:
	#var tls_options = TLSOptions.client_unsafe()
	#websocket_url = "ws://127.0.0.1:8000/ws/"
	print(websocket_url)
	websocket_peer = WebSocketPeer.new()
	#var err = websocket_peer.connect_to_url(websocket_url, tls_options)
	var err = websocket_peer.connect_to_url(websocket_url)
	if err != OK:
		print("Failed to connect to server: ", err)
		return
	set_process(true)

func _process(_delta: float) -> void:
	if websocket_peer:
		websocket_peer.poll()
		var state = websocket_peer.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			emit_signal("connection_established")
			while websocket_peer.get_available_packet_count() > 0:
				var packet = websocket_peer.get_packet().get_string_from_utf8()
				var data: Dictionary = JSON.parse_string(packet)
				
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


func close_connection() -> void:
	if websocket_peer and websocket_peer.get_ready_state() == WebSocketPeer.STATE_OPEN:
		websocket_peer.close()
		print("Close message sent; waiting for connection to close...")
	
	var timeout := 1.0
	var elapsed := 0.0
	while websocket_peer.get_ready_state() != WebSocketPeer.STATE_CLOSED and elapsed < timeout:
		websocket_peer.poll()
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	print("WebSocket connection closed, elapsed:", elapsed)
	set_process(false)
