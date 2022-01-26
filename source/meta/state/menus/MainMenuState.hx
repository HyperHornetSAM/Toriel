package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var storypic_1:FlxSprite;
	var storypic_2:FlxSprite;
	var freeplay:FlxSprite;
	var options_1:FlxSprite;
	var options_2:FlxSprite;
	var heart:FlxSprite;
	
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	var canSnap:Array<Float> = [];

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if !html5
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// add the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		storypic_1 = new FlxSprite(600, 150).loadGraphic(Paths.image('menus/base/mainmenu/story1'));
		storypic_2 = new FlxSprite(600, 150).loadGraphic(Paths.image('menus/base/mainmenu/story2'));
		freeplay = new FlxSprite(600, 150).loadGraphic(Paths.image('menus/base/mainmenu/freeplay'));
		options_1 = new FlxSprite(600, 150).loadGraphic(Paths.image('menus/base/mainmenu/options1'));
		options_2 = new FlxSprite(600, 150).loadGraphic(Paths.image('menus/base/mainmenu/options2'));
		
		storypic_1.antialiasing = true;
		storypic_2.antialiasing = true;
		freeplay.antialiasing = true;
		options_1.antialiasing = true;
		options_2.antialiasing = true;
		
		storypic_1.alpha = 0;
		storypic_2.alpha = 0;
		freeplay.alpha = 0;
		options_1.alpha = 0;
		options_2.alpha = 0;
		
		storypic_1.setGraphicSize(Std.int(storypic_1.width * 0.6));
		storypic_2.setGraphicSize(Std.int(storypic_2.width * 0.6));
		freeplay.setGraphicSize(Std.int(freeplay.width * 0.6));
		options_1.setGraphicSize(Std.int(options_1.width * 0.6));
		options_2.setGraphicSize(Std.int(options_2.width * 0.6));
		
		storypic_1.updateHitbox();
		storypic_2.updateHitbox();
		freeplay.updateHitbox();
		options_1.updateHitbox();
		options_2.updateHitbox();
		
		add(storypic_1);
		add(storypic_2);
		add(freeplay);
		add(options_1);
		add(options_2);
		
		heart = new FlxSprite(10, 205);
		heart.frames = Paths.getSparrowAtlas('menus/base/mainmenu/heart');
		heart.antialiasing = true;
		heart.animation.addByPrefix('beat', 'heart', 24, true);
		heart.setGraphicSize(Std.int(heart.width * 0.8));
		heart.animation.play('beat');
		add(heart);

		// create the menu items themselves
		var tex = Paths.getSparrowAtlas('menus/base/title/FNF_main_menu_assets');

		// loop through the menu options
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 200 + (i * 150));
			menuItem.frames = tex;
			// add the animations in a cool way (real
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.6));
			menuItem.animation.play('idle');
			canSnap[i] = -1;
			// set the id
			menuItem.ID = i;
			// menuItem.alpha = 0;

			// placements
			menuItem.screenCenter(X);
			// if the id is divisible by 2
			if (menuItem.ID % 2 == 0)
				menuItem.x += 1000;
			else
				menuItem.x -= 1000;

			// actually add the item
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.updateHitbox();
		}

		// set the camera to actually follow the camera object that was created before
		//var camLerp = Main.framerateAdjust(0.10);
		//FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();

		// from the base game lol

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Forever Engine v" + Main.gameVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

		var up = controls.UP;
		var down = controls.DOWN;
		var up_p = controls.UP_P;
		var down_p = controls.DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					// if single press
					if (i > 1)
					{
						// up is 2 and down is 3
						// paaaaaiiiiiiinnnnn
						if (i == 2)
							curSelected--;
						else if (i == 3)
							curSelected++;

						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					if (curSelected < 0)
						curSelected = optionShit.length - 1;
					else if (curSelected >= optionShit.length)
						curSelected = 0;
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}
		
		switch(curSelected){
			case 0:
				storypic_1.alpha = 1;
				freeplay.alpha = 0;
				options_1.alpha = 0;
				heart.y = 205;
			case 1:
				storypic_1.alpha = 0;
				freeplay.alpha = 1;
				options_1.alpha = 0;
				heart.y = 350;
			case 2:
				storypic_1.alpha = 0;
				freeplay.alpha = 0;
				options_1.alpha = 1;
				heart.y = 495;
		}

		if ((controls.ACCEPT) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			//FlxFlicker.flicker(magenta, 0.8, 0.1, false);

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0, x: FlxG.width * 2}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						var daChoice:String = optionShit[Math.floor(curSelected)];

						switch (daChoice)
						{
							case 'story mode':
								Main.switchState(this, new StoryMenuState());
							case 'freeplay':
								Main.switchState(this, new FreeplayState());
							case 'options':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new OptionsMenuState());
						}
					});
				}
			});
		}

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

		super.update(elapsed);

		menuItems.forEach(function(menuItem:FlxSprite)
		{
			menuItem.screenCenter(X);
			menuItem.x -= 350;
			if (menuItem.ID == 0){
				menuItem.x += 50;
			}
		});
	}

	var lastCurSelected:Int = 0;

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
		});

		/*
		camFollow.setPosition(menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().x,
			menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().y);
		*/

		if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
			menuItems.members[Math.floor(curSelected)].animation.play('selected');

		menuItems.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}

