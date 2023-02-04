package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import objects.Bullet;
import objects.GameMap;
import objects.Player;

class PlayState extends FlxState
{
	public var background:FlxSprite;
	public var foreground:FlxSprite;
	public var collisionMap:FlxTilemap;
	public var player:Player;

	public var crosshair:FlxSprite;

	public var playerShots:FlxTypedGroup<Bullet>;

	public static inline var CROSSHAIR_DIST:Float = 100;

	override public function create()
	{
		Globals.initGame();
		Globals.PlayState = this;

		// add background
		add(background = new FlxSprite(0, 0));
		background.makeGraphic(FlxG.width, FlxG.height, 0xff462626);

		// add collision map
		add(collisionMap = new FlxTilemap());
		var mapData:GameMap = Globals.MapList[0];
		collisionMap.loadMapFromArray(mapData.baseLayerData, mapData.widthInTiles, mapData.heightInTiles, "assets/images/tiles.png", 4, 4,
			FlxTilemapAutoTiling.OFF, 0, 1, 1);

		add(playerShots = new FlxTypedGroup<Bullet>());

		// add player
		add(player = new Player());
		player.screenCenter();

		// add foreground

		add(crosshair = new FlxSprite());
		crosshair.makeGraphic(8, 8, 0xffffffff);
		crosshair.centerOrigin();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, collisionMap);

		updateCrosshair();
	}

	public function updateCrosshair()
	{
		var angleToMouse:Float = FlxAngle.angleBetweenMouse(player);
		var pos:FlxPoint = FlxPoint.get();
		pos.setPolarRadians(CROSSHAIR_DIST, angleToMouse);

		trace(angleToMouse, pos);

		crosshair.x = player.x + (player.width / 2) + pos.x - (crosshair.width / 2);
		crosshair.y = player.y + (player.height / 2) + pos.y - (crosshair.height / 2);
	}

	public function playerShoot(Count:Int = 1):Void
	{
		var b:Bullet = playerShots.getFirstAvailable(Bullet);
		if (b == null)
			playerShots.add(b = new Bullet());
		b.spawn(player.x + (player.width / 2), player.y + (player.height / 2), true, FlxAngle.angleBetweenMouse(player), Player.BULLET_SPEED);
	}
}
