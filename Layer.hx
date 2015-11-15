package;

import aze.display.behaviours.TileGroupTransform;
import aze.display.TileLayer;
import aze.display.TilesheetEx;

/**
 * ...
 * @author Fiery Squirrel
 */
class Layer extends TileLayer
{
	private var order : Int;
	
	public function new(tilesheet:TilesheetEx,order : Int = 0, smooth:Bool=true, additive:Bool=false) 
	{
		super(tilesheet, smooth, additive);
		
		this.order = order;
	}
	
	public function GetOrder() : Int
	{
		return order;
	}
}