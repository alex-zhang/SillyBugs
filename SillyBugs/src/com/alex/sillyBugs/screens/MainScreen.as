package com.alex.sillyBugs.screens
{
	import com.alex.sillyBugs.components.SillyBug;
	import com.alex.sillyBugs.components.SillyBugGroup;
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.assets.ImageAsset;
	import com.croco2d.components.render.ImageComponent;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.SceneScreen;
	import com.fireflyLib.utils.MathUtil;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	
	public class MainScreen extends SceneScreen
	{
		private var mSillyBugGroup:SillyBugGroup;
		
		public function MainScreen()
		{
			super();
		}
		
		override protected function beforCreateScene():void
		{
			var bgImgPath:String = AppConfig.findScreenResourcePath(screenID, "bg_02.jpg");
			var bgImgAsset:ImageAsset = assetsManager.getImageAsset(bgImgPath); 
			var image:Image = new Image(bgImgAsset.texture);
			image.blendMode = BlendMode.NONE;
			addChild(image);
		}
		
		override protected function createScene():GameObject
		{
			mSillyBugGroup = new SillyBugGroup();
			mSillyBugGroup.name = "SillyBugGroup";
			
			var go:GameObject = super.createScene();
			go.initComponents = [mSillyBugGroup];
			
			return go;
		}
		
		override protected function afterCreateScene():void
		{
			var defultBugsCount:int = SillyBugsAppConfig.DEFAULT_SILLYBUGS_COUNT;
			for(var i:int = 0; i < defultBugsCount; i++)
			{
				var sillyBug:GameObject = createSillyBug();
				CrocoEngine.rootGameObject.addGameObejct(sillyBug);
			}
		}
		
		public function createSillyBug():GameObject
		{
			var bugAsset:ImageAsset = CrocoEngine.globalAssetsManager.getImageAsset(AppConfig.findPreloadResourcePath("laser.png"));
			
			var go:GameObject = null;
			
			go = GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					props:
					{
						initComponents:
						[
							{
								clsType:ImageComponent,
								props:
								{
									texture:bugAsset.texture
								}
							}
							,
							{
								clsType:SillyBug,
								props:
								{
									sillyBugGroup:mSillyBugGroup,
									x:MathUtil.randomNumberBetween(0, 800),
									y:MathUtil.randomNumberBetween(0, 800),
									
									minForce:0.1,
									maxForce:0.2,
									
									minSpeed:0.1,
									maxSpeed:0.2,
									
									minWanderDistance:5.0,
									maxWanderDistance:30.0,
									
									minWanderRadius:5.0,
									maxWanderRadius:20.0,
									
									minWanderStep:0.2,
									maxWanderStep:0.3,
									
									boundsRadius:250
								}
							}
						]
					}
				});	
			
			return go; 
		}
	}
}