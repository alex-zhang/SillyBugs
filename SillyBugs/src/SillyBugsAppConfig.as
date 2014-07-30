package
{
	import com.alex.sillyBugs.screens.MainScreen;
	import com.croco2d.AppConfig;
	
	import flash.display3D.Context3DProfile;
	
	import feathers.controls.ScreenNavigatorItem;

	public final class SillyBugsAppConfig extends AppConfig
	{
		public static function init():void
		{
			globalEvnConfig = 
				{
					//1.3333~ 1.777 ratio.
					designWidth:0,
					designHeight:0,
					backgroundColor:0x00,
					frameRate:30,
					textureScaleFactor:1.0,
					textureUseMipmaps:false,
					pauseEngineWhenDeActivated:true,
					pauseRenderingWhenDeActivated:true,
					startupLogger:true,
					startupLoggerConfigCallback:null,
					gravityX:0,
					gravityY:600,
					physicsStepTime: 1 / 20,
					systemIdleMode:null
				}
			
			starlingConfig = 
			{
				clsProps:
				{
					handleLostContext:false,
					multitouchEnabled:false
				},
				
				clsType:"(class)starling.core::Starling",
				
				ctorParams:
				[
					"(class)com.croco2d.screens::CrocoScreenNavigator",
					"(stage)",
					"(null)", 
					"(null)", 
					"auto", 
					Context3DProfile.BASELINE
				],
				
				props:
				{
					enableErrorChecking:false,
					showStats:false,
					antiAliasing:0,
					simulateMultitouch:false
				}
			}
			
			screensConfig = 
			[
				{
					clsType:ScreenNavigatorItem,
					
					ctorParams:
					[
						MainScreen,
						null,
						{
							screenID:"MainScreen"
						}
					]
				}
			];
		}
	}
}