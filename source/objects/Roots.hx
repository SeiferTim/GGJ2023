package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;

// not sure about this yet
// should be in the background, slowly growing down - and when attacked by the enemies, should lose health?
// game over when health is 0
class Roots extends FlxSprite
{
	public function new():Void
	{
		super();
		loadGraphic("assets/images/roots.png");

		centerOffsets();
		centerOrigin();

		origin.y = 0;
		scale.set(.01, .01);
		updateHitbox();
	}
}
