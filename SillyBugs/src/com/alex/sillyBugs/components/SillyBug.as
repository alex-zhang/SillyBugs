﻿package com.alex.sillyBugs.components
{
	import com.alex.sillyBugs.consants.EdgeBehaviorType;
	import com.croco2d.components.script.ScriptComponent;
	
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class SillyBug extends ScriptComponent
	{
		//———————————————————————————————————————————————————————————
		
		/**
		 * An empty Object to store any extra data
		 */

		public var extra : Object = {};

		//———————————————————————————————————————————————————————————

		private var _maxForce : Number;
		private var _maxSpeed : Number;
		private var _distance : Number;
		private var _maxForceSQ : Number;
		private var _maxSpeedSQ : Number;
		private var _velocity : Vector3D;
		private var _position : Vector3D;
		private var _acceleration : Vector3D;
		private var _steeringForce : Vector3D;
		
		private var _boundsRadius : Number;
		private var _boundsCentre : Vector3D = new Vector3D();
		private var _radius : Number = 10.0;
		private var _wanderTheta : Number = 0.0;
		private var _wanderPhi : Number = 0.0;
		private var _wanderPsi : Number = 0.0;
		private var _wanderRadius : Number = 16.0;
		private var _wanderDistance : Number = 60.0;
		private var _wanderStep : Number = 0.25;
		private var _lookAtTarget : Boolean = true;
		
		public var sillyBugGroup:SillyBugGroup;

		//___________________________________________________________
		//————————————————————————————————————————— GETTERS + SETTERS
		
		override protected function onInit():void
		{
			if(sillyBugGroup) sillyBugGroup.addChild(this);
		}
		
		/**
		 * The position of the Boid along the x axis
		 */

		public function get x() : Number
		{
			return _position.x;
		}

		public function set x( value : Number ) : void
		{
			_position.x = value;
		}

		/**
		 * The position of the Boid along the y axis
		 */

		public function get y() : Number
		{
			return _position.y;
		}

		public function set y( value : Number ) : void
		{
			_position.y = value;
		}

		/**
		 * The maximum force available to the Boid when
		 * calculating the steering force produced by 
		 * the Boids steering bahaviors
		 */

		public function get maxForce() : Number
		{
			return _maxForce;
		}

		public function set maxForce( value : Number ) : void
		{
			if ( value < 0 )
			{
				value = 0;
			}
			
			_maxForce = value;
			_maxForceSQ = value * value;
		}

		/**
		 * The maximum speed the Boid can reach
		 */

		public function get maxSpeed() : Number
		{
			return _maxSpeed;
		}

		public function set maxSpeed( value : Number ) : void
		{
			if ( value < 0 )
			{
				value = 0;
			}
			
			_maxSpeed = value;
			_maxSpeedSQ = value * value;
		}

		/**
		 * The centrepoint of the Boids bounding sphere.
		 * If the Boid travels futher than boundsRadius 
		 * from this point the specified edge behavior 
		 * will take affect.
		 */

		public function get boundsCentre() : Vector3D
		{
			return _boundsCentre;
		}

		public function set boundsCentre( value : Vector3D ) : void
		{
			_boundsCentre = value;
		}

		/**
		 * The maximum distance which this Boid can 
		 * travel from it's boundsCentre before the 
		 * specified edge behavior takes affect
		 */

		public function get boundsRadius() : Number
		{
			return _boundsRadius;
		}

		public function set boundsRadius( value : Number ) : void
		{
			_boundsRadius = value;
		}

		/**
		 * The maximum angle, in radians, that the 
		 * Boid's wander behavior can turn at each 
		 * step. When calculating wander, a number 
		 * will be chosen at random with this as the 
		 * maximum value in each direction (either 
		 * positive or negative rotation)
		 */

		public function get wanderStep() : Number
		{
			return _wanderStep;
		}

		public function set wanderStep( value : Number ) : void
		{
			_wanderStep = value;
		}

		/**
		 * The distance in front of the Boid at which 
		 * the circle for calculating rotation will 
		 * be placed.
		 */

		public function get wanderDistance() : Number
		{
			return _wanderDistance;
		}

		public function set wanderDistance( value : Number ) : void
		{
			_wanderDistance = value;
		}

		/**
		 * The radius of the circle used for calculating
		 * the wander behavior of the Boid
		 */

		public function get wanderRadius() : Number
		{
			return _wanderRadius;
		}

		public function set wanderRadius( value : Number ) : void
		{
			_wanderRadius = value;
		}

		/**
		 * The position of the Boid in 3D space
		 */

		public function get position() : Vector3D
		{
			return _position;
		}

		public function set position( value : Vector3D ) : void
		{
			_position = value;
		}

		/**
		 * The current velocity of the Boid
		 */

		public function get velocity() : Vector3D
		{
			return _velocity;
		}

		/**
		 * If true, the Boid will adjust it's x, y and z
		 * rotation in order to face the direction in 
		 * which it is travelling
		 */

		public function get lookAtTarget() : Boolean
		{
			return _lookAtTarget;
		}

		public function set lookAtTarget( value : Boolean ) : void
		{
			_lookAtTarget = value;
		}

		//___________________________________________________________
		//——————————————————————————————————————————————— CONSTRUCTOR

		public function SillyBug( maxForce : Number = 1.0, maxSpeed : Number = 10.0) 
		{
			this.maxForce = maxForce;
			this.maxSpeed = maxSpeed;
			
			reset();
		}

		//___________________________________________________________
		//——————————————————————————————————————————————————— METHODS

		/**
		 * After calling one or more of the Boid's steering methods, 
		 * call the update method in order to set the Boid's position 
		 * in relation to the force being applied to it as a result of 
		 * it's steering behaviors. If the Boid's edgeBehavior property 
		 * is anything other than EDGE_NONE (no edge behavior) then the 
		 * Boid's position will be modified accordingly after the 
		 * steering forces have been applied
		 */

		override public function tick(deltaTime:Number):void
		{
			transform.setPosition(_position.x, _position.y);
			_velocity.incrementBy(_acceleration);
			
			if ( _velocity.lengthSquared > _maxSpeedSQ )
			{
				_velocity.normalize();
				_velocity.scaleBy(_maxSpeed);
			}
			
			_position.incrementBy(_velocity);
			
			_acceleration.x = 0;
			_acceleration.y = 0;
			
//			var distance : Number = Vector3D.distance(_position, _boundsCentre);
//			
//			if( distance > _boundsRadius + _radius )
//			{
//				switch( _edgeBehavior )
//				{
//					case EDGE_BOUNCE :
//						
//						/**
//						 * Move the boid to the edge of the boundary 
//						 * then invert it's velocity and step it 
//						 * forward back into the sphere 
//						 */
//						
//						_position.decrementBy(_boundsCentre);
//						_position.normalize();
//						_position.scaleBy(_boundsRadius + _radius);
//						
//						_velocity.scaleBy(-1);
//						_position.incrementBy(_velocity);
//						_position.incrementBy(_boundsCentre);
//						break;
//					
//					case EDGE_WRAP :
//						
//						/**
//						 * Move the Boid to the antipodal point of it's 
//						 * current position on the bounding sphere by 
//						 * taking the inverse of it's position vector
//						 */
//						
//						_position.decrementBy(_boundsCentre);
//						_position.negate();
//						_position.incrementBy(_boundsCentre);
//						break;
//				}
//			}
		}

		/**
		 * Constrains the Boid to a rectangular area of the screen 
		 * by calculating the 2D position of the Boid on the screen, 
		 * limiting it to the dimensions of the Rectangle and then 
		 * projecting the resulting values back into 3D space
		 * 
		 * @param	rect
		 * 
		 * The rectangle to constrain the Boid's position to
		 * 
		 * @param	behavior
		 * 
		 * Since this method is a substitute for the normal 
		 * edge behavior, you can specify which behavior the 
		 * Boid should use manually
		 * 
		 * @param	zMin
		 * 
		 * Use this if you wish to constrain the Boid's z 
		 * position to a minimum amount
		 * 
		 * @param	zMax
		 * 
		 * Use this if you wish to constrain the Boid's z 
		 * position to a maximum amount
		 * 
		 */

		public function constrainToRect(rect : Rectangle, behavior : EdgeBehaviorType) : void
		{
			if ( _position.x < rect.left - _radius )
			{
				switch( behavior )
				{
					case EdgeBehaviorType.EDGE_WRAP :
						_position.x = rect.right;
						break;
					
					case EdgeBehaviorType.EDGE_BOUNCE :
						_position.x = rect.left;
						_velocity.x *= -1;
						break;
				}
			}
			else if ( _position.x > rect.right + _radius )
			{
				switch( behavior )
				{
					case EdgeBehaviorType.EDGE_WRAP :
						_position.x = rect.left;
						break;
					
					case EdgeBehaviorType.EDGE_BOUNCE :
						_position.x = rect.right;
						_velocity.x *= -1;
						break;
				}
			}
			
			if ( _position.y < rect.top - _radius )
			{
				switch( behavior )
				{
					case EdgeBehaviorType.EDGE_WRAP :
						_position.y = rect.bottom;
						break;
					
					case EdgeBehaviorType.EDGE_BOUNCE :
						_position.y = rect.top;
						_velocity.y *= -1;
					
						break;
				}
			}
			else if ( _position.y > rect.bottom + _radius )
			{
				switch( behavior )
				{
					case EdgeBehaviorType.EDGE_WRAP :
						_position.y = rect.top;
						break;
					
					case EdgeBehaviorType.EDGE_BOUNCE :
						_position.y = rect.bottom;
						_velocity.y *= -1;
						break;
				}
			}
		}

		//___________________________________________________________
		//————————————————————————————————————————————————— BEHAVIORS
		
		/**
		 * Applies a braking force to the boid by scaling it's 
		 * velocity.
		 * 
		 * @param	brakingForce
		 * 
		 * A number between 0 and 1. 0 = no effect
		 */

		public function brake(brakingForce : Number = 0.01) : void
		{
			_velocity.scaleBy(1 - brakingForce);
		}

		/**
		 * Seeks the Boid towards the specified target
		 * 
		 * @param	target
		 * 
		 * The target for the Boid to seek
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function seek( target : Vector3D, multiplier : Number = 1.0 ) : void
		{
			_steeringForce = steer(target);
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}

		/**
		 * Seeks the Boid towards the specified target and 
		 * applies a deceleration force as the Boid arrives
		 * 
		 * @param	target
		 * 
		 * The target for the Boid to seek
		 * 
		 * @param	easeDistance
		 * 
		 * The distance from the target at which the Boid should 
		 * begin to decelerate
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function arrive( target : Vector3D, easeDistance : Number = 100, multiplier : Number = 1.0 ) : void
		{
			_steeringForce = steer(target, true, easeDistance);
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}

		/**
		 * If a target is within a certain range of the Boid, as 
		 * specified by the panicDistance parameter, the Boid will 
		 * steer to avoid contact with the target
		 * 
		 * @param	target
		 * 
		 * The target for the Boid to avoid
		 * 
		 * @param	panicDistance
		 * 
		 * If the distance between the Boid and the target position 
		 * is greater than this value, the Boid will ignore the 
		 * target and it's steering force will be unchanged
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function flee( target : Vector3D, panicDistance : Number = 100, multiplier : Number = 1.0 ) : void
		{
			_distance = Vector3D.distance(_position, target);
			
			if ( _distance > panicDistance )
			{
				return;
			}
			
			_steeringForce = steer(target, true, -panicDistance);
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_steeringForce.negate();
			_acceleration.incrementBy(_steeringForce);
		}

		/**
		 * Generates a random wandering force for the Boid. 
		 * The results of this method can be controlled by the 
		 * _wanderDistance, _wanderStep and _wanderRadius parameters
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function wander( multiplier : Number = 1.0 ) : void
		{
			_wanderTheta += -_wanderStep + Math.random() * _wanderStep * 2;
			_wanderPhi += -_wanderStep + Math.random() * _wanderStep * 2;
			_wanderPsi += -_wanderStep + Math.random() * _wanderStep * 2;
			
			if ( Math.random() < 0.5 )
			{
				_wanderTheta = -_wanderTheta;
			}
			
			var pos : Vector3D = _velocity.clone();
			
			pos.normalize();
			pos.scaleBy(_wanderDistance);
			pos.incrementBy(_position);
			
			var offset : Vector3D = new Vector3D();
			
			offset.x = _wanderRadius * Math.cos(_wanderTheta);
			offset.y = _wanderRadius * Math.sin(_wanderPhi);
			offset.z = _wanderRadius * Math.cos(_wanderPsi);
			
			_steeringForce = steer(pos.add(offset));
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}

		/**
		 * Use this method to simulate flocking movement in a 
		 * group of Boids. Flock will combine the separate, 
		 * align and cohesion steering behaviors to produce 
		 * the flocking effect. Adjusting the weighting of each 
		 * behavior, as well as the distance values for each 
		 * can 0produce distinctly different flocking behaviors
		 * 
		 * @param	boids
		 * 
		 * An Array of Boids to consider when calculating the 
		 * flocking behavior
		 * 
		 * @param	separationWeight
		 * 
		 * The weighting given to the separation behavior
		 * 
		 * @param	alignmentWeight
		 * 
		 * The weighting given to the alignment bahavior
		 * 
		 * @param	cohesionWeight
		 * 
		 * The weighting given to the cohesion bahavior
		 * 
		 * @param	separationDistance
		 * 
		 * The distance which each Boid will attempt to maintain
		 * between itself and any other Boid in the flock
		 * 
		 * @param	alignmentDistance
		 * 
		 * If another Boid is within this distance, this Boid will 
		 * consider the other Boid's heading when adjusting it's own
		 * 
		 * @param	cohesionDistance
		 * 
		 * If another Boid is within this distance, this Boid will 
		 * consider the other Boid's position when adjusting it's own
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function flock( boids : Vector.<SillyBug>, separationWeight : Number = 0.5, alignmentWeight : Number = 0.1, cohesionWeight : Number = 0.2, separationDistance : Number = 100.0, alignmentDistance : Number = 200.0, cohesionDistance : Number = 200.0 ) : void
		{
			separate(boids, separationDistance, separationWeight);
			align(boids, alignmentDistance, alignmentWeight);
			cohesion(boids, cohesionDistance, cohesionWeight);
		}

		/**
		 * Separation will attempt to ensure that a certain distance 
		 * is maintained between any given Boid and others in the flock
		 * 
		 * @param	boids
		 * 
		 * An Array of Boids to consider when calculating the behavior
		 * 
		 * @param	separationDistance
		 * 
		 * The distance which the Boid will attempt to maintain between 
		 * itself and any other Boid in the flock
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function separate( boids : Vector.<SillyBug>, separationDistance : Number = 50.0, multiplier : Number = 1.0 ) : void
		{
			_steeringForce = getSeparation(boids, separationDistance);
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}

		/**
		 * Align will correct the Boids heading in order for it 
		 * to point in the average direction of the flock
		 * 
		 * @param	boids
		 * 
		 * An Array of Boids to consider when calculating the behavior
		 * 
		 * @param	neighborDistance
		 * 
		 * If another Boid is within this distance, this Boid will 
		 * consider the other Boid's heading when adjusting it's own
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function align( boids : Vector.<SillyBug>, neighborDistance : Number = 40.0, multiplier : Number = 1.0 ) : void
		{
			_steeringForce = getAlignment(boids, neighborDistance);
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}

		/**
		 * Cohesion will attempt to make all Boids in the flock converge 
		 * on a point which lies at the centre of the flock
		 * 
		 * @param	boids
		 * 
		 * An Array of Boids to consider when calculating the behavior
		 * 
		 * @param	neighborDistance
		 * 
		 * If another Boid is within this distance, this Boid will 
		 * consider the other Boid's position when adjusting it's own
		 * 
		 * @param	multiplier
		 * 
		 * By multiplying the force generated by this behavior, 
		 * more or less weight can be given to this behavior in
		 * comparison to other behaviors being calculated by the 
		 * Boid. To increase the weighting of this behavior, use 
		 * a number above 1.0, or to decrease it use a number 
		 * below 1.0
		 */

		public function cohesion( boids : Vector.<SillyBug>, neighborDistance : Number = 10.0, multiplier : Number = 1.0 ) : void
		{
			_steeringForce = getCohesion(boids, neighborDistance);
			
			if ( multiplier != 1.0 )
			{
				_steeringForce.scaleBy(multiplier);
			}
			
			_acceleration.incrementBy(_steeringForce);
		}

		/**
		 * Resets the Boid's position, velocity, acceleration and 
		 * current steering force to zero
		 */

		public function reset() : void
		{
			_velocity = new Vector3D();
			_position = new Vector3D();
			_acceleration = new Vector3D();
			_steeringForce = new Vector3D();
		}

		//———————————————————————————————————————————————————————————

		private function steer( target : Vector3D, ease : Boolean = false, easeDistance : Number = 100 ) : Vector3D
		{
			_steeringForce = target.clone();
			_steeringForce.decrementBy(_position);
			
			_distance = _steeringForce.normalize();
			
			if ( _distance > 0.00001 )
			{
				if ( _distance < easeDistance && ease )
				{
					_steeringForce.scaleBy(_maxSpeed * ( _distance / easeDistance ));
				}
				else
				{
					_steeringForce.scaleBy(_maxSpeed);
				}
				
				_steeringForce.decrementBy(_velocity);
				
				if ( _steeringForce.lengthSquared > _maxForceSQ )
				{
					_steeringForce.normalize();
					_steeringForce.scaleBy(_maxForce);
				}
			}
			
			return _steeringForce;
		}

		private function getSeparation( boids : Vector.<SillyBug>, separation : Number = 25.0 ) : Vector3D
		{
			var force : Vector3D = new Vector3D();
			var difference : Vector3D;
			var distance : Number;
			var count : int = 0;
			var boid : SillyBug;
			
			for (var i : int = 0;i < boids.length; i++) 
			{
				boid = boids[i];
				
				distance = Vector3D.distance(_position, boid.position);
				
				if ( distance > 0 && distance < separation )
				{
					difference = _position.subtract(boid.position);
					difference.normalize();
					difference.scaleBy(1 / distance);
					
					force.incrementBy(difference);
					count++;
				}
			}
			
			if ( count > 0 )
			{
				force.scaleBy(1 / count);
			}
			
			return force;
		}

		private function getAlignment( boids : Vector.<SillyBug>, neighborDistance : Number = 50.0 ) : Vector3D
		{
			var force : Vector3D = new Vector3D();
			var distance : Number;
			var count : int = 0;
			var boid : SillyBug;
			
			for (var i : int = 0;i < boids.length; i++) 
			{
				boid = boids[i];
				distance = Vector3D.distance(_position, boid.position);
				
				if ( distance > 0 && distance < neighborDistance )
				{
					force.incrementBy(boid.velocity);
					count++;
				}
			}
			
			if ( count > 0 )
			{
				force.scaleBy(1 / count);
				
				if ( force.lengthSquared > _maxForceSQ )
				{
					force.normalize();
					force.scaleBy(_maxForce);
				}
			}
			
			return force;
		}

		private function getCohesion( boids : Vector.<SillyBug>, neighborDistance : Number = 50.0 ) : Vector3D
		{
			var force : Vector3D = new Vector3D();
			var distance : Number;
			var count : int = 0;
			var boid : SillyBug;
			
			for (var i : int = 0;i < boids.length; i++) 
			{
				boid = boids[i];
				distance = Vector3D.distance(_position, boid.position);
				
				if ( distance > 0 && distance < neighborDistance )
				{
					force.incrementBy(boid.position);
					count++;
				}
			}
			
			if ( count > 0 )
			{
				force.scaleBy(1 / count);
				force = steer(force);
				
				return force;
			}
			
			return force;
		}
	}
}
