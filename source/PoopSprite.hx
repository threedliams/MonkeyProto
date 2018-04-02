package;

import flixel.FlxSprite;

/**
 * ...
 * @author ropp
 */
class PoopSprite extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) {
		super(X, Y);
		
		loadGraphic(AssetPaths.scaledPoop__png, false);
	}
	
	override public function update(elapsed:Float):Void {
		
		super.update(elapsed);
	}
	
}