package states.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import objects.UpgradeData;

using StringTools;

class UpgradeState extends FlxSubState
{
	public var header:FlxText;
	public var column1:FlxButton;
	public var column2:FlxButton;
	public var column3:FlxButton;
	public var bg:FlxSprite;

	public var choiceAName:FlxText;
	public var choiceBName:FlxText;
	public var choiceCName:FlxText;

	public var choiceADesc:FlxText;
	public var choiceBDesc:FlxText;
	public var choiceCDesc:FlxText;

	public var choices:Array<UpgradeData> = [];

	override public function create():Void
	{
		// FlxG.width/2 centers sprite. -FlxG.width/4 reduce width of sprite b about 25% b/c we don't want menu to take up whole screen
		bg = new FlxSprite(Std.int(FlxG.width / 2 - FlxG.width / 4), Std.int(FlxG.height / 2 - FlxG.height / 4));
		// Make and center
		bg.makeGraphic(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2), 0xff800080);
		add(bg);

		// Origin point of header is the top left corner of the bg object. Width is width of bg
		header = new FlxText(bg.x, bg.y + 10, bg.width, "Choose an Upgrade");
		header.setFormat(null, 24, 0xFFFFFF, "center"); // Center text width width of bg
		header.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 1);
		add(header);

		// Divide bg into 3 evenly spaced columns
		var columnWidth:Int = Std.int(bg.width / 3); // Must be int b/c we pass buttonwidth to makeGraphic
		// Height of the button takes up entire height of bg
		var columnHeight:Int = Std.int(bg.height - header.height);

		FlxG.random.shuffle(Globals.UpgradeList);

		choices.push(Globals.UpgradeList.shift());
		choices.push(Globals.UpgradeList.shift());
		choices.push(Globals.UpgradeList.shift());

		// Set position of column1 at left border of bg, y starts at header.y under height of header + 20 padding
		column1 = new FlxButton(Std.int(bg.x), header.y + header.height + 20, "", chose.bind(0));
		// How big is column1
		column1.makeGraphic(columnWidth, columnHeight, 0xFF222222);
		column1.label.setFormat(null, 16, 0xFFFFFF, "center");
		add(column1);

		// Height stays the same across all columns. Add width b/c this is where the second column starts
		column2 = new FlxButton(Std.int(bg.x) + columnWidth, header.y + header.height + 20, "", chose.bind(1));
		column2.makeGraphic(columnWidth, columnHeight, 0xFF4D3D07);
		column2.label.setFormat(null, 16, 0xFFFFFF, "center");
		add(column2);

		column3 = new FlxButton(Std.int(bg.x) + (columnWidth * 2), header.y + header.height + 20, "", chose.bind(2));
		column3.makeGraphic(columnWidth, columnHeight, 0xFF11311D);
		column3.label.setFormat(null, 16, 0xFFFFFF, "center");
		add(column3);

		add(choiceAName = new FlxText(column1.x, column1.y + 10, column1.width, choices[0].name));
		choiceAName.setFormat(null, 18, 0xFFFFFF, "center");
		choiceAName.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 1);

		add(choiceADesc = new FlxText(column1.x, choiceAName.y + choiceAName.height + 10, column1.width,
			choices[0].effect.replace("{x}", Std.string(choices[0].ranks[0]))));
		choiceADesc.setFormat(null, 12, 0xFFFFFF, "center");
		choiceADesc.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 1);

		add(choiceBName = new FlxText(column2.x, column2.y + 10, column2.width, choices[1].name));
		choiceBName.setFormat(null, 18, 0xFFFFFF, "center");
		choiceBName.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 1);

		add(choiceBDesc = new FlxText(column2.x, choiceBName.y + choiceBName.height + 10, column2.width,
			choices[1].effect.replace("{x}", Std.string(choices[1].ranks[0]))));
		choiceBDesc.setFormat(null, 12, 0xFFFFFF, "center");
		choiceBDesc.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 1);

		add(choiceCName = new FlxText(column3.x, column3.y + 10, column3.width, choices[2].name));
		choiceCName.setFormat(null, 18, 0xFFFFFF, "center");
		choiceCName.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 1);

		add(choiceCDesc = new FlxText(column3.x, choiceCName.y + choiceCName.height + 10, column3.width,
			choices[2].effect.replace("{x}", Std.string(choices[2].ranks[0]))));
		choiceCDesc.setFormat(null, 12, 0xFFFFFF, "center");
		choiceCDesc.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 1);
	}

	public function chose(Which:Int):Void
	{
		choices[Which] = Globals.PlayState.player.addUpgrade(choices[Which]);
		for (i in 0...3)
		{
			if (choices[i].ranks.length > 0)
				Globals.UpgradeList.push(choices[i]);
		}
		close();
	}
}
