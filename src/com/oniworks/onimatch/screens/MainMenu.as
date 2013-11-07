package com.oniworks.onimatch.screens 
{
	import com.oniworks.onimatch.OniMatch;
	import oni.Oni;
	import oni.screens.Screen;
	import oni.assets.AssetManager;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Sam Hellawell
	 */
	public class MainMenu extends Screen
	{
		private var gradient:Image, back_light:Image, monolith:Image;
		private var credits:Image, onilogo:Image, logo_lit:Image;
		
		private var play_button:Image, topscores_button:Image;
		
		private var _fadeTimer:int;
		
		public function MainMenu(oni:Oni) 
		{
			//Super
			super(oni, "menu");
			
			//Create gradient
			gradient = new Image(AssetManager.getTexture("menu_gradient"));
			gradient.alpha = 0;
			gradient.touchable = false;
			addChild(gradient);
			
			//Create back light
			back_light = new Image(AssetManager.getTexture("menu_back_light"));
			back_light.alpha = 0;
			back_light.x = 153;
			back_light.y = 39;
			back_light.touchable = false;
			addChild(back_light);
			
			//Create monolith
			monolith = new Image(AssetManager.getTexture("menu_monolith"));
			monolith.alpha = 0;
			monolith.x = 267;
			monolith.y = 59;
			monolith.touchable = false;
			addChild(monolith);
			
			//Create lit logo
			logo_lit = new Image(AssetManager.getTexture("menu_logo_lit"));
			logo_lit.alpha = 0;
			logo_lit.x = 312;
			logo_lit.y = 55;
			logo_lit.touchable = false;
			addChild(logo_lit);
			
			//Create credits
			credits = new Image(AssetManager.getTexture("menu_credits"));
			credits.alpha = 0;
			credits.x = 8;
			credits.y = 725;
			credits.touchable = false;
			addChild(credits);
			
			//Create logo
			onilogo = new Image(AssetManager.getTexture("menu_oniworks_logo"));
			onilogo.alpha = 0;
			onilogo.x = 950;
			onilogo.y = 666;
			onilogo.touchable = false;
			addChild(onilogo);
			
			//Create play button
			play_button = new Image(AssetManager.getTexture("menu_play_button"));
			play_button.alpha = 0;
			play_button.x = monolith.x + 163;
			play_button.y = 515;
			play_button.addEventListener(TouchEvent.TOUCH, _onTouchPlay);
			addChild(play_button);
			
			//Create top scores button
			topscores_button = new Image(AssetManager.getTexture("menu_topscores_button"));
			topscores_button.alpha = 0;
			topscores_button.x = play_button.x;
			topscores_button.y = 576;
			topscores_button.addEventListener(TouchEvent.TOUCH, _onTouchScores);
			addChild(topscores_button);
			
			//Listen for screen added
			addEventListener(Oni.SCREEN_ADDED, _onScreenAdded);
		}
		
		/**
		 * Called when the screen has been added
		 * @param	e
		 */
		private function _onScreenAdded(e:Event):void
		{
			//Reset timer
			_fadeTimer = 0;
			
			//Listen for update
			addEventListener(Oni.UPDATE, _onScreenFadeIn);
		}
		
		/**
		 * Called when the screen has been added and should fade
		 * @param	e
		 */
		private function _onScreenFadeIn(e:Event):void
		{
			//Check if we should even fade
			if (credits.alpha != 1)
			{
				//Fade in elements in order
				if (_fadeTimer <= 30)
				{
					gradient.alpha += 0.03;
				}
				else if (_fadeTimer > 30 && _fadeTimer <= 40)
				{
					monolith.alpha += 0.1;
				}
				else if (_fadeTimer > 35 && _fadeTimer <= 65)
				{
					back_light.alpha += 0.05;
				}
				else if (_fadeTimer > 80 && _fadeTimer <= 120)
				{
					logo_lit.alpha += 0.025;
				}
				else if (_fadeTimer > 120 && _fadeTimer <= 145)
				{
					(oni as OniMatch).music_toggle_button.alpha += 0.04;
					(oni as OniMatch).sound_toggle_button.alpha += 0.04;
				}
				else if (_fadeTimer > 145 && _fadeTimer <= 170)
				{
					play_button.alpha += 0.05;
				}
				if (_fadeTimer > 155 && _fadeTimer <= 200)
				{
					topscores_button.alpha += 0.05;
				}
				if (_fadeTimer > 190 && _fadeTimer <= 240)
				{
					credits.alpha += 0.05;
					onilogo.alpha += 0.05;
				}
				
				//Increment timer
				_fadeTimer++;
			}
			else
			{
				//Remove listener
				removeEventListener(Oni.UPDATE, _onScreenFadeIn);
			}
		}
		
		/**
		 * Called when the screen is removed
		 */
		override public function remove():void 
		{
			//Reset timer
			_fadeTimer = 0;
			
			//Listen for update
			_oni.addEventListener(Oni.UPDATE, _onScreenFadeOut);
		}
		
		/**
		 * Called when the screen has been removed and should fade out
		 * @param	e
		 */
		private function _onScreenFadeOut(e:Event):void
		{
			//Check if we should even fade
			if (logo_lit.alpha != 0)
			{
				//Fade in elements in order
				if (_fadeTimer <= 30)
				{
					play_button.alpha -= 0.05;
					topscores_button.alpha -= 0.05;
				}
				else if (_fadeTimer > 30 && _fadeTimer <= 60)
				{
					back_light.alpha -= 0.05;
				}
				else if (_fadeTimer > 60 && _fadeTimer <= 90)
				{
					gradient.alpha -= 0.05;
					monolith.alpha -= 0.05;
					credits.alpha -= 0.05;
					onilogo.alpha -= 0.05;
				}
				else if (_fadeTimer > 90 && _fadeTimer <= 140)
				{
					logo_lit.alpha -= 0.04;
				}
				
				//Increment timer
				_fadeTimer++;
			}
			else
			{
				//Remove listener
				removeEventListener(Oni.UPDATE, _onScreenFadeOut);
				
				//Super remove
				super.remove();
			}
		}
		
		/**
		 * Called when the play button is touched
		 * @param	e
		 */
		private function _onTouchPlay(e:TouchEvent):void
		{
			//Get touch
			var touch:Touch = e.getTouch(play_button);
			
			//Touched?
			if (touch != null)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN: //Pressed
						play_button.texture = AssetManager.getTexture("menu_play_button_down");
						break;
						
					case TouchPhase.ENDED: //Press ended
						play_button.texture = AssetManager.getTexture("menu_play_button");
						
						//Switch to game screen
						_oni.screens.switchToName("game");
						break;
				}
			}
		}
		
		/**
		 * Called when the top scores button is touched
		 * @param	e
		 */
		private function _onTouchScores(e:TouchEvent):void
		{
			//Get touch
			var touch:Touch = e.getTouch(topscores_button);
			
			//Touched?
			if (touch != null)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN: //Pressed
						topscores_button.texture = AssetManager.getTexture("menu_topscores_button_down");
						break;
						
					case TouchPhase.ENDED: //Press ended
						topscores_button.texture = AssetManager.getTexture("menu_topscores_button");
						
						//Switch to to scores screen
						_oni.screens.switchToName("scores");
						break;
				}
			}
		}
		
	}

}