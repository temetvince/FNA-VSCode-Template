using Nez;

namespace project_name
{
    class Game1 : Core
    {
        public Game1() : base()
        {}

        override protected void Initialize()
        {
            base.Initialize();
			
#if DEBUG
            System.Diagnostics.Debug.Listeners.Add(new System.Diagnostics.TextWriterTraceListener(System.Console.Out));
#endif

			// setup a Scene so we have something to show
			var newScene = new Scene();
            newScene.addRenderer(new DefaultRenderer());

            var logo = newScene.content.Load<Microsoft.Xna.Framework.Graphics.Texture2D>("nez-logo-black");
            newScene.createEntity("logo")
                .setPosition(Screen.center)
                .addComponent(new Nez.Sprites.Sprite(logo));

            scene = newScene;
            
            // optionally render Nez in an ImGui window
			var imGuiManager = new ImGuiManager();
			Core.registerGlobalManager( imGuiManager );
			imGuiManager.setEnabled( true );
        }
    }
}