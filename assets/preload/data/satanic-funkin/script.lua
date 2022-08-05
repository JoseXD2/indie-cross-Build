function onCreate()
    precacheImage('characters/cuphead/Devil')
end

function onUpdate()
    if getProperty('dad.curCharacter') == 'Devil_Cup_Intro' and getProperty('dad.animation.curAnim.finished') == true then
        triggerEvent('Change Character','dad','Devil_Cup')
    end
end

function onCreate()
    setProperty('skipCountdown', true)

    

    setPropertyFromClass('GameOverSubstate', 'characterName', 'BF_Ghost'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'cup/CupDeath'); --put in mods/sounds/

    makeAnimatedLuaSprite('CupTitle','cup/ready_wallop',-350,0)
    setLuaSpriteScrollFactor('CupTitle',0,0)
    addAnimationByPrefix('CupTitle','Ready?','Ready? WALLOP!',24,false)
    objectPlayAnimation('CupTitle','Ready?',false)
    scaleObject('CupTitle',0.8,0.8)
    setObjectCamera('CupTitle','hud')


   
    if not lowQuality then
        makeAnimatedLuaSprite('CupThing','cup/the_thing2.0',-345,-200)
        setLuaSpriteScrollFactor('CupThing',0,0)
        addAnimationByPrefix('CupThing','BOO','BOO instance 1',20,false)
        objectPlayAnimation('CupThing','BOO',false)
        scaleObject('CupThing',1.6,1.6)
        addLuaSprite('CupThing',true)
        setObjectCamera('CupThing', 'hud');
    end
    runTimer('CupReady',0.5)
end

function onUpdate(elapsed)   
 Random = math.random(0,1)

    if getProperty('CupTitle.animation.curAnim.finished') == true then
        removeLuaSprite('CupTitle',true)
    end

    if getProperty('CupThing.animation.curAnim.finished') == true then
        removeLuaSprite('CupThing',true)
    end
end


function onTimerCompleted(tag, loops, loopsLeft)

    if tag == 'CupReady' then
		if Random == 0 then
			playSound('cup/intros/angry/0')
        end
		if Random == 1 then
			playSound('cup/intros/angry/1')
		end
		addLuaSprite('CupTitle',true)
	end
end


function onCreate()
    GameOverActive = false
    enableEnd = false
    GameOverState = 0
    songPositionCup = getSongPosition()
    CupSelection = 0
    AlphaCupEffect = 1

    setPropertyFromClass('GameOverSubstate', 'characterName', 'BF_Ghost'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'Cup/CupDeath'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music

    makeAnimatedLuaSprite('BF_Ghost','cup/BF_Ghost',getProperty('boyfriend.x'),getProperty('boyfriend.y'))
    addAnimationByPrefix('BF_Ghost','Death','thrtr instance 1',24,true)

    makeLuaSprite('You re dead','cup/death',200,300)
    setObjectCamera('You re dead','hud')
    scaleObject('You re dead',0.9,0.9)

makeAnimatedLuaSprite('b', 'Buttons_IC/A', 1150, 582.5);
	addAnimationByPrefix('b', 'Attack 1', 'Attack 1', 24, false);
	addAnimationByPrefix('b', 'Attack 2', 'Attack 2', 12, false);
	setObjectCamera('b', 'other');    
    

    makeLuaSprite('DeathCard','cup/devil_death',450,100)
    setObjectCamera('DeathCard','hud')
    scaleObject('DeathCard',0.7,0.7)
    setProperty('DeathCard.angle',200)
    setProperty('DeathCard.alpha',0)


    makeAnimatedLuaSprite('CupExitButton','cup/buttons',getProperty('DeathCard.x') + 155,getProperty('DeathCard.y') + 385)
    addAnimationByPrefix('CupExitButton','Normal','menu basic',24,true)
    addAnimationByPrefix('CupExitButton','Selected','menu white',24,true)
    setObjectCamera('CupExitButton','hud')

    makeAnimatedLuaSprite('CupRetryButton','cup/buttons',getProperty('DeathCard.x') + 200,getProperty('DeathCard.y') + 320)
    addAnimationByPrefix('CupRetryButton','Selected','retry white',24,true)
    addAnimationByPrefix('CupRetryButton','Normal','retry basic',24,true)

    setObjectCamera('CupRetryButton','hud')

    DadFrameCup = 0
end
function onGameOver()
    if not GameOverActive and not enableEnd then
     setPropertyFromClass('PlayState', 'instance.vocals.volume', 0)
     playSound('cup/CupDeath')
     setProperty('boyfriend.visible',false)
     addLuaSprite('BF_Ghost',true)
     removeLuaSprite('button')
     removeLuaSprite('a')
     addLuaSprite('b', false)
     addLuaSprite('You re dead',true)
     runTimer('GameOverText',2)
     GameOverActive = true
     addLuaSprite('DeathCard',true)
     addLuaSprite('CupExitButton',true)
     addLuaSprite('CupRetryButton',true)
     setProperty('boyfriend.stunned', true)
     setProperty('dad.stunned', true)
     setPropertyFromClass('PlayState', 'instance.vocals.volume', 0)
     setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
     setPropertyFromClass('PlayState', 'instance.generatedMusic', false)
    end
    return Function_Stop;
end

function onPause()
    if GameOverActive then
        return Function_Stop
    end
end
function onEndSong()
    if GameOverActive and not enableSong then
     return Function_Stop;
    end
    return Function_Continue;
end


function onUpdate(el)
    
    setProperty('CupExitButton.angle',getProperty('DeathCard.angle'))
    setProperty('CupRetryButton.angle',getProperty('DeathCard.angle'))
    setProperty('CupExitButton.alpha',getProperty('DeathCard.alpha'))
    setProperty('CupRetryButton.alpha',getProperty('DeathCard.alpha'))
    for i = 0, getProperty('notes.length')-1 do
        if GameOverActive then
         setPropertyFromGroup('notes', i, 'active', false)
         setPropertyFromGroup('notes', i, 'canBeHit', false)
        end
    end
    for e = 0, getProperty('eventNotes.length') do
        if GameOverActive then
          removeFromGroup('eventNotes', i, 'active', false)
          removeFromGroup('eventNotes', i, 'canBeHit', false)
        end
    end

    if GameOverActive then
        setProperty('dad.animation.curAnim.frameRate',0)
        cameraSetTarget('boyfriend')
        setProperty('BF_Ghost.y',getProperty('BF_Ghost.y') - 4)
    end

    if getProperty('You re dead.alpha') < 1 then
        setProperty('You re dead.alpha',getProperty('You re dead.alpha') - 0.05)
    end

    if GameOverState == 1 then
        AlphaCupEffect = AlphaCupEffect - 0.05
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'alpha', AlphaCupEffect)
            setPropertyFromGroup('opponentStrums', i, 'alpha', AlphaCupEffect)
        end
        for j = 0, getProperty('notes.length') do
            setPropertyFromGroup('notes', j, 'alpha', AlphaCupEffect)
        end

        if getProperty('DeathCard.alpha') < 1 then
            setProperty('DeathCard.alpha',getProperty('DeathCard.alpha') + 0.05)
        end
        setProperty('timeTxt.alpha',AlphaCupEffect)
        setProperty('scoreTxt.alpha',AlphaCupEffect)
        setProperty('iconP1.alpha',AlphaCupEffect)
        setProperty('iconP2.alpha',AlphaCupEffect)
        setProperty('healthBar.alpha',AlphaCupEffect)
    end

    if GameOverState == 2 then
        
        if CupSelection == 0 then
            objectPlayAnimation('CupRetryButton','Selected')
            objectPlayAnimation('CupExitButton','Normal')
            if keyJustPressed('up') or keyJustPressed('down') then
                playSound('cup/select')
                CupSelection = 1
            end
    
            if (getMouseX('camHUD') > 1150 and getMouseX('camHUD') < 1280) and (getMouseY('camHUD') > 582.5 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('x') then
                enableEnd = true
                playSound('cup/select')
                loadSong(songName, difficulty)
            end
        else
            objectPlayAnimation('CupRetryButton','Normal')
            objectPlayAnimation('CupExitButton','Selected')
            if keyJustPressed('up') or keyJustPressed('down') then
                playSound('cup/select')
                CupSelection = 0
            end
            if (getMouseX('camHUD') > 1150 and getMouseX('camHUD') < 1280) and (getMouseY('camHUD') > 582.5 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('x') then
                enableEnd = true
                GameOverActive = false
                endSong()
                playSound('cup/select')
            end
        end
    end
   

end



function onTweenCompleted(tween)
    if tween == 'DeathCardAngle' then
        GameOverState = 2
    end
end

function onTimerCompleted(tag)
    if tag == 'GameOverText' then

        doTweenAngle('DeathCardAngle','DeathCard',340,0.7,'QuartOut')
        setProperty('You re dead.alpha',getProperty('You re dead.alpha') - 0.05)
        runTimer('GameOverBar',0.5)
        GameOverState = 1
    end
end

function lerp(a, b, ratio)
    return math.floor(a + ratio * (b - a))
end

function onCreatePost()
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'texture', 'cup/Cuphead_NOTE_assets')
    end

end
function onUpdate()
    for j = 0,getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes', j, 'noteType') == '' then
            setPropertyFromGroup('notes', j,'texture','cup/Cuphead_NOTE_assets')
        end
    end
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