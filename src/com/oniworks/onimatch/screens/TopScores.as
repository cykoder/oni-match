package com.oniworks.onimatch.screens 
{
	import com.oniworks.onimatch.OniMatch;
	import flash.net.URLRequest;
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
	public class TopScores extends Screen
	{
		private var gradient:Image, title:Image, monolith:Image, advert:Image;
		
		private var menu_button:Image, share_button:Image;
		
		private var _fadeTimer:int;
		
		public function TopScores(oni:Oni) 
		{
			//Super
			super(oni, "scores");
			
			//Create gradient
			gradient = new Image(AssetManager.getTexture("menu_gradient"));
			gradient.alpha = 0;
			gradient.touchable = false;
			addChild(gradient);
			
			//Create monolith
			monolith = new Image(AssetManager.getTexture("topscores_monolith"));
			monolith.alpha = 0;
			monolith.x = 405;
			monolith.y = 39;
			monolith.touchable = false;
			addChild(monolith);
			
			//Create title
			title = new Image(AssetManager.getTexture("topscores_title"));
			title.alpha = 0;
			title.x = 612;
			title.y = 51;
			title.touchable = false;
			addChild(title);
			
			//Create advert
			advert = new Image(AssetManager.getTexture("topscores_advert"));
			advert.alpha = 0;
			advert.x = 58;
			advert.y = 173;
			advert.addEventListener(TouchEvent.TOUCH, _onTouchAdvert);
			addChild(advert);
			
			//Create share button
			share_button = new Image(AssetManager.getTexture("topscores_share_button"));
			share_button.alpha = 0;
			share_button.x = 530;
			share_button.y = 675;
			addChild(share_button);
			
			//Create menu button
			menu_button = new Image(AssetManager.getTexture("topscores_menu_button"));
			menu_button.alpha = 0;
			menu_button.x = 720;
			menu_button.y = 675;
			addChild(menu_button);
			
			//Listen for screen added
			addEventListener(Oni.SCREEN_ADDED, _onScreenAdded);
		}
		
		/**
		 * Called when the advert is touched
		 * @param	e
		 */
		private function _onTouchAdvert(e:TouchEvent):void
		{
			//Get touch
			var touch:Touch = e.getTouch(advert, TouchPhase.BEGAN);
			
			//Touched?
			if (touch != null)
			{
				//Open oni world website
				flash.net.navigateToURL(new URLRequest("http://oniworld.co.uk"), "_blank");
			}
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
			if (advert.alpha != 1)
			{
				if (_fadeTimer >= 100)
				{
					//Fade in elements in order
					if (_fadeTimer <= 130)
					{
						gradient.alpha += 0.03;
					}
					else if (_fadeTimer > 130 && _fadeTimer <= 140)
					{
						monolith.alpha += 0.18;
						title.alpha += 0.18;
						advert.alpha += 0.18;
						share_button.alpha += 0.18;
						menu_button.alpha += 0.18;
					}
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
		
	}

}