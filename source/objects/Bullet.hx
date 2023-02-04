package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	// generic class for bullets/projectiles/etc from the player or from enemies
	public function new():Void
	{
		super();
		makeGraphic(12, 12, FlxColor.WHITE);
		kill();
	}

	public function spawn(X:Float, Y:Float, FromPlayer:Bool, Angle:Float = 0, Speed:Float = 0):Void
	{
		reset(X - width / 2, Y - height / 2);
		color = FromPlayer ? FlxColor.LIME : FlxColor.ORANGE;
		velocity.setPolarRadians(Speed, Angle);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (y < -height || y > FlxG.height || x < -width || x > FlxG.width)
			kill();
	}
}
