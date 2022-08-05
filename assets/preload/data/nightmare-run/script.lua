BfFrames = 0
DadFrames = 0
EnableDadBendyFrames = true
EnableBFBendyFrames = true
ChangeBendyNotes = true
BfMaxFrames = 9
DadMaxFrames = 9

function onGameOver()
    ChangeBendyNotes = false
    EnableBFBendyFrames = false
    EnableDadBendyFrames = false
    setProperty('dad.animation.curAnim.frameRate',24)
    setProperty('boyfriend.animation.curAnim.frameRate',24)
end

function onUpdate(elapsed)
    if getProperty('boyfriend.curCharacter') == 'BF_Bendy_Run' or getProperty('boyfriend.curCharacter') == 'BF_Bendy_Run-Dark' then
     BfFrames = BfFrames + 0.36

    else
        EnableBFBendyFrames = false
    end
    if getProperty('dad.curCharacter') == 'Bendy_Run' or getProperty('dad.curCharacter') == 'Bendy_Run-Dark' then
        DadFrames = DadFrames + 0.36
        EnableDadBendyFrames = true
    else
        EnableDadBendyFrames = false
    end
    if(ChangeBendyNotes) then
        if (curStep > 416 and curStep < 543 or curStep > 1055 and curStep < 1311 or curStep > 1680 and curStep < 1937) then
            for j = 0,getProperty('notes.length') -1 do
                noteType = getPropertyFromGroup('notes', j, 'noteType')

                if (noteType ~= 'BendySplashNote' and noteType ~= 'BendyShadowNote') then
                    setPropertyFromGroup('notes', j, 'texture','bendy/images/BendyNotes')
                end
                if (noteType == 'BendyShadowNote') then
                    setPropertyFromGroup('notes', j, 'texture','bendy/images/BendyShadowNoteDark')
                end
                if (noteType == 'BendySplashNote') then
                    setPropertyFromGroup('notes', j, 'texture','bendy/images/BendySplashNoteDark')
                end
            end
            for i = 0,7 do
                setPropertyFromGroup('strumLineNotes', i, 'texture','bendy/images/BendyNotes')
            end
        end
    end
        
    if (curStep == 543 or curStep == 1311 or curStep == 1937) then
        for j = 0,getProperty('notes.length') -1 do
            if getPropertyFromGroup('notes', j, 'noteType') ~= 'BendySplashNote' and getPropertyFromGroup('notes', j, 'noteType') ~= 'BendyShadowNote' then
                setPropertyFromGroup('notes', j, 'texture','')
            end
            if getPropertyFromGroup('notes', j, 'noteType') == 'BendyShadowNote' then
                setPropertyFromGroup('notes', j, 'texture','bendy/images/BendyShadowNoteAssets')
            end
            if getPropertyFromGroup('notes', j, 'noteType') == 'BendySplashNote' then
                setPropertyFromGroup('notes', j, 'texture','bendy/images/BendySplashNoteAssets')
            end
        end
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'texture','NOTE_assets')
        end
    end


    if (EnableBFBendyFrames == true) then
        setProperty('boyfriend.animation.curAnim.curFrame',math.min(math.floor(BfFrames), BfMaxFrames))
        setProperty('boyfriend.animation.curAnim.frameRate',0)
    end
    if EnableDadBendyFrames then
        setProperty('dad.animation.curAnim.curFrame',math.min(math.floor(DadFrames), DadMaxFrames))
        setProperty('dad.animation.curAnim.frameRate',0)
    end

    if (getProperty('boyfriend.animation.curAnim.name') ~= 'idle-alt') then
        BfMaxFrames = 11
    else
        BfMaxFrames = 9
    end
    if (math.floor(BfFrames) > BfMaxFrames) then
        BfFrames = 0
    end
    if (math.floor(DadFrames) > DadMaxFrames) then
        DadFrames = 0
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if (isSustainNote) then
        setProperty('health', getProperty('health') + 0.01)
    else
        setProperty('health', getProperty('health') + 0.02)
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    cameraShake('camGame', 0.0025, 0.1);
    cameraShake('hud', 0.0025, 0.01);

    if (getProperty('health') > 0.4) then
        if (isSustainNote) then
            setProperty('health', getProperty('health') - 0.0375)
        else
            setProperty('health', getProperty('health') - 0.045)
        end
    end
end


function onCreate()
    makeLuaSprite('BlackFade','sans/white',0,0)
    setObjectCamera('BlackFade','hud')
    addLuaSprite('BlackFade',true)
    doTweenColor('WhiteToBlack','BlackFade','000000',0.01,'LinearOut')

    setProperty('skipCountdown',true)
    setProperty('camGame.zoom', 2)

    makeLuaSprite('TextIntro','bendy/images/introductionsong4',320,280)

    setObjectCamera('TextIntro','hud')
    addLuaSprite('TextIntro',true)

    runTimer('textSongDestroy',2)
    runTimer('doDaZoom', 2)
    CountTextCompleted = false
    scaleEffect = 1;
    alphaEffect = 1;
    Zoomin = false
end

function onUpdate(elapsed)
    scaleEffect = scaleEffect + 0.001

    scaleObject('TextIntro', scaleEffect, scaleEffect)
    setProperty('TextIntro.x', getProperty('TextIntro.x') - 0.25)
    setProperty('TextIntro.y', getProperty('TextIntro.y') - 0.1)

    if (getProperty('camGame.zoom') > 0.75 and Zoomin == true) then
        setProperty('camGame.zoom', getProperty('camGame.zoom') - 0.0075)
    end
    if (getProperty('camGame.zoom') <= 0.75) then
        Zoomin = false
    end

    if (alphaEffect < 1) then
        setProperty('BlackFade.alpha', alphaEffect)
        alphaEffect = alphaEffect - 0.01

    elseif (alphaEffect < 0) then
        removeLuaSprite('TextIntro', false)
        alphaEffect = nil
    end
    setProperty('TextIntro.alpha', alphaEffect)
end

local allowCountdown = false
function onStartCountdown() --pls countdown
	if allowCountdown == false then
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag)
	if (tag == 'textSongDestroy') then
		CountTextCompleted = true
		alphaEffect = alphaEffect - 0.01
        allowCountdown = true
        startCountdown()
    elseif (tag == 'doDaZoom' and Zoomin == false) then
        Zoomin = true
    end
end


function onCreate()
    makeLuaSprite('BlackFade','sans/white',0,0)
    setObjectCamera('BlackFade','hud')
    addLuaSprite('BlackFade',true)
    doTweenColor('WhiteToBlack','BlackFade','000000',0.01,'LinearOut')

    setProperty('skipCountdown',true)
    setProperty('camGame.zoom', 2)

    makeLuaSprite('TextIntro','bendy/images/introductionsong4',320,280)

    setObjectCamera('TextIntro','hud')
    addLuaSprite('TextIntro',true)

    runTimer('textSongDestroy',2)
    runTimer('doDaZoom', 2)
    CountTextCompleted = false
    scaleEffect = 1;
    alphaEffect = 1;
    Zoomin = false
end

function onUpdate(elapsed)
    scaleEffect = scaleEffect + 0.001

    scaleObject('TextIntro', scaleEffect, scaleEffect)
    setProperty('TextIntro.x', getProperty('TextIntro.x') - 0.25)
    setProperty('TextIntro.y', getProperty('TextIntro.y') - 0.1)

    if (getProperty('camGame.zoom') > 0.75 and Zoomin == true) then
        setProperty('camGame.zoom', getProperty('camGame.zoom') - 0.0075)
    end
    if (getProperty('camGame.zoom') <= 0.75) then
        Zoomin = false
    end

    if (alphaEffect < 1) then
        setProperty('BlackFade.alpha', alphaEffect)
        alphaEffect = alphaEffect - 0.01

    elseif (alphaEffect < 0) then
        removeLuaSprite('TextIntro', false)
        alphaEffect = nil
    end
    setProperty('TextIntro.alpha', alphaEffect)
end

local allowCountdown = false
function onStartCountdown() --pls countdown
	if allowCountdown == false then
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag)
	if (tag == 'textSongDestroy') then
		CountTextCompleted = true
		alphaEffect = alphaEffect - 0.01
        allowCountdown = true
        startCountdown()
    elseif (tag == 'doDaZoom' and Zoomin == false) then
        Zoomin = true
    end
end

local allowEndSong = false
function onEndSong()
    if not allowEndSong and isStoryMode and not seenCutscene then
        startVideo('bendy/5')
        allowEndSong = true
        return Function_Stop;
    end
    return Function_Continue;
end