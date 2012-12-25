class Example 
{
	static function main()
	{
		var date = CompileTime.buildDate();						// Equivalent of writing `new Date(2012,11,25,20,48,15);`
		var dateAsString = CompileTime.buildDateString();		// A string saying "2012-12-25 20:48:15"
		var file = CompileTime.readFile("README.md");			// Reads the contents of README.md as a String.
		var xmlString = CompileTime.readXmlFile("haxelib.xml");	// Reads the contents of haxelib.xml as a String, but checks that it is valid XML
	}
}