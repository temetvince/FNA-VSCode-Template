using Nez;
using Nez.ImGuiTools;

namespace project_name
{
    class Game1 : Core
    {
        public Game1() : base()
        {
			// uncomment this line for scaled pixel art games
			//Environment.SetEnvironmentVariable("FNA_OPENGL_BACKBUFFER_SCALE_NEAREST", "1");
        }

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

#if DEBUG
			// optionally load up ImGui DLL if not using the above setup so that its command gets loaded in the DebugConsole
			//System.Reflection.Assembly.Load("Nez.ImGui")
#endif
        }
    }
}
