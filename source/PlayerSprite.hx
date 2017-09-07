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
	private var speed:Float = 200;
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
		
		//makeGraphic(spriteWidth, spriteHeight, FlxColor.BROWN);
		
		this.gamepad = gamepad;
		
		aimer = new FlxSprite(X, Y);
		aimer.makeGraphic(Math.floor(spriteHeight * 1.5), 3, FlxColor.ORANGE);
		aimer.origin = new FlxPoint(0, 0);
		parent.add(aimer);
		
		this.parent = parent;
		//this.visible = false;
		
		this.playerHealth = 100;
		this.playerPoop = 100;
		
		this.touchingBanana = false;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		//var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		//trace(gamepad);
		if (gamepad != null) {
			updateGamepadInput(gamepad);
		}
		
		aimer.x = this.x + spriteWidth / 2;
		aimer.y = this.y + spriteHeight / 2;
		//aimer.origin = new FlxPoint(aimer.x, aimer.origin.y);
		//trace(aimer.origin);
		//trace(x);
		//trace(y);
		if (fillingPoop) {
			if (playerPoop < 100) {
				this.playerPoop += .5;
			}
		}
	}
	
	private function updateGamepadInput(gamepad:FlxGamepad):Void {
		/*(if (gamepad.pressed.A) {
			trace("A pressed");
		}
		
		if (gamepad.analog.justMoved.LEFT_STICK_X) {
			trace("x moved");
		}*/
		
		var upDown:Float = 0;
		var leftRight:Float = 0;
		
		//up = gamepad.analog.value.LEFT_STICK_X;
		//trace(gamepad.analog.value.LEFT_STICK_X);
		upDown = gamepad.analog.value.LEFT_STICK_Y;
		leftRight = gamepad.analog.value.LEFT_STICK_X;
		
		//if (upDown != 0 || leftRight != 0) {
		this.velocity.y = upDown * speed;
		this.velocity.x = leftRight * speed;
		//}
		
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
		
		if (
			(
				aimerAngle >= 270
				&& aimerAngle <= 360
			) || (
				aimerAngle <= 90
				&& aimerAngle >= 0
			)
		) {
			startingX += spriteWidth * 1.5;
		}
		else if (aimerAngle > 90 && aimerAngle < 270) {
			startingX -= spriteWidth / 2;
		}
		
		if (aimerAngle > 0 && aimerAngle < 180) {
			startingY -= spriteHeight / 2;
		}
		else if (aimerAngle > 180 && aimerAngle < 360) {
			startingY += spriteHeight * 1.5;
		}
		//trace(startingX);
		//trace(startingY);
		
		var newPoop:PoopSprite = new PoopSprite(startingX, startingY);
		newPoop.velocity.set(poopSpeed, 0);
		newPoop.velocity.rotate(FlxPoint.weak(0, 0), aimer.angle);
		//trace(newPoop);
		parent.addPoop(newPoop);
	}
	
	private function aim(aimUpDown:Float, aimLeftRight:Float):Void {
		//var scaleFactor:Float = Math.sqrt(Math.pow(aimUpDown, 2) + Math.pow(aimLeftRight, 2));
		//aimer.scale = scaleFactor;
		//var scaleFactor:Float = (Math.abs(aimLeftRight) + Math.abs(aimUpDown)) / 2;
		var scaleFactor:Float = Math.sqrt(Math.pow(aimUpDown, 2) + Math.pow(aimLeftRight, 2));
		aimer.scale = new FlxPoint(scaleFactor, scaleFactor);
		aimer.angle = Math.atan2(aimUpDown, aimLeftRight) * 180 / Math.PI;
		//aimer.angle += 2;
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