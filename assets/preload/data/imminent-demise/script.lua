function onCreate()


	makeLuaSprite('BendyBG', 'bendy/images/BACKBACKgROUND',-220, -100);
	scaleObject('BendyBG',1,1)
    
	makeLuaSprite('BendyBG2', 'bendy/images/BackgroundwhereDEEZNUTSfitINYOmOUTH', -600, -150);
	scaleObject('BendyBG2',1,1)

	makeLuaSprite('BendyGround', 'bendy/images/MidGrounUTS', -600, -150);

	scaleObject('BendyGround',1,1)

    precacheImage('bendy/images/BACKBACKgROUND')
	precacheImage('bendy/images/BackgroundwhereDEEZNUTSfitINYOmOUTH')

    if not lowQuality then
        makeLuaSprite('Pillar2', 'bendy/images/ForegroundEEZNUTS', 1700, -200);
        setScrollFactor('Pillar2',1.2,1)
        precacheImage('bendy/images/ForegroundEEZNUTS')
    end

end

function onStepHit()
    if curStep == 936 then
        startVideo('bendy/bendy1')
        addLuaSprite('BendyBG',false)
        setProperty('inCutscene',false)
        addLuaSprite('BendyBG2',false)
        addLuaSprite('BendyGround',false)
        removeLuaSprite('BG',true)
        removeLuaSprite('BendySprite',true)
        if not lowQuality then
         removeLuaSprite('Pillar',true)
         addLuaSprite('Pillar2',true)
        end
        setProperty('defaultCamZoom',0.5)
        triggerEvent('Change Character','bf','BF_Bendy_IC_Phase2')
        triggerEvent('Change Character','dad','Bendy_IC')
        removeLuaSprite('Light',true)
    end
    if curStep == 1000 then
        setProperty('boyfriend.x',1250)
        setProperty('boyfriend.y',1205)
        setProperty('dad.x',0)
        setProperty('dad.y',750)
        setProperty('dad.visible',true)
        setProperty('defaultCamZoom',0.5)
    end
end

local allowEndSong = false;
function onEndSong()

  if not allowEndSong and isStoryMode and not seenCutscene then
    startVideo('bendy/2');
    
    allowEndSong = true;

    return Function_Stop;
  end
    return Function_Continue;
end


function onCreate()
    makeLuaSprite('BlackFade','sans/white',0,0)
    setObjectCamera('BlackFade','hud')
    addLuaSprite('BlackFade',true)
    doTweenColor('WhiteToBlack','BlackFade','000000',0.01,'LinearOut')

    setProperty('skipCountdown',true)
    makeLuaSprite('TextIntro','bendy/images/introductionsong1',250,280)   

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
	if not allowCountdown then
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