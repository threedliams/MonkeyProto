package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;

import flixel.input.gamepad.FlxGamepad;

/**
 * ...
 * @author ropp
 */
class PlayerSprite extends FlxSprite {
	
	private var spriteWidth = 50;
	private var spriteHeight = 100;
	private var speed:Float = 350;
	private var gamepad:FlxGamepad;
	private var aimer:FlxSprite;
	private var poopSpeed = 300;
	private var parent:PlayState;
	
	private var playerHealth:Float;
	private var playerPoop:Float;
	
	private var touchingBanana:Bool;
	
	private var fillingPoop:Bool;

	public function new(?X:Float=0, ?Y:Float=0, gamepad:FlxGamepad, parent:PlayState) {
		super(X, Y);
		
		this.gamepad = gamepad;
		
		aimer = new FlxSprite(X, Y);
		aimer.makeGraphic(Math.floor(spriteHeight * 1.5), 3, FlxColor.ORANGE);
		aimer.origin = new FlxPoint(0, 0);
		parent.add(aimer);
		
		this.parent = parent;
		
		this.playerHealth = 100;
		this.playerPoop = 100;
		
		this.touchingBanana = false;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (gamepad != null) {
			updateGamepadInput(gamepad);
		}
		
		aimer.x = this.x + spriteWidth / 2;
		aimer.y = this.y + spriteHeight / 2;
		if (fillingPoop) {
			if (playerPoop < 100) {
				this.playerPoop += .5;
			}
		}
	}
	
	private function updateGamepadInput(gamepad:FlxGamepad):Void {
		
		var upDown:Float = 0;
		var leftRight:Float = 0;
		
		upDown = gamepad.analog.value.LEFT_STICK_Y;
		leftRight = gamepad.analog.value.LEFT_STICK_X;

		this.velocity.y = upDown * speed;
		this.velocity.x = leftRight * speed;
		
		var aimUpDown:Float = 0;
		var aimLeftRight: Float = 0;
		
		aimUpDown = gamepad.analog.value.RIGHT_STICK_Y;
		aimLeftRight = gamepad.analog.value.RIGHT_STICK_X;
		
		aim(aimUpDown, aimLeftRight);
		
		
		if (gamepad.pressed.Y && touchingBanana && !fillingPoop) {
			fillingPoop = true;
		}
		
		if (gamepad.justReleased.Y || !touchingBanana) {
			fillingPoop = false;
		}
		
		if (!fillingPoop && gamepad.justPressed.RIGHT_SHOULDER && playerPoop >= 10) {
			playerPoop -= 10;
			throwPoop();
		}
	}
	
	private function throwPoop():Void {
		var startingX = x;
		var startingY = y;
		var aimerAngle = aimer.angle;
		if (aimerAngle < 0) {
			aimerAngle = Math.abs(aimerAngle);
		}
		else {
			aimerAngle = 360 - aimerAngle;
		}
		
		startingY = this.getMidpoint().y + spriteHeight * Math.sin((aimer.angle) * Math.PI / 180);
		startingX = this.getMidpoint().x + spriteWidth * Math.cos((aimer.angle) * Math.PI / 180);
		
		var newPoop:PoopSprite = new PoopSprite(startingX, startingY);
		newPoop.velocity.set(poopSpeed, 0);
		newPoop.velocity.rotate(FlxPoint.weak(0, 0), aimer.angle);
		parent.addPoop(newPoop);
	}
	
	private function aim(aimUpDown:Float, aimLeftRight:Float):Void {
		var scaleFactor:Float = Math.sqrt(Math.pow(aimUpDown, 2) + Math.pow(aimLeftRight, 2));
		aimer.scale = new FlxPoint(scaleFactor, scaleFactor);
		aimer.angle = Math.atan2(aimUpDown, aimLeftRight) * 180 / Math.PI;
	}
	
	public function getHealth():Float {
		return playerHealth;
	}
	
	public function getPoop():Float {
		return playerPoop;
	}
	
	public function setHealth(playerHealth:Float):Void {
		this.playerHealth = playerHealth;
	}
	
	public function setPoop(playerPoop:Float):Void {
		this.playerPoop = playerPoop;
	}
	
	public function setTouchingBanana(touchingBanana:Bool):Void {
		this.touchingBanana = touchingBanana;
	}
	
	public function getTouchingBanana():Bool {
		return touchingBanana;
	}
}