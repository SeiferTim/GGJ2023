package ui;

import flixel.group.FlxGroup;

class HUD extends FlxGroup
{
	// HUD should contain the current Wave number, the time remaining, and the root health.
	var waveNumber:FlxText;
	var timeRemaining:FlxText;
	var rootHealth:FlxText;

	public function new():Void
	{
		super();
		// wave
		waveNumber = new FlxText(20, FlxG.height - 20,, "0", 12);
		// timer
		timeRemaining = new FlxText(0, FlxG.height - 20,, "0", 12);
		timeRemaining.screenCenter(X);
		// root health
		rootHealth = new FlxText(FlxG.width - 20, FlxG.height - 20, 0, "100", 12);
		rootHealth.alignment = RIGHT;

		add(waveNumber);
		add(timeRemaining);
		add(rootHealth);
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHUD(wave:Int, time:Float, health:Int)
	{
		waveNumber.text = "Wave " + wave;
		timeRemaining.text = time;
		rootHealth.text = "Root Health:" + health;
	}
}
