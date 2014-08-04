package
{
	import com.croco2d.AppBootStrap;
	import com.llamaDebugger.Console;
	
	import flash.display.StageDisplayState;
	
	import starling.core.Starling;
	
	[SWF(width="960", height="640", backgroundColor="0x00")]
	public class SillyBugs extends AppBootStrap
	{
		SillyBugsAppConfig;
		
		public function SillyBugs()
		{
			super();
		}
		
		override protected function onAppConfigInit():void
		{
			super.onAppConfigInit();
			
			SillyBugsAppConfig.init();
		}
		
		override protected function onLlamaDebuggerInit():void
		{
			super.onLlamaDebuggerInit();
			
			Console.registerCommand("fullscreen", 
				function():void 
				{
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}, 
				"fullscreen");
			
			Console.registerCommand("fps-starling", 
				function():void 
				{
					Starling.current.showStats = !Starling.current.showStats;
				}, 
				"fps-starling");
		}
	}
}