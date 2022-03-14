package meta.data;

import flixel.FlxG;

using StringTools;

class Ending
{
	public static var endingStatus:String = 'neutral';
	
	public static function setStatus(newStatus:String){
		endingStatus = newStatus;
		FlxG.save.data.endingStatus = newStatus;
		FlxG.save.flush();
	}
	
	public static function loadStatus():Void
	{
		if (FlxG.save.data.endingStatus != null)
		{
			endingStatus = FlxG.save.data.endingStatus;
		}
	}
	
	public static function getStatus():String
	{
		return endingStatus;
	}
}
