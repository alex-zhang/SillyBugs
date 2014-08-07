package com.alex.sillyBugs.screens
{
	import com.alex.sillyBugs.components.SillyBugGroup;
	import com.alex.sillyBugs.components.bugsBehavior.ChaseBehavior;
	import com.alex.sillyBugs.components.bugsBehavior.SeekBehavior;
	import com.alex.sillyBugs.components.bugsBehavior.WanderBehavior;
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.assets.ImageAsset;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.SceneScreen;
	
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
//			mSillyBugGroup.groupBehavior = new ChaseBehavior();//new SeekBehavior()//new WanderBehavior();
			mSillyBugGroup.groupBehavior = new SeekBehavior()//new WanderBehavior();
			
			var go:GameObject = super.createScene();
			go.initComponents = [mSillyBugGroup];
			
			return go;
		}
		
		override protected function afterCreateScene():void
		{
			var defultBugsCount:int = SillyBugsAppConfig.DEFAULT_SILLYBUGS_COUNT;
			for(var i:int = 0; i < defultBugsCount; i++)
			{
				var sillyBug:GameObject = mSillyBugGroup.createSillyBug();
				CrocoEngine.rootGameObject.addGameObejct(sillyBug);
			}
		}
	}
}