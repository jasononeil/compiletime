/****
* Copyright (c) 2013 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

using Lambda;

class CompileTimeClassList 
{
	static var lists:Map<String, List<Class<Dynamic>>> = null;
	
	public static function get(id:String)
	{
		if (lists == null) initialise();
		return lists.get(id);
	}

	static function initialise()
	{
		lists = new Map();
		var m = haxe.rtti.Meta.getType(CompileTimeClassList);
		if (m.classLists != null)
		{
			for (item in m.classLists)
			{
				var array:Array<String> = cast item;
				var listID = array[0];
				var classes = item[1].split(',').map(function (typeName) {
					return Type.resolveClass(typeName);
				});
				lists.set(listID, classes);
			}
		}
	}
}