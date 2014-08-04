package com.alex.sillyBugs.components
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectSet;

	public class SillyBugGroup extends CrocoObjectSet
	{
		public function SillyBugGroup()
		{
			super();
		}
		
		public function removeSillyBug(value:SillyBug):void
		{
			this.removeChild(value);
		}
		
		public function addSillyBug(value:SillyBug):void
		{
			this.addChild(value);
		}
		
		override public function tick(deltaTime:Number):void
		{
			var child:SillyBug = __childrenLinkList.moveFirst();
			while(child)
			{
				if(child.__alive && child.tickable)
				{
					child.wander();
				}
				
				child = __childrenLinkList.moveNext();
			}
		}
	}
}