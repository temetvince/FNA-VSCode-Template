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
			
			// uncomment this line for scaled pixel art games
			//Environment.SetEnvironmentVariable("FNA_OPENGL_BACKBUFFER_SCALE_NEAREST", "1");
			
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
