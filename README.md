Compile Time
============

Simple Haxe Macro Helpers that let you do or get things at compile-time. 

Usage
-----

	// Compile date and time
	
	var date = CompileTime.buildDate();						// Equivalent of writing `new Date(2012,11,25,20,48,15);`
	var dateAsString = CompileTime.buildDateString();		// A string saying "2012-12-25 20:48:15"
	
	// Read a file
	
	var file = CompileTime.readFile("README.md"); // will be compiled as an ordinary string in your code

	// Import a whole package to make sure it's included in compilation.  Does not affect dead-code-elimination.
	
	CompileTime.importPackage("server.controllers");
	
	// Read a file, and check it is valid XML.  Will give a compile time error if it's not XML.
	
	var xmlString = CompileTime.readXmlFile("haxelib.xml");	// Will insert it as a String.  
	Xml.parse(xmlString);

	// Read a file, and check it is valid JSON.  Will give a compile time error if it's not valid Json.

	var jsonString = CompileTime.readJsonFile("test.json"); // Inserts the contents of text.json as a String

	// Parse the JSON file, so it is inserted as an object declaration into the code.
	// This has the added benefit of giving you compile time typing and autocompletion.
	
	var jsonObject = CompileTime.parseJsonFile("test.json"); 
	var typedJsonObject:Person = CompileTime.parseJsonFile("test.json"); // Same as above, but check the result matches a typedef
	
	// Get lists of classes that have been compiled

	CompileTime.getAllClasses("my.package");				// Returns a list of all the classes in the "my.package" package, including sub-packages
	CompileTime.getAllClasses("my.package", false);			// Returns a list of only the classes in the "my.package" package, so not including sub-packages
	CompileTime.getAllClasses(MySuperClass);				// Returns a list of all the classes that inherit MySuperClass, no matter what package
	CompileTime.getAllClasses("my.package", MySuperClass);	// Returns a list of all the classes in the "my.package" package that inherit MySuperClass.

Possible Future Features
------------------------

String Interpolation from a compile time file.

eg:

    var name = "Jason";
    var output = CompileTime.fileInterpolation("mytemplate.txt"); // 'Hi my name is $name';
    trace (output); // 'Hi my name is Jason';

Essentialy does the same as single quote mark (') string interpolation, (previously Std.format), but instead of using a string there it loads something at compile time.