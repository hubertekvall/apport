package apport.core;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;
import apport.core.Apport;
import apport.core.Router;
import apport.core.MessageHandler;
import apport.core.MessageHandler;




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
		var request = MessageHandler.readRequest(conn);

		// Generate a new response object that we will pass to the routehandler
		var response = new Response();

		// Find the route and send the request and response
		var route = router.findRoute(request.method, request.path);
		request.route = route;
		route.fun(request, response);

		response.compose();
		MessageHandler.sendMessage(response, conn);

		conn.close();
	}



	public function post(path : String, fun : Dynamic) {
		router.addRoute("POST", path, fun);
	}


	public function get(path : String, fun : Dynamic){
		router.addRoute("GET", path, fun);
	}
	
	
	public function error(fun : Dynamic){
		router.errorHandler = fun;
	}





}