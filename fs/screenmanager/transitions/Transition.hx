package fs.screenmanager.transitions;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import fs.screenmanager.events.GameEvent;

/**
 * ...
 * @author Henry D. Fernández B.
 */

class Transition implements ITransition
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "TRANSITION";
	
	/*
	 * This event is fired when the transition ends.
	 * */
	static public var EVENT_ENDED : String = "TRANSITION_ENDED";
	
	/*
	 * This event is fired when the transition starts.
	 * */
	static public var EVENT_STARTED : String = "TRANSITION_STARTED";
	
	/*
	 * This event is fired when the screen should be removed or changed or added.
	 * Some transitions are not supposed to end exactly when the screen is added or removed.
	 * This event is used for that specific moment.
	 * */
	static public var EVENT_CHANGE_SCREEN : String = "TRANSITION_CHANGE_SCREEN";
	
	
	/*
	 * Event dispatcher, fires all the logic events.
	 * */
	private var eventDispatcher : EventDispatcher;
	
	/*
	 * Event dispatcher, fires all the logic events.
	 * */
	private var isEnded : Bool;
	
	/*
	 * Event dispatcher, fires all the logic events.
	 * */
	private var isRunning : Bool;
	
	/*
	 * Screen container.
	 */
	private var screenContainer : Sprite;
	
	public function new(eventDispatcher : EventDispatcher,screenContainer : Sprite) 
	{
		isEnded = false;
		isRunning = false;
		this.eventDispatcher = eventDispatcher;
		this.screenContainer = screenContainer;
	}
	
	/*
	 * Updates the game screen logic.
	 * 
	 * @param gameTime Current game time
	 */
	public function Update(gameTime:Float) : Void
	{}
	
	/*
	 * Draws the screen elements.
	 * 
	 * @param gameTime Current game time
	 */
	public function Draw(graphics : Graphics) : Void
	{}
	
	/*
	 * 
	 */
	public function IsEnded() : Bool
	{
		return isEnded;
	}
	
	/*
	 * 
	 */
	public function IsRunning() : Bool
	{
		return isRunning;
	}
	
	/*
	 * 
	 */
	public function Start() : Void
	{
		isRunning = true;
		eventDispatcher.dispatchEvent(new GameEvent(EVENT_STARTED,NAME));
	}
	
	/*
	 * 
	 */
	public function StartHalf() : Void
	{
		isRunning = true;
		//eventDispatcher.dispatchEvent(new GameEvent(EVENT_STARTED,NAME));
	}
	
	/*
	 * 
	 */
	public function End() : Void
	{
		isRunning = false;
		eventDispatcher.dispatchEvent(new GameEvent(EVENT_ENDED,NAME));
	}
}