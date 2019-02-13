using System;
using System.Reflection;
using ImGuiNET;
using ImGuiNET.SampleProgram.XNA;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Nez
{
	public class ImGuiFinalRenderDelegate : IFinalRenderDelegate
	{
		public Scene scene { get; set; }

        ImGuiRenderer _imGuiRenderer;
        RenderTarget2D _lastRenderTarget;
        IntPtr _renderTargetId;

        public ImGuiFinalRenderDelegate()
        {
            var core = typeof(Core).GetField("_instance", BindingFlags.Static | BindingFlags.NonPublic).GetValue(null) as Core;
            _imGuiRenderer = new ImGuiRenderer(core);
            _imGuiRenderer.RebuildFontAtlas();
        }

		public void handleFinalRender( Color letterboxColor, RenderTarget2D source, Rectangle finalRenderDestinationRect, SamplerState samplerState )
		{
            if(_lastRenderTarget != source)
            {
                // unbind the old texture if we had one
                if(_lastRenderTarget != null)
                    _imGuiRenderer.UnbindTexture(_renderTargetId);

                // bind the new texture
                _lastRenderTarget = source;
                _renderTargetId = _imGuiRenderer.BindTexture(source);
            }

            Core.graphicsDevice.setRenderTarget( null );
            Core.graphicsDevice.Clear( letterboxColor );


            _imGuiRenderer.BeforeLayout(Time.time);
            layoutGui();
            _imGuiRenderer.AfterLayout();
		}

        void layoutGui()
        {
            ImGui.ShowDemoWindow();

            var maxSize = new System.Numerics.Vector2(_lastRenderTarget.Width, _lastRenderTarget.Height);
            var minSize = maxSize / 4;
            unsafe
            {
                ImGui.SetNextWindowSizeConstraints(minSize, maxSize, data =>
                {
                    var size = (*data).CurrentSize;
                    var ratio = size.X / _lastRenderTarget.Width;
                    (*data).DesiredSize.Y = ratio * _lastRenderTarget.Height;
                });
            }

            ImGui.SetNextWindowPos(new System.Numerics.Vector2(0, 0), ImGuiCond.FirstUseEver);
            ImGui.Begin("Game Window");
            ImGui.Image(_renderTargetId, ImGui.GetContentRegionAvail());
            ImGui.End();
        }

		public void onAddedToScene()
		{}

		public void onSceneBackBufferSizeChanged( int newWidth, int newHeight )
		{}

		public void unload()
		{}
	}
}
