package fs.screenmanager.events;


/**
 * ...
 * @author Henry D. Fernández B.
 */

class GameScreenEvent extends GameEvent
{
	/*
	 * Screen class name
	 * */
	private var screen : GameScreen;
	
	public function new(type:String,screen : GameScreen, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type,ScreenManager.NAME,bubbles, cancelable);
		
		this.screen = screen;
	}
	
	/*
	 * Get screen name.
	 */
	public function GetScreen() : GameScreen
	{
		return screen;
	}
}