package com.alex.sillyBugs.screens
{
	import com.croco2d.screens.SceneScreen;
	
	import starling.display.Quad;
	
	public class MainScreen extends SceneScreen
	{
		public function MainScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var quad:Quad = new Quad(300, 300, 0xFF0000);
			addChild(quad);
		}
	}
}