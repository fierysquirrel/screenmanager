package fs.screenmanager.console;

/**
 * ...
 * @author Henry D. Fernández B.
 */

interface ICommand
{
	/*
	 * This method parses the input command and performs a task accordingly.
	 * */
	public function Parse(command : String) : Void;
}