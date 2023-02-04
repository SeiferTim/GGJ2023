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
import objects.Enemy;
import objects.GameMap;
import objects.Player;
import objects.Roots;

class PlayState extends FlxState
{
	public var background:FlxSprite;
	public var foreground:FlxSprite;
	public var collisionMap:FlxTilemap;
	public var player:Player;

	public var crosshair:FlxSprite;

	public var playerShots:FlxTypedGroup<Bullet>;
	public var enemies:FlxTypedGroup<Enemy>;

	public var roots:Roots;

	public var spawnTimer:Float = 1;

	public var levelTimer:Float = 0;

	public var rootHealth:Int = 100;

	public static inline var CROSSHAIR_DIST:Float = 100;

	override public function create()
	{
		Globals.initGame();
		Globals.PlayState = this;

		// add background
		add(background = new FlxSprite(0, 0));
		background.makeGraphic(FlxG.width, FlxG.height, 0xff462626);

		add(roots = new Roots());
		roots.x = FlxG.width / 2 - roots.width / 2;
		roots.y = 0;

		// add collision map
		add(collisionMap = new FlxTilemap());
		var mapData:GameMap = Globals.MapList[0];
		collisionMap.loadMapFromArray(mapData.baseLayerData, mapData.widthInTiles, mapData.heightInTiles, "assets/images/tiles.png", 4, 4,
			FlxTilemapAutoTiling.OFF, 0, 1, 1);

		add(enemies = new FlxTypedGroup<Enemy>());

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

	public function startLevel():Void
	{
		levelTimer = 0;
		spawnTimer = 1;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		levelTimer += elapsed;
		roots.scale.set(levelTimer / 60, levelTimer / 60);
		roots.updateHitbox();
		roots.x = FlxG.width / 2 - roots.width / 2;
		if (levelTimer >= 60)
		{
			// wave is complete!
		}

		FlxG.collide(player, collisionMap);
		FlxG.overlap(enemies, playerShots, bulletHitEnemy, checkBulletHitEnemy);
		FlxG.overlap(player, enemies, playerHitEnemy, checkPlayerHitEnemy);
		FlxG.overlap(roots, enemies, rootsHitEnemy, checkRootsHitEnemy);

		updateCrosshair();

		checkSpawns(elapsed);
	}

	public function checkRootsHitEnemy(Root:Roots, Enemy:Enemy):Bool
	{
		return (!Enemy.onRoot && Enemy.alive && Enemy.exists && Root.alive && Root.exists);
	}

	public function rootsHitEnemy(Root:Roots, Enemy:Enemy):Void
	{
		Enemy.onRoot = true;
	}

	public function playerHitEnemy(Player:Player, Enemy:Enemy):Void
	{
		Player.stun();
	}

	public function checkPlayerHitEnemy(Player:Player, Enemy:Enemy):Bool
	{
		return Enemy.alive && Enemy.exists && Player.alive && Player.exists && Player.stunTimer <= 0;
	}

	public function checkBulletHitEnemy(Enemy:Enemy, Bullet:Bullet):Bool
	{
		return Enemy.alive && Enemy.exists && Bullet.alive && Bullet.exists;
	}

	public function bulletHitEnemy(Enemy:Enemy, Bullet:Bullet):Void
	{
		Enemy.kill();
		Bullet.kill();
	}

	public function checkSpawns(elapsed:Float)
	{
		spawnTimer -= elapsed;
		if (spawnTimer <= 0)
		{
			spawnTimer = 5;
			var e:Enemy = null;
			for (i in 0...FlxG.random.int(2, 8))
			{
				e = enemies.getFirstAvailable(Enemy);
				if (e == null)
					enemies.add(e = new Enemy());
				e.spawn(FlxG.random.bool() ? -50 : FlxG.width + 50, FlxG.random.float(-10, FlxG.height + 10));
			}
		}
	}

	public function updateCrosshair()
	{
		var angleToMouse:Float = FlxAngle.angleBetweenMouse(player);
		var pos:FlxPoint = FlxPoint.get();
		pos.setPolarRadians(CROSSHAIR_DIST, angleToMouse);

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
