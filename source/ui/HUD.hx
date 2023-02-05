package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class HUD extends FlxTypedGroup<FlxSprite>
{
	// HUD should contain the current Wave number, the time remaining, and the root health.
	var waveNumber:FlxText;
	var timeRemaining:FlxText;
	var rootHealth:FlxText;
	var roundedTime:String;

	public function new():Void
	{
		super();
		// wave
		waveNumber = new FlxText(20, FlxG.height - 20, 0, "0", 16);
		// timer
		timeRemaining = new FlxText(0, FlxG.height - 20, 0, "0", 16);
		timeRemaining.screenCenter(FlxAxes.X);
		rootHealth.alignment = CENTER;
		// root health
		rootHealth = new FlxText(FlxG.width - 40, FlxG.height - 20, 0, "100", 16);
		rootHealth.alignment = RIGHT;

		add(waveNumber);
		add(timeRemaining);
		add(rootHealth);
		// forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHUD(wave:Int, time:Float, health:Int)
	{
		// wave
		waveNumber.text = "Wave " + wave;
		// timer
		roundedTime = Std.string(Std.int(time));
		if (roundedTime == "60")
			timeRemaining.text = "01:00";
		else
			timeRemaining.text = "00:" + StringTools.lpad(roundedTime, "0", 2);
		// root health
		rootHealth.text = "Root Health:" + health + "%";
	}
}
