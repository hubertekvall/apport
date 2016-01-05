package apport.core;

import sys.net.Socket;
import haxe.io.Bytes;
import apport.core.Router;





class MessageHandler{

	
	public static function readRequest(socket : Socket) : Request{

		var request = new Request();
		var headers = new Array<String>();
		var line : String;

		do{
			line = socket.input.readLine();
			headers.push(line);
		} while(line.length > 0);

		var firstLine = headers.shift();
		request.method = firstLine.substr(0, 4).split(" ")[0].toUpperCase();
		request.path = firstLine.split(" ")[1];
		
		for (h in headers) {
			var split = h.split(":");
			request.headers[split[0]] = split[1];
		}

		return request;
	}
	
	
	
	
	public static function sendMessage(message : HTTPMessage, socket : Socket) {
		socket.output.prepare(message.bytes.length);
		socket.output.write(message.bytes);
	}


}






class Request extends HTTPMessage{

	public var route : Route;
	
	public function get(name : String) : Dynamic {
		return route.extractParameterPosition(name, path);	
	}

}








class Response extends HTTPMessage{
	
	public function write(?content = "", ?status = "200", ?contentType = "text/html"){
		this.content = content;
		this.status = status;	
		headers["Content-type"] = contentType;
	}

	public override function compose() {
		
		var messageString = "HTTP/1.1 " + status + " " + HTTPMessage.statusCodes[status] + "\r\n";
		
		for (k in headers.keys()) {
			messageString += k + ": " + headers[k] + "\r\n";	
		}
		
		messageString += "\r\n";
		messageString += content;
		bytes = Bytes.ofString(messageString);
	}
}





class HTTPMessage {
	
	public static var statusCodes = [
		"200" => "OK"
	];
	
	public var headers : Map<String, String> = new Map();
	public var method : String;
	public var path : String;
	public var status : String;
	public var content : String;
	public var bytes : Bytes;
	
	public function compose(){}
	
}


