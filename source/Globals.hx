package;

import flixel.FlxG;
import objects.UpgradeData;
import states.PlayState;

class Globals
{
	public static var initialized:Bool = false;

	public static var PlayState:PlayState;

	public static var UpgradeList:Array<UpgradeData> = [];

	public static function initGame():Void
	{
		if (initialized)
			return;

		FlxG.autoPause = false;

		Actions.init();

		createUpgradeList();

		trace(UpgradeList);

		initialized = true;
	}

	private static function createUpgradeList():Void
	{
		UpgradeList.push(new UpgradeData("Increased Damage", "Increases damage by {x}%.", "damage", [10, 20, 30, 40, 50]));

		UpgradeList.push(new UpgradeData("Increased Fire Rate", "Increases fire rate by {x}%.", "fireRate", [10, 20, 30, 40, 50]));

		UpgradeList.push(new UpgradeData("Increased Speed", "Increases Movement Speed by {x}%.", "moveSpeed", [10, 20, 30, 40, 50]));

		UpgradeList.push(new UpgradeData("Reduced Stun Time", "Reduces Stun Time by {x}%.", "stunTime", [10, 20, 30, 40, 50]));

		UpgradeList.push(new UpgradeData("Spread Shot", "Fires {x} extra projectile.", "spread", [1, 2, 3, 4, 5]));
	}
}
