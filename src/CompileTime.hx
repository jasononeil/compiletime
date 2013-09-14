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

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Format;
import haxe.Json;
using StringTools;
using Lambda;

class CompileTime 
{
    /** Inserts a date object of the date and time that this was compiled */
    macro public static function buildDate() {
        var date = Date.now();
        var year = toExpr(date.getFullYear());
        var month = toExpr(date.getMonth());
        var day = toExpr(date.getDate());
        var hours = toExpr(date.getHours());
        var mins = toExpr(date.getMinutes());
        var secs = toExpr(date.getSeconds());
        return macro new Date($year, $month, $day, $hours, $mins, $secs);
    }

    /** Returns a string of the date and time that this was compiled */
    macro public static function buildDateString() {
        return toExpr(Date.now().toString());
    }

    /** Reads a file at compile time, and inserts the contents into your code as a string.  The file path is resolved using `Context.resolvePath`, so it will search all your class paths */
    macro public static function readFile(path:String) {
        return toExpr(loadFileAsString(path));
    }

    /** Reads a file at compile time, and inserts the contents into your code as an interpolated string, similar to using 'single $quotes'.  */
    macro public static function interpolateFile(path:String) {
        return Format.format( toExpr(loadFileAsString(path)) );
    }

    /** Same as readFile, but checks that the file is valid Json */
    macro public static function readJsonFile(path:String) {
        var content = loadFileAsString(path);
        try Json.parse(content) catch (e:Dynamic) {
            haxe.macro.Context.error("Json failed to validate: " + Std.string(e), Context.currentPos());
        }
        return toExpr(content);
    }

    /** Same as readFile, but checks that the file is valid Json */
    macro public static function parseJsonFile(path:String) {
        var content = loadFileAsString(path);
        var obj = try Json.parse(content) catch (e:Dynamic) {
            haxe.macro.Context.error("Json failed to validate: " + Std.string(e), Context.currentPos());
        }
        return toExpr(obj);
    }

    /** Same as readFile, but checks that the file is valid Xml */
    macro public static function readXmlFile(path:String) {
        var content = loadFileAsString(path);
        try Xml.parse(content) catch (e:Dynamic) {
            haxe.macro.Context.error("Xml failed to validate: " + Std.string(e), Context.currentPos());
        }
        return toExpr(content);
    }

    /** Import a package at compile time.  Is a simple mapping to haxe.macro.Compiler.include(), but means you don't have to wrap your code in conditionals. */
    macro public static function importPackage(path:String, ?recursive:Bool = true, ?ignore : Array<String>, ?classPaths : Array<String>) {
        haxe.macro.Compiler.include(path, recursive, ignore, classPaths);
        return toExpr(0);
    }

    /** Returns an Array of Classes.  By default it will return all classes, but you can also search for classes in a particular package, 
    classes that extend a particular type, and you can choose whether to look for classes recursively or not. */
    macro public static function getAllClasses(?inPackage:String, ?includeChildPackages:Bool = true, ?extendsBaseClass:ExprOf<Class<Dynamic>>) {
        var p = Context.currentPos();
        var baseClass:ClassType = getClassTypeFromExpr(extendsBaseClass);
        var baseClassName:String = (baseClass == null) ? "" : baseClass.pack.join('.') + '.' + baseClass.name;
        var listIDExpr = toExpr(inPackage + "," + includeChildPackages + "," + baseClassName);
        Context.onGenerate(checkForMatchingClasses.bind(inPackage, includeChildPackages, baseClass, listIDExpr, p));
        return macro CompileTimeClassList.get($listIDExpr);
    }

    #if macro
        static function toExpr(v:Dynamic) {
            return Context.makeExpr(v, Context.currentPos());
        }

        static function loadFileAsString(path:String) {
            try {
                var p = haxe.macro.Context.resolvePath(path);
                return sys.io.File.getContent(p);
            } 
            catch(e:Dynamic) {
                return haxe.macro.Context.error('Failed to load file $path: $e', Context.currentPos());
            }
        }

        static function isSameClass(a:ClassType, b:ClassType):Bool {
            return (
                a.pack.join(".") == b.pack.join(".")
                && a.name == b.name 
            );
        }

        static function isSubClassOfBaseClass(subClass:ClassType, baseClass:ClassType):Bool {
            var sClass = subClass;
            while (sClass.superClass != null)
            {
                sClass = sClass.superClass.t.get();
                if (isSameClass(baseClass, sClass)) { return true; }
            }
            return false;
        }

        static function getClassTypeFromExpr(e:Expr):ClassType {
            var ct:ClassType = null;
            var fullClassName = null;
            var parts = new Array<String>();
            var nextSection = e.expr;
            while (nextSection != null) {
                // Break the loop unless we explicitly encounter a next section...
                var s = nextSection;
                nextSection = null;

                switch (s) {
                    // Might be a direct class name, no packages
                    case EConst(c):
                        switch (c) {
                            case CIdent(s):
                                if (s != "null") parts.unshift(s);
                            default:
                        }
                    // Might be a fully qualified package name
                    // { expr => EField({ expr => EField({ expr => EConst(CIdent(sys)), pos => #pos(src/server/Server.hx:35: characters 53-56) },db), pos => #pos(src/server/Server.hx:35: characters 53-59) },Object), pos => #pos(src/server/Server.hx:35: characters 53-66) }
                    case EField(e, field):
                        parts.unshift(field);
                        nextSection = e.expr;
                    default:
                }
            }
            fullClassName = parts.join(".");
            if (fullClassName != "") {
                switch (Context.getType(fullClassName)) {
                    case TInst(classType, _):
                        ct = classType.get();
                    default:
                        throw "Currently CompileTime.getAllClasses() can only search by package name or base class, not interface, typedef etc.";
                }
            }
            return ct;
        }

        static function checkForMatchingClasses(?inPackage:String, ?includeChildPackages:Bool = true, ?baseClass:ClassType, listIDExpr:Expr, p:Position, arr:Array<haxe.macro.Type>) {
            var classesFound:Array<String> = [];
            for (type in arr) {
                switch (type) {
                    // We only care for Classes 
                    case TInst(t, _):
                        var include = true;

                        // Check if it belongs to a certain package or subpackage
                        if (inPackage != null) {
                            if (includeChildPackages) {
                                if (t.toString().startsWith(inPackage) == false) 
                                    include = false;
                            }
                            else {
                                var re = new EReg("^" + inPackage + "\\.([A-Z][a-zA-Z0-9]*)$", "");
                                if (re.match(t.toString()) == false)
                                    include = false;
                            }
                        }

                        // Check if it is a subclass of a certain type
                        if (baseClass != null) {
                            if (isSubClassOfBaseClass(t.get(), baseClass) == false)
                                include = false;
                        }

                        if (include) 
                            classesFound.push(t.toString()); 
                    default:
                }
            }

            // Create a list of all the qualified class names
            var classNames = classesFound.map(function (c) { return c.toString(); });
            var classNamesExpr = toExpr(classNames.join(","));

            // Get the CompileTimeClassList class
            var ct:ClassType = null;
            switch (Context.getType("CompileTimeClassList")) {
                case TInst(classType, _):
                    ct = classType.get();
                default:
            }

            // If the @classLists metadata already exists, get a copy of it and remove it
            // (We'll re-add it in a minute)
            var classListsMetaArray:Array<Expr>;
            if (ct.meta.has('classLists')) {
                classListsMetaArray = ct.meta.get().filter(function (i) { return i.name == "classLists"; })[0].params;
                ct.meta.remove('classLists');
            }
            else {
                classListsMetaArray = [];
            }
            
            // Add the class names to CompileTimeClassList as metadata
            var itemAsArray = macro [$listIDExpr, $classNamesExpr];
            classListsMetaArray.push(itemAsArray);
            ct.meta.add('classLists', classListsMetaArray, Context.currentPos());

            return;
        }
    #end
}