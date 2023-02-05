package objects;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Death extends FlxSprite
{
	public function new():Void
	{
		super();
		frames = FlxAtlasFrames.fromSparrow("assets/images/death.png", "assets/images/death.xml");
		animation.addByPrefix("death", "death", 12, false);

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		kill();

		animation.finishCallback = (a:String) ->
		{
			kill();
		};
	}

	public function spawn(E:Enemy):Void
	{
		reset(E.x + E.width / 2 - width / 2, E.y + E.height / 2 - height / 2);
		angle = E.angle;
		facing = E.facing;

		animation.play("death");
	}
}
