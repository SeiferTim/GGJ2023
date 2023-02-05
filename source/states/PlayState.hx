package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.Bullet;
import objects.Enemy;
import objects.Player;
import objects.Roots;
import states.substates.PauseSubState;
import states.substates.UpgradeState;
import ui.HUD;

class PlayState extends FlxState
{
	public var background:FlxSprite;
	public var foreground:FlxSprite;
	// public var collisionMap:FlxTilemap;
	public var floor:FlxSprite;
	public var player:Player;
	public var playerGun:FlxSprite;

	public var crosshair:FlxSprite;

	public var playerShots:FlxTypedGroup<Bullet>;
	public var enemies:FlxTypedGroup<Enemy>;
	public var hud:HUD;

	public var roots:Roots;

	public var spawnTimer:Float = 1;

	public var levelTimer:Float = 0;

	public var rootHealth:Int = 100;
	public var waveNumber:Int = 1;

	public static inline var CROSSHAIR_DIST:Float = 100;

	public var gameMode:String = "title";

	public var camTarget:FlxSprite;

	public var title:FlxSprite;

	public var anyKey:FlxText;

	override public function create()
	{
		Globals.initGame();
		Globals.PlayState = this;

		camTarget = new FlxSprite();
		camTarget.makeGraphic(2, 2, 0x00000000);
		camTarget.screenCenter();
		camTarget.y -= 900;

		// add background
		add(background = new FlxSprite(0, -900, "assets/images/background.png"));

		add(title = new FlxSprite(0, -900, "assets/images/title.png"));

		add(anyKey = new FlxText(0, 800, FlxG.width, "Press any key to Play"));
		anyKey.scrollFactor.set();
		anyKey.setFormat(null, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		anyKey.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);

		FlxTween.tween(anyKey, {y: 810}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineIn});

		add(roots = new Roots());
		roots.x = FlxG.width / 2 - roots.width / 2;
		roots.y = 0;

		add(enemies = new FlxTypedGroup<Enemy>());

		add(playerShots = new FlxTypedGroup<Bullet>());

		add(foreground = new FlxSprite(0, 0, "assets/images/foreground.png"));

		// add player
		add(player = new Player());
		player.screenCenter();
		// player.exists = false;

		add(playerGun = new FlxSprite("assets/images/weapon.png"));
		playerGun.width = playerGun.height = 28;
		playerGun.offset.y = 46;
		playerGun.origin.x = 14;
		playerGun.origin.y = 60;

		// add foreground

		add(crosshair = new FlxSprite());
		crosshair.makeGraphic(8, 8, 0xffffffff);
		crosshair.centerOrigin();
		crosshair.visible = false;

		add(floor = new FlxSprite());
		floor.makeGraphic(FlxG.width, 70, 0xff000000);
		floor.visible = false;
		floor.immovable = true;
		floor.moves = false;
		floor.y = FlxG.height - floor.height;

		// add HUD
		add(hud = new HUD());

		FlxG.camera.focusOn(camTarget.getMidpoint());
		FlxG.camera.follow(camTarget, FlxCameraFollowStyle.LOCKON, .2);

		super.create();

		// FlxG.camera.fade(0xff000000, 1);
	}

	public function showUpgrades():Void
	{
		openSubState(new UpgradeState());
	}

	public function startLevel():Void
	{
		levelTimer = 0;
		spawnTimer = 1;
		gameMode = "ingame";
		// player.exists = true;
		crosshair.visible = hud.visible = true;
		if (waveNumber <= 2)
		{
			FlxG.sound.playMusic("assets/music/intensity-1.ogg", 0.3, true);
		}
		else if (waveNumber <= 4)
		{
			FlxG.sound.playMusic("assets/music/intensity-2.ogg", 0.3, true);
		}
		else
		{
			FlxG.sound.playMusic("assets/music/intensity-3.ogg", 0.3, true);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, floor);
		updateCrosshair();

		switch (gameMode)
		{
			case "title":
				if (FlxG.keys.anyJustReleased([ANY]))
				{
					gameMode = "togame";
					FlxG.sound.play(AssetPaths.start__ogg, 1, false);
					FlxTween.cancelTweensOf(anyKey);
					FlxTween.tween(anyKey, {alpha: 0}, .2);
					FlxTween.tween(title, {alpha: 0}, 1, {
						onComplete: (_) ->
						{
							FlxTween.tween(camTarget, {y: camTarget.y + 900}, 3, {
								ease: FlxEase.sineInOut,
								onComplete: (_) ->
								{
									title.kill();
									anyKey.kill();
									startLevel();
								}
							});
						}
					});
				}

			case "ingame":
				if (Actions.pause.check())
				{
					FlxG.sound.play(AssetPaths.pauseon__ogg, 1, false);
					openSubState(new PauseSubState());

					return;
				}

				levelTimer += elapsed;
				roots.scale.set(Math.min(1, levelTimer / 60), Math.min(1, levelTimer / 60));
				roots.updateHitbox();
				roots.x = FlxG.width / 2 - roots.width / 2;
				if (levelTimer >= 60 && enemies.countLiving() == 0)
				{
					// wave is complete!
					waveComplete();
				}
				else if (rootHealth <= 0)
				{
					// game over!
					gameOver();
				}
				hud.updateHUD(waveNumber, levelTimer, rootHealth);

				// FlxG.collide(player, collisionMap);

				if (player.x < 70)
					player.x = 70;
				if (player.x > FlxG.width - 70)
					player.x = FlxG.width - 70;

				FlxG.overlap(enemies, playerShots, bulletHitEnemy, checkBulletHitEnemy);
				FlxG.overlap(player, enemies, playerHitEnemy, checkPlayerHitEnemy);
				FlxG.overlap(roots, enemies, rootsHitEnemy, checkRootsHitEnemy);

				checkSpawns(elapsed);
			case "showsprout":

			case "waiting-gameover":
				if (FlxG.keys.anyJustReleased([ANY]))
				{
					gameMode = "quit";
					FlxG.camera.fade(FlxColor.BLACK, .2, false, () ->
					{
						FlxG.resetGame();
					});
				}
		}
	}

	public function waveComplete():Void
	{
		gameMode = "showsprout";
		// player.exists = false;
		FlxTween.tween(camTarget, {y: camTarget.y - 900}, 2, {
			ease: FlxEase.sineInOut,
			onComplete: (_) -> {
				// show the sprouting bud, then show upgrade screen
			}
		});
	}

	public function checkRootsHitEnemy(Root:Roots, Enemy:Enemy):Bool
	{
		return (!Enemy.onRoot && Enemy.alive && Enemy.exists && Root.alive && Root.exists && Enemy.x > 70 && Enemy.x < FlxG.width - 70 && Enemy.y > 70
			&& Enemy.y < FlxG.height - 70);
	}

	public function rootsHitEnemy(Root:Roots, Enemy:Enemy):Void
	{
		Enemy.onRoot = true;
		hud.updateHUD(waveNumber, levelTimer, rootHealth);
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
		Enemy.hurt(player.damage);
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

		playerGun.x = player.x + (player.width / 2) - (playerGun.width / 2);
		playerGun.y = player.y + (player.height / 2) - (playerGun.height / 2);

		playerGun.angle = FlxAngle.asDegrees(angleToMouse);
	}

	public function playerShoot(Count:Int = 1):Void
	{
		var b:Bullet = null;
		var shots:Int = player.spread;
		var startAngle:Float = -((shots - 1 / 2)) * 5;
		FlxG.sound.play(AssetPaths.shoot__flac, 1, false);
		for (i in 0...shots)
		{
			b = playerShots.getFirstAvailable(Bullet);
			if (b == null)
				playerShots.add(b = new Bullet());
			b.spawn(player.x
				+ (player.width / 2), player.y
				+ (player.height / 2), true, FlxAngle.angleBetweenMouse(player, true)
				+ startAngle
				+ (10 * i),
				Player.BULLET_SPEED);
		}
	}

	public function gameOver():Void
	{
		gameMode = "gameover";
		FlxG.sound.play(AssetPaths.gameover__ogg, 1, false);
		// player.exists = false;

		var goScreen:FlxSprite = new FlxSprite(0, 0, "assets/images/gameover.png");
		goScreen.scrollFactor.set();
		goScreen.alpha = 0;

		var goText:FlxText = new FlxText(0, 0, FlxG.width, "Press Any Key to Restart");
		goText.setFormat(null, 16, 0xFFFFFFFF, "center");
		goText.scrollFactor.set();
		goText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1);
		goText.y = FlxG.height - goText.height - 10;
		goText.alpha = 0;

		FlxTween.tween(goScreen, {alpha: 1}, .2);

		FlxTween.tween(goText, {alpha: 1}, .2, {
			startDelay: .1,
			onComplete: (_) ->
			{
				gameMode = "waiting-gameover";
			}
		});
	}
}
