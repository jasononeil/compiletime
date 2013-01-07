import pack.*;
import pack.sub1.*;
import pack.sub2.*;

class Example 
{
	static function main()
	{
		var date = CompileTime.buildDate();						// Equivalent of writing `new Date(2012,11,25,20,48,15);`
		var dateAsString = CompileTime.buildDateString();		// A string saying "2012-12-25 20:48:15"
		var file = CompileTime.readFile("README.md");			// Reads the contents of README.md as a String.
		var xmlString = CompileTime.readXmlFile("haxelib.xml");	// Reads the contents of haxelib.xml as a String, but checks that it is valid XML

		CompileTime.importPackage("pack");						// Imports every class in that package

		var allClasses = CompileTime.getAllClasses();					// Get every class that is compiled.  You probably don't ever want this.
		assert(allClasses.length > 10);

		var packClasses = CompileTime.getAllClasses("pack");			// Get every class in package "pack"
		assert(packClasses.length == 10);

		var packClassesOnly = CompileTime.getAllClasses("pack", false);	// Get every class in package "pack", but ignore sub-packages
		assert(packClassesOnly.length == 2);

		var packSub1Classes = CompileTime.getAllClasses("pack.sub1");	// Get every class in package "pack.sub1"
		assert(packSub1Classes.length == 4);

		var packSub2Classes = CompileTime.getAllClasses("pack.sub2");	// Get every class in package "pack.sub2"
		assert(packSub2Classes.length == 4);

		var baseAClasses = CompileTime.getAllClasses(BaseA);			// Get every class that inherits BaseA, no matter which package
		assert(baseAClasses.length == 4);

		var baseBClasses = CompileTime.getAllClasses(BaseB);			// Get every class that inherits BaseB, no matter which package
		assert(baseBClasses.length == 4);

		var baseBClasses = CompileTime.getAllClasses(pack.BaseB);		// You can also use a fully qualified class name
		assert(baseBClasses.length == 4);

		var BaseBPackSub1Classes = CompileTime.getAllClasses("pack.sub1", BaseB);	// Get every class in package "pack.sub1" that inherits BaseB
		assert(BaseBPackSub1Classes.length == 2);

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