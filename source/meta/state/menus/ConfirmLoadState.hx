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
import meta.data.font.Alphabet;

using StringTools;

class ConfirmLoadState extends MusicBeatState
{
	var confirmText:Alphabet;
	var yesText:Alphabet;
	var noText:Alphabet;
	var resetHeart:FlxSprite;
	var curSelected:Int = 0;
	
	override function create()
	{
		confirmText = new Alphabet(0, 0, "* Do you wish to reset?", false, false);
		confirmText.screenCenter();
		add(confirmText);
		
		yesText = new Alphabet(850, 500, "Yes", false, false);
		yesText.updateHitbox();
		yesText.antialiasing = false;
		add(yesText);
		
		noText = new Alphabet(250, 500, "No", false, false);
		noText.updateHitbox();
		noText.antialiasing = false;
		add(noText);
		
		resetHeart = new FlxSprite(185, 570).loadGraphic(Paths.image('menus/base/resetheart'));
		resetHeart.setGraphicSize(Std.int(resetHeart.width * 2));
		resetHeart.updateHitbox();
		resetHeart.antialiasing = false;
		add(resetHeart);
	}
	
	override function update(elapsed:Float)
	{
		if(FlxG.keys.justPressed.RIGHT && curSelected == 0){
			curSelected++;
		}
		else if(FlxG.keys.justPressed.LEFT && curSelected == 1){
			curSelected--;
		}
		else if(FlxG.keys.justPressed.ENTER){
			exitState(curSelected);
		}
		switch(curSelected){
			case 0:
				resetHeart.x = 185;
			default:
				resetHeart.x = 805;
		}
	}
	
	private function exitState(selected:Int){
		if(selected == 1){
			Ending.setStatus('neutral');
			Ending.changeMusic = true;
			TitleState.initialized = false;
			Main.switchState(this, new TitleState());
		}
		else{
			Main.switchState(this, new MainMenuState());
		}
	}
}