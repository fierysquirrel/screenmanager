package fs.screenmanager.console;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import fs.screenmanager.events.GameEvent;
import fs.screenmanager.events.GameScreenEvent;
import fs.screenmanager.events.GameEvents;
import fs.screenmanager.events.FunctionEvent;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Console extends DraggableWindow
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "CONSOLE";
	static public var CURSOR_TIME : Float = 0.1;
	
	private static var instance : Console;
	var console : TextField;
	var consoleText : TextField;
	var commandList : Array<String>;
	var currentCommand : Int;
	var command  : String;
	var scroll : Rectangle;
	var shifPressed : Bool;
	var cursorTimer : Float;
	var cursorOn : Bool;
	
	public static function GetInstance(x : Float,y : Float,width : Float,height : Float,eventDispatcher : EventDispatcher) : Console
	{
		if (instance == null)
			instance = new Console(x,y,width,height,eventDispatcher);
		
		return instance;
	}
	
	private function new(x : Float,y : Float,width : Float,height : Float,eventDispatcher : EventDispatcher) 
	{
		super(x, y, width, height,0x000000,eventDispatcher);
		
		command = "";
		
		var format = new TextFormat ("Verdana", 16, 0xFFFFFF);
		var format2 = new TextFormat ("Verdana", 16, 0xFFFFFF);
		
		
		console = new TextField();
		console.defaultTextFormat = format;
		console.selectable = false;
		//console.embedFonts = true;
		console.width = width;
		console.height = height;
		console.x = 0;
		console.y = 20;
		console.alpha = 0.5;
		console.multiline = true;
		console.backgroundColor = 0x000000;
		console.background = true;
		console.border = true;
		console.borderColor = 0x666666;
		console.wordWrap = true;
		console.autoSize = TextFieldAutoSize.LEFT;
		
		scroll = new Rectangle(0, 0, width, height - 40);
		console.scrollRect = scroll;
		//console.scrollV = 500;
		console.text = "Console:\n";
		
		consoleText = new TextField();
		consoleText.defaultTextFormat = format2;
		consoleText.selectable = false;
		consoleText.x = 0;
		consoleText.y = height - 20;
		consoleText.multiline = true;
		consoleText.autoSize = TextFieldAutoSize.LEFT;
		consoleText.scrollRect = new Rectangle(0, 0, width, 20);
		commandList = new Array<String>();
		currentCommand = -1;
		consoleText.text = "_";
		
		addChild(console);
		addChild(consoleText);
		
		closeButton.addEventListener(MouseEvent.CLICK, OnClose);
		
		this.eventDispatcher = eventDispatcher;
		
		shifPressed = false;
		cursorTimer = 0;
		cursorOn = true;
	}
	
	private function Scroll()
	{
		//scroll.y++;
		//console.scrollRect = scroll;
		
		//scroll.y--;
		//console.scrollRect = scroll;
	}
	
	public function Update(gameTime : Float) : Void
	{
		/*if (cursorTimer >= Helper.ConvertSecToMillisec(CURSOR_TIME))
		{
			if (cursorOn)
				consoleText.text = consoleText.text.substr(0, command.length - 1);
			else
				consoleText.text += "|";
			
			cursorOn = !cursorOn;	
			cursorTimer = 0;
		}
		else
			cursorTimer += gameTime;*/
	}
	
	public override function HandleKeyboardPressed(event : KeyboardEvent)
	{
		var params : Array<String> = command.split(' ');
		var comm : String = params[0];
		
		switch(event.keyCode)
		{
			case Keyboard.SHIFT:
				shifPressed = true;
			case Keyboard.RIGHT:
				scroll.y++;
				console.scrollRect = scroll;
			case Keyboard.LEFT:
				scroll.y--;
				console.scrollRect = scroll;
			case Keyboard.UP:
				if (currentCommand + 1 < commandList.length)
				{
					currentCommand++;
					command = commandList[currentCommand];
					consoleText.text = command;
				}	
			case Keyboard.DOWN:
				if (currentCommand - 1 >= 0)
				{
					currentCommand--;
					command = commandList[currentCommand];
					consoleText.text = command;
				}
			case Keyboard.ENTER:
				
				//Type.resolveClass(
				//var instance : ICommand = Type.createInstance(Type.resolveClass(com), []);
				
				
				switch(comm)
				{
					case "trace":
						eventDispatcher.dispatchEvent(new GameEvent(GameEvents.EVENT_TRACE_SCREENS,NAME));
					case "restart":
						eventDispatcher.dispatchEvent(new GameEvent(GameEvents.EVENT_RESTART_GAME,NAME));
					case "close":
						Clean();
						eventDispatcher.dispatchEvent(new GameEvent(GameEvents.EVENT_CLOSE_CONSOLE,NAME));
					case "debug":
						var debug = params[1] == "on" ? true : false;
					case "fun":
						var funcName : String = params[1];
						var args : Array<Dynamic>;
						args = new Array<Dynamic>();
						if (params.length > 2)
						{
							for (i in 2 ... params.length)
							{
								if (Std.is(params[i], Float))
									args.push(Std.parseFloat(params[i]));
								else if (Std.is(params[i], Float))
									args.push(Std.parseInt(params[i]));
								else
									args.push(params[i]);
							}
						}
						
						eventDispatcher.dispatchEvent(new FunctionEvent(GameScreen.EVENT_EXECUTE_FUNCTION,NAME,funcName,args));
					case "exit":
						eventDispatcher.dispatchEvent(new GameEvent(GameEvents.EVENT_EXIT_GAME,NAME));
					case "add":
						var scr : GameScreen = null;
						
						var action = params[1];
						switch(action)
						{
							case "main":
								//scr = new MainMenuScreen();
							case "pause":
								//scr = new PauseScreen(eventDispatcher,1280, 800);
							default:
								console.text += action + " is not  defined";
						}
						if(scr != null)
							eventDispatcher.dispatchEvent(new GameScreenEvent(GameEvents.EVENT_SCREEN_LOADED,scr));
					case "remove":
						eventDispatcher.dispatchEvent(new GameEvent(GameEvents.EVENT_SCREEN_EXITED,NAME));
					case "animation":
						var action = params[1];
						switch(action)
						{
							case "play":
								//anim.Play();
							case "pause":
								//anim.Pause();
							case "stop":
								//anim.Stop();
							case "resume":
								//anim.Resume();
							case "rotate":
								var param1 = params[2];
								//anim.Rotate(Std.parseInt(param1));
							case "translate":
								var param1 = params[2];
								var param2 = params[3];
								//anim.Translate(Std.parseFloat(param1), Std.parseFloat(param2));
							case "scale":
								var param1 = params[2];
								var param2 = params[3];
								//anim.Scale(Std.parseFloat(param1), Std.parseFloat(param2));
							default:
								console.text += action + " is not  defined";
						}
					default:
						console.text += command + " is not  defined";
				}
				
				console.text += command + "\n";
				commandList.push(command);
				command = "";
				consoleText.text = command;
			case Keyboard.BACKSPACE:
				command = command.substr(0, command.length - 1);
				consoleText.text = command + "_";
			default:
				command += shifPressed ? String.fromCharCode(event.charCode).toUpperCase() : String.fromCharCode(event.charCode).toLowerCase();
				consoleText.text = command + "_";
		}
	}
	
	public override function HandleKeyboardReleased(event : KeyboardEvent)
	{
		switch(event.keyCode)
		{
			case Keyboard.SHIFT:
				shifPressed = false;
			default:
		}
	}
	
	override private function OnClose(event:Event):Void 
	{
		Clean();
		eventDispatcher.dispatchEvent(new Event(GameEvents.EVENT_CLOSE_CONSOLE));
	}
	
	public function PrintText(text : String) : Void
	{
		console.text += "print: " + text + "\n";
	}
	
	private function Clean() : Void
	{
		command = "";
		consoleText.text = "";
	}
	
	public static function Print(text : String) : Void
	{
		if (instance != null)
			instance.PrintText(text);
	}
}