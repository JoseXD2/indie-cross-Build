
state = true;
shouldAdd = true;

function onUpdate(elapsed)
	if (getMouseX('camHUD') > 1150 and getMouseX('camHUD') < 1280) and (getMouseY('camHUD') > 582.5 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('x') then
		objectPlayAnimation('button', 'Attack 2', false); --when the button is Attack 2 
	else
		objectPlayAnimation('button', 'Attack 1', false); --do not do anything
	end
end

function onCreate()  --random shit lol
	makeAnimatedLuaSprite('button', 'Buttons_IC/AttackButtonLeft', 1150, 582.5);
	addAnimationByPrefix('button', 'Attack 1', 'Attack 1', 24, false);
	addAnimationByPrefix('button', 'Attack 2', 'Attack 2', 12, false);
	addLuaSprite('button', false);
	setObjectCamera('button', 'other');
end

function onStepHit()
    if curStep ==  379 and curStep == 1146 then
    AttackEnable = false
    end
    if curStep == 0 and curStep ==  896 and curStep == 1408 then
    AttackEnable = true
    end
end