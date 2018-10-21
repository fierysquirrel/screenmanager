package screenevents;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class GameEvents
{
	/*
	 * Screen added to the game.
	 * */
	static public inline var EVENT_SCREEN_ADDED : String 	= "SCREEN_MANAGER_SCREEN_ADDED";
	/*
	 * Screen removed to the game.
	 * */
	static public inline var EVENT_SCREEN_REMOVED : String = "SCREEN_MANAGER_SCREEN_REMOVED";
	/*
	 * Screen removed to the game.
	 * */
	static public inline var EVENT_SCREEN_LOADED : String 	= "SCREEN_MANAGER_SCREEN_LOADED";
	/*
	 * Screen exited.
	 * */
	static public inline var EVENT_SCREEN_EXITED : String 	= "SCREEN_MANAGER_SCREEN_EXITED";
	/*
	 * .
	 * */
	static public inline var EVENT_TRACE_SCREENS : String 	= "SCREEN_MANAGER_TRACE_SCREENS";
	/*
	 * Exit the game.
	 * */
	static public inline var EVENT_EXIT_GAME : String 		= "MAIN_EXIT_GAME";
	/*
	 * Restart the game.
	 * */
	static public inline var EVENT_RESTART_GAME : String 	= "MAIN_RESTART_GAME";
	/*
	 * Launch console.
	 * */
	static public inline var EVENT_LAUNCH_CONSOLE : String = "MAIN_LAUNCH_CONSOLE";
	/*
	 * Close console.
	 * */
	static public inline var EVENT_CLOSE_CONSOLE : String 	= "MAIN_CLOSE_CONSOLE";
	/*
	 * Close inspector.
	 * */
	static public inline var EVENT_CLOSE_INSPECTOR : String = "MAIN_CLOSE_INSPECTOR";
}