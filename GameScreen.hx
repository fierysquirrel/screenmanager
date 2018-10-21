package;

import openfl.display.SparrowTileset;
import openfl.display.Tile;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.text.TextField;
import openfl.Assets;
import screenevents.*;
import flash.ui.Keyboard;

/**
 * Concrete class that represents a game screen logic.
 * 
 * @author Henry D. Fernández B.
 */
class GameScreen extends Sprite implements IGameScreen
{
	/*
	 * .
	 * */
	static public var EVENT_EXECUTE_FUNCTION : String 	= "GAMESCREEN_EXECUTE_FUNCTION";
	
	static public var MOUSE_DOWN_ID : Int = -1;
	
	/*
	 * Event dispatcher, fires all the logic events.
	 * */
	private var eventDispatcher : EventDispatcher;
	
	/*
	 * Screen manager view events handler.
	 * */
	public var viewEventsHandler : Dynamic -> Void;
	
	/*
	 * Is the screen a popup screen?.
	 */
	private var isPopup : Bool;
	
	/*
	 * Is the screen being removed?.
	 */
	private var isExit : Bool;
	
	/*
	 * Is the screen active?.
	 */
	private var isActive : Bool;
	
	/*
	 * Sprites.
	 */
	private var sprites : Map<String,Tile>;
	
	/*
	 * Tilesheets.
	 */
	private var tilesheets : Map<String,SparrowTileset>;
	
	/*
	 * Layers.
	 */
	private var layers : Map<String,Layer>;
	
	private var backgroundColor : BackgroundColor;
	
	public function new(name : String = "",x : Float = 0,y : Float = 0,isPopup : Bool = false) 
	{	
		super();
		
		this.x = x;
		this.y = y;
		this.name = name;
		this.isPopup = isPopup;
		
		isExit = false;
		isActive = true;
		layers = new Map<String,Layer>();
		sprites = new Map<String,Tile>();
		
		eventDispatcher = ScreenManager.GetEventDispatcher();
		
		//Background
		InitBackgroundColor();
	}
	
	private function InitBackgroundColor() 
	{
		//Re-write this function where you want to add a background color
		if(backgroundColor != null)
			addChild(backgroundColor);
	}
	
	public function LoadContent() : Void
	{
	}
	
	public function Clean() : Void
	{
		for (k in layers.keys())
		{
			while(layers.get(k).numTiles > 0)
				layers.get(k).removeTileAt(0);
			
			layers.remove(k);
		}
		
		while (numChildren > 0)
			removeChildAt(0);
			
		if (backgroundColor != null)
			removeChild(backgroundColor);
			
		//trace("SI SE EJECUTA");
	}
	
	/*
	 * Is the screen a popup screen?.
	 */
	public function IsPopup() : Bool
	{
		return isPopup;
	}
	
	/*
	 * Is the screen being removed?.
	 */
	public function IsExiting() : Bool
	{
		return isExit;
	}
	
	/*
	 * Is the screen active?.
	 */
	public function IsActive() : Bool
	{
		return isActive;
	}
	
	/*
	 * Is the screen being removed?.
	 */
	public function SetActive(active : Bool) : Void
	{
		isActive = active;
	}
	
	/*
	 * Get screen name.
	 */
	public function GetName() : String
	{
		return name;
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
	public function Draw(graphics:Graphics) : Void
	{
		//for (l in layers)
			//l.render();
	}
	
	/*
	 * 
	 */
	public function Destroy() : Void
	{}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleEvent(event : GameEvent) : Void
	{
		if (event.type == EVENT_EXECUTE_FUNCTION)
		{
			var funcEvent : FunctionEvent = cast(event, FunctionEvent);
			var isFunction : Bool;
			try
			{
				isFunction = Reflect.isFunction(Reflect.field(this, funcEvent.GetFunctionName()));
				
				if (isFunction)
					Reflect.callMethod(this, Reflect.field(this, funcEvent.GetFunctionName()), funcEvent.GetArgs());
				else	
					throw "Error: " + funcEvent.GetFunctionName() + " is not a function.";
			}
			catch (e : String)
			{
				trace(e);
			}
		}
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleKeyDownEvent(key : UInt) : Void
	{
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleKeyUpEvent(key : UInt) : Void
	{
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleMouseClickEvent(event : MouseEvent) : Void
	{
		var mousePos : Point;
		
		mousePos = new Point(event.stageX, event.stageY);
		HandleCursorClick(mousePos,MOUSE_DOWN_ID);
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleMouseDownEvent(event : MouseEvent) : Void
	{
		var mousePos : Point;
		
		mousePos = new Point(event.stageX, event.stageY);
		HandleCursorDown(mousePos,MOUSE_DOWN_ID);
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleMouseMoveEvent(event : MouseEvent) : Void
	{
		var mousePos : Point;
		
		mousePos = new Point(event.stageX, event.stageY);
		HandleCursorMove(mousePos,MOUSE_DOWN_ID);
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleMouseOutEvent(event : MouseEvent) : Void
	{
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleMouseUpEvent(event : MouseEvent) : Void
	{
		var mousePos : Point;
		
		mousePos = new Point(event.stageX, event.stageY);
		HandleCursorUp(mousePos,MOUSE_DOWN_ID);
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleTouchTapEvent(event : TouchEvent) : Void
	{
		var mousePos : Point;
		
		//TODO: verify this is actually working as expected
		mousePos = new Point(event.stageX, event.stageY);
		HandleCursorClick(mousePos,MOUSE_DOWN_ID);
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleTouchDownEvent(event : TouchEvent) : Void
	{
		var touchPos : Point;
		
		touchPos = new Point(event.stageX, event.stageY);
		HandleCursorDown(touchPos,event.touchPointID);
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleTouchMoveEvent(event : TouchEvent) : Void
	{
		var touchPos : Point;
		
		touchPos = new Point(event.stageX, event.stageY);
		HandleCursorMove(touchPos,event.touchPointID);
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public function HandleTouchUpEvent(event : TouchEvent) : Void
	{
		var touchPos : Point;
		
		touchPos = new Point(event.stageX, event.stageY);
		HandleCursorUp(touchPos,event.touchPointID);
	}
	
	private function HandleCursorClick(cursorPos : Point,cursorId : Int) : Void
	{
	}
	
	private function HandleCursorDown(cursorPos : Point,cursorId : Int) : Void
	{
	}
	
	private function HandleCursorMove(cursorPos : Point, cursorId : Int) : Void
	{
	}
	
	private function HandleCursorUp(cursorPos : Point, cursorId : Int) : Void
	{
	}
	
	/*
	 * Exits this screen.
	 * Calls the screen managers and request for being removed.
	 */
	public function Exit() : Void
	{
		isExit = true;
	}
	
	/*
	 * Draws the background color for this screen.
	 */
	public function DrawBackgroundColor() : Void
	{}
	
	private function AddEventHandler(event : String)
	{
		if(eventDispatcher != null && !eventDispatcher.hasEventListener(event))
			eventDispatcher.addEventListener(event, ScreenManager.HandleEvent);
	}
	
	private function AddAllHandlers(event : String)
	{
	}
	
	private function RemoveAllHandlers(event : String)
	{
	}
	
	public function AddToLayer(key : String,element : Tile)
	{
		if (layers.get(key).getTileIndex(element) == -1)
			layers.get(key).addTile(element);
	}
	
	public function RemoveFromLayer(key : String,element : Tile)
	{
		if (layers.get(key).getTileIndex(element) != -1)
			layers.get(key).removeTile(element);
	}
	
	public function HandleBackButtonPressed(e : Event) : Void
	{
	}
	
	public function HandleBackButtonReleased(e : Event) : Void
	{
	}
	
	public function AddLayer(key : String,element : Layer) : Void
	{
		if (!layers.exists(key))
		{
			layers.set(key, element);
			addChild(element);
		}
	}
	
	public function AddElementsToRender() : Void
	{
		var orderedLayers : Array<Layer>;
		
		orderedLayers = new Array<Layer>();
		
		for (l in layers)
			orderedLayers.push(l);
		
		//Order
		orderedLayers.sort(SortLayer);
			
		//Layers
		//TODO: review if this is still necessary
		//for (l in orderedLayers)
			//addChild(l.view);
	}
	
	private function SortLayer(x : Layer,y : Layer) : Int
	{
		if (x.GetOrder() == y.GetOrder())
			return 0;
		else if (x.GetOrder() > y.GetOrder())
			return 1;
		else
			return -1;
	}
	
	public function RemoveLayer(key : String) : Void
	{
		if (layers.exists(key))
		{
			//removeChild(layers.get(key).view);
			layers.remove(key);
		}
	}
	
	public function GetLayer(key : String) : Layer
	{
		return layers.get(key);
	}
	
	private function Render() : Void
	{
		//for (l in layers)
			//l.render();
	}
	
	public function TransitionChanged() : Void
	{}
	
	public function TransitionEnded() : Void
	{}
}