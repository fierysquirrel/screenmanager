package screentransitions;

import flash.display.Sprite;
import flash.events.EventDispatcher;

enum DissapearState
{
	FadeOut;
	NoFade;
}

/**
 * ...
 * @author Henry D. Fernández B.
 */
class DisappearTransition extends Transition
{	
	/*
	 * TODO: Hay que tratar de modificar esto por el valor que está en el application.nmml
	 * */
	static private var TICKS_PER_SECOND : Int = 60;
	
	/*
	 * Constant to represent the initial time.
	 * */
	static private var MAX_ALPHA : Int = 1;
	
	/*
	 * Constant to represent the initial time.
	 * */
	static private var MIN_ALPHA : Int = 0;
	
	/*
	 * Constant to represent the initial time.
	 * */
	static private var MAX_DURATION : Int = 8;
	
	/*
	 * Constant to represent the initial time.
	 * */
	static private var MIN_DURATION : Int = 0;
	
	static private var NUMBER_OF_TRANSITIONS : Int = 1;
	
	private var state : DissapearState;
	
	private var duration : Float;
	
	private var step : Float;

	public function new(eventDispatcher : EventDispatcher,sc : Sprite,screenWidth : Float,screenHeight : Float, color : Int, duration : Float) 
	{
		super(eventDispatcher,sc);
		
		var screenX : Float = 0;
		var screenY : Float = 0;
		
		if (duration > MAX_DURATION || duration <= MIN_DURATION)
			throw "Error: duration must be between " + MIN_DURATION + " and " + MAX_DURATION;
			
		this.duration = duration;
		step = (NUMBER_OF_TRANSITIONS * MAX_ALPHA) / (duration * TICKS_PER_SECOND);
		state = DissapearState.NoFade;
	}
	
	/*
	 * Updates the game screen logic.
	 * 
	 * @param gameTime Current game time
	 */
	override public function Update(gameTime:Float) : Void
	{
		super.Update(gameTime);
		
		if (isRunning)
		{
			switch(state)
			{
				case DissapearState.FadeOut:
					if (screen.alpha > MIN_ALPHA)
						screen.alpha -= step;
					else
					{
						screen.alpha = MIN_ALPHA;
						state = DissapearState.NoFade;
						eventDispatcher.dispatchEvent(new GameEvent(Transition.EVENT_CHANGE_SCREEN, Transition.NAME));
						End();
					}
				default:
			}
		}
	}
	
	override public function Start(screen : GameScreen):Void 
	{
		super.Start(screen);
		
		state = DissapearState.FadeOut;
	}
}