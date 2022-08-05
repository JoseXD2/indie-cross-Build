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




function opponentNoteHit(id, direction, noteType, isSustainNote)
    cameraShake('camGame', 0.015, 0.1);
    cameraShake('camHud', 0.005, 0.1);
end