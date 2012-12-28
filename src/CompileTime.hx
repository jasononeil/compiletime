/****
* Copyright (c) 2012 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

import haxe.macro.Context;

class CompileTime 
{
    /** Inserts a date object of the date and time that this was compiled */
    @:macro public static function buildDate() {
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
    @:macro public static function buildDateString() {
        return toExpr(Date.now().toString());
    }

    /** Reads a file at compile time, and inserts the contents into your code as a string. */
    @:macro public static function readFile(path:String) {
        return toExpr(sys.io.File.getContent(path));
    }

    /** Same as readFile, but checks that the file is valid Xml */
    @:macro public static function readXmlFile(path:String) {
        var content = sys.io.File.getContent(path);

        try
        {
            Xml.parse(content);
        } 
        catch (e:Dynamic)
        {
            haxe.macro.Context.error("Xml failed to validate: " + Std.string(e), Context.currentPos());
        }

        return toExpr(content);
    }

    /** Include a package at compile time.  Is a simple mapping to haxe.macro.Compiler.include(), but means you don't have to wrap your code in conditionals. */
    @:macro public static function includePackage(path:String, ?recursive:Bool = true, ?ignore : Array<String>, ?classPaths : Array<String>)
    {
        #if macro 
            haxe.macro.Compiler.include(path, recursive, ignore, classPaths);
        #end
    }

    #if macro
        static function toExpr(v:Dynamic) 
        {
            return Context.makeExpr(v, Context.currentPos());
        }
    #end
}