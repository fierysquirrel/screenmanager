package;

import flash.display.Sprite;

/**
 * ...
 * @author Fiery Squirrel
 */
class BackgroundColor extends Sprite
{
	public function new(width : Int, height : Int, color : UInt, alpha : Float) 
	{
		super();
				
		graphics.beginFill(color);
		graphics.drawRect(0,0,width,height);
		graphics.endFill();
		this.alpha = alpha;
	}	
}