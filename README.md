# apport
Haxe micro web-framework

# Status
Apport is currently just a proof of concept; help is appreciated!

# How to use
```haxe
    var app = new Apport(3000, 0.0.0.0);
    
    // Static get route
    app.get("/", function(req, res){
        res.write("Hello world!", "200", "text/html");
    });
    
    // Dynamic REST-style route
    // ':' - indicates the name and position of the parameter
    app.get("/employee/:firstname/:secondname", function(req,res){
        var fname = req.get("firstname");
        res.write("Hello " + fname + "!", "200", "text/html");
    });  
    
    // Put this inside your event loop
    // The try-catch statement is for non-blocking mode
        try {
			app.run();	
		}catch ( e : Dynamic) {}

```

#Warning
Apport is currently nowhere near production-quality, use at your own risk! 