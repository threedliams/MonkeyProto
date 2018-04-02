package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * ...
 * @author ropp
 */
class Bananas extends FlxSprite
{

	private var spriteWidth:Int = 32;
	private var spriteHeight:Int = 32;
	
	private var lifetime:Float = 0;
	
	private var maxLifetime:Float = 30;
	
	public function new(?X:Float=0, ?Y:Float=0) {
		super(X, Y);
		
		loadGraphic(AssetPaths.banana__png, false);
		setGraphicSize(spriteWidth, spriteHeight);
	}
	
	override public function update(elapsed:Float):Void {
		lifetime += elapsed;
		
		super.update(elapsed);
	}
	
	public function isReadyToDespawn():Bool {
		return lifetime >= maxLifetime;
	}
}