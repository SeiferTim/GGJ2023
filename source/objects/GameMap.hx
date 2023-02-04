package objects;

class GameMap
{
	public var widthInTiles:Int = -1;
	public var heightInTiles:Int = -1;
	public var baseLayerData:Array<Int> = [];
	public var tilesetFirstID:Int = -1;

	public function new(Data:macros.MapBuilder.MapStructure):Void
	{
		tilesetFirstID = Data.tilesets[0].firstgid;
		widthInTiles = Data.width;
		heightInTiles = Data.height;

		var baseLayer:Dynamic = null;
		baseLayer = Data.layers[0];

		baseLayerData = [
			for (i in 0...baseLayer.data.length)
				baseLayer.data[i] > 0 ? Std.int(baseLayer.data[i] - tilesetFirstID) : 0
		];
	}
}
