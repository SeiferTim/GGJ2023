package;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.actions.FlxActionInput.FlxInputDeviceID;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;

class Actions
{
	public static var actions:FlxActionManager;

	public static var setGameplay:FlxActionSet;

	public static var up:FlxActionDigital;
	public static var down:FlxActionDigital;
	public static var left:FlxActionDigital;
	public static var right:FlxActionDigital;
	public static var attack:FlxActionDigital;
	public static var pause:FlxActionDigital;

	public static var rightStick:FlxActionAnalog;

	public static var gameplayIndex:Int = -1;

	public static function init():Void
	{
		if (Actions.actions != null)
			return;

		Actions.actions = FlxG.inputs.add(new FlxActionManager());
		Actions.actions.resetOnStateSwitch = ResetPolicy.NONE;

		Actions.up = new FlxActionDigital();
		Actions.down = new FlxActionDigital();
		Actions.left = new FlxActionDigital();
		Actions.right = new FlxActionDigital();
		Actions.pause = new FlxActionDigital();
		Actions.attack = new FlxActionDigital();

		Actions.rightStick = new FlxActionAnalog();

		var gameplaySet:FlxActionSet = new FlxActionSet("GameplayControls", [
			Actions.up,
			Actions.down,
			Actions.left,
			Actions.right,
			Actions.pause,
			Actions.attack
		], [Actions.rightStick]);

		gameplayIndex = Actions.actions.addSet(gameplaySet);

		Actions.up.addKey(UP, PRESSED);
		Actions.up.addKey(W, PRESSED);
		Actions.down.addKey(DOWN, PRESSED);
		Actions.down.addKey(S, PRESSED);
		Actions.left.addKey(LEFT, PRESSED);
		Actions.left.addKey(A, PRESSED);
		Actions.right.addKey(RIGHT, PRESSED);
		Actions.right.addKey(D, PRESSED);

		Actions.pause.addKey(P, JUST_RELEASED);
		Actions.pause.addKey(ESCAPE, JUST_RELEASED);

		Actions.attack.addKey(SPACE, PRESSED);

		Actions.up.addGamepad(DPAD_UP, PRESSED);
		Actions.down.addGamepad(DPAD_DOWN, PRESSED);
		Actions.left.addGamepad(DPAD_LEFT, PRESSED);
		Actions.right.addGamepad(DPAD_RIGHT, PRESSED);

		Actions.pause.addGamepad(START, JUST_RELEASED);

		Actions.attack.addGamepad(A, PRESSED);
		Actions.attack.addGamepad(B, PRESSED);

		Actions.rightStick.addMousePosition(MOVED, BOTH);

		Actions.actions.activateSet(Actions.gameplayIndex, FlxInputDevice.ALL, FlxInputDeviceID.ALL);
	}
}
