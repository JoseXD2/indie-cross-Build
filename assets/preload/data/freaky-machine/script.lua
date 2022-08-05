function onCreate()

    makeLuaSprite('Black','sans/white',0,0)
    setObjectCamera('Black','hud')
    addLuaSprite('Black',true)
    doTweenColor('WhiteToBlackBendy','Black','000000',0.01,'linear')
    
    addLuaSprite('Black',true)

end

function onUpdate(elapsed)

    if curStep < 682 then
        setProperty('Black.alpha',0)
    end
    
    if curStep >= 683 and curStep < 704 then
        setProperty('Black.alpha',getProperty('Black.alpha') + 0.02)
    end
    if curStep == 704 then
        triggerEvent('Change Character','dad','Bendy_DAPhase2')
        removeLuaSprite('Black',true)
    end

    if curStep > 704 then
         songPos = getSongPosition()
         local currentBeat = (songPos/1000)*(bpm/80)
         doTweenY(dadTweenY, 'dad', 50 + 50*math.sin((currentBeat*1)*math.pi),0.5)
    end

end

function onCreate()
    setTextFont('scoreTxt', 'BendyICFont.ttf')
    setTextFont('timeTxt','BendyICFont.ttf')
end

function onCreate()

	makeLuaSprite('BendyHealthBar', 'health_IC/bendyhealthbar', 0, 0)
	setObjectCamera('BendyHealthBar', 'hud')
	
	addLuaSprite('BendyHealthBar', true)
end

function onCreatePost()
    setProperty('BendyHealthBar.alpha',  getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))

    setProperty('BendyHealthBar.x', getProperty('healthBar.x') - 25)

    setProperty('BendyHealthBar.angle', getProperty('healthBar.angle'))
    setProperty('BendyHealthBar.y', getProperty('healthBar.y') - 87)
    setObjectOrder('BendyHealthBar', 4)
	setProperty('healthBarBG.visible', false)
	setProperty('healthBar.scale.y', 2)
	setObjectOrder('BendyHealthBar', 4)
	setObjectOrder('healthBar', 3)
	setObjectOrder('healthBarBG', 2)
	setProperty('healthBar.x', getProperty('healthBar.x') + 20)
	setProperty('health.y', getProperty('healthBar.y') + 10)

end


function onCreate()
    setProperty('skipCountdown',true)   

    makeLuaSprite('BlackFade','sans/white',0,0)
    setObjectCamera('BlackFade','hud')
    addLuaSprite('BlackFade',true)
    doTweenColor('WhiteToBlack','BlackFade','000000',0.01,'LinearOut')

    setProperty('skipCountdown',true)
    makeLuaSprite('TextIntro','bendy/images/introductionbonus',250,280)

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