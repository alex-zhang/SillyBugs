package com.alex.sillyBugs.components
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.script.ScriptComponent;

	public class CameraScriptComponent extends ScriptComponent
	{
		public function CameraScriptComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			//init pos
			transform.setPosition(CrocoEngine.stageWidth * 0.5, CrocoEngine.stageHeight * 0.5);
		}
	}
}