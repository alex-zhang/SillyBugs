package com.alex.sillyBugs.components
{
	import com.alex.sillyBugs.components.bugsBehavior.BugsBehavior;
	import com.alex.sillyBugs.consants.EdgeBehaviorType;
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.assets.ImageAsset;
	import com.croco2d.components.render.ImageComponent;
	import com.croco2d.core.CrocoObjectSet;
	import com.croco2d.core.GameObject;
	import com.fireflyLib.utils.MathUtil;
	
	import flash.geom.Rectangle;

	public class SillyBugGroup extends CrocoObjectSet
	{
		private var mSillyBugGroupBehavior:BugsBehavior;
		
		private var mEdgeBehavior : EdgeBehaviorType = EdgeBehaviorType.EDGE_BOUNCE;
		private var mMaxForce : Number = 1.0;
		private var mMaxSpeed:Number = 1.0;
		
		public function SillyBugGroup()
		{
			super();
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
									sillyBugGroup:this,
									x:MathUtil.randomNumberBetween(0, 800),
									y:MathUtil.randomNumberBetween(0, 800),
									
									minForce:0.1,
									maxForce:0.2,
									
									minSpeed:1.5,
									maxSpeed:2,
									
									minWanderDistance:30.0,
									maxWanderDistance:60.0,
									
									minWanderRadius:30.0,
									maxWanderRadius:60.0,
									
									minWanderStep:1,
									maxWanderStep:2,
									
									boundsRadius:80
								}
							}
						]
					}
				});	
			
			return go; 
		}
		
		public function get groupBehavior():BugsBehavior
		{
			return mSillyBugGroupBehavior;
		}
		
		public function set groupBehavior(value:BugsBehavior):void
		{
			if(mSillyBugGroupBehavior != value)
			{
				if(mSillyBugGroupBehavior)
				{
					mSillyBugGroupBehavior.deactive();
					mSillyBugGroupBehavior.sillyBugGroup = null;
				}
				
				mSillyBugGroupBehavior = value;
				
				if(__inited) return;
				
				if(mSillyBugGroupBehavior)
				{
					mSillyBugGroupBehavior.sillyBugGroup = this;
					mSillyBugGroupBehavior.init();
					mSillyBugGroupBehavior.active();
				}
			}
		}
		
		/**
		 * How the Boid behaves when it reaches the
		 * boundaries of the stage. Possible values are:
		 * 
		 * EDGE_NONE
		 * 
		 * The Boid ignores the stage boundaries
		 * 
		 * EDGE_WRAP
		 * 
		 * If the Boid reaches the edge of the stage it 
		 * will switch it's position to the opposite edge
		 * 
		 * EDGE_BOUNCE
		 * 
		 * The Boid will bounce off the side of it's 
		 * boundaries in order to stay within them
		 */
		public function get edgeBehavior() : EdgeBehaviorType
		{
			return mEdgeBehavior;
		}
		
		public function set edgeBehavior( value : EdgeBehaviorType ) : void
		{
			mEdgeBehavior = value;
		}
		
		/**
		 * The maximum force available to the Boid when
		 * calculating the steering force produced by 
		 * the Boids steering bahaviors
		 */
		
		public function get maxForce() : Number
		{
			return mMaxForce;
		}
		
		public function set maxForce( value : Number ) : void
		{
			if ( value < 0 ) value = 0;
			
			if(mMaxForce != value)
			{
				mMaxForce = value;
				
				forEach(function(child:SillyBug):void 
				{
					if(child.__alive)
					{
						child.maxForce = value;				
					}
				});
			}
		}
		
		public function get maxSpeed() : Number
		{
			return mMaxSpeed;
		}
		
		public function set maxSpeed( value : Number ) : void
		{
			if ( value < 0 ) value = 0;
			
			if(mMaxSpeed)
			{
				mMaxSpeed = value;
				
				forEach(function(child:SillyBug):void 
				{
					if(child.__alive)
					{
						child.maxSpeed = value;				
					}
				});
			}
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			if(!mSillyBugGroupBehavior) mSillyBugGroupBehavior = new BugsBehavior();
			mSillyBugGroupBehavior.sillyBugGroup = this;
			mSillyBugGroupBehavior.init();
			mSillyBugGroupBehavior.active();
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(mSillyBugGroupBehavior) mSillyBugGroupBehavior.tick(deltaTime);
		}
	}
}