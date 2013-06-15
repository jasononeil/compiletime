import pack.*;
import pack.sub1.*;
import pack.sub2.*;

using Lambda;

class Example 
{
	static function main()
	{
		var date = CompileTime.buildDate();						// Equivalent of writing `new Date(2012,11,25,20,48,15);`
		var dateAsString = CompileTime.buildDateString();		// A string saying "2012-12-25 20:48:15"
		var file = CompileTime.readFile("README.md");			// Reads the contents of README.md as a String.
		var xmlString = CompileTime.readXmlFile("test.xml");	// Reads the contents of text.xml as a String, but checks that it is valid XML
		var jsonString = CompileTime.readJsonFile("test.json"); // Reads the contents of text.json as a String, but checks that it is valid JSON
		var jsonObject = CompileTime.parseJsonFile("test.json"); // Reads the contents of text.json, parses it, and places the resulting object in the code so no parsing happens at runtime

		CompileTime.importPackage("pack");						// Imports every class in that package

		var allClasses = CompileTime.getAllClasses();					// Get every class that is compiled.  You probably don't ever want this.
		assert(allClasses.count() > 10);

		var packClasses = CompileTime.getAllClasses("pack");			// Get every class in package "pack"
		assert(packClasses.count() == 10);

		var packClassesOnly = CompileTime.getAllClasses("pack", false);	// Get every class in package "pack", but ignore sub-packages
		assert(packClassesOnly.count() == 2);

		var packSub1Classes = CompileTime.getAllClasses("pack.sub1");	// Get every class in package "pack.sub1"
		assert(packSub1Classes.count() == 4);

		var packSub2Classes = CompileTime.getAllClasses("pack.sub2");	// Get every class in package "pack.sub2"
		assert(packSub2Classes.count() == 4);

		var baseAClasses = CompileTime.getAllClasses(BaseA);			// Get every class that inherits BaseA, no matter which package
		assert(baseAClasses.count() == 4);

		var baseBClasses = CompileTime.getAllClasses(BaseB);			// Get every class that inherits BaseB, no matter which package
		assert(baseBClasses.count() == 4);

		var baseBClasses = CompileTime.getAllClasses(pack.BaseB);		// You can also use a fully qualified class name
		assert(baseBClasses.count() == 4);

		var BaseBPackSub1Classes = CompileTime.getAllClasses("pack.sub1", BaseB);	// Get every class in package "pack.sub1" that inherits BaseB
		assert(BaseBPackSub1Classes.count() == 2);

		for (c in BaseBPackSub1Classes)
		{
			var o = Type.createInstance(c, []);
			trace (o.b);  // sub1.1, sub1.2
		}

	}

	static function assert (condition:Bool)
	{
		if (condition == false) throw "Error...";
	}
}