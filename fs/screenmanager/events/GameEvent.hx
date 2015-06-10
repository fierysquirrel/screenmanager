package fs.screenmanager.events;

import flash.events.Event;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class GameEvent extends Event
{
	var source : String;
	
	public function new(type : String,source : String, bubbles:Bool=false, cancelable:Bool=false)
	{
		super(type, bubbles, cancelable);
		
		this.source = source;
	}
	
	public function GetSource() : String
	{
		return source;
	}
}