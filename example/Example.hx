import pack.*;
import pack.sub1.*;
import pack.sub2.*;

using Lambda;

typedef Person = {
	name:String,
	age:Int,
	pets:Array<String>,
	?other:Int
}

class Example
{
	static var myObj = CompileTime.parseJsonFile("test.json");

	static function main()
	{
		var date = CompileTime.buildDate();						// Equivalent of writing `new Date(2012,11,25,20,48,15);`
		var dateAsString = CompileTime.buildDateString();		// A string saying "2012-12-25 20:48:15"
		var gitsha = CompileTime.buildGitCommitSha();			// A string that might say '104ad4e'
		var gitTagDesrc = CompileTime.buildGitTagDescription();	// A string that might say 'v1.0.2' or 'v1.0.2-104ad4e'
		var gitTag = CompileTime.buildGitTag();					// A string that might say 'v1.0.2'
		var file = CompileTime.readFile("README.md");			// Reads the contents of README.md as a String.
		var name="Jason", age=25;
		var greeting = CompileTime.interpolateFile("test.txt"); // Reads the contents of test.txt, and interpolates local values, similar to single quotes
		var xmlString = CompileTime.readXmlFile("test.xml");	// Reads the contents of text.xml as a String, but checks that it is valid XML
		// var xmlString = CompileTime.readXmlFile("broken.xml");
		var markdownHTML = CompileTime.readMarkdownFile("test.md");	// Reads the contents of text.xml as a String, but checks that it is valid XML
		var jsonString = CompileTime.readJsonFile("test.json"); // Reads the contents of text.json as a String, but checks that it is valid JSON
		// var jsonString = CompileTime.readJsonFile("broken.json");
		var jsonObject = CompileTime.parseJsonFile("test.json"); // Reads the contents of text.json, parses it, and places the resulting object in the code so no parsing happens at runtime
		var typedJsonObject:Person = CompileTime.parseJsonFile("test.json"); // Same as above, but check the result matches our typedef

		var yamlObject = CompileTime.parseYamlFile("test.yaml");  // Reads the contents of test.yaml, parses it, and places the resulting object in the code so no parsing happens at runtime

		myObj; // Set from static variable: that's pretty cool!

		CompileTime.importPackage("pack");						// Imports every class in that package

		var allClasses = CompileTime.getAllClasses();					// Get every class that is compiled.  You probably don't ever want this.
		assert(allClasses.count() > 10);

		var packClasses = CompileTime.getAllClasses("pack");			// Get every class in package "pack"
		assertEquals(10, packClasses.count());

		var packClassesOnly = CompileTime.getAllClasses("pack", false);	// Get every class in package "pack", but ignore sub-packages
		assertEquals(2, packClassesOnly.count());

		var packSub1Classes = CompileTime.getAllClasses("pack.sub1");	// Get every class in package "pack.sub1"
		assertEquals(4, packSub1Classes.count());

		var packSub2Classes = CompileTime.getAllClasses("pack.sub2");	// Get every class in package "pack.sub2"
		assertEquals(4, packSub2Classes.count());

		var packSubClasses = CompileTime.getAllClasses("pack.sub");	// Get every class in package "pack.sub" (not "pack.sub1" or "pack.sub2") - verify exact package name matching.
		assertEquals(0, packSubClasses.count());

		var baseAClasses = CompileTime.getAllClasses(BaseA);			// Get every class that inherits BaseA, no matter which package
		assertEquals(4, baseAClasses.count());

		var baseBClasses = CompileTime.getAllClasses(BaseB);			// Get every class that inherits BaseB, no matter which package
		assertEquals(4, baseBClasses.count());

		var baseBClasses = CompileTime.getAllClasses(pack.BaseB);		// You can also use a fully qualified class name
		assertEquals(4, baseBClasses.count());

		var baseBPackSub1Classes = CompileTime.getAllClasses("pack.sub1", BaseB);	// Get every class in package "pack.sub1" that inherits BaseB
		assertEquals(2, baseBPackSub1Classes.count());

		for (c in baseBPackSub1Classes)
		{
			var o = Type.createInstance(c, []);
			trace(o.b);  // sub1.1, sub1.2
		}

		var interfaceCClasses = CompileTime.getAllClasses(InterfaceC);	// Get every class that implements interface C.
		assertEquals(6, interfaceCClasses.count());

		var interfaceCClasses = CompileTime.getAllClasses("pack.sub1", InterfaceC);	// Get every class that implements interface C.
		assertEquals(3, interfaceCClasses.count());
	}

	static function assertEquals<T>(expected:T, actual:T, ?pos:haxe.PosInfos) {
		if (expected != actual) haxe.Log.trace('Failure (Expected $expected, actual $actual)',pos);
	}

	static function assert (condition:Bool, ?pos:haxe.PosInfos)
	{
		if (condition == false) haxe.Log.trace('Failure',pos);
	}
}
