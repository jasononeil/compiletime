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

    #if macro
        static function toExpr(v:Dynamic) 
        {
            return Context.makeExpr(v, Context.currentPos());
        }
    #end
}