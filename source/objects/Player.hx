package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public static inline var GRAVITY:Float = 1200;
	public static inline var MAX_VELOCITY:Float = 400;
	public static inline var MOVE_SPEED:Float = 200;
	public static inline var JUMP_SPEED:Float = 600;
	public static inline var JUMP_TIME:Float = 0.2;
	public static inline var FIRE_RATE:Float = 0.2;
	public static inline var BULLET_SPEED:Float = 800;
	public static inline var STUN_TIME:Float = 1;
	public static inline var DAMAGE:Float = 10;
	public static inline var SPREAD:Int = 1;

	public var moveSpeed(get, null):Float;
	public var stunTime(get, null):Float;
	public var damage(get, null):Float;
	public var spread(get, null):Int;
	public var fireRate(get, null):Float;

	public var jumpTimer:Float = 0;
	public var fireTimer:Float = 0;
	public var stunTimer:Float = 0;

	public var upgrades:Map<String, Int> = [];

	public function new():Void
	{
		super();
		loadGraphic("assets/images/player.png");

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

		var attack:Bool = Actions.attack.check();

		if (stunTimer > 0)
		{
			stunTimer -= elapsed;
			left = right = jump = attack = false;
		}

		if (left && right)
			left = right = false;

		if (left)
			velocity.x -= moveSpeed;
		else if (right)
			velocity.x += moveSpeed;

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

		if (fireTimer > 0)
			fireTimer -= elapsed;

		if (attack && fireTimer <= 0)
		{
			fireTimer = fireRate;
			Globals.PlayState.playerShoot(1);
		}

		angularVelocity = velocity.x * 10;

		super.update(elapsed);
	}

	public function stun():Void
	{
		if (stunTimer > 0)
			return;
		stunTimer = stunTime;
	}

	private function get_moveSpeed():Float
	{
		var amt:Int = 0;
		if (upgrades.exists("moveSpeed"))
			amt = upgrades.get("moveSpeed");
		return MOVE_SPEED * ((amt / 100) + 1);
	}

	private function get_stunTime():Float
	{
		var amt:Int = 0;
		if (upgrades.exists("stunTime"))
			amt = upgrades.get("stunTime");
		return STUN_TIME * (1 - (amt / 100));
	}

	private function get_damage():Float
	{
		var amt:Int = 0;
		if (upgrades.exists("damage"))
			amt = upgrades.get("damage");
		return DAMAGE * ((amt / 100) + 1);
	}

	private function get_spread():Int
	{
		var amt:Int = 0;
		if (upgrades.exists("spread"))
			amt = upgrades.get("spread");
		return SPREAD + amt;
	}

	private function get_fireRate():Float
	{
		var amt:Int = 0;
		if (upgrades.exists("fireRate"))
			amt = upgrades.get("fireRate");
		return FIRE_RATE * (1 - (amt / 100));
	}

	public function addUpgrade(Data:UpgradeData):UpgradeData
	{
		if (!upgrades.exists(Data.variable))
			upgrades.set(Data.variable, Data.ranks.shift());
		else
			upgrades.set(Data.variable, Data.ranks.shift());
		return Data;
	}
}
