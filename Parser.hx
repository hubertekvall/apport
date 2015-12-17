package;

import sys.net.Socket;


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
	public var 


	public function new(){

	}
}