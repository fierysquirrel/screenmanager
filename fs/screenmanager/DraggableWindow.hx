package fs.screenmanager;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;

/**
 * ...
 * @author Henry D. Fernández B.
 */

class DraggableWindow extends Sprite
{

	private var mainBar   : Sprite;
	private var container : Sprite;
	private var closeButton : Sprite;
	private var eventDispatcher : EventDispatcher;
	private var isFocused : Bool;
	
	public function new(x : Float,y : Float,width : Float,height : Float,color : Int,eventDispatcher : EventDispatcher) 
	{
		//super(x,y,width,height,color,true);
		
		super();
		
		this.eventDispatcher = eventDispatcher;
		
		mainBar = new Sprite();
		mainBar.graphics.beginFill(0x666666);
		mainBar.graphics.drawRect(0, 0, width, 20);
		mainBar.graphics.endFill();
		
		container = new Sprite();
		container.graphics.beginFill(0x000000);
		container.graphics.drawRect(0, 0, width, height);
		container.graphics.endFill();
		container.alpha = 0.7;
		
		closeButton = new Sprite();
		closeButton.graphics.beginFill(0x000FFF);
		closeButton.graphics.drawRect(width - 20, 0, 20, 20);
		closeButton.graphics.endFill();
		
		addChild(container);
		addChild(mainBar);
		addChild(closeButton);
		
		
		mainBar.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseBarDown);
		mainBar.addEventListener(MouseEvent.MOUSE_UP, OnMouseBarUp);
		closeButton.addEventListener(MouseEvent.CLICK, OnClose);
		
		this.x = x;
		this.y = y;
	}
	
	function OnMouseBarDown(event : MouseEvent) : Void
	{
		startDrag(false);
	}
	
	function OnMouseBarUp(event : MouseEvent) : Void
	{
		stopDrag();
	}
	
	function OnClose(event : Event) : Void
	{
	}
	
	public function IsFocused() : Bool
	{
		return isFocused;
	}
	
	public function HandleKeyboardPressed(event : KeyboardEvent)
	{}
	
	public function HandleKeyboardReleased(event : KeyboardEvent)
	{}
}