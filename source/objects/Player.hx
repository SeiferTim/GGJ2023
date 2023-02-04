package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public static inline var GRAVITY:Float = 1200;
	public static inline var MAX_VELOCITY:Float = 400;
	public static inline var MOVE_SPEED:Float = 200;
	public static inline var JUMP_SPEED:Float = 600;
	public static inline var JUMP_TIME:Float = 0.2;

	public var jumpTimer:Float = 0;

	public function new():Void
	{
		super();
		makeGraphic(32, 32, FlxColor.GREEN);

		centerOrigin();

		acceleration.y = GRAVITY;

		maxVelocity.y = MAX_VELOCITY;
	}

	override public function update(elapsed:Float):Void
	{
		velocity.x = 0;

		var left:Bool = Actions.left.check();
		var right:Bool = Actions.right.check();
		var jump:Bool = Actions.up.check();

		if (left && right)
			left = right = false;

		if (left)
			velocity.x -= MOVE_SPEED;
		else if (right)
			velocity.x += MOVE_SPEED;

		if (jump && isTouching(FLOOR))
		{
			velocity.y = -JUMP_SPEED;
			jumpTimer = JUMP_TIME;
		}
		else if (jump && jumpTimer > 0)
		{
			velocity.y = -JUMP_SPEED;
			jumpTimer -= elapsed;
		}
		else
			jumpTimer = 0;

		super.update(elapsed);
	}
}
