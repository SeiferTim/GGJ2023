package;

import states.PlayState;

@:build(macros.MapBuilder.build()) // MapList
@:build(macros.UpgradesBuilder.build()) // UpgradesList
class Globals
{
	public static var initialized:Bool = false;

	public static var PlayState:PlayState;

	public static function initGame():Void
	{
		if (initialized)
			return;

		Actions.init();

		initialized = true;
	}
}
