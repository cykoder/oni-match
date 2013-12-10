package com.oniworks.onimatch.entities 
{
	import com.greensock.TweenLite;
	import com.oniworks.onimatch.screens.Game;
	import oni.assets.AssetManager;
	import oni.entities.Entity;
	import oni.Oni;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Sam Hellawell
	 */
	public class Head extends Entity
	{
		private var _rx:int, _ry:int;
		
		private var _type:int;
		
		private var _image:Image;
		
		private var _game:Game;
		
		public function Head(game:Game, type:int, rx:int, ry:int) 
		{
			//Super
			super( { type: type, rx: rx, ry: ry } );
			
			//Set type
			this._type = type;
			
			//Set position
			this.rx = rx;
			this.ry = ry;
			
			//Set pivot
			this.pivotX = this.pivotY = 50;
			
			//Set game
			this._game = game;
			
			//Set touchable
			this.touchable = true;
			
			//Set image
			_image = new Image(AssetManager.getTexture("game_head_" + type));
			addChild(_image);
			
			//Listen for touch
			addEventListener(TouchEvent.TOUCH, _onTouch);
			
			//Effects
			scaleX = scaleY = 0.1;
			TweenLite.to(this, 0.5, { scaleX:1, scaleY:1 } );
		}
		
		public function get rx():int
		{
			return _rx;
		}
		
		public function set rx(value:int):void
		{
			_rx = value;
			x = 229 + (_rx * 101);
		}
		
		public function get ry():int
		{
			return _ry;
		}
		
		public function set ry(value:int):void
		{
			_ry = value;
			y = 71 + (_ry * 101);
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(num:int):void
		{
			if (num > 5) num = 1;
			if (_type != num)
			{
				_type = num;
				if(num > 0) _image.texture = AssetManager.getTexture("game_head_" + num);
			}
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			//Get touch
			var touch:Touch = e.getTouch(this);
			
			//Check if pressed
			if (touch != null && touch.phase == TouchPhase.BEGAN)
			{
				_game.dispatchEventWith(Game.HEAD_SELECTED, false, { head:this } );
			}
		}
		
	}

}