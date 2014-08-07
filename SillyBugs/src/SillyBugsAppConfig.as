package
{
	import com.alex.sillyBugs.screens.MainScreen;
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.render.CameraRenderComponent;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.FlashBootStrapScreen;
	import com.croco2d.screens.PreloadHubScreen;
	
	import flash.display3D.Context3DProfile;
	
	import feathers.controls.ScreenNavigatorItem;

	public final class SillyBugsAppConfig extends AppConfig
	{
		public static const DEFAULT_SILLYBUGS_COUNT:int = 50;
		
		CrocoEngine.debug = true;
		
		[Embed(source="assets/app/launchImage.png")]
		private static var launchImageCls:Class;
		
		public static function init():void
		{
			crocoEngineConfig.clsProps.camera = 
			{
				clsType:GameObject,
				props:
				{
					debug:CrocoEngine.debug,
					initComponents:
					[
						{
							clsType:CameraRenderComponent,
							props:
							{
								debug:CrocoEngine.debug
							}
						}
					]
				}
			}
			
			bootStrapSceenConfig = 
			{
				clsType:FlashBootStrapScreen,
				
				props:
				{
					launchImage:launchImageCls,
					fadeoutDelayTime:2,
					fadeoutTime:2,
					fadeoutProps:{alpha:0}
				}
			}
				
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
							screenID:"MainScreen",
							hubScreenID:"MainScreenHubScreen"
						}
					]
				},
				
				//hub screens
				{
					clsType:ScreenNavigatorItem,
					
					ctorParams:
					[
						PreloadHubScreen,
						null,
						{
							screenID:"MainScreenHubScreen"
						}
					]
				}
			];
		}
	}
}