package;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import screentransitions.*;
import screenevents.*;
import flash.ui.Keyboard;

enum ScreenState
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
 **/
class ScreenManager
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "SCREEN_MANAGER";
	
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
	public static var eventDispatcher : EventDispatcher;
	
	/*
	 * Screen container.
	 */
	private static var container : Sprite;
	
	/*
	 * Screen manager state.
	 */
	private static var state : ScreenState;
	
	/*
	 * Transition that will be applied when the screen is added or removed.
	 */
	private static var transition : Transition;
	
	/*
	 * 
	 * */
	private static var auxScreens : Array<GameScreen>;
	
	public static function InitInstance(mainSprite : Sprite): ScreenManager
	{
		if (instance == null)
			instance = new ScreenManager(mainSprite);
		
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
	 * Container is a Sprite where all the elements will be added.
	 */
	private function new(cont : Sprite) 
	{
		container = cont;
		screens = new List<GameScreen>();
		state = ScreenState.Run;
		
		//Event dispatcher
		eventDispatcher = new EventDispatcher();
		
		eventDispatcher.addEventListener(Transition.EVENT_STARTED, OnTransitionChange);
		eventDispatcher.addEventListener(Transition.EVENT_ENDED, OnTransitionChange);
		eventDispatcher.addEventListener(Transition.EVENT_CHANGE_SCREEN, OnTransitionChange);
		eventDispatcher.addEventListener(GameEvents.EVENT_TRACE_SCREENS, HandleEvent);
		eventDispatcher.addEventListener(GameEvents.EVENT_SCREEN_LOADED, HandleEvent);
		eventDispatcher.addEventListener(GameEvents.EVENT_SCREEN_EXITED, HandleEvent);
		eventDispatcher.addEventListener(GameScreen.EVENT_EXECUTE_FUNCTION, HandleEvent);
		
		auxScreens = new Array<GameScreen>();
	}
	
	public static function GetContainer() : Sprite
	{
		return container;
	}
	
	public static function GetEventDispatcher() : EventDispatcher
	{
		return eventDispatcher;
	}
	
	public static function AddEvent(event : String, handler : Dynamic -> Void) : Void
	{
		eventDispatcher.addEventListener(event, handler);
	}
	
	public static function RemoveEvent(event : String, handler : Dynamic -> Void) : Void
	{
		eventDispatcher.removeEventListener(event, handler);
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
			case ScreenState.AddScreen:
				//transition.Update(gameTime);
			case ScreenState.RemoveScreen:
				//transition.Update(gameTime);
			case ScreenState.Run:
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
		//Adapt the logic size to the real size
		if (GraphicManager.ScreenSizeChanged())
			GraphicManager.Resize();
			
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
		var transition : Transition;
		if (event != null)
		{
			switch(event.type)
			{
				case GameEvents.EVENT_TRACE_SCREENS:
					TraceScreens();
				case GameEvents.EVENT_SCREEN_LOADED:
					var e : GameScreenEvent = cast(event, GameScreenEvent);
					
					transition = e.GetTransition();
					LoadScreen(e.GetScreen(),transition);
				case GameEvents.EVENT_SCREEN_EXITED:
					ExitScreen(currentScreen);
				default:
					if (currentScreen != null)
					{
						//if(currentScreen.GetName() == event.GetSource() || event.GetSource() == Console.NAME)
						//	currentScreen.HandleEvent(event);
					}
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
						if (event.keyCode == Keyboard.ESCAPE)
						{
							currentScreen.HandleBackButtonPressed(event);
							event.stopPropagation();
						}
						else
							currentScreen.HandleKeyDownEvent(event.keyCode);
					case KeyboardEvent.KEY_UP:
						if (event.keyCode == Keyboard.ESCAPE)
						{
							currentScreen.HandleBackButtonReleased(event);
							event.stopPropagation();
						}
						else	
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
			}
			
			screens.add(screen);
			container.addChild(screen);
			if (state == ScreenState.AddScreen && transition != null)
				transition.SetOnTop();
			
			currentScreen = screen;
			screen.LoadContent();
			//This was done to preserve the order on the screen
			screen.AddElementsToRender();
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
				container.removeChild(screen);
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
	public static function LoadScreen(screen : GameScreen, newTransition : Transition = null): Void
	{
		if (screen != null)
		{
			//Update new transition if there's any
			if(newTransition != null)
				transition = newTransition;
			
			if (screen.IsPopup())
			{
				if (auxScreens.length <= 0)
					AddScreen(screen);
				else
					auxScreens.push(screen);
			}
			else
			{		
				//TODO: Check and test this
				//There is no transition
				if (newTransition == null)
				{
					//The screen is not a popup, remove all screens
					for (s in screens)
						RemoveScreen(s);
						
					screens.clear();
					state = ScreenState.Run;
					AddScreen(screen);
				}
				else 
				{
					auxScreens.push(screen);
					state = ScreenState.AddScreen;
					transition.Start(screen);
					//Deactivate screen
					if(currentScreen != null)
						currentScreen.SetActive(false);
				}
			}
		}
		else
			throw "Error: the screen cannot be null";
	}
	
	/*
	 * Loads a screen if it is a "Popup screen", 
	 * if it's not, then clean the screens queue and load the new one.
	 */
	public static function ExitScreen(screen : GameScreen, newTransition : Transition = null): Void
	{
		if (screen != null)
		{
			//Update new transition if there's any
			transition = newTransition;
			
			if (!screen.IsExiting())
			{
				screen.Exit();
				
				if (transition == null)
					RemoveScreen(screen);
				else
				{
					//auxScreen = screen;
					auxScreens.push(screen);
					state = ScreenState.RemoveScreen;
					//if(transition != null)
					transition.Start(screen);
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
			case ScreenState.AddScreen:
				if (event.type == Transition.EVENT_ENDED)
					state = ScreenState.Run;
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
			case ScreenState.RemoveScreen:
				if (event.type == Transition.EVENT_ENDED)
					state = ScreenState.Run;
				else if (event.type == Transition.EVENT_CHANGE_SCREEN)
				{	
					if (auxScreens.length > 0)
						RemoveScreen(auxScreens.shift());
				}
			case ScreenState.Run:	
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
	
	public static function StartTransition(newTransition : Transition) : Void
	{
		transition = newTransition;
		if (transition != null)
			transition.Start(currentScreen);
	}
	
	public static function StartHalfTransition(newTransition : Transition) : Void
	{
		transition = newTransition;
		if (transition != null)
			transition.StartHalf(currentScreen);
	}
}