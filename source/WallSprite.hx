package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class WallSprite extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?W:Int=16, ?H:Int=16, ?color:FlxColor=FlxColor.GRAY) 
	{
		super(X, Y);
		
		makeGraphic(W, H, color);
		
		solid = true;
		immovable = true;
	}
	
}