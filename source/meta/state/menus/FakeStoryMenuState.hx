package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import meta.data.*;
import openfl.Assets;
import meta.MusicBeat.MusicBeatState;
import gameObjects.*;
import gameObjects.userInterface.*;
import sys.io.File;

using StringTools;

class FakeStoryMenuState extends MusicBeatState
{
	public static var dialogueHUD:FlxCamera;
	var dialogueBox:DialogueBox;
	
	override function create()
	{
		var bggrid:FlxSprite = new FlxSprite(20, 40).loadGraphic(Paths.image('menus/base/storymenu/bggrid'));
		bggrid.setGraphicSize(Std.int(bggrid.width * 1));
		bggrid.updateHitbox();
		bggrid.antialiasing = true;
		add(bggrid);
		
		dialogueHUD = new FlxCamera();
		dialogueHUD.bgColor.alpha = 0;
		FlxG.cameras.add(dialogueHUD);
		
		var dialogPath = Paths.json('heartache/fakestory');
		if (sys.FileSystem.exists(dialogPath))
		{
			dialogueBox = DialogueBox.createDialogue(sys.io.File.getContent(dialogPath));
			dialogueBox.cameras = [dialogueHUD];
			dialogueBox.whenDaFinish = exitState;

			add(dialogueBox);
		}
		else{
			exitState();
		}
	}
	
	override function update(elapsed:Float)
	{
		if (dialogueBox != null && dialogueBox.alive) {
			// wheee the shift closes the dialogue
			if (FlxG.keys.justPressed.SHIFT)
				dialogueBox.closeDialog();

			// the change I made was just so that it would only take accept inputs
			if (controls.ACCEPT && dialogueBox.textStarted)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				dialogueBox.curPage += 1;

				if (dialogueBox.curPage == dialogueBox.dialogueData.dialogue.length)
					dialogueBox.closeDialog();
				else
					dialogueBox.updateDialog();
			}

		}
		
		super.update(elapsed);
	}

	public function exitState()
	{
		trace("Yo lol");
		// play menu music
		ForeverTools.resetMenuMusic();

		// set up transitions
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		Main.switchState(this, new MainMenuState());
		
	}
}