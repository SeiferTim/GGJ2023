package macros;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

using StringTools;

class MapBuilder
{
	@:access(flixel.system.macros.FlxAssetPaths.addFileReferences)
	public static macro function build():Array<Field>
	{
		var fields = Context.getBuildFields();
		var map:Array<Expr> = [];
		var e:Expr;
		var json:haxe.DynamicAccess<Dynamic>;
		var mapData:MapStructure;

		for (file in flixel.system.macros.FlxAssetPaths.addFileReferences([], 'assets/data/maps/', false, ~/^.*\.(tmj)$/ig))
		{
			if (!file.name.startsWith("_"))
			{
				json = tjson.TJSON.parse(sys.io.File.getContent(file.value));
				mapData = {
					height: Std.int(json.get("height")),
					width: Std.int(json.get("width")),
					layers: cast(json.get("layers"), Array<Dynamic>),
					tilesets: cast(json.get("tilesets"), Array<Dynamic>),
				};

				e = macro new objects.GameMap($v{mapData});
				map.push(macro $e{e});
			}
		}

		fields.push({
			pos: Context.currentPos(),
			name: "MapList",
			meta: null,
			kind: FieldType.FVar(macro :Array<objects.GameMap>, macro $a{map}),
			doc: null,
			access: [Access.APublic, Access.AStatic]
		});

		return fields;
	}
}

typedef MapStructure =
{
	var height:Int;
	var width:Int;
	var layers:Array<Dynamic>;
	var tilesets:Null<Array<Dynamic>>;
}
