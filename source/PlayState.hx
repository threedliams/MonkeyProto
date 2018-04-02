package;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.ui.FlxBar;
import Bananas;
import flixel.text.FlxText;
import flixel.math.FlxRandom;


class PlayState extends FlxState
{
	private var player1:PlayerSprite;
	private var player2:PlayerSprite;
	
	private var walls:FlxTypedGroup<WallSprite>;
	private var innerWalls:FlxTypedGroup<WallSprite>;
	private var dividerWalls: FlxTypedGroup<WallSprite>;
	
	private var poops:FlxTypedGroup<PoopSprite>;
	
	private var player1HealthBar:FlxBar;
	private var player2HealthBar:FlxBar;
	
	private var player1PoopBar:FlxBar;
	private var player2PoopBar:FlxBar;
	
	private var bananas:FlxTypedGroup<Bananas>;
	private var leftSideBananas:FlxTypedGroup<Bananas>;
	private var rightSideBananas:FlxTypedGroup<Bananas>;
	
	private var nextLeftSpawn:Float = 0;
	private var nextRightSpawn:Float = 0;
	
	private var maxSpawnTime:Float = 60;
	private var minSpawnTime:Float = 10;
	
	private var currentText:FlxText;
	
	private var inWinState:Bool;
	
	private var randomNumberGenerator:FlxRandom;
	
	private var leftSideMinX:Int = 20;
	private var rightSideMinX:Int = 321;
	
	private var leftSideMinY:Int = 20;
	private var rightSideMinY:Int = 20;
	
	private var leftSideMaxX:Int = 282;
	private var rightSideMaxX:Int = 587;
	
	private var leftSideMaxY:Int = 427;
	private var rightSideMaxY:Int = 427;
	
	override public function create():Void
	{
		
		walls = new FlxTypedGroup<WallSprite>();
		innerWalls = new FlxTypedGroup<WallSprite>();
		dividerWalls = new FlxTypedGroup<WallSprite>();
		
		walls.add(new WallSprite(0, 0, 640, 20));
		walls.add(new WallSprite(0, 0, 20, 480));
		walls.add(new WallSprite(0, 460, 640, 20));
		walls.add(new WallSprite(620, 0, 20, 480));
		
		dividerWalls.add(new WallSprite(317.5, 20, 5, 440, FlxColor.RED));
		
		innerWalls.add(new WallSprite(260, 20, 5, 440, FlxColor.GREEN));
		innerWalls.add(new WallSprite(375, 20, 5, 440, FlxColor.GREEN));
		
		
		for (wall in walls) {
			add(wall);
		}
		
		for (wall in innerWalls) {
			add(wall);
		}
		
		for (wall in dividerWalls) {
			add(wall);
		}
		
		poops = new FlxTypedGroup<PoopSprite>();
		
		player1HealthBar = new FlxBar(40, 440, FlxBarFillDirection.LEFT_TO_RIGHT);
		player1HealthBar.createColoredFilledBar(FlxColor.RED, true, FlxColor.RED);
		add(player1HealthBar);
		
		
		player1PoopBar = new FlxBar(150, 440, FlxBarFillDirection.LEFT_TO_RIGHT);
		player1PoopBar.createColoredFilledBar(FlxColor.BROWN, true, FlxColor.BROWN);
		add(player1PoopBar);
		
			
			
		player2HealthBar = new FlxBar(390, 440, FlxBarFillDirection.LEFT_TO_RIGHT);
		player2HealthBar.createColoredFilledBar(FlxColor.RED, true, FlxColor.RED);
		add(player2HealthBar);
		
		
			
			
		player2PoopBar = new FlxBar(500, 440, FlxBarFillDirection.LEFT_TO_RIGHT);
		player2PoopBar.createColoredFilledBar(FlxColor.BROWN, true, FlxColor.BROWN);
		add(player2PoopBar);
		
		bananas = new FlxTypedGroup<Bananas>();
		leftSideBananas = new FlxTypedGroup<Bananas>();
		rightSideBananas = new FlxTypedGroup<Bananas>();
		
		
		inWinState = false;
		
		randomNumberGenerator = new FlxRandom();
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (inWinState) {
			player1 = null;
			player2 = null;
			return;
		}
		if (player1 != null) {
			player1.setTouchingBanana(false);
			FlxG.collide(player1, walls);
			FlxG.collide(player1, dividerWalls);
			FlxG.overlap(player1, poops, collidePoopWithPlayer);
			FlxG.overlap(player1, leftSideBananas, collidePlayerWithBanana);
		
			player1HealthBar.value = player1.getHealth();
			player1PoopBar.value = player1.getPoop();
			
			if (player1.getHealth() <= 0) {
				inWinState = true;
				currentText = new FlxText(250, 200, 300, "Player 2 Wins!", 12);
				add(currentText);
			}
		}
		else if (FlxG.gamepads.getByID(0) != null) {
			player1 = new PlayerSprite(20, 20, FlxG.gamepads.getByID(0), this);
			player1.loadGraphic(AssetPaths.monkey1__png);
			add(player1);
		}
		
		if (player2 != null) {
			player2.setTouchingBanana(false);
			FlxG.collide(player2, walls);
			FlxG.collide(player2, dividerWalls);
			FlxG.overlap(player2, poops, collidePoopWithPlayer);
			FlxG.overlap(player2, rightSideBananas, collidePlayerWithBanana);
			
			player2HealthBar.value = player2.getHealth();
			player2PoopBar.value = player2.getPoop();
			
			if (player2.getHealth() <= 0) {
				inWinState = true;
				currentText = new FlxText(250, 200, 300, "Player 1 Wins!", 12);
				add(currentText);
			}
		}
		else if (FlxG.gamepads.getByID(1) != null) {
			player2 = new PlayerSprite(570, 20, FlxG.gamepads.getByID(1), this);
			player2.loadGraphic(AssetPaths.monkey2__png);
			add(player2);
		}
		
		FlxG.overlap(walls, poops, collidePoopWithWall);
		
		updateBananas();
		
		nextLeftSpawn -= elapsed;
		nextRightSpawn -= elapsed;
		
		super.update(elapsed);
	}
	
	private function maybeSpawnBanana():Void {
		if (nextLeftSpawn <= 0 && leftSideBananas.length < 3) {
			nextLeftSpawn = randomNumberGenerator.float(minSpawnTime, maxSpawnTime);
			var newBanana:Bananas = new Bananas(randomNumberGenerator.int(leftSideMinX, leftSideMaxX), randomNumberGenerator.int(leftSideMinY, leftSideMaxY));
			leftSideBananas.add(newBanana);
			add(newBanana);
		}
		if (nextRightSpawn <= 0 && leftSideBananas.length < 3) {
			nextRightSpawn = randomNumberGenerator.float(minSpawnTime, maxSpawnTime);
			var newBanana:Bananas = new Bananas(randomNumberGenerator.int(rightSideMinX, rightSideMaxX), randomNumberGenerator.int(rightSideMinY, rightSideMaxY));
			rightSideBananas.add(newBanana);
			add(newBanana);
		}
	}
	
	private function updateBananas():Void {
		for (banana in leftSideBananas) {
			if (banana.isReadyToDespawn()) {
				leftSideBananas.remove(banana, true);
				banana.destroy();
			}
		}
		for (banana in rightSideBananas) {
			if (banana.isReadyToDespawn()) {
				rightSideBananas.remove(banana, true);
				banana.destroy();
			}
		}
		
		maybeSpawnBanana();
	}

	public function addPoop(poop:PoopSprite):Void {
		poops.add(poop);
		add(poop);
	}
	
	private function collidePoopWithPlayer(player:PlayerSprite, poop:PoopSprite):Void {
		player.setHealth(player.getHealth() - 10);
		destroyPoop(poop);
	}
	
	private function collidePoopWithWall(wall:WallSprite, poop:PoopSprite):Void {
		destroyPoop(poop);
	}
	
	private function destroyPoop(poop:PoopSprite):Void {
		poops.remove(poop, true);
		poop.destroy();
	}
	
	private function collidePlayerWithBanana(player:PlayerSprite, banana:Bananas):Void {
		player.setTouchingBanana(true);
	}
}