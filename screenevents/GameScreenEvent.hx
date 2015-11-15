package screenevents;

import screentransitions.*;

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
	
	private var transition : Transition;
	
	public function new(type:String,screen : GameScreen,transition : Transition = null, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type,ScreenManager.NAME,bubbles, cancelable);
		
		this.screen = screen;
		this.transition = transition;
	}
	
	/*
	 * Get screen name.
	 */
	public function GetScreen() : GameScreen
	{
		return screen;
	}
	
	public function GetTransition() : Transition
	{
		return transition;
	}
}