package com.oniworks.onimatch.screens 
{
	import com.greensock.TweenLite;
	import com.oniworks.onimatch.entities.Head;
	import com.oniworks.onimatch.OniMatch;
	import flash.globalization.StringTools;
	import oni.Oni;
	import oni.screens.GameScreen;
	import oni.screens.Screen;
	import oni.assets.AssetManager;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author Sam Hellawell
	 */
	public class Game extends GameScreen
	{
		/**
		 * Event fired when a head is selected
		 */
		public static var HEAD_SELECTED:String = "headselected";
		
		/**
		 * Variables, variables everywhere!
		 */
		private var logo:Image, clock:Image, clock_hand:Image, score_bg:Image, game_bg:Image, four_seconds:Image, five_seconds:Image;
		
		/**
		 * Game specific variables
		 */
		private var selection:Image, _canSelect:Boolean = true, _gameTime:int, _fadeTimer:int;
		
		/**
		 * The current selected head
		 */
		private var _selectedHead:Head, _headToSwitch:Head;
		
		private var _scoreTextFields:Array;
		
		/**
		 * The game grid
		 */
		public var grid:Array;
		
		public function Game(oni:Oni) 
		{
			//Super
			super(oni, false);
			
			//Create logo
			logo = new Image(AssetManager.getTexture("game_logo"));
			logo.x = 21;
			logo.y = 577;
			logo.touchable = false;
			addChild(logo);
			
			//Create a clock background
			clock = new Image(AssetManager.getTexture("game_clock"));
			clock.x = 25;
			clock.y = 82;
			clock.touchable = false;
			addChild(clock);
			
			//Create a clock hand
			clock_hand = new Image(AssetManager.getTexture("game_clock_hand"));
			clock_hand.x = 86;
			clock_hand.y = 144;
			clock_hand.touchable = false;
			clock_hand.pivotX = 1;
			clock_hand.pivotY = clock_hand.height - 2;
			addChild(clock_hand);
			
			//Create a score background
			score_bg = new Image(AssetManager.getTexture("game_score_bg"));
			score_bg.x = 20;
			score_bg.y = 224;
			score_bg.touchable = false;
			addChild(score_bg);
			
			//Create a game background
			game_bg = new Image(AssetManager.getTexture("game_game_bg"));
			game_bg.x = 176;
			game_bg.y = 18;
			game_bg.touchable = false;
			addChild(game_bg);
			
			//Create a 4 seconds powerup
			four_seconds = new Image(AssetManager.getTexture("game_4seconds"));
			four_seconds.x = 30;
			four_seconds.y = 391;
			four_seconds.touchable = false;
			four_seconds.alpha = 0;
			addChild(four_seconds);
			
			//Create a 5 seconds powerup
			five_seconds = new Image(AssetManager.getTexture("game_5seconds"));
			five_seconds.x = 22;
			five_seconds.y = 443;
			five_seconds.touchable = false;
			five_seconds.alpha = 0;
			addChild(five_seconds);
			
			//Create a selection image
			selection = new Image(AssetManager.getTexture("game_selection"));
			selection.visible = false;
			selection.touchable = false;
			selection.pivotX = selection.pivotY = 50;
			addChild(selection);
			
			//Create a score textfields
			_scoreTextFields = new Array();
			for (var i:int = 0; i < 6; i++)
			{
				var textfield:TextField = new TextField(16, 30, "0", "Calibri", 24, 0x414141, true);
				textfield.hAlign = HAlign.CENTER;
				textfield.vAlign = VAlign.CENTER;
				textfield.x = 35 + (17*i);
				textfield.y = 268;
				_scoreTextFields.push(textfield);
				addChild(textfield);
			}
			
			//Listen for screen added
			addEventListener(Oni.SCREEN_ADDED, _onScreenAdded);
			
			//Listen for head selection
			addEventListener(Game.HEAD_SELECTED, _onHeadSelected);
			
			addEventListener(Oni.UPDATE, _onUpdate);
			
			
			setupGame();
		}
		
		/**
		 * The current selected head
		 */
		public function get selectedHead():Head
		{
			return _selectedHead;
		}
		
		/**
		 * The current selected head
		 */
		public function set selectedHead(value:Head):void
		{
			//Set
			_selectedHead = value;
				
			//Move selection
			if (value != null)
			{
				selection.x = _selectedHead.x;
				selection.y = _selectedHead.y;
				selection.visible = true;
			}
			else
			{
				selection.visible = false;
			}
		}
		
		/**
		 * Called when a head is selected
		 * @param	e
		 */
		private function _onHeadSelected(e:Event):void
		{
			if (_canSelect)
			{
				if (_selectedHead == null) //Select
				{
					selectedHead = e.data.head;
				}
				else if (_selectedHead == e.data.head) //Deselect
				{
					selectedHead = null;
				}
				else //Switch
				{
					if ((_selectedHead.rx + 1 == e.data.head.rx && _selectedHead.ry == e.data.head.ry) ||
						(_selectedHead.rx - 1 == e.data.head.rx && _selectedHead.ry == e.data.head.ry) ||
						(_selectedHead.ry + 1 == e.data.head.ry && _selectedHead.rx == e.data.head.rx) ||
						(_selectedHead.ry - 1 == e.data.head.ry && _selectedHead.rx == e.data.head.rx))
					{
						//Set head to switch
						_headToSwitch = e.data.head;
					
						//Tween!
						TweenLite.to(_selectedHead, 0.5, { x:229 + (_headToSwitch.rx * 101), y:71 + (_headToSwitch.ry * 101)});
						TweenLite.to(_headToSwitch, 0.5, { x:229 + (_selectedHead.rx * 101), y:71 + (_selectedHead.ry * 101) } );
						
						//Disable selection
						_canSelect = false;
					}
					else
					{
						selectedHead = null;
					}
				}
			}
		}
		
		/**
		 * Called when the game is updated
		 * @param	e
		 */
		private function _onUpdate(e:Event):void
		{
			//Check if ran out of time
			_gameTime++;
			clock_hand.rotation = _gameTime * 0.0034906585;
			if (_gameTime >= 1800)
			{
				trace("GAME OVER");
				removeEventListener(Game.HEAD_SELECTED, _onHeadSelected);
			}
			else
			{
				//Bouncy selection effects
				if (selection.visible)
				{
					if (selection.width == 100 && selection.height == 100)
					{
						TweenLite.to(selection, 0.5, { width:90, height:90 });
					}
					else if (selection.width == 90 && selection.height == 90)
					{
						TweenLite.to(selection, 0.5, { width:100, height:100 });
					}
				}
				
				//Are we switching?
				if (_selectedHead != null && _headToSwitch != null)
				{
					//Tweens over?
					if (_selectedHead.x == (229 + (_headToSwitch.rx * 101)) && _selectedHead.y == (71 + (_headToSwitch.ry * 101)))
					{
						//Switch positions
						var selected_orx:int = _selectedHead.rx;
						var selected_ory:int = _selectedHead.ry;
						var toswitch_orx:int = _headToSwitch.rx;
						var toswitch_ory:int = _headToSwitch.ry;
						
						_selectedHead.rx = toswitch_orx;
						_selectedHead.ry = toswitch_ory;
						
						_headToSwitch.rx = selected_orx;
						_headToSwitch.ry = selected_ory;
						
						grid[selected_orx][selected_ory] = _headToSwitch;
						grid[toswitch_orx][toswitch_orx] = _selectedHead;
						
						//Is a winner me?
						var matches:int = _checkAndRemove(_selectedHead);
						if (matches >= 2) //Winner!
						{
							//Add time?
							if(matches == 4) _addTime(4);
							if(matches >= 5) _addTime(5);
						}
						else
						{
							//No cake, switch back positions
							_selectedHead.rx = selected_orx;
							_selectedHead.ry = selected_ory;
							
							_headToSwitch.rx = toswitch_orx;
							_headToSwitch.ry = toswitch_ory;
						}
						
						//Allow selection
						_canSelect = true;
						
						//Nullify
						selectedHead = null;
						_headToSwitch = null;
					}
				}
			}
		}
		
		/**
		 * Repopulates the empty grid spaces
		 */
		private function _repopulate():void
		{
			for (var cx:int = 0; cx < 8; cx++)
			{
				for (var cy:int = 0; cy < 7; cy++)
				{
					if (grid[cx][cy] == null)
					{
						var head:Head = new Head(this, Math.ceil(Math.floor(Math.random() * (5 - 1 + 1)) + 1), cx, cy);
						grid[cx][cy] = entities.add(head) as Head;
					}
				}
			}
		}
		
		/**
		 * Sets up the game
		 */
		public function setupGame():void
		{
			//Reset
			reset();
			
			//Setup a scene
			createScene(false);
			
			//Create game grid
			grid = [];
			
			//Columns
			for (var cx:int = 0; cx < 8; cx++)
			{
				grid.push([]);
				
				//Rows
				for (var cy:int = 0; cy < 7; cy++)
				{
					//Create head
					var head:Head = new Head(this, Math.ceil(Math.floor(Math.random() * (5 - 1 + 1)) + 1), cx, cy);
					entities.add(head);
					
					//Populate grid
					grid[cx].push(head);
				}
			}
			
			//Make sure there arent any matches
			var matches:Array;
			for (var i:uint = 0; i < entities.entities.length; i++)
			{
				if (entities.entities[i] is Head)
				{
					matches = _checkSurrounding(entities.entities[i] as Head);
					for each(var checkHead:Head in matches) checkHead.type = checkHead.type + 1;
				}
			}
			
			//Set selection to top
			setChildIndex(selection, numChildren);
			
			//Set clock timer!
			_gameTime = 0;
		}
		
		/**
		 * Adds time to the game
		 * @param	seconds
		 */
		private function _addTime(seconds:int):void
		{
			//Fix up rotation
			_gameTime -= seconds*30;
			
			//Four seconds
			if (seconds == 4)
			{
				four_seconds.x = 30;
				four_seconds.y = 391;
				four_seconds.alpha = 1;
				TweenLite.to(four_seconds, 1.25, { alpha: 0, y:four_seconds.y - 50 } );
			}
			else //Five seconds
			{
				five_seconds.x = 22;
				five_seconds.y = 443;
				five_seconds.alpha = 1;
				TweenLite.to(five_seconds, 1.25, { alpha: 0, y:five_seconds.y - 50 } );
			}
		}
		
		/**
		 * Checks the surrounding heads and returns any matches
		 * @param	head
		 * @return
		 */
		private function _checkSurrounding(head:Head):Array
		{
			//Initialise variables
			var matches:Array = [];
			var cx:uint = head.rx;
			var cy:uint = head.ry;
			var i:int;
			
			//Go left
			for (i = cx - 1; i >= 0; i--)
			{
				if (grid[i] != null && grid[i][cy] != null && grid[i][cy].type != head.type)
				{
					break;
				}
				matches.push(grid[i][cy]);
			}
			
			//Go right
			for (i = cx + 1; i < grid.length; i++)
			{
				if (grid[i] != null && grid[i][cy] != null && grid[i][cy].type != head.type)
				{
					break;
				}
				matches.push(grid[i][cy]);
			}
			
			//Go up
			if (matches.length == 0)
			{
				for (i = cy - 1; i >= 0; i--)
				{
					if (grid[cx] != null && grid[cx][i] != null && grid[cx][i].type != head.type)
					{
						break;
					}
					matches.push(grid[cx][i]);
				}
				
				//Go down
				for (i = cy + 1; i < grid[cx].length; i++)
				{
					if (grid[cx] != null && grid[cx][i] != null && grid[cx][i].type != head.type)
					{
						break;
					}
					matches.push(grid[cx][i]);
				}
			}
			
			return matches;
		}
		
		/**
		 * Checks surrounding heads and removes matches
		 * @param	head
		 * @return
		 */
		private function _checkAndRemove(head:Head):int
		{
			//Check for matches
			var matches:Array = _checkSurrounding(head);
			if (matches.length >= 2)
			{
				//Remove the entities
				matches.push(head);
				for each(var head:Head in matches)
				{
					grid[head.rx][head.ry] = null;
					entities.remove(head);
				}
				
				//Repopulate
				_repopulate();
			}
			
			return matches.length;
		}
		
		/**
		 * Called when the screen has been added
		 * @param	e
		 */
		private function _onScreenAdded(e:Event):void
		{
			//Reset alpha
			this.alpha = _fadeTimer = 0;
			
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
			if (this.alpha != 1)
			{
				//Wait for menu to fade out
				if (_fadeTimer > 100)
				{
					this.alpha += 0.05;
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