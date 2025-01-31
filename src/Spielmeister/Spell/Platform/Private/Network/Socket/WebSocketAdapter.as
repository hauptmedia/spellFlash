package Spielmeister.Spell.Platform.Private.Network.Socket {

	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketErrorEvent
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage

	import flash.events.SecurityErrorEvent


	public class WebSocketAdapter {
		private var socket : WebSocket
		private var onMessageCallback : Function
		private var setOnConnectedCallback : Function


		public function WebSocketAdapter( url : String, origin : String, protocol : String ) {
			socket = new WebSocket( url, origin, protocol )
			socket.connect()

			socket.addEventListener(
				WebSocketEvent.OPEN,
				function( event : WebSocketEvent ) : void {
					setOnConnectedCallback()
				}
			)

			socket.addEventListener(
				WebSocketEvent.CLOSED,
				function( event : WebSocketEvent ) : void {
//					trace( 'Socket closed connection.' )
				}
			)

			socket.addEventListener(
				WebSocketErrorEvent.CONNECTION_FAIL,
				function( event : WebSocketErrorEvent ) : void {
//					trace( 'Error on socket: ' + event.text )
				}
			)

			socket.addEventListener(
				SecurityErrorEvent.SECURITY_ERROR,
				function( event : SecurityErrorEvent ) : void {
//					trace( 'Security error on socket: ' + event.text )
				}
			)

			socket.addEventListener(
				WebSocketErrorEvent.IO_ERROR,
				function( event : WebSocketErrorEvent ) : void {
//					trace( 'IO error on socket: ' + event.text )
				}
			)

			socket.addEventListener(
				WebSocketEvent.MESSAGE,
				function( event : WebSocketEvent ) : void {
					if( event.message.type === WebSocketMessage.TYPE_UTF8 ) {
//						trace( "Received message: " + event.message.utf8Data )

						onMessageCallback( event.message.utf8Data )

					} else if( event.message.type === WebSocketMessage.TYPE_BINARY ) {
						trace( "Got binary message of length " + event.message.binaryData.length )
					}
				}
			)
		}

		public function send( message : String ) : void {
			socket.sendUTF( message )
		}

		public function setOnMessage( callback : Function ) : void {
			onMessageCallback = callback
		}

		public function setOnConnected( callback : Function ) : void {
			setOnConnectedCallback = callback
		}
	}
}
