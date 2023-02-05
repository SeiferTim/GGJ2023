package objects;

class UpgradeData
{
	public var name:String = "";
	public var effect:String = "";
	public var variable:String = "";
	public var ranks:Array<Int> = [];

	public function new(Name:String, Effect:String, Variable:String, Ranks:Array<Int>):Void
	{
		name = Name;
		effect = Effect;
		variable = Variable;
		ranks = Ranks;
	}
}
