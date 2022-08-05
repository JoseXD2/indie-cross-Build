function onCreate()
    InvincibleTime = 0;
	DamageEnable = false;
	DamageEnable2 = false;
	RandomAngle = 0;
	FlipX = 0
	FlipX2 = false
    SansAttack = false
	


    
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'sans/gameovernormal'); --put in mods/music/

	makeAnimatedLuaSprite('ray','sans/Gaster_blasterss',-2500,400);
	scaleObject('ray', 4,4)
	addAnimationByPrefix('ray','Attack1','fefe instance 1',24,false)
	objectPlayAnimation('ray','Attack1',false)

	makeAnimatedLuaSprite('ray2','sans/Gaster_blasterss',-2500,400);
	addAnimationByPrefix('ray2','Attack1','fefe instance 1',24,false)
	scaleObject('ray2', 4,4)
	objectPlayAnimation('ray2','Attack1',false)

	makeLuaSprite('HeartSans','sans/heart',990,850)
	precacheImage('sans/Gaster_blasterss')
	precacheImage('sans/sans/heart')



	SansAttack = false
end

function onUpdate(elapsed)

	if SansAttack == true then

		RandomAngle = math.random(0,30)

		if FlipX == 0 then
			FlipX2 = false
		else
			FlipX2 = true
		end
		
		if SansAttack == true then

			triggerEvent('Camera Follow Pos',getProperty('boyfriend.x') - 340,getProperty('boyfriend.y'))

			if getProperty('HeartSans.alpha') < 1 then
				setProperty('HeartSans.alpha',getProperty('HeartSans.alpha') + 0.02)
			end

			if getProperty('boyfriend.alpha') > 0.5 then
				setProperty('boyfriend.alpha',getProperty('boyfriend.alpha') - 0.02)
			end


			if keyPressed('left') and getProperty('HeartSans.x') >220 then
				setProperty('HeartSans.x',getProperty('HeartSans.x') - 10)
			end

			if keyPressed('right') and getProperty('HeartSans.x') <1660 then
				setProperty('HeartSans.x',getProperty('HeartSans.x') + 10)
			end

			if keyPressed('up') and getProperty('HeartSans.y') >440 then
				setProperty('HeartSans.y',getProperty('HeartSans.y') - 10)
			end

			if keyPressed('down') and getProperty('HeartSans.y') <1110 then
				setProperty('HeartSans.y',getProperty('HeartSans.y') + 10)
			end
			
			if InvincibleTime == 0  then

				if getProperty('HeartSans.y') > (getProperty('ray.y') + 10) and getProperty('HeartSans.y') < (getProperty('ray.y') - 10) + getProperty('ray.height')/2 and DamageEnable == true or getProperty('HeartSans.y') > (getProperty('ray2.y') + 10)  and getProperty('HeartSans.y') < (getProperty('ray2.y')- 10) + getProperty('ray2.height') / 2 and DamageEnable2 == true or objectsOverlap('HeartSans','ray') and DamageEnable == true or objectsOverlap('HeartSans','ray2') and DamageEnable2 == true  then
					InvincibleTime = 200
					playSound('sans/hearthurt',2)
					setProperty('health',getProperty('health') - 1)
				end
			end
		end
    end

	if InvincibleTime > 0 then
		InvincibleTime = InvincibleTime - 1
	end

	if SansAttack == false then
		if getProperty('HeartSans.alpha') > 0 then
			setProperty('HeartSans.alpha',getProperty('HeartSans.alpha') - 0.02)
		end
		if getProperty('boyfriend.alpha') < 1 then
			setProperty('boyfriend.alpha', getProperty('boyfriend.alpha') + 0.02)
		end
	end

	if getProperty('ray.animation.curAnim.finished') == true then
		removeLuaSprite('ray',false)
		
	end

	if getProperty('ray2.animation.curAnim.finished') == true then
		removeLuaSprite('ray2',false)
	end
	if curStep == 1904 then
		for i = 0,7 do
			noteTweenAlpha('noteAlpha'..i, i, 0, 3, 'linear')
		end
	end

	if curStep == 408 or curStep == 662 then
	    AttackEnable = false
		SansAttack = true
		runTimer('SansAttack1',1)
		addLuaSprite('HeartSans',true)
		setProperty('HeartSans.alpha',0)
		
	end

	if curStep == 508 or curStep == 761 then 
		SansAttack = false
		triggerEvent('Camera Follow Pos','','')
	end
end

function onTimerCompleted(tag)
	if SansAttack == true then
		if tag == 'SansAttack1' then
			runTimer('gasSound',1.1)
			addLuaSprite('ray',true)
			objectPlayAnimation('ray','Attack1')
			setProperty('ray.flipX',FlipX2)
			setProperty('ray.y',getProperty('HeartSans.y')- 170)
			setProperty('ray.angle',RandomAngle)
			updateHitbox('ray')
			playSound('sans/readygas')
			runTimer('SansAttack2',1)
			runTimer('SansHitBox',1.1)
			
		end

		if tag == 'SansAttack2' then
			runTimer('gasSound2',1.1)
			addLuaSprite('ray2',true)
			objectPlayAnimation('ray2','Attack1')
			setProperty('ray2.flipX',FlipX2)
			setProperty('ray2.y',getProperty('HeartSans.y')- 170)
			setProperty('ray2.angle',RandomAngle)
			updateHitbox('ray2')
			playSound('sans/readygas')
			runTimer('SansAttack1',2)
			runTimer('SansHitBox2',1.1)
		end
    end

	if tag == 'gasSound' or tag == 'gasSound2' then
		playSound('sans/shootgas')
	end

	if tag == 'SansHitBox' then
		DamageEnable = true
		runTimer('DisableHitBox',0.3)
	end
	
	if tag == 'SansHitBox2' then
		DamageEnable2 = true
		runTimer('DisableHitBox2',0.3)
	end
	if tag == 'DisableHitBox'then
		DamageEnable = false
	end
	if tag == 'DisableHitBox2'then
		DamageEnable2 = false
	end
end

function onStepHit()
	FlipX = math.random(0,1)
end







local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then --Block the first countdown
		startVideo('Sans/3b');
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

local allowEndSong = false
function onEndSong()
	if not allowEndSong and isStoryMode and not seenCutscene then --Block the first countdown
		startVideo('Sans/4b');
		allowEndSong = true;
		return Function_Stop;
	end
	return Function_Continue;
end





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




local attack = 0
local RandomSound = 0
local AttackEnable = true
local Atacado = false
local PuedeAtacar = true
local Bf_AttackSansVisible = false

function onCreate()


   makeAnimatedLuaSprite('SansDodge','characters/sans/Sans_Phase_3',getProperty('dad.x') - 125,getProperty('dad.y') - 20)
   addAnimationByPrefix('SansDodge','Dodge','SansDodge instance 1',24,false)
   objectPlayAnimation('SansDodge','Dodge',false)

   makeAnimatedLuaSprite('AttackButton','IC_Buttons',50,300)
   addAnimationByPrefix('AttackButton','Static','Attack instance 1',24,true)
   addAnimationByPrefix('AttackButton','NA','AttackNA instance 1',30,false)
   objectPlayAnimation('AttackButton','Static',true)
   setObjectCamera('AttackButton','hud')
   addLuaSprite('AttackButton',false)
   scaleObject('AttackButton',0.7,0.7)
   setProperty('AttackButton.alpha',0.5)
   
   makeAnimatedLuaSprite('m', 'Buttons_IC/AttackButtonLeft', 1150, 582.5);
	addAnimationByPrefix('m', 'Attack 1', 'Attack 1', 24, false);
	addAnimationByPrefix('m', 'Attack 2', 'Attack 2', 12, false);
	addLuaSprite('m',false)
	setObjectCamera('m', 'other');


   makeLuaSprite('SansBattle','sans/battle',0,-800)
   scaleObejct('SansBattle',1.55,1.5)        
end

function onUpdate()

    RandomSound = math.random(1,3)


       if PuedeAtacar == true and (getMouseX('camHUD') > 1150 and getMouseX('camHUD') < 1280) and (getMouseY('camHUD') > 582.5 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('x') and AttackEnable == true and getProperty('AttackButton.animation.curAnim.name') == 'Static' then
        PuedeAtacar = false
        objectPlayAnimation('button', 'Attack 2', false); --when the button is Attack 2 
        characterPlayAnim('boyfriend','attack',false)
        setProperty('boyfriend.specialAnim',true)
        objectPlayAnimation('BF_Attack','attack',false)
        playSound('IC/Throw'..RandomSound)
        runTimer('SansDodge',0.3)
        objectPlayAnimation('AttackButton','NA',false)
        setProperty('AttackButton.y',getProperty('AttackButton.y') - 20)
        Bf_AttackSansVisible = 1
        Atacado = true;
        runTimer('dex', 5,1); 
        else
		objectPlayAnimation('button', 'Attack 1', false); --do not do anything
    end
    if Bf_AttackSansVisible == 1 then
        for i = 0,getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', i, 'mustPress') == true then
                if getProperty('boyfriend.animation.curAnim.name') ~= 'attack' then
                    setPropertyFromGroup('notes', i, 'noAnimation', false)
                end
                if getProperty('boyfriend.animation.curAnim.finished') and getProperty('boyfriend.animation.curAnim.name') ~= 'attack' and Bf_AttackSansVisible == 1 then
                    setPropertyFromGroup('notes', i, 'noAnimation', true)
                end
            end
        end
    end

    if getProperty('boyfriend.animation.curAnim.finished') and getProperty('boyfriend.animation.curAnim.name') == 'attack' then
        Bf_AttackSansVisible = 0
    end

    if getProperty('AttackButton.animation.curAnim.finished') == true then
        objectPlayAnimation('AttackButton','Static',true)
        setProperty('AttackButton.y',getProperty('AttackButton.y')+ 20)
    end

    if AttackEnable == false and getProperty('AttackButton.alpha') > 0 then
        setProperty('AttackButton.alpha',getProperty('AttackButton.alpha') - 0.01)
    end
    if AttackEnable == true and getProperty('AttackButton.alpha') < 0.5 then
        setProperty('AttackButton.alpha',getProperty('AttackButton.alpha') + 0.01)
    end

    if BfFly == true then
        AttackEnable = false
        songPos = getSongPosition()
        local currentBeat = (songPos/1000)*(bpm/80)
   
        doTweenY(boyfriendTweenY, 'boyfriend', 700 + 300 *math.sin((currentBeat *1) * math.pi),10)         
    end

    if getProperty('SansDodge.animation.curAnim.finished') then
        removeLuaSprite('SansDodge',false)
        setProperty('dad.visible',true)
    end
    end
    
function onTimerCompleted(tag)
    if tag == 'eyeSound' then
        playSound('sans/eye')
    end
    if tag == 'SansDodge' then
     playSound('sans/dodge')
     setProperty('dad.visible',false)
     addLuaSprite('SansDodge',true)
     setProperty('health',getProperty('health') + 0.5)
     objectPlayAnimation('SansDodge','Dodge',false)
     cameraShake('game','0.01','0.5') 
    end
        if tag == 'dex' then
   PuedeAtacar = true
   end
end

function onStepHit()
    if curStep ==  379 then
    removeLuaSprite('m')
    AttackEnable = false
    PuedeAtacar = false
    end
    if curStep ==  896 then
   makeAnimatedLuaSprite('m', 'Buttons_IC/AttackButtonLeft', 1150, 582.5);
	addAnimationByPrefix('m', 'Attack 1', 'Attack 1', 24, false);
	addAnimationByPrefix('m', 'Attack 2', 'Attack 2', 12, false);
	addLuaSprite('m',false)
	setObjectCamera('m', 'other');
    AttackEnable = true
    PuedeAtacar = true
    end
    if curStep ==  1146 then
    removeLuaSprite('m')
    AttackEnable = false
    PuedeAtacar = false
    end
        if curStep ==  1408 then
    makeAnimatedLuaSprite('m', 'Buttons_IC/AttackButtonLeft', 1150, 582.5);
	addAnimationByPrefix('m', 'Attack 1', 'Attack 1', 24, false);
	addAnimationByPrefix('m', 'Attack 2', 'Attack 2', 12, false);
	addLuaSprite('m',false)
	setObjectCamera('m', 'other');
    AttackEnable = true
    PuedeAtacar = true
    end
end
  