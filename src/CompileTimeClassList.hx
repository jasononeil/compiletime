	using Lambda;

class CompileTimeClassList 
{
	static var lists:Hash<List<Class<Dynamic>>> = null;
	
	public static function get(id:String)
	{
		if (lists == null) initialise();
		return lists.get(id);
	}

	static function initialise()
	{
		lists = new Hash();
		var m = haxe.rtti.Meta.getType(CompileTimeClassList);
		if (m.classLists != null)
		{
			var allLists:Array<Array<String>> = m.classLists;
			for (item in allLists)
			{
				var listID = item[0];
				var classes = item[1].split(',').map(function (typeName) {
					return Type.resolveClass(typeName);
				});
				lists.set(listID, classes);
			}
		}
	}
}