package;

import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * The W.I.P Ending for people who played the mod! 
 */
class EndingState extends MusicBeatSubstate
{
    var blinkingWhite:FlxSprite;

    override function create() 
    {
        if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

        var endingSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('secret_folder/thankyou', 'preload'));
        add(endingSprite);

        blinkingWhite = new FlxSprite(830, 531).makeGraphic(270, 74, FlxColor.WHITE);
        blinkingWhite.visible = false;
        add(blinkingWhite);
        // 830, 531 to 1100, 605
    }

    override function update(elapsed:Float)
    {
        if (controls.ACCEPT)
		{
			FlxFlicker.flicker(blinkingWhite, 1, 0.05, false, true, function(_)
            {
                FlxG.switchState(new MainMenuState());
            });
		}
    }
}