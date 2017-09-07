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
		//this.width = 16;
		//this.height = 16;
		//this.setGraphicSize(16, 16);
	}
	
	override public function update(elapsed:Float):Void {
		//if (this.x < 0 || this.x > 640 || this.y < 0 || this.y > 480) {
		//	this.destroy();
		//}
		
		super.update(elapsed);
	}
	
}