package;

import sys.net.Socket;
import haxe.io.Bytes;

class Parser{

	
	public static function parse(socket : Socket){

		var request = new Request();
		var headers = new Array<String>();

		var line : String;

		do{
			line = socket.input.readLine();
			headers.push(line);
		} while(line.length > 0);

		request.type = headers[0].substr(0, 4).split(" ")[0];
		request.path = headers[0].split(" ")[1];
		

		return request;
	}


}



class Request{

	public var type : String;
	public var path : String;
	public var contentType : String;
	public var contentLength : Int;
	public var body : haxe.io.Bytes;

	public function new(){}

}


class Response{
	public var status : String = "200"; 
	public var contentType : String = "text/html";
	public var body : String = "";

	public function new(){

	}

	public function write(?body = "", ?status = "200", ?contentType = "text/html"){
		this.body = body;
		this.status = status;
		this.contentType = contentType;
	}

	public function toMessage() : haxe.io.Bytes{
		var message = 
		"HTTP/1.1 " + status + " OK" + "\r\n" + 
		"Content-type: text/html" + "\r\n" +
		"Content-length: " + Std.string(body.length) + "\r\n\r\n" +
		body; 

		return Bytes.ofString(message);	
	}
}