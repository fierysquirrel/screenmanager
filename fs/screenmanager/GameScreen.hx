package fs.screenmanager;

import aze.display.SparrowTilesheet;
import aze.display.TileLayer;
import aze.display.TileSprite;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.text.TextField;
import openfl.Assets;

import fs.screenmanager.events.GameEvent;
import fs.screenmanager.events.FunctionEvent;

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
	private var sprites : Map<String,TileSprite>;
	
	/*
	 * Tilesheets.
	 */
	private var tilesheets : Map<String,SparrowTilesheet>;
	
	/*
	 * Layers.
	 */
	private var layers : Map<String,TileLayer>;
	
	private var textFields : Map<String,TextField>;
	
	private var popupVeil : Sprite;
	
	private var view : String;
	
	
	public function new(name : String = "",x : Float = 0,y : Float = 0,view : String = "",isPopup : Bool = false) 
	{	
		super();
		
		this.x = x;
		this.y = y;
		this.name = name;
		this.view = view;
		this.isPopup = isPopup;
		
		isExit = false;
		isActive = true;
		layers = new Map<String,TileLayer>();
		textFields = new Map<String,TextField>();
		sprites = new Map<String,TileSprite>();
		
		eventDispatcher = ScreenManager.GetEventDispatcher();
	}
	
	public function LoadContent() : Void
	{
		if (isPopup)
		{
			/*popupVeil = new Sprite();
			popupVeil.graphics.beginFill(Globals.VEIL_COLOR);
			popupVeil.graphics.drawRect(0,0,Globals.SCREEN_WIDTH,Globals.SCREEN_HEIGHT);
			popupVeil.graphics.endFill();
			popupVeil.alpha = Globals.VEIL_ALPHA;
			addChild(popupVeil);*/
		}
		
		ParseView(view);
	}
	
	private function ParseViewHeader(xml : Xml) : Void
	{}
	
	private function ParseViewBody(xml : Xml) : Void
	{}
	
	private function ParseView(view : String) :Void
	{
		var str : String;
		var xml : Xml;
		
		try
		{
			if (view != "")
			{
				str = Assets.getText(view);
				xml = Xml.parse(str).firstElement();
				
				ParseViewHeader(xml);
				for (e in xml.elements())
					ParseViewBody(e);
			}
		}
		catch (e : String)
		{
			trace(e);
		}
	}
	
	public function Clean() : Void
	{
		for (k in layers.keys())
		{
			while(layers.get(k).children.length > 0)
				layers.get(k).removeChildAt(0);
			
			layers.remove(k);
		}
		
		while (numChildren > 0)
			removeChildAt(0);
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
	public function HandleMouseClickEvent(event : MouseEvent) : Void
	{
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
	
	private function HandleCursorDown(cursorPos : Point,cursorId : Int) : Void
	{}
	
	private function HandleCursorMove(cursorPos : Point, cursorId : Int) : Void
	{}
	
	private function HandleCursorUp(cursorPos : Point, cursorId : Int) : Void
	{}
	
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
	
	public function AddToLayer(key : String,element : TileBase)
	{
		if (layers.get(key).indexOf(element) == -1)
			layers.get(key).addChild(element);
	}
	
	public function RemoveFromLayer(key : String,element : TileBase)
	{
		if (layers.get(key).indexOf(element) != -1)
			layers.get(key).removeChild(element);
	}
	
	public function AddText(key : String,text : TextField) : Void
	{
		if (!textFields.exists(key))
		{
			textFields.set(key, text);
			addChild(text);
		}
	}
	
	public function HandleBackButtonPressed(e : Event) : Void
	{
	}
	
	public function HandleBackButtonReleased(e : Event) : Void
	{
	}
	
	public function AddLayer(key : String,element : TileLayer) : Void
	{
		if (!layers.exists(key))
		{
			layers.set(key, element);
			addChild(element.view);
		}
	}
	
	public function RemoveLayer(key : String) : Void
	{
		if (layers.exists(key))
		{
			removeChild(layers.get(key).view);
			layers.remove(key);
		}
	}
	
	public function GetLayer(key : String) : TileLayer
	{
		return layers.get(key);
	}
	
	private function Render() : Void
	{
		for (l in layers)
			l.render();
	}
	
	public function TransitionChanged() : Void
	{}
	
	public function TransitionEnded() : Void
	{}
}