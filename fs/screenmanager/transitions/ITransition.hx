package fs.screenmanager.transitions;

import flash.display.Graphics;

/**
 * ...
 * @author Henry D. Fernández B.
 */

interface ITransition 
{
	/*
	 * Updates the game screen logic.
	 * 
	 * @param gameTime Current game time
	 */
	function Update(gameTime:Float) : Void;
	
	/*
	 * Draws the screen elements.
	 * 
	 * @param gameTime Current game time
	 */
	function Draw(graphics : Graphics) : Void;
}