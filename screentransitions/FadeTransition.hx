package screentransitions;

import flash.display.Sprite;
import flash.events.EventDispatcher;

enum FadeState
{
	FadeIn;
	FadeOut;
	NoFade;
}

/**
 * ...
 * @author Henry D. Fernández B.
 */
class FadeTransition extends Transition
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
	
	/*
	 * 
	 * */
	static private var NUMBER_OF_TRANSITIONS : Int = 2;
	
	private var state : FadeState;
	
	private var veil : Sprite;
	
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
		veil = new Sprite();
		veil.graphics.beginFill(color);
		veil.graphics.drawRect(screenX, screenY, screenWidth, screenHeight);
		veil.graphics.endFill();
		veil.alpha = MIN_ALPHA;
		state = FadeState.NoFade;
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
				case FadeState.FadeIn:
					if (veil.alpha < MAX_ALPHA)
						veil.alpha += step;
					else
					{
						veil.alpha = MAX_ALPHA;
						state = FadeState.FadeOut;
						eventDispatcher.dispatchEvent(new GameEvent(Transition.EVENT_CHANGE_SCREEN,Transition.NAME));
					}
				case FadeState.FadeOut:
					if (veil.alpha > MIN_ALPHA)
						veil.alpha -= step;
					else
					{
						veil.alpha = MIN_ALPHA;
						state = FadeState.NoFade;
						End();
					}
				default:
			}
		}
	}
	
	public function UpdateVeilSize(width: Float, height : Float) : Void
	{
		veil.width = width;
		veil.height = height;
	}
	
	override public function Start(screen : GameScreen):Void 
	{
		super.Start(screen);
		
		screenContainer.addChild(veil);
		state = FadeState.FadeIn;
	}
	
	override public function StartHalf(screen : GameScreen):Void 
	{
		super.StartHalf(screen);
		
		veil.alpha = MAX_ALPHA;
		screenContainer.addChild(veil);
		state = FadeState.FadeOut;
	}
	
	override public function End():Void 
	{
		super.End();
		
		screenContainer.removeChild(veil);
		state = FadeState.NoFade;
	}
	
	override public function SetOnTop():Void 
	{
		super.SetOnTop();
		
		screenContainer.removeChild(veil);
		screenContainer.addChild(veil);
	}
}