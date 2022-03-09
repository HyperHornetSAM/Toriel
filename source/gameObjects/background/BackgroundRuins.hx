package gameObjects.background;

import flixel.graphics.frames.FlxAtlasFrames;
import meta.data.dependency.FNFSprite;

class BackgroundRuins extends FNFSprite
{
	public function new(x:Float, y:Float, isSavePoint:Bool)
	{
		super(x, y);

		if(isSavePoint == true){
			frames = Paths.getSparrowAtlas("backgrounds/ruins/SAVE_symbol");
			animation.addByIndices('danceLeft', 'SAVE symbol', [0, 1, 2, 3], "", 24, false);
			animation.addByIndices('danceRight', 'SAVE symbol', [4, 5, 6, 7], "", 24, false);
			animation.play('danceLeft');
			antialiasing = true;
		}
		else{
			frames = Paths.getSparrowAtlas("backgrounds/ruins/froggit_jam");
			animation.addByIndices('danceLeft', 'froggit vibe', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
			animation.addByIndices('danceRight', 'froggit vibe', [8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
			animation.play('danceLeft');
			antialiasing = true;
		}
	}

	var danceDir:Bool = false;

	public function dance():Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
