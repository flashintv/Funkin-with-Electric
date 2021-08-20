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
        var endingSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('secretfolder/thankyou', 'shared'));
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
			FlxFlicker.flicker(blinkingWhite, 1, 0.1, false, true, function(_)
            {
                FlxG.switchState(new MainMenuState());
            });
		}
    }
}