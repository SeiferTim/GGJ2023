package macros;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

using StringTools;

class UpgradesBuilder
{
	public static macro function build():Array<Field>
	{
		var fields = Context.getBuildFields();
		var map:Array<Expr> = [];
		var e:Expr;

		var list:Array<Dynamic> = tjson.TJSON.parse(sys.io.File.getContent("assets/data/upgrades.json"));

		for (l in 0...list.length)
		{
			e = macro new objects.UpgradeData($v{list[l]});
			map.push(macro $v{list[l].name} => $e{e});
		}

		fields.push({
			pos: Context.currentPos(),
			name: "UpgradeList",
			meta: null,
			kind: FieldType.FVar(macro :Map<String, objects.UpgradeData>, macro $a{map}),
			doc: null,
			access: [Access.APublic, Access.AStatic]
		});

		return fields;
	}
}
