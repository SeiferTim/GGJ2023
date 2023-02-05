package objects;

class UpgradeData
{
	public var name:String = "";
	public var effect:String = "";
	public var variable:String = "";
	public var ranks:Array<Int> = [];

	public function new(Data:Dynamic):Void
	{
		name = Data.name;
		effect = Data.effect;
		variable = Data.variable;
		ranks = Data.ranks;
	}
}
