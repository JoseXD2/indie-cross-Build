state = true;
shouldAdd = true;

function onCreate()
    makeAnimatedLuaSprite('a', 'Buttons_IC/DodgeButtonMobile', 5, 600);
	addAnimationByPrefix('a', 'Dodge 1', 'Dodge 1', 24, false);
	addAnimationByPrefix('a', 'Dodge 2', 'Dodge 2', 12, false);
	addLuaSprite('a', false);
	setObjectCamera('a', 'other');

end

function onUpdate(elapsed)
                if (getMouseX('camHUD') > 5 and getMouseX('camHUD') < 132) and (getMouseY('camHUD') > 600 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('z') then
			objectPlayAnimation('a', 'Dodge 2', false); --when the a is Dodge 2 
	else
		objectPlayAnimation('a', 'Dodge 1', false); --do not do anything
	end
end

local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then --Block the first countdown
		startVideo('Sans/1');
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

local allowEndSong = false
function onEndSong()
	if not allowEndSong and isStoryMode and not seenCutscene then --Block the first countdown
		startVideo('Sans/2');
		allowEndSong = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onCreate()
        makeLuaSprite('Black?','',0,0)
        setObjectCamera('Black?','other')
        makeGraphic('Black?',screenWidth,screenHeight,'646464')
        setProperty('Black?.alpha',0)
        setBlendMode('Black?','SUBTRACT')
        addLuaSprite('Black?',true)
end

function onStepHit()

    if curStep == 16 then
        doTweenAlpha('BlackLightEffect', 'Black?', 0.5, 2,'quardInOut')
    end

    if curStep == 159 then
        doTweenAlpha('BlackLightEffect', 'Black?', 0, 2,'quardInOut')
    end
    if curStep > 159 and getProperty('Black?.alpha') <= 0 then
        removeLuaSprite('Black?',true)
        removeLuaSprite('a')
    end
end