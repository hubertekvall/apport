package;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;



class Apport{
	var socket : Socket = new Socket();
	var router : Router = new Router();

	public function new(?port : Int = 80, ?addr : String = "0.0.0.0"){
	
		socket.bind(new Host(addr), port);
		socket.listen(4);
	}


	public function run() : Void{

		var conn = socket.accept();
		if(conn == null){ trace("Nope"); return; }
		
		var line : String;
		do{
			line = conn.input.readLine();
			
		}while(line.length > 0);

		var messageLength = Std.string(Bytes.ofString("Hello").length);
		var response = "HTTP/1.1 200 OK"+"\r\n" + "Content-type: text/html" + "\r\n" + "Content-length: "+ messageLength + "\r\n" + "Hello" + "\r\n" +"\r\n\r\n";
		var bytes = Bytes.ofString(response);
		conn.output.prepare(bytes.length);
		conn.output.write(bytes);
		conn.close();

	}

	public static function main(){
		var app = new Apport(3000, "127.0.0.1");

		app.run();
	}


}