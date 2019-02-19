using Nez;
using Nez.ImGuiTools;

namespace project_name
{
    public class DefaultScene : Scene
    {
        public override void initialize()
        {
            setDesignResolution( Screen.width, Screen.height, Scene.SceneResolutionPolicy.None );

            addRenderer(new DefaultRenderer());

            var logo = content.Load<Microsoft.Xna.Framework.Graphics.Texture2D>("nez-logo-black");
            createEntity("logo")
                .setPosition(Screen.center)
                .addComponent(new Nez.Sprites.Sprite(logo));
        }
    }
}
