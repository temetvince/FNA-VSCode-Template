using Nez;
using Nez.ImGuiTools;

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

            Scene = new DefaultScene();
            
            // optionally render Nez in an ImGui window
			var imGuiManager = new ImGuiManager();
			Core.RegisterGlobalManager(imGuiManager);
        }
    }
}
