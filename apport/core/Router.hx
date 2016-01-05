package apport.core;
import apport.core.Router.Route;




class Router{
	
	
	public var errorHandler : Dynamic;
	var supportedMethods = ["POST", "GET"];
	var dynamicRoutes : Map<String, Array<Route>> = new Map();
	var staticRoutes  : Map<String, Map<String, Route>> = new Map();

	public function new(){
		for (method in supportedMethods) {
			dynamicRoutes[method] = new Array();
			staticRoutes[method] = new Map();
		}
	}






	public function addRoute(method : String, path : String, fun : Dynamic){
		var route = new Route(path, fun);

		if (route.parametrized) {
			dynamicRoutes[method].push(route);
		}

		else {
			staticRoutes[method][route.path] = route;	
		}
	}


	public function findRoute(method : String, path : String) : Route {

		if(staticRoutes[method].exists(path)){
			return staticRoutes[method][path];
			trace("Found static route!");
		}

		else{
			for (route in dynamicRoutes[method]) {
				
				if(route.ereg.match(path)){
					return route;
				}
			}
	
			
		}
		
	
		return new Route(path, errorHandler);
	}
	

}









class Route{

	public var parametrized : Bool = false;
	public var parameterPositions : Map<String, Int> = new Map();
	public var ereg : EReg;
	public var path : String;
	public var fun  : Dynamic;

	public function new(path : String, fun: Dynamic){
		this.path = path;
		this.fun = fun;
		parse(path);
	}	


	function parse(path : String){
		var eregString = "^";
		var splitPath = path.split("/");
		splitPath.shift();
	
		
		for(i in 0...splitPath.length){
			eregString += "\\/";
			var characters = splitPath[i].split("");

			if(characters[0] == ":"){
				parametrized = true;
				characters.shift();
				parameterPositions[characters.join("")] = i;
				eregString += "[a-zA-Z0-9]+";
			}

			else{
				eregString += splitPath[i];
			}
		}
		eregString +"$";

		this.ereg = new EReg(eregString, "g");

	}



	public function extractParameterPosition(parameterName : String, requestedPath : String) : Dynamic{
		var splitPath = requestedPath.split("/");
		splitPath.shift();

		return splitPath[parameterPositions[parameterName]];
	}


}

