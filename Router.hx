package;


import Parser;


class Router{

	public var getRoutes : Map<String, Request->Response-> Void> = new Map();
	public var postRoutes : Map<String, Request->Response-> Void> = new Map();

	public function new(){

	}
}