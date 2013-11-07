package com.oniworks.onimatch 
{
	import com.oniworks.onimatch.screens.Game;
	import com.oniworks.onimatch.screens.MainMenu;
	import com.oniworks.onimatch.screens.TopScores;
	import oni.assets.AssetManager;
	import oni.Oni;
	import oni.screens.Screen;
	import oni.utils.Backend;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * OniMatch game class!
	 * @author Sam Hellawell
	 */
	public class OniMatch extends Oni
	{
		public var music_toggle_button:Image, sound_toggle_button:Image;
		
		private var _musicSilent:Boolean = false, _soundSilent:Boolean=false;
		
		public function OniMatch() 
		{
			//Log this
			Backend.log("OniMatch starting up!");
			
			//Listen for init
			addEventListener(Oni.INIT, _init);
		}
		
		/**
		 * Called when we should initialise 
		 * @param	e
		 */
		private function _init(e:Event):void
		{
			//Create background
			var bg:Image = new Image(AssetManager.getTexture("background"));
			bg.touchable = false;
			addChild(bg);
			
			//Create music toggle button
			music_toggle_button = new Image(AssetManager.getTexture("music_toggle_button"));
			music_toggle_button.alpha = 0;
			music_toggle_button.x = 36;
			music_toggle_button.y = 20;
			music_toggle_button.addEventListener(TouchEvent.TOUCH, _onMusicToggle);
			addChild(music_toggle_button);
			
			//Create sound toggle button
			sound_toggle_button = new Image(AssetManager.getTexture("sound_toggle_button"));
			sound_toggle_button.alpha = 0;
			sound_toggle_button.x = music_toggle_button.x + 53;
			sound_toggle_button.y = music_toggle_button.y;
			sound_toggle_button.addEventListener(TouchEvent.TOUCH, _onSoundToggle);
			addChild(sound_toggle_button);
			
			screens.add(new MainMenu(this));
			screens.add(new TopScores(this));
			screens.add(new Game(this));
			
			//screens.switchTo(2);
		}
		
		/**
		 * Called when the music toggle button is touched
		 * @param	e
		 */
		private function _onMusicToggle(e:TouchEvent):void
		{
			//Get touch
			var touch:Touch = e.getTouch(music_toggle_button, TouchPhase.BEGAN);
			
			//Touched?
			if (touch != null)
			{
				if (_musicSilent)
				{
					music_toggle_button.texture = AssetManager.getTexture("music_toggle_button");
				}
				else
				{
					music_toggle_button.texture = AssetManager.getTexture("music_toggle_button_down");
				}
				
				_musicSilent = !_musicSilent;
			}
		}
		
		/**
		 * Called when the sound toggle button is touched
		 * @param	e
		 */
		private function _onSoundToggle(e:TouchEvent):void
		{
			//Get touch
			var touch:Touch = e.getTouch(sound_toggle_button, TouchPhase.BEGAN);
			
			//Touched?
			if (touch != null)
			{
				if (_soundSilent)
				{
					sound_toggle_button.texture = AssetManager.getTexture("sound_toggle_button");
				}
				else
				{
					sound_toggle_button.texture = AssetManager.getTexture("sound_toggle_button_down");
				}
				
				_soundSilent = !_soundSilent;
			}
		}
		
	}

}