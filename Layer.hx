package;

import openfl.display.Tilemap;
import openfl.display.Tileset;

/**
 * ...
 * @author Fiery Squirrel
 */
class Layer extends Tilemap
{
	private var order : Int;
	
	public function new(tilesheet : Tileset,  width : Int, height : Int,order : Int = 0, smooth:Bool=true) 
	{
		super(width, height,tilesheet, smooth);
		
		this.order = order;
	}
	
	public function GetOrder() : Int
	{
		return order;
	}
}