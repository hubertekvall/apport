package apport.core;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;
import apport.core.Apport;
import apport.core.Router;
import apport.core.Parser.Response;
import apport.core.Parser.Request;




class Apport{
	var socket : Socket = new Socket();
	var router : Router = new Router();

	public function new(?port : Int = 80, ?addr : String = "0.0.0.0", ?blocking = false){
		socket.bind(new Host(addr), port);
		socket.listen(4);
		socket.setBlocking(blocking);
	}


	public function run() : Void{

		// Get connection; return if the socket is null 
		var conn = socket.accept();
		if (conn == null) {  return; }

		// Parse the request
		var request = Parser.parse(conn);

		// Generate a new response object that we will pass to the routehandler
		var response = new Response();

		// Find the route and send the request and response
		switch(request.type){
			case "GET":
				router.getRoutes.get(request.path)(request, response);

			case "POST":
				router.postRoutes.get(request.path)(request, response);
		}

		var msg = response.toMessage();
		conn.output.prepare(msg.length);
		conn.output.write(msg);

		conn.close();
	}



	public function get(id : String, fun : Dynamic){
		router.getRoutes.set(id, fun);
	}

	public function post(id : String, fun : Dynamic){
		router.postRoutes.set(id, fun);
	}





}