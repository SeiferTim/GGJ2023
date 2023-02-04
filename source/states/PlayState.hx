package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import js.lib.webassembly.Global;
import objects.GameMap;
import objects.Player;

class PlayState extends FlxState
{
	public var background:FlxSprite;
	public var foreground:FlxSprite;
	public var collisionMap:FlxTilemap;
	public var player:Player;

	override public function create()
	{
		Globals.initGame();

		// add background
		add(background = new FlxSprite(0, 0));
		background.makeGraphic(FlxG.width, FlxG.height, 0xff462626);

		// add collision map
		add(collisionMap = new FlxTilemap());
		var mapData:GameMap = Globals.MapList[0];
		collisionMap.loadMapFromArray(mapData.baseLayerData, mapData.widthInTiles, mapData.heightInTiles, "assets/images/tiles.png", 4, 4,
			FlxTilemapAutoTiling.OFF, 0, 1, 1);

		// add player
		add(player = new Player());
		player.screenCenter();

		// add foreground

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, collisionMap);
	}
}
