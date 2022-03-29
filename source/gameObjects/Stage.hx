package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	
	public var RuinsDancers:FlxTypedGroup<BackgroundRuins>;
	
	public var swordDamageTotal:Int;
	
	public var swordDamageOnes:Int;
	public var swordDamageTens:Int;
	public var swordDamageHuns:Int;
	
	public var onesString:String;
	public var tensString:String;
	public var hunsString:String;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;
	
	public static var doorway:FNFSprite;
	var doorway_battle:FNFSprite;
	var swordDamageOne:FNFSprite;
	var swordDamageTen:FNFSprite;
	var swordDamageHun:FNFSprite;
	var swordDamageThou:FNFSprite;
	var swordDamageTenThou:FNFSprite;
	var bHeart:FNFSprite;
	public static var tHeart:FNFSprite;
	var gHeart:FNFSprite;
	var sliceAnim:FNFSprite;
	public static var heartHealth:FNFSprite;
	var froggitJam:BackgroundRuins;
	var saveSymbol:BackgroundRuins;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'highway';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'fallen-down':
					curStage = 'entrance';
				case 'ruins':
					curStage = 'ruins';
				case 'heartache':
					curStage = 'doorway';
				case 'anticipation':
					curStage = 'antruins';
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'entrance':
				curStage = 'entrance';
				PlayState.defaultCamZoom = 0.8;
				
				var bg:FNFSprite = new FNFSprite(-660, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/entrance'));
				bg.setGraphicSize(Std.int(bg.width * 1.2));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.95, 0.95);
				bg.active = false;
				add(bg);
	
				var door:FNFSprite = new FNFSprite(380, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/door'));
				door.updateHitbox();
				door.antialiasing = true;
				door.scrollFactor.set(0.2, 0.7);
				door.active = false;
	
				add(door);
			case 'ruins':
				curStage = 'ruins';
				PlayState.defaultCamZoom = 0.8;

				var floor:FNFSprite = new FNFSprite(-475, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/floor'));
				floor.setGraphicSize(Std.int(floor.width * 1.0));
				floor.updateHitbox();
				floor.antialiasing = true;
				floor.scrollFactor.set(0.95, 0.95);
				floor.active = false;
				add(floor);

				var wall:FNFSprite = new FNFSprite(-475, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/wall'));
				wall.setGraphicSize(Std.int(wall.width * 1.0));
				wall.updateHitbox();
				wall.antialiasing = true;
				wall.scrollFactor.set(0.8, 0.95);
				wall.active = false;
				add(wall);
				
				RuinsDancers = new FlxTypedGroup<BackgroundRuins>();
				add(RuinsDancers);

				froggitJam = new BackgroundRuins(-325, 350, false);
				froggitJam.setGraphicSize(Std.int(froggitJam.width * 0.8));
				RuinsDancers.add(froggitJam);
				
				saveSymbol = new BackgroundRuins(1410, 800, true);
				//saveSymbol.setGraphicSize(Std.int(saveSymbol.width * 2));
				RuinsDancers.add(saveSymbol);
				
			case 'antruins':
				curStage = 'antruins';
				PlayState.defaultCamZoom = 0.6;

				var floor:FNFSprite = new FNFSprite(-475, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/floor'));
				floor.setGraphicSize(Std.int(floor.width * 1.0));
				floor.updateHitbox();
				floor.antialiasing = true;
				floor.scrollFactor.set(0.95, 0.95);
				floor.active = false;
				add(floor);

				var wall:FNFSprite = new FNFSprite(-475, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/wall'));
				wall.setGraphicSize(Std.int(wall.width * 1.0));
				wall.updateHitbox();
				wall.antialiasing = true;
				wall.scrollFactor.set(0.95, 0.95);
				wall.active = false;
				add(wall);
				
			case 'doorway':
				curStage = 'doorway';
				PlayState.defaultCamZoom = 0.8;
				
				doorway = new FNFSprite(-425, -500);
				doorway.loadGraphic(Paths.image('backgrounds/' + curStage + '/doorway'));
				doorway.setGraphicSize(Std.int(doorway.width * 0.8));
				doorway.updateHitbox();
				doorway.antialiasing = true;
				doorway.scrollFactor.set(0.95, 0.95);
				doorway.active = false;
				add(doorway);
				
				doorway_battle = new FNFSprite(-425, -400);
				doorway_battle.loadGraphic(Paths.image('backgrounds/' + curStage + '/doorway_battle'));
				doorway_battle.setGraphicSize(Std.int(doorway_battle.width * 0.8));
				doorway_battle.updateHitbox();
				doorway_battle.antialiasing = true;
				doorway_battle.scrollFactor.set(0.95, 0.95);
				doorway_battle.active = false;
				doorway_battle.alpha = 0;
				add(doorway_battle);
				
				swordDamageOne = new FNFSprite(315, 500);
				swordDamageOne.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/damage');
				swordDamageOne.animation.addByPrefix('0', '0', 24, false);
				swordDamageOne.animation.addByPrefix('1', '1', 24, false);
				swordDamageOne.animation.addByPrefix('2', '2', 24, false);
				swordDamageOne.animation.addByPrefix('3', '3', 24, false);
				swordDamageOne.animation.addByPrefix('4', '4', 24, false);
				swordDamageOne.animation.addByPrefix('5', '5', 24, false);
				swordDamageOne.animation.addByPrefix('6', '6', 24, false);
				swordDamageOne.animation.addByPrefix('7', '7', 24, false);
				swordDamageOne.animation.addByPrefix('8', '8', 24, false);
				swordDamageOne.animation.addByPrefix('9', '9', 24, false);
				swordDamageOne.setGraphicSize(Std.int(swordDamageOne.width * 2));
				swordDamageOne.antialiasing = true;

				swordDamageTen = new FNFSprite(200, 500);
				swordDamageTen.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/damage');
				swordDamageTen.animation.addByPrefix('0', '0', 24, false);
				swordDamageTen.animation.addByPrefix('1', '1', 24, false);
				swordDamageTen.animation.addByPrefix('2', '2', 24, false);
				swordDamageTen.animation.addByPrefix('3', '3', 24, false);
				swordDamageTen.animation.addByPrefix('4', '4', 24, false);
				swordDamageTen.animation.addByPrefix('5', '5', 24, false);
				swordDamageTen.animation.addByPrefix('6', '6', 24, false);
				swordDamageTen.animation.addByPrefix('7', '7', 24, false);
				swordDamageTen.animation.addByPrefix('8', '8', 24, false);
				swordDamageTen.animation.addByPrefix('9', '9', 24, false);
				swordDamageTen.setGraphicSize(Std.int(swordDamageTen.width * 2));
				swordDamageTen.antialiasing = true;
						
				swordDamageHun = new FNFSprite(85, 500);
				swordDamageHun.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/damage');
				swordDamageHun.animation.addByPrefix('0', '0', 24, false);
				swordDamageHun.animation.addByPrefix('1', '1', 24, false);
				swordDamageHun.animation.addByPrefix('2', '2', 24, false);
				swordDamageHun.animation.addByPrefix('3', '3', 24, false);
				swordDamageHun.animation.addByPrefix('4', '4', 24, false);
				swordDamageHun.animation.addByPrefix('5', '5', 24, false);
				swordDamageHun.animation.addByPrefix('6', '6', 24, false);
				swordDamageHun.animation.addByPrefix('7', '7', 24, false);
				swordDamageHun.animation.addByPrefix('8', '8', 24, false);
				swordDamageHun.animation.addByPrefix('9', '9', 24, false);
				swordDamageHun.setGraphicSize(Std.int(swordDamageHun.width * 2));
				swordDamageHun.antialiasing = true;
				
				swordDamageThou = new FNFSprite(-30, 500);
				swordDamageThou.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/damage');
				swordDamageThou.animation.addByPrefix('0', '0', 24, false);
				swordDamageThou.animation.addByPrefix('1', '1', 24, false);
				swordDamageThou.animation.addByPrefix('2', '2', 24, false);
				swordDamageThou.animation.addByPrefix('3', '3', 24, false);
				swordDamageThou.animation.addByPrefix('4', '4', 24, false);
				swordDamageThou.animation.addByPrefix('5', '5', 24, false);
				swordDamageThou.animation.addByPrefix('6', '6', 24, false);
				swordDamageThou.animation.addByPrefix('7', '7', 24, false);
				swordDamageThou.animation.addByPrefix('8', '8', 24, false);
				swordDamageThou.animation.addByPrefix('9', '9', 24, false);
				swordDamageThou.setGraphicSize(Std.int(swordDamageThou.width * 2));
				swordDamageThou.antialiasing = true;
				
				swordDamageTenThou = new FNFSprite(-145, 500);
				swordDamageTenThou.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/damage');
				swordDamageTenThou.animation.addByPrefix('1', '1', 24, false);
				swordDamageTenThou.animation.addByPrefix('2', '2', 24, false);
				swordDamageTenThou.setGraphicSize(Std.int(swordDamageTenThou.width * 2));
				swordDamageTenThou.antialiasing = true;

				heartHealth = new FNFSprite(50, 600);
				heartHealth.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/healthbar');
				heartHealth.animation.addByPrefix('health1', 'health1', 24, false);
				heartHealth.animation.addByPrefix('health2', 'health2', 24, false);
				heartHealth.animation.addByPrefix('health3', 'health3', 24, false);
				heartHealth.animation.addByPrefix('health4', 'health4', 24, false);
				heartHealth.animation.addByPrefix('health5', 'health5', 24, false);
				heartHealth.animation.addByPrefix('health6', 'health6', 24, false);
				heartHealth.animation.addByPrefix('health7', 'health7', 24, false);
				heartHealth.animation.addByPrefix('health8', 'health8', 24, false);
				heartHealth.animation.addByPrefix('health9', 'health9', 24, false);
				heartHealth.antialiasing = true;
				heartHealth.animation.play('health1', true);

				sliceAnim = new FNFSprite(165, 300);
				sliceAnim.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/slice');
				sliceAnim.animation.addByPrefix('slice', 'slice', 24, false);
				sliceAnim.setGraphicSize(Std.int(sliceAnim.width * 0.75));
				sliceAnim.antialiasing = true;
				sliceAnim.updateHitbox();
						
				tHeart = new FNFSprite(190, 345);
				tHeart.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/heart_break');
				tHeart.animation.addByPrefix('die', 'white heart death', 24, false);
				tHeart.antialiasing = true;
				add(tHeart);

				var gHeart:FlxSprite = new FNFSprite(700, 280).loadGraphic(Paths.image('backgrounds/' + curStage + '/bleu_hert'));
				add(gHeart);

				var bHeart:FlxSprite = new FNFSprite(1000, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/red_hert'));
				add(bHeart);
				
			case 'spooky':
				curStage = 'spooky';
				// halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/halloween_bg');

				halloweenBG = new FNFSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

			// isHalloween = true;
			case 'philly':
				curStage = 'philly';

				var bg:FNFSprite = new FNFSprite(-100).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FNFSprite = new FNFSprite(-10).loadGraphic(Paths.image('backgrounds/' + curStage + '/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FNFSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FNFSprite = new FNFSprite(city.x).loadGraphic(Paths.image('backgrounds/' + curStage + '/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FNFSprite = new FNFSprite(-40, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/behindTrain'));
				add(streetBehind);

				phillyTrain = new FNFSprite(2000, 360).loadGraphic(Paths.image('backgrounds/' + curStage + '/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FNFSprite = new FNFSprite().loadGraphic(AssetPaths.win0.png);

				var street:FNFSprite = new FNFSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/' + curStage + '/street'));
				add(street);
			case 'highway':
				curStage = 'highway';
				PlayState.defaultCamZoom = 0.90;

				var skyBG:FNFSprite = new FNFSprite(-120, -50).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FNFSprite = new FNFSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FNFSprite = new FNFSprite(-500, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/limoDrive');

				limo = new FNFSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FNFSprite(-300, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fastCarLol'));
			// loadArray.add(limo);
			case 'mall':
				curStage = 'mall';
				PlayState.defaultCamZoom = 0.80;

				var bg:FNFSprite = new FNFSprite(-1000, -500).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FNFSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FNFSprite = new FNFSprite(-1100, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FNFSprite = new FNFSprite(370, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FNFSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FNFSprite = new FNFSprite(-600, 700).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FNFSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			case 'mallEvil':
				curStage = 'mallEvil';
				var bg:FNFSprite = new FNFSprite(-400, -500).loadGraphic(Paths.image('backgrounds/mall/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FNFSprite = new FNFSprite(300, -300).loadGraphic(Paths.image('backgrounds/mall/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FNFSprite = new FNFSprite(-200, 700).loadGraphic(Paths.image("backgrounds/mall/evilSnow"));
				evilSnow.antialiasing = true;
				add(evilSnow);
			case 'school':
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FNFSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FNFSprite = new FNFSprite(repositionShit, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FNFSprite = new FNFSprite(repositionShit).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FNFSprite = new FNFSprite(repositionShit + 170, 130).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FNFSprite = new FNFSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('backgrounds/' + curStage + '/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FNFSprite = new FNFSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (PlayState.SONG.song.toLowerCase() == 'roses')
					bgGirls.getScared();

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			case 'schoolEvil':
				var posX = 400;
				var posY = 200;
				var bg:FNFSprite = new FNFSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);

			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'antruins':
				gfVersion = 'gf-toriel';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, dad:Character, gf:Character, camPos:FlxPoint, songPlayer2):Void
	{
		switch (songPlayer2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
			/*
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
			}*/

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				dad.x += 50;
				dad.y += 200;
			case 'dummy':
				dad.y += 350;
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;

			// resetFastCar();
			// add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				// var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				// add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'antruins':
				gf.x += 275;
				gf.y -= 200;
				boyfriend.x -= 725;
				dad.x += 1000;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'doorway':
				if ((curBeat == 24 || curBeat == 174) && PlayState.SONG.song.toLowerCase() == 'heartache'){
					doorway_battle.alpha = 1;
					doorway.alpha = 0;
				}
				if (curBeat == 102 && PlayState.SONG.song.toLowerCase() == 'heartache'){
					doorway_battle.alpha = 0;
					doorway.alpha = 1;
				}
				if (curBeat == 216 && PlayState.SONG.song.toLowerCase() == 'heartache'){
					doorway_battle.alpha = 0;
					doorway.alpha = 1;
					if(PlayState.genocideHits > 0 && PlayState.isStoryMode){
						foreground.add(sliceAnim);
						sliceAnim.animation.play('slice');
					}
				}
				if (curBeat == 218 && PlayState.SONG.song.toLowerCase() == 'heartache' && PlayState.isStoryMode){
					if(PlayState.genocideHits > 0){
						foreground.add(heartHealth);
					}
					if(PlayState.genocideHits > 0 && PlayState.genocideHits <= 10){
						remove(sliceAnim);
						swordDamageTotal = PlayState.genocideHits * 43;
						while(swordDamageTotal >= 100){
							swordDamageHuns++;
							swordDamageTotal = swordDamageTotal - 100;
						}
						while(swordDamageTotal >= 10){
							swordDamageTens++;
							swordDamageTotal = swordDamageTotal - 10;
						}
						swordDamageOnes = swordDamageTotal;
						onesString = "" + swordDamageOnes;
						tensString = "" + swordDamageTens;
						hunsString = "" + swordDamageHuns;
						foreground.add(swordDamageOne);
						foreground.add(swordDamageTen);
						if(swordDamageHuns > 0){
							foreground.add(swordDamageHun);
						}
						swordDamageOne.animation.play(onesString);
						swordDamageTen.animation.play(tensString);
						if(swordDamageHuns > 0){
							swordDamageHun.animation.play(hunsString);
						}
					}
					else if(PlayState.genocideHits > 10){
						remove(sliceAnim);
						foreground.add(swordDamageOne);
						foreground.add(swordDamageTen);
						foreground.add(swordDamageHun);
						foreground.add(swordDamageThou);
						foreground.add(swordDamageTenThou);
						swordDamageOne.x = swordDamageOne.x + 115;
						swordDamageTen.x = swordDamageTen.x + 115;
						swordDamageHun.x = swordDamageHun.x + 115;
						swordDamageThou.x = swordDamageThou.x + 115;
						swordDamageTenThou.x = swordDamageTenThou.x + 115;
						swordDamageOne.animation.play("" + FlxG.random.int(0,9));
						swordDamageTen.animation.play("" + FlxG.random.int(0,9));
						swordDamageHun.animation.play("" + FlxG.random.int(0,9));
						swordDamageThou.animation.play("" + FlxG.random.int(0,9));
						swordDamageTenThou.animation.play("" + FlxG.random.int(1,2));
					}
				}
				if (curBeat == 221 && PlayState.SONG.song.toLowerCase() == 'heartache' && PlayState.genocideHits > 0 && PlayState.isStoryMode){
					foreground.remove(swordDamageOne);
					foreground.remove(swordDamageTen);
					if(swordDamageHuns > 0 || PlayState.genocideHits > 10){
						foreground.remove(swordDamageHun);
					}
					if(PlayState.genocideHits > 10){
						foreground.remove(swordDamageThou);
						foreground.remove(swordDamageTenThou);
					}
					foreground.remove(heartHealth);
				}
			case 'ruins':
				froggitJam.dance();
				saveSymbol.dance();
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
