package;

import flash.display.Graphics;

/**
 * Interface that represents a game screen logic.
 * 
 * @author Henry D. Fernández B.
 */
interface IGameScreen
{	
	/*
	 * Updates the game screen logic.
	 * 
	 * @param gameTime Current game time
	 */
	function Update(gameTime:Float) : Void;
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	function HandleEvent(event:GameEvent) : Void;
	
	/*
	 * Draws the screen elements.
	 * 
	 * @param gameTime Current game time
	 */
	function Draw(graphics : Graphics) : Void;
	
	/*
	 * Frees all the programmer's loaded resources.
	 */
	function Destroy() : Void;
}