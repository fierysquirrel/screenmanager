# Screen Manager for OpenFL

This is the core of the screen system. All screens are managed by this class.

# Functionality:
- Basic game screen
- Popup screens
- Screen properties
- Layers to handle each screen
- Screens transitions
- Loading, removing, changing screens

Initialize the system using ScreenManager.InitInstance(gameContainer) where gameContainer is a sprite, usually done in the Main class.

Use the functions: ScreenManager.Update(deltaTime) and ScreenManager.Draw(graphics) to let each screen loaded by the system to be updated and drawn.

This is still in development, I have to fix bugs and keep improving it but the basic functionality is there.

Feel free to contact me: henry@fierysquirrel.com
http://fierysquirrel.com/
