package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
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

	public var sprouts:Array<FlxSprite> = [];

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

		sprouts.push(new FlxSprite(0, -900, "assets/images/sprout.png"));
		sprouts.push(new FlxSprite(0, -900, "assets/images/sprout2.png"));
		sprouts.push(new FlxSprite(0, -900, "assets/images/sprout3.png"));

		for (i in 0...3)
		{
			add(sprouts[i]);
			sprouts[i].alpha = 0;
			sprouts[i].kill();
		}

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
		playerGun.offset.x = 46;
		playerGun.origin.y = 14;
		playerGun.origin.x = 60;

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
		openSubState(new UpgradeState(returnFromUpgrade));
	}

	public function returnFromUpgrade():Void
	{
		waveNumber++;
		FlxTween.tween(camTarget, {y: camTarget.y + 900}, 1, {
			ease: FlxEase.sineInOut,
			onComplete: (_) ->
			{
				sprouts[2].alpha = 0;
				sprouts[2].kill();
				startLevel();
			}
		});
	}

	public function startLevel():Void
	{
		levelTimer = 0;
		spawnTimer = 1;
		gameMode = "ingame";
		// player.exists = true;
		crosshair.visible = hud.visible = true;
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
					openSubState(new PauseSubState());

					return;
				}

				levelTimer += elapsed;
				roots.scale.set(Math.min(1, levelTimer / 60), Math.min(1, levelTimer / 60));
				roots.updateHitbox();
				roots.x = FlxG.width / 2 - roots.width / 2;
				if (levelTimer >= 60)
				{
					// wave is complete!
					waveComplete();
					return;
				}
				else if (rootHealth <= 0)
				{
					// game over!
					gameOver();
					return;
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
		for (x in enemies)
			x.kill();
		// player.exists = false;
		sprouts[0].revive();
		sprouts[1].revive();
		sprouts[2].revive();

		FlxTween.tween(camTarget, {y: camTarget.y - 900}, 2, {
			ease: FlxEase.sineInOut,
			startDelay: .5,
			onComplete: (_) ->
			{
				roots.scale.set(0.01, 0.01);
			}
		});

		// show the sprouting bud, then show upgrade screen

		FlxTween.tween(sprouts[0], {alpha: 1}, .5, {
			startDelay: 2.5,
			onComplete: (_) ->
			{
				FlxTween.tween(sprouts[0], {alpha: 0}, .5, {
					onComplete: (_) ->
					{
						sprouts[0].kill();
					}
				});
			}
		});

		FlxTween.tween(sprouts[1], {alpha: 1}, .5, {
			startDelay: 3,
			onComplete: (_) ->
			{
				FlxTween.tween(sprouts[1], {alpha: 0}, .5, {
					onComplete: (_) ->
					{
						sprouts[1].kill();
					}
				});
			}
		});

		FlxTween.tween(sprouts[2], {alpha: 1}, .5, {
			startDelay: 3.5,
			onComplete: (_) ->
			{
				showUpgrades();
			}
		});
	}

	public function checkRootsHitEnemy(Root:Roots, Enemy:Enemy):Bool
	{
		return (!Enemy.onRoot && Enemy.alive && Enemy.exists && Root.alive && Root.exists && Enemy.x > 150 && Enemy.x < FlxG.width - 150 && Enemy.y > 150
			&& Enemy.y < FlxG.height - 150);
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
			spawnTimer = 10 * (1 - (waveNumber / 10));
			var e:Enemy = null;
			for (i in 0...FlxG.random.int(Std.int(1 * (1 + waveNumber / 25)), Std.int(5 * (1 + waveNumber / 50))))
			{
				e = enemies.getFirstAvailable(Enemy);
				if (e == null)
					enemies.add(e = new Enemy());
				e.spawn(FlxG.random.bool() ? -50 : FlxG.width + 50, FlxG.random.float(100, FlxG.height + 10));
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

		playerGun.angle = FlxAngle.asDegrees(angleToMouse) - 180;
	}

	public function playerShoot(Count:Int = 1):Void
	{
		var b:Bullet = null;
		var shots:Int = player.spread;
		var startAngle:Float = -((shots - 1 / 2)) * 5;
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
		// player.exists = false;

		var goScreen:FlxSprite = new FlxSprite(0, 0, "assets/images/gameover.png");
		add(goScreen);
		goScreen.scrollFactor.set();
		goScreen.alpha = 0;

		var goText:FlxText = new FlxText(0, 0, FlxG.width, "Press Any Key to Restart");
		add(goText);
		goText.setFormat(null, 22, 0xFFFFFFFF, "center");
		goText.scrollFactor.set();
		goText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1);
		goText.y = FlxG.height - goText.height - 20;
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
