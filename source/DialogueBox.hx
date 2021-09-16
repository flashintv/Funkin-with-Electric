package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	// Cutscene backgrounds 
	var backgroundBlack:FlxSprite;
	var backgroundOne:FlxSprite;
	var backgroundTwo:FlxSprite;
	var backgroundThr:FlxSprite;
	var backgroundFou:FlxSprite;

	// Unknown portrait
	var unknownPortrait:FlxSprite;

	// Character portraits
	var portraitElectric:FlxSprite;
	var portraitConfused:FlxSprite;
	var portraitConfident:FlxSprite;
	var portraitNervous:FlxSprite;
	var portraitCorrupt:FlxSprite;
	var portraitMad:FlxSprite;
	var portraitAngry:FlxSprite;
	var portraitBF:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
		box.animation.addByPrefix('leBronJames', 'lebronjames', 24, true);
		box.width = 200;
		box.height = 200;
		box.x = -100;
		box.y = 375;

		this.dialogueList = dialogueList;

		portraitElectric = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/normalElectric', 'shared'));
		portraitElectric.updateHitbox();
		portraitElectric.scrollFactor.set();
		add(portraitElectric);
		portraitElectric.alpha = 0;

		portraitConfused = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/confusedElectric', 'shared'));
		portraitConfused.updateHitbox();
		portraitConfused.scrollFactor.set();
		add(portraitConfused);
		portraitConfused.alpha = 0;

		portraitConfident = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/confidentElectric', 'shared'));
		portraitConfident.updateHitbox();
		portraitConfident.scrollFactor.set();
		add(portraitConfident);
		portraitConfident.alpha = 0;

		portraitNervous = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/nervousElectric', 'shared'));
		portraitNervous.updateHitbox();
		portraitNervous.scrollFactor.set();
		add(portraitNervous);
		portraitNervous.alpha = 0;

		portraitAngry = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/angryElectric', 'shared'));
		portraitAngry.updateHitbox();
		portraitAngry.scrollFactor.set();
		add(portraitAngry);
		portraitAngry.alpha = 0;

		portraitMad = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/madElectric', 'shared'));
		portraitMad.updateHitbox();
		portraitMad.scrollFactor.set();
		add(portraitMad);
		portraitMad.alpha = 0;

		portraitCorrupt = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/corruptElectric', 'shared'));
		portraitCorrupt.updateHitbox();
		portraitCorrupt.scrollFactor.set();
		add(portraitCorrupt);
		portraitCorrupt.alpha = 0;

		portraitBF = new FlxSprite(730, 210).loadGraphic(Paths.image('portraits/bfPortrait', 'shared'));
		portraitBF.updateHitbox();
		portraitBF.scrollFactor.set();
		add(portraitBF);
		portraitBF.alpha = 0;

		if (PlayState.SONG.song.toLowerCase() == 'trybolty')
		{
			backgroundBlack = new FlxSprite(0, 0).makeGraphic(1280, 768, FlxColor.BLACK);
			add(backgroundBlack);
			backgroundBlack.screenCenter();
			backgroundBlack.alpha = 0;

			backgroundOne = new FlxSprite(0, 0).loadGraphic(Paths.image('CutsceneBGs/bg1', 'electricWeek'));
			backgroundOne.setGraphicSize(1280, 768);
			add(backgroundOne);
			backgroundOne.screenCenter();
			backgroundOne.alpha = 0;

			backgroundTwo = new FlxSprite(0, 0).loadGraphic(Paths.image('CutsceneBGs/bg2', 'electricWeek'));
			backgroundTwo.setGraphicSize(1280, 768);
			add(backgroundTwo);
			backgroundTwo.screenCenter();
			backgroundTwo.alpha = 0;

			backgroundThr = new FlxSprite(0, 0).loadGraphic(Paths.image('CutsceneBGs/bg3', 'electricWeek'));
			backgroundThr.setGraphicSize(1280, 768);
			add(backgroundThr);
			backgroundThr.screenCenter();
			backgroundThr.alpha = 0;

			backgroundFou = new FlxSprite(0, 0).loadGraphic(Paths.image('CutsceneBGs/bg4', 'electricWeek'));
			backgroundFou.setGraphicSize(1280, 768);
			add(backgroundFou);
			backgroundFou.screenCenter();
			backgroundFou.alpha = 0;

			unknownPortrait = new FlxSprite(110, 330).loadGraphic(Paths.image('portraits/unknownPortrait', 'shared'));
			add(unknownPortrait);
			unknownPortrait.alpha = 0;
		}

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		box.flipX = true;

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitElectric.alpha -= 1 / 5;
						portraitConfused.alpha -= 1 / 5;
						portraitConfident.alpha -= 1 / 5;
						portraitNervous.alpha -= 1 / 5;
						portraitCorrupt.alpha -= 1 / 5;
						portraitAngry.alpha -= 1 / 5;
						portraitMad.alpha -= 1 / 5;
						portraitBF.alpha -= 1 / 5;
						unknownPortrait.alpha -= 1 / 5;
						backgroundBlack.alpha -= 1 / 5;
						backgroundOne.alpha -= 1 / 5;
						backgroundTwo.alpha -= 1 / 5;
						backgroundThr.alpha -= 1 / 5;
						backgroundFou.alpha -= 1 / 5;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		if (PlayState.SONG.song.toLowerCase() != 'trybolty' || (PlayState.SONG.song.toLowerCase() == 'trybolty' && curBackground == 'default'))
		{
			switch (curCharacter) // TODO: could've done just for members so it does it for me but i guess fuck me
			{
				case 'corrupt':
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitElectric.alpha = 0;
					portraitBF.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitConfused.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = true;
					if (portraitCorrupt.alpha == 0)
					{
						portraitCorrupt.alpha = 1;
					}
				case 'confused':
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitElectric.alpha = 0;
					portraitBF.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = true;
					if (portraitConfused.alpha == 0)
					{
						portraitConfused.alpha = 1;
					}
				case 'confident':
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitElectric.alpha = 0;
					portraitBF.alpha = 0;
					portraitConfused.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = true;
					if (portraitConfident.alpha == 0)
					{
						portraitConfident.alpha = 1;
					}
				case 'nervous':
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitElectric.alpha = 0;
					portraitBF.alpha = 0;
					portraitConfident.alpha = 0;
					portraitConfused.alpha = 0;
					portraitCorrupt.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = true;
					if (portraitNervous.alpha == 0)
					{
						portraitNervous.alpha = 1;
					}
				case 'emp':
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitBF.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = true;
					if (portraitElectric.alpha == 0)
					{
						portraitElectric.alpha = 1;
					}
				case 'angry':
					portraitConfused.alpha = 0;
					portraitMad.alpha = 0;
					portraitElectric.alpha = 0;
					portraitBF.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = true;
					if (portraitAngry.alpha == 0)
					{
						portraitAngry.alpha = 1;
					}
				case 'mad':
					portraitAngry.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfused.alpha = 0;
					portraitBF.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = true;
					if (portraitMad.alpha == 0)
					{
						portraitMad.alpha = 1;
					}
				case 'bf':
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					unknownPortrait.alpha = 0;
					box.flipX = false;
					if (portraitBF.alpha == 0)
					{
						portraitBF.alpha = 1;
					}
				case '???' | 'unknown':
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					portraitBF.alpha = 0;
					unknownPortrait.alpha = 0;
					if (unknownPortrait.alpha == 0)
					{
						unknownPortrait.alpha = 1;
					}
			}
		}
		else
		{
			switch (curBackground)
			{
				case 'bg1':
					box.animation.play('leBronJames', true);
					// Backgrounds
					backgroundFou.alpha = 0;
					backgroundTwo.alpha = 0;
					backgroundThr.alpha = 0;
					backgroundBlack.alpha = 0;

					// Characters
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					portraitBF.alpha = 0;
					unknownPortrait.alpha = 0;
					if (backgroundOne.alpha == 0)
					{
						backgroundOne.alpha = 1;
					}
				case 'bg2':
					box.animation.play('leBronJames', true);
					// Backgrounds
					backgroundOne.alpha = 0;
					backgroundFou.alpha = 0;
					backgroundThr.alpha = 0;
					backgroundBlack.alpha = 0;

					// Characters
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					portraitBF.alpha = 0;
					unknownPortrait.alpha = 0;
					if (backgroundTwo.alpha == 0)
					{
						backgroundTwo.alpha = 1;
					}
				case 'bg3':
					box.animation.play('leBronJames', true);
					// Backgrounds
					backgroundOne.alpha = 0;
					backgroundTwo.alpha = 0;
					backgroundFou.alpha = 0;
					backgroundBlack.alpha = 0;

					// Characters
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					portraitBF.alpha = 0;
					unknownPortrait.alpha = 0;
					if (backgroundThr.alpha == 0)
					{
						backgroundThr.alpha = 1;
					}
				case 'bg4':
					box.animation.play('leBronJames', true);
					// Backgrounds
					backgroundOne.alpha = 0;
					backgroundTwo.alpha = 0;
					backgroundThr.alpha = 0;
					backgroundBlack.alpha = 0;

					// Characters
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					portraitBF.alpha = 0;
					unknownPortrait.alpha = 0;
					if (backgroundFou.alpha == 0)
					{
						backgroundFou.alpha = 1;
					}
				case 'default':
					box.animation.play('leBronJames', true);
					backgroundOne.alpha = 0;
					backgroundTwo.alpha = 0;
					backgroundThr.alpha = 0;
					backgroundFou.alpha = 0;

					// Characters
					portraitAngry.alpha = 0;
					portraitMad.alpha = 0;
					portraitConfused.alpha = 0;
					portraitElectric.alpha = 0;
					portraitConfident.alpha = 0;
					portraitNervous.alpha = 0;
					portraitCorrupt.alpha = 0;
					portraitBF.alpha = 0;
					unknownPortrait.alpha = 0;
					if (backgroundBlack.alpha == 0)
					{
						backgroundBlack.alpha = 1;
					}
				default:
					box.animation.play('normal', true);
					backgroundOne.alpha = 0;
					backgroundTwo.alpha = 0;
					backgroundThr.alpha = 0;
					backgroundFou.alpha = 0;
					backgroundBlack.alpha = 0;
			}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		var splitChar:Array<String> = splitName[1].split("|");
		curCharacter = splitChar[0];
		curBackground = splitChar[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}

	var curBackground:String = "";
}
