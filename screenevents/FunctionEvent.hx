package screenevents;

/**
 * ...
 * @author Henry D. Fernández B.
 */

class FunctionEvent extends GameEvent
{
	/*
	 * Screen class name
	 * */
	private var functionName : String;
	
	private var args : Array<Dynamic>;
	
	public function new(type:String,source : String,functionName : String,args : Array<Dynamic> , bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type,source, bubbles, cancelable);
		
		this.functionName = functionName;
		this.args = args;
	}
	
	/*
	 * Get screen name.
	 */
	public function GetFunctionName() : String
	{
		return functionName;
	}
	
	/*
	 * Get screen name.
	 */
	public function GetArgs() : Array<Dynamic>
	{
		return args;
	}
}