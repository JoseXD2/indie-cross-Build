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



state = true;
shouldAdd = true;

function onUpdate(elapsed)
	if (getMouseX('camHUD') > 990 and getMouseX('camHUD') < 1090) and (getMouseY('camHUD') > 582.5 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('w') then
		objectPlayAnimation('a2', 'Attack 2', false); --when the a2 is Attack 2 
	else
		objectPlayAnimation('a2', 'Attack 1', false); --do not do anything
	end
end

function onCreate()  --random shit lol
	makeAnimatedLuaSprite('a2', 'Buttons_IC/ca', 990, 582.5);
	addAnimationByPrefix('a2', 'Attack 1', 'Attack 1', 24, false);
	addAnimationByPrefix('a2', 'Attack 2', 'Attack 2', 12, false);
	addLuaSprite('a2', false);
	setObjectCamera('a2', 'other');
end

function onCreate(elapsed)

    makeAnimatedLuaSprite('icon-nightmare','icons/icon-nightmare-bendy(animated)',getProperty('iconP2.x') - 50,getProperty('iconP2.y') - 70)
    addAnimationByPrefix('icon-nightmare','Normal','nightmare bendy normal',24,true)
    addAnimationByPrefix('icon-nightmare','Losing','loss',24,true)
    objectPlayAnimation('icon-nightmare','Normal',true)
    setObjectCamera('icon-nightmare','hud')
    addLuaSprite('icon-nightmare',true)
    setProperty('iconP2.alpha',0)
end



function onUpdate(elapsed)
    setProperty('icon-nightmare.x',getProperty('iconP2.x'))
    setProperty('icon-nightmare.y',getProperty('iconP2.y'))
end

function onCreate()
    makeAnimatedLuaSprite('NM-Bendy-Jumpscare','NightmareSongs/NightmareJumpscares03',0,-490)
    setProperty('NM-Bendy-Jumpscare.alpha',0)
    addAnimationByPrefix('NM-Bendy-Jumpscare','Boo','Emmi instance',24,false)
    scaleObject('NM-Bendy-Jumpscare',0.7,0.7)
    setObjectCamera('NM-Bendy-Jumpscare','other')
    addLuaSprite('NM-Bendy-Jumpscare',true)

    makeAnimatedLuaSprite('Static','NightmareSongs/static',0,0)
    scaleObject('Static',1.2,1.2)
    addAnimationByPrefix('Static','StaticAnim','static',30,true)
    setObjectCamera('Static','other')

end

function onUpdate()
    if curStep == 3965 then
        characterPlayAnim('dad','Bye',true)
        setProperty('dad.specialAnim',true)
    end
    if curStep > 3965 then 
        if getProperty('dad.animation.curAnim.name') == 'Bye' and getProperty('dad.animation.curAnim.finished') == true then
            setProperty('dad.visible',false)
        end
    end
    if curStep > 3980 and getProperty('NM-Bendy-Jumpscare.animation.curAnim.finished') == true then
        removeLuaSprite('NM-Bendy-Jumpscare',true)
        addLuaSprite('Static',true)
    end
end

function onStepHit()
    if curStep == 3980 then
        playSound('bendy/BendyGameOver')
        setProperty('NM-Bendy-Jumpscare.alpha',1)
        objectPlayAnimation('NM-Bendy-Jumpscare','Boo',true)
    end
end


function onCreate()
    

    makeLuaSprite('BlackFade','sans/white',0,0)
    setObjectCamera('BlackFade','hud')
    addLuaSprite('BlackFade',true)
    doTweenColor('WhiteToBlack','BlackFade','000000',0.01,'LinearOut')


    setProperty('skipCountdown',true)
    makeLuaSprite('TextIntro','bendy/images/introductiondespair',320,280)

    setObjectCamera('TextIntro','hud')
    addLuaSprite('TextIntro',true)

    runTimer('textSongDestroy',2)
    CountTextCompleted = false
    scaleEffect = 1;
    alphaEffect = 1;
end

function onUpdate()
     scaleEffect = scaleEffect + 0.001
     scaleObject('TextIntro',scaleEffect,scaleEffect)
     setProperty('TextIntro.x',getProperty('TextIntro.x') - 0.25)
     setProperty('TextIntro.y',getProperty('TextIntro.y') - 0.1)

        if alphaEffect < 1 then
         setProperty('BlackFade.alpha',alphaEffect)
         alphaEffect = alphaEffect - 0.01
        end
        if alphaEffect < 0 then
         removeLuaSprite('TextIntro',false)
         alphaEffect = null
        end
    setProperty('TextIntro.alpha',alphaEffect)
end

local allowCountdown = false
function onStartCountdown() --pls countdown
	if allowCountdown == false then
		return Function_Stop;
	end
 
	return Function_Continue;
end

function onTimerCompleted(tag)
	if tag == 'textSongDestroy' then
		CountTextCompleted = true
		alphaEffect = alphaEffect - 0.01
        allowCountdown = true
        startCountdown()
	end
end

function onUpdate()
    for i = 0, getProperty('unspawnNotes.length')-1 do
        --Check if the note is an Instakill Note
        if curStep > 1296 then
            if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'BendySplashNote' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'bendy/images/BendySplashNoteDark');--Change texture
            end
            if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'BendyShadowNote' then
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'bendy/images/BendyShadowNoteDark');--Change texture
            end
        end
    end
end

function onCreate()
    setProperty('dad.visible', false)
end

function onStepHit()
    if curStep == 48 then
        setProperty('dad.visible',true)
        characterPlayAnim('dad','Intro',false)
        setProperty('dad.specialAnim',true)
        playSound('bendy/nmbendy_land')
        cameraShake('game',0.06,0.3)
    end
end

function opponentNoteHit()
    cameraShake('game',0.02,0.1)
    cameraShake('hud',0.01,0.1)
end
