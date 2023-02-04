package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public static inline var SPEED:Float = 100;

	public var onRoot:Bool = false;

	// enemies will spawn on either side of the screen
	// basic enemy type just moves towards the 'roots' in the center of the screen
	public function new():Void
	{
		super();
		makeGraphic(24, 24, FlxColor.YELLOW);
		kill();
	}

	public function spawn(X:Float, Y:Float):Void
	{
		reset(X - width / 2, Y - height / 2);
		onRoot = false;
	}

	override public function update(elapsed:Float):Void
	{
		if (!onRoot)
		{
			// move towards the center of the screen
			var angleToCenter:Float = FlxAngle.angleBetweenPoint(this, FlxPoint.weak(FlxG.width / 2, FlxG.height / 2));
			velocity.setPolarRadians(SPEED, angleToCenter);
			// if moving left, face left, otherwise face right
			// if (velocity.x < 0)
			// {
			// 	facing = LEFT;
			// 	angle = FlxAngle.asDegrees(angleToCenter) + 180;
			// }
			// else
			// {
			// 	facing = RIGHT;
			// 	angle = FlxAngle.asDegrees(angleToCenter);
			// }

			angle = FlxAngle.asDegrees(angleToCenter);
		}
		else
			velocity.set();
		super.update(elapsed);
	}
}
