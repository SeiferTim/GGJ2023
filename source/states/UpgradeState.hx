package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class UpgradeState extends FlxSubState
{
	public var header:FlxText;
	public var column1:FlxButton;
	public var column2:FlxButton;
	public var column3:FlxButton;
	public var bg:FlxSprite;

	override public function create():Void
	{
		// FlxG.width/2 centers sprite. -FlxG.width/4 reduce width of sprite b about 25% b/c we don't want menu to take up whole screen
		bg = new FlxSprite(Std.int(FlxG.width / 2 - FlxG.width / 4), Std.int(FlxG.height / 2 - FlxG.height / 4));
		// Make and center
		bg.makeGraphic(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2), 0xff800080);
		add(bg);

		// Origin point of header is the top left corner of the bg object. Width is width of bg
		header = new FlxText(bg.x, bg.y, bg.width, "Upgrades");
		header.setFormat(null, 24, 0xFFFFFF, "center"); // Center text width width of bg
		add(header);

		// Divide bg into 3 evenly spaced columns
		var columnWidth:Int = Std.int(bg.width / 3); // Must be int b/c we pass buttonwidth to makeGraphic
		// Height of the button takes up entire height of bg
		var columnHeight:Int = Std.int(bg.height - header.height);

		// Set position of column1 at left border of bg, y starts at header.y under height of header + 20 padding
		column1 = new FlxButton(Std.int(bg.x), header.y + header.height + 20, "Movement speed x2", function():Void
		{
			trace("MovementSpeed Added");
		});
		// How big is column1
		column1.makeGraphic(columnWidth, columnHeight, 0xFF404040);
		column1.label.setFormat(null, 16, 0xFFFFFF, "center");
		add(column1);

		// Height stays the same across all columns. Add width b/c this is where the second column starts
		column2 = new FlxButton(Std.int(bg.x) + columnWidth, header.y + header.height + 20, "Regen 5%", function():Void
		{
			trace("Regen added");
		});
		column2.makeGraphic(columnWidth, columnHeight, 0xFFBE9914);
		column2.label.setFormat(null, 16, 0xFFFFFF, "center");
		add(column2);

		column3 = new FlxButton(Std.int(bg.x) + (columnWidth * 2), header.y + header.height + 20, "Slow Enemies", function():Void
		{
			trace("Slow enemies added");
		});
		column3.makeGraphic(columnWidth, columnHeight, 0xFF56F091);
		column3.label.setFormat(null, 16, 0xFFFFFF, "center");
		add(column3);
	}
}
