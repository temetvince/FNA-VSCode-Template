using System;
using System.Reflection;
using ImGuiNET;
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
			_imGuiRenderer = new ImGuiRenderer( Core.instance );
			_imGuiRenderer.rebuildFontAtlas();
            ImGui.GetIO().ConfigWindowsMoveFromTitleBarOnly = true;
		}

		[Console.Command( "toggle-imgui", "Toggles the Dear ImGui renderer" )]
		static void toggleImGui()
		{
			if( Core.scene.finalRenderDelegate == null )
				Core.scene.finalRenderDelegate = new ImGuiFinalRenderDelegate();
			else
				Core.scene.finalRenderDelegate = null;
		}

		void layoutGui()
		{
			ImGui.ShowDemoWindow();

			var maxSize = new System.Numerics.Vector2( _lastRenderTarget.Width, _lastRenderTarget.Height );
			var minSize = maxSize / 4;
			maxSize *= 4;
			unsafe
			{
				ImGui.SetNextWindowSizeConstraints( minSize, maxSize, data =>
				 {
					 var size = ( *data ).CurrentSize;
					 var ratio = size.X / _lastRenderTarget.Width;
					 ( *data ).DesiredSize.Y = ratio * _lastRenderTarget.Height;
				 } );
			}

			ImGui.SetNextWindowPos( new System.Numerics.Vector2( 0, 0 ), ImGuiCond.FirstUseEver );
			ImGui.PushStyleVar( ImGuiStyleVar.WindowPadding, new System.Numerics.Vector2( 0, 0 ) );
			ImGui.Begin( "Game Window" );

			ImGui.Image( _renderTargetId, ImGui.GetContentRegionAvail() );
			ImGui.End();

			ImGui.PopStyleVar();
		}

        #region IFinalRenderDelegate

		public void handleFinalRender( RenderTarget2D finalRenderTarget, Color letterboxColor, RenderTarget2D source, Rectangle finalRenderDestinationRect, SamplerState samplerState )
		{
			if( _lastRenderTarget != source )
			{
				// unbind the old texture if we had one
				if( _lastRenderTarget != null )
					_imGuiRenderer.unbindTexture( _renderTargetId );

				// bind the new texture
				_lastRenderTarget = source;
				_renderTargetId = _imGuiRenderer.bindTexture( source );
			}

			Core.graphicsDevice.setRenderTarget( finalRenderTarget );
			Core.graphicsDevice.Clear( letterboxColor );


			_imGuiRenderer.beforeLayout( Time.deltaTime );
			layoutGui();
			_imGuiRenderer.afterLayout();
		}

		public void onAddedToScene()
		{ }

		public void onSceneBackBufferSizeChanged( int newWidth, int newHeight )
		{ }

		public void unload()
		{ }

        #endregion
	}
}
