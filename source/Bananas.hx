package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * ...
 * @author ropp
 */
class Bananas extends FlxSprite
{

	private var spriteWidth = 32;
	private var spriteHeight = 32;
	
	public function new(?X:Float=0, ?Y:Float=0) {
		super(X, Y);
		
		loadGraphic(AssetPaths.banana__png, false);
		setGraphicSize(spriteWidth, spriteHeight);
	}
	
	override public function update(elapsed:Float):Void {
		
		super.update(elapsed);
	}
	
}