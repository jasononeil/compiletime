Compile Time
============

Simple Haxe Macro Helpers that let you do or get things at compile-time. 

Usage
-----

	var date = CompileTime.buildDate();						// Equivalent of writing `new Date(2012,11,25,20,48,15);`
	var dateAsString = CompileTime.buildDateString();		// A string saying "2012-12-25 20:48:15"
	var file = CompileTime.readFile("README.md");			// Reads the contents of README.md as a String.
	var xmlString = CompileTime.readXmlFile("haxelib.xml");	// Reads the contents of haxelib.xml as a String, but checks that it is valid XML
	CompileTime.importPackage("server.controllers");		// Will include all classes in the server.controllers package.

	CompileTime.getAllClasses("my.package");				// Returns a list of all the classes in the "my.package" package, including sub-packages
	CompileTime.getAllClasses("my.package", false);			// Returns a list of only the classes in the "my.package" package, so not including sub-packages
	CompileTime.getAllClasses(MySuperClass);				// Returns a list of all the classes that inherit MySuperClass, no matter what package
	CompileTime.getAllClasses("my.package", MySuperClass);	// Returns a list of all the classes in the "my.package" package that inherit MySuperClass.

Possible Future Features
------------------------

String Interpolation from a compile time file.

eg:

    var name = "Jason";
    var output = CompileTime.fileInterpolation("mytemplate.txt"); // "Hi my name is $name";
    trace (output);

Essentialy does the same as single quote mark (') string interpolation, (previously Std.format), but instead of using a string there it loads something at compile time.