Compile Time
============

Simple Haxe Macro Helpers that let you do or get things at compile-time.

Usage
-----

```haxe
// Compile date and time

var date = CompileTime.buildDate();						// Equivalent of writing `new Date(2012,11,25,20,48,15);`
var dateAsString = CompileTime.buildDateString();		// A string saying "2012-12-25 20:48:15"

// Compile git commit sha

var sha = CompileTime.buildGitCommitSha();
//'104ad4e'

// Read a file

var file = CompileTime.readFile("README.md"); // will be compiled as an ordinary string in your code

// Read a file and use String Interpolation

var name="Jason", age=25;
var greeting = CompileTime.interpolateFile("test.txt");
	// Reads the contents of test.txt, and interpolates local values, similar to single quote string interpolation
	// Same as writing greeting = 'Hello my name is $name and I am ${age-5} years old'
	// Result will be "Hello my name is Jason and I am 20 years old";

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

// Parse the JSON file, so it is inserted as an object declaration into the code.
// This has the added benefit of giving you compile time typing and autocompletion.

var yamlObject = CompileTime.parseYamlFile("test.yaml");
var yamlObject:Person = CompileTime.parseYamlFile("test.yaml"); // Check the type is correct.

// Read a markdown file, convert to HTML and check the result is valid XML.  Will give a compile time error if it doesn't validate.

var htmlString = CompileTime.readMarkdownFile("test.md");	// Will insert it as a HTML String.  
Xml.parse(htmlString);

// Get lists of classes that have been compiled

// Returns a list of all the classes in the "my.package" package, including sub-packages
CompileTime.getAllClasses("my.package");

// Returns a list of only the classes in the "my.package" package, so not including sub-packages
CompileTime.getAllClasses("my.package", false);

// Returns a list of all the classes that inherit MySuperClass, no matter what package
CompileTime.getAllClasses(MySuperClass);

// Returns a list of all the classes in the "my.package" package that inherit MySuperClass.
CompileTime.getAllClasses("my.package", MySuperClass);

// Returns a list of all the classes that implement MyInterface, no matter what package.
CompileTime.getAllClasses(MyInterface);

// Returns a list of all the classes in the "my.package" package that implement MyInterface.
CompileTime.getAllClasses("my.package", MyInterface);

```
