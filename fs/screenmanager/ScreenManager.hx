package fs.screenmanager;

import fs.screenmanager.console.Console;
import fs.screenmanager.events.GameEvent;
import fs.screenmanager.events.GameScreenEvent;
import fs.screenmanager.transitions.FadeTransition;
import fs.screenmanager.transitions.Transition;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import fs.screenmanager.events.GameEvents;


enum State
{
	AddScreen;
	RemoveScreen;
	Run;
}
	
/**
 * 
 * This is the core of the screen system. All screens are managed by this class.
 * Due to its nature, the screen manager is modeled as a Singleton.
 * Screen manager cannot be instantiated directly, to get an instance "GetInstance" should be used.
 * Singleton is used to prevent more than one instance of the screen manager class.
 * 
 * @author Henry D. Fernández B.
 */
class ScreenManager
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "SCREEN_MANAGER";
	
	/*
	 * Transition time in seconds.
	 * */
	static public var TRANSITION_TIME : Float = 0.5;
	
	/*
	 * Screen manager instance.
	 */
	private static var instance : ScreenManager;
	
	/*
	 * Current showing screen.
	 */
	private static var currentScreen: GameScreen;
 
	/*
	 * Game screens.
	 */
	private static var screens : List<GameScreen>;
	
	/*
	 * Event dispatcher, fires all the logic events.
	 * */
	public static var EVENT_DISPATCHER : EventDispatcher;
	
	/*
	 * Screen container.
	 */
	private static var gameContainer : Sprite;
	
	/*
	 * Screen container.
	 */
	private static var fixedContainer : Sprite;
	
	/*
	 * Screen manager state.
	 */
	private static var state : State;
	
	private var screenWidth : Float;
	
	private var screenHeight : Float;
	
	private var fadeColor : Int;
	
	/*
	 * .
	 */
	//private static var auxScreen : GameScreen;
	
	/*
	 * Transition that will be applied when the screen is added or removed.
	 */
	private static var transition : Transition;
	
	private static var auxScreens : Array<GameScreen>;
	
	public static function InitInstance(eventDisp : EventDispatcher,gc : Sprite,fc : Sprite, screenWidth : Float, screenHeight : Float, fadeColor : Int): ScreenManager
	{
		if (instance == null)
			instance = new ScreenManager(eventDisp,gc,fc,screenWidth,screenHeight,fadeColor);
		
		return instance;
	}
	
	/*
	 * Creates and returns a screen manager instance if it's not created yet.
	 * Returns the current instance of this class if it already exists.
	 */
	public static function GetInstance(): ScreenManager
	{
		if ( instance == null )
			throw "The Screen Manager is not initialized. Use function 'InitInstance'";
		
		return instance;
	}
	
	/*
	 * Constructor
	 */
	private function new(eventDisp : EventDispatcher,gc : Sprite,fc : Sprite,screenWidth : Float, screenHeight : Float, fadeColor : Int) 
	{
		this.screenWidth = screenWidth;
		this.screenHeight = screenHeight;
		this.fadeColor = fadeColor;
		screens = new List<GameScreen>();
		EVENT_DISPATCHER = eventDisp;
		gameContainer = gc;
		fixedContainer = fc;
		state = State.Run;
		
		transition = new FadeTransition(EVENT_DISPATCHER,fixedContainer,screenWidth,screenHeight,fadeColor,TRANSITION_TIME);
		
		EVENT_DISPATCHER.addEventListener(Transition.EVENT_STARTED, OnTransitionChange);
		EVENT_DISPATCHER.addEventListener(Transition.EVENT_ENDED, OnTransitionChange);
		EVENT_DISPATCHER.addEventListener(Transition.EVENT_CHANGE_SCREEN, OnTransitionChange);
		EVENT_DISPATCHER.addEventListener(GameEvents.EVENT_TRACE_SCREENS, HandleEvent);
		EVENT_DISPATCHER.addEventListener(GameEvents.EVENT_SCREEN_LOADED, HandleEvent);
		EVENT_DISPATCHER.addEventListener(GameEvents.EVENT_SCREEN_EXITED, HandleEvent);
		EVENT_DISPATCHER.addEventListener(GameScreen.EVENT_EXECUTE_FUNCTION, HandleEvent);
		
		auxScreens = new Array<GameScreen>();
	}
	
	/*
	 * This is executed when the object is destroyed.
	 * Usually it handles resources and all programmer's set content.
	 * .
	 */
	public static function Destroy()
	{
	}
	
	/*
	 * Updates the game screen logic.
	 * 
	 * @param gameTime Current game time
	 */
	public static function Update(gameTime:Float) : Void
	{
		if (transition != null)
			transition.Update(gameTime);
		switch(state)
		{
			case State.AddScreen:
				//transition.Update(gameTime);
			case State.RemoveScreen:
				//transition.Update(gameTime);
			case State.Run:
				if (currentScreen != null)
					currentScreen.Update(gameTime);
		}
	}
	
	/*
	 * Draws the screen elements.
	 * 
	 * @param gameTime Current game time
	 */
	public static function Draw(graphics:Graphics) : Void
	{
		if (currentScreen != null)
			currentScreen.Draw(graphics);
		
		if(transition != null)
			transition.Draw(graphics);
			/*switch(state)
			{
				case State.AddScreen:
					transition.Draw(graphics);
				case State.RemoveScreen:
					transition.Draw(graphics);
				default:
			}*/
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public static function HandleEvent(event : GameEvent)
	{
		switch(event.type)
		{
			case GameEvents.EVENT_TRACE_SCREENS:
				TraceScreens();
			case GameEvents.EVENT_SCREEN_LOADED:
				var e : GameScreenEvent = cast(event, GameScreenEvent);
				LoadScreen(e.GetScreen());
			case GameEvents.EVENT_SCREEN_EXITED:
				ExitScreen(currentScreen);
			default:
				if (currentScreen != null)
				{
					if(currentScreen.GetName() == event.GetSource() || event.GetSource() == Console.NAME)
						currentScreen.HandleEvent(event);
				}
		}
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public static function HandleKeyboardEvent(event : KeyboardEvent) : Void
	{
		if (currentScreen != null)
		{
			if (currentScreen.IsActive())
			{
				switch(event.type)
				{
					case KeyboardEvent.KEY_DOWN:
						currentScreen.HandleKeyDownEvent(event.keyCode);
					case KeyboardEvent.KEY_UP:
						currentScreen.HandleKeyUpEvent(event.keyCode);
				}
			}
		}
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public static function HandleMouseEvent(event : MouseEvent) : Void
	{
		var e : MouseEvent;
		if (currentScreen != null)
		{
			if (currentScreen.IsActive())
			{
				switch(event.type)
				{
					case MouseEvent.MOUSE_DOWN:
						currentScreen.HandleMouseDownEvent(event);
					case MouseEvent.MOUSE_UP:
						currentScreen.HandleMouseUpEvent(event);
					case MouseEvent.MOUSE_MOVE:
						currentScreen.HandleMouseMoveEvent(event);
					case MouseEvent.CLICK:
						currentScreen.HandleMouseClickEvent(event);
				}
			}
		}
	}
	
	/*
	 * Handles the event passed from the main.
	 * 
	 * @param event the passed event to be handled.
	 */
	public static function HandleTouchEvent(event : TouchEvent) : Void
	{
		var e : MouseEvent;
		if (currentScreen != null)
		{
			if (currentScreen.IsActive())
			{
				switch(event.type)
				{
					case TouchEvent.TOUCH_BEGIN:
						currentScreen.HandleTouchDownEvent(event);
					case TouchEvent.TOUCH_END:
						currentScreen.HandleTouchUpEvent(event);
					case TouchEvent.TOUCH_MOVE:
						currentScreen.HandleTouchMoveEvent(event);
					case TouchEvent.TOUCH_TAP:
						currentScreen.HandleTouchTapEvent(event);
				}
			}
		}
	}
	
	/*
	 * Adds a new screen to the queue and set it as the current screen.
	 * To properly load a screen into the screens queue, use LoadScreen method.
	 */
	private static function AddScreen(screen : GameScreen): Void
	{
		if (screen != null)
		{
			//Deactivate screen
			if (currentScreen != null)
			{
				currentScreen.SetActive(false);
				//trace("deactivate");
			}
			
			screens.add(screen);
			gameContainer.addChild(screen);
			currentScreen = screen;
			screen.LoadContent();
		}
		else
			throw "Error: the screen cannot be null";
	}
	
	/*
	 * Removes a screen from the queue and set the previous screen as the current.
	 */
	private static function RemoveScreen(screen : GameScreen): Void
	{	
		if (screen != null)
		{
			if (!screens.isEmpty())
			{
				screen.Clean();
				gameContainer.removeChild(screen);
				screens.remove(screen);
				currentScreen = screens.last();
				
				//Activate screen
				if(currentScreen != null)
					currentScreen.SetActive(true);
			}	
		}
		else
			throw "Error: the screen cannot be null";
	}
	
	/*
	 * Loads a screen if it is a "Popup screen", 
	 * if it's not, then clean the screens queue and load the new one.
	 */
	public static function LoadScreen(screen : GameScreen): Void
	{
		if (screen != null)
		{
			if (screen.IsPopup())
			{
				if (auxScreens.length <= 0)
					AddScreen(screen);
				else
					auxScreens.push(screen);
			}
			else
			{
				auxScreens.push(screen);
				state = State.AddScreen;
				transition.Start();
				
				//Deactivate screen
				if(currentScreen != null)
					currentScreen.SetActive(false);
			}
		}
		else
			throw "Error: the screen cannot be null";
	}
	
	/*
	 * Loads a screen if it is a "Popup screen", 
	 * if it's not, then clean the screens queue and load the new one.
	 */
	public static function ExitScreen(screen : GameScreen): Void
	{
		if (screen != null)
		{
			if (!screen.IsExiting())
			{
				screen.Exit();
				
				if (screen.IsPopup())
					RemoveScreen(screen);
				else
				{
					//auxScreen = screen;
					auxScreens.push(screen);
					state = State.RemoveScreen;
					transition.Start();
				}
			}
		}
		else
			throw "Error: the screen cannot be null";
	}
	
	/*
	 *
	 */
	private static function OnTransitionChange(event : GameEvent): Void
	{			
		switch(state)
		{
			case State.AddScreen:
				if (event.type == Transition.EVENT_ENDED)
					state = State.Run;
				else if (event.type == Transition.EVENT_CHANGE_SCREEN)
				{	
					if (auxScreens.length > 0)
					{
						//The screen is not a popup, remove all screens
						for (s in screens)
							RemoveScreen(s);
							
						screens.clear();
						while (auxScreens.length > 0)
							AddScreen(auxScreens.shift());
					}
				}
			case State.RemoveScreen:
				if (event.type == Transition.EVENT_ENDED)
					state = State.Run;
				else if (event.type == Transition.EVENT_CHANGE_SCREEN)
				{	
					if (auxScreens.length > 0)
						RemoveScreen(auxScreens.shift());
				}
			case State.Run:	
				if (event.type == Transition.EVENT_ENDED)
				{
					if (currentScreen != null)
						currentScreen.TransitionEnded();
				}
				else if (event.type == Transition.EVENT_CHANGE_SCREEN)
				{	
					if (currentScreen != null)
						currentScreen.TransitionChanged();
				}
		}
	}
	
	/*
	 *
	 */
	private static function TraceScreens(): Void
	{
		trace("/n");
		for (s in screens)
			trace(s.GetName() + " " + s.IsActive());
	}
	
	public static function HandleBackButtonPressed(e : Event) : Void
	{
		currentScreen.HandleBackButtonPressed(e);
	}
	
	public static function HandleBackButtonReleased(e : Event) : Void
	{
		currentScreen.HandleBackButtonReleased(e);
	}
	
	public static function StartTransition() : Void
	{
		if (transition != null)
			transition.Start();
	}
	
	public static function StartHalfTransition() : Void
	{
		if (transition != null)
			transition.StartHalf();
	}
}