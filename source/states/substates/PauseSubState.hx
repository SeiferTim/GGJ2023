package states.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;

class PauseSubState extends FlxSubState
{
	public var bg:FlxSprite;
	public var resumeButton:FlxButton;
	public var quitButton:FlxButton;
	public var pauseOffSound:FlxSound;

	override public function create():Void
	{
		bg = new FlxSprite(0, 0);
		bg.makeGraphic(320, 240, 0x88000000);
		bg.screenCenter();
		add(bg);

		resumeButton = new FlxButton(0, 0, "Resume", resume);
		resumeButton.x = (FlxG.width - resumeButton.width) / 2;
		resumeButton.y = (FlxG.height - resumeButton.height) / 2 - 20;
		add(resumeButton);

		quitButton = new FlxButton(0, 0, "Quit", quit);
		quitButton.x = (FlxG.width - quitButton.width) / 2;
		quitButton.y = (FlxG.height - quitButton.height) / 2 + 20;
		add(quitButton);

		pauseOffSound = FlxG.sound.load(AssetPaths.pauseoff__ogg);

		super.create();
	}

	public function resume():Void
	{
		pauseOffSound.play();
		close();
	}

	public function quit():Void
	{
		openSubState(new ConfirmQuit());
	}
}

class ConfirmQuit extends FlxSubState
{
	public var bg:FlxSprite;
	public var yesButton:FlxButton;
	public var noButton:FlxButton;
	public var message:FlxText;

	override public function create():Void
	{
		bg = new FlxSprite(0, 0);
		bg.makeGraphic(320, 240, 0x88000000);
		bg.screenCenter();
		add(bg);

		message = new FlxText(0, 0, FlxG.width, "Are you sure you want to quit?");
		message.alignment = "center";
		message.screenCenter(FlxAxes.X);
		message.y = bg.y + 4;
		add(message);

		yesButton = new FlxButton(0, 0, "Yes", yes);
		yesButton.x = (FlxG.width - yesButton.width) / 2;
		yesButton.y = (FlxG.height - yesButton.height) / 2 - 20;
		add(yesButton);

		noButton = new FlxButton(0, 0, "No", no);
		noButton.x = (FlxG.width - noButton.width) / 2;
		noButton.y = (FlxG.height - noButton.height) / 2 + 20;
		add(noButton);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function yes():Void
	{
		FlxG.switchState(new TitleState());
	}

	public function no():Void
	{
		close();
	}
}
