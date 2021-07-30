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

	var portraitElectric:FlxSprite;
	var portraitConfused:FlxSprite;
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
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'pnc' | 'volt' | 'trybolty':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitElectric = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/electricElectric', 'shared'));
		// portraitElectric.setGraphicSize(Std.int(portraitElectric.width * PlayState.daPixelZoom * 0.9));
		portraitElectric.updateHitbox();
		portraitElectric.scrollFactor.set();
		add(portraitElectric);
		portraitElectric.visible = false;

		portraitConfused = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/confusedElectric', 'shared'));
		// portraitConfused.setGraphicSize(Std.int(portraitConfused.width * PlayState.daPixelZoom * 0.9));
		portraitConfused.updateHitbox();
		portraitConfused.scrollFactor.set();
		add(portraitConfused);
		portraitConfused.visible = false;

		portraitAngry = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/angryElectric', 'shared'));
		// portraitAngry.setGraphicSize(Std.int(portraitAngry.width * PlayState.daPixelZoom * 0.9));
		portraitAngry.updateHitbox();
		portraitAngry.scrollFactor.set();
		add(portraitAngry);
		portraitAngry.visible = false;

		portraitMad = new FlxSprite(-20, 80).loadGraphic(Paths.image('portraits/madElectric', 'shared'));
		// portraitMad.setGraphicSize(Std.int(portraitMad.width * PlayState.daPixelZoom * 0.9));
		portraitMad.updateHitbox();
		portraitMad.scrollFactor.set();
		add(portraitMad);
		portraitMad.visible = false;

		portraitBF = new FlxSprite(730, 210).loadGraphic(Paths.image('portraits/bfPortrait', 'shared'));
		// portraitBF.setGraphicSize(Std.int(portraitBF.width * PlayState.daPixelZoom * 0.9));
		portraitBF.updateHitbox();
		portraitBF.scrollFactor.set();
		add(portraitBF);
		portraitBF.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

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

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
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
						portraitElectric.visible = false;
						portraitConfused.visible = false;
						portraitAngry.visible = false;
						portraitMad.visible = false;
						portraitBF.visible = false;
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

		switch (curCharacter)
		{
			case 'confused':
				portraitAngry.visible = false;
				portraitMad.visible = false;
				portraitElectric.visible = false;
				portraitBF.visible = false;
				box.flipX = true;
				if (!portraitConfused.visible)
				{
					portraitConfused.visible = true;
					// portraitConfused.animation.play('enter');
				}
			case 'emp':
				portraitAngry.visible = false;
				portraitMad.visible = false;
				portraitConfused.visible = false;
				portraitBF.visible = false;
				box.flipX = true;
				if (!portraitElectric.visible)
				{
					portraitElectric.visible = true;
					// portraitElectric.animation.play('enter');
				}
			case 'angry':
				portraitConfused.visible = false;
				portraitMad.visible = false;
				portraitElectric.visible = false;
				portraitBF.visible = false;
				box.flipX = true;
				if (!portraitAngry.visible)
				{
					portraitAngry.visible = true;
					// portraitAngry.animation.play('enter');
				}
			case 'mad':
				portraitAngry.visible = false;
				portraitElectric.visible = false;
				portraitConfused.visible = false;
				portraitBF.visible = false;
				box.flipX = true;
				if (!portraitMad.visible)
				{
					portraitMad.visible = true;
					// portraitMad.animation.play('enter');
				}
			case 'bf':
				portraitAngry.visible = false;
				portraitMad.visible = false;
				portraitConfused.visible = false;
				portraitElectric.visible = false;
				box.flipX = false;
				if (!portraitBF.visible)
				{
					portraitBF.visible = true;
					// portraitBF.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
