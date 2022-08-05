function onCreate() 


    makeLuaSprite('BlackRitual','sans/white',0,0)
    setObjectCamera('BlackRitual','hud')
    doTweenColor('BlackToWhiteRitual','BlackRitual','000000',0.01,'linear')
    addLuaSprite('BlackRitual',true)
end

function onUpdate()
    if curStep > 62 and curStep < 85 and getProperty('BlackRitual.alpha') < 1 or curStep > 1310 then
        setProperty('BlackRitual.alpha',getProperty('BlackRitual.alpha') + 0.014)
        addLuaSprite('BlackRitual',true)
    end
    if curStep <= 62 then
        setProperty('BlackRitual.alpha',0)
    end
    
    if curStep >= 86 and curStep < 1310 then
        setProperty('BlackRitual.alpha',getProperty('BlackRitual.alpha') - 0.015)

        if getProperty('BlackRitual.alpha') < 0 then
            removeLuaSprite('BlackRitual')
        end
    end
end


state = true;
shouldAdd = true;

function onUpdate(elapsed)
	if (getMouseX('camHUD') > 1150 and getMouseX('camHUD') < 1280) and (getMouseY('camHUD') > 582.5 and getMouseY('camHUD') < 720 and mouseClicked('left')) or keyJustPressed('z') then
		objectPlayAnimation('button', 'Dodge 2', false); --when the a is Dodge 2 
	else
		objectPlayAnimation('button', 'Dodge 1', false); --do not do anything
	end
end

function onCreate()  --random shit lol
	makeAnimatedLuaSprite('button', 'Buttons_IC/DodgeButtonMobile', 1150, 582.5);
	addAnimationByPrefix('button', 'Dodge 1', 'Dodge 1', 24, false);
	addAnimationByPrefix('button', 'Dodge 2', 'Dodge 2', 12, false);
	addLuaSprite('button', false);
	setObjectCamera('button', 'other');
end


function onCreate()
    

    makeLuaSprite('BlackFade','sans/white',0,0)
    setObjectCamera('BlackFade','hud')
    addLuaSprite('BlackFade',true)
    doTweenColor('WhiteToBlack','BlackFade','000000',0.01,'LinearOut')

    setProperty('skipCountdown',true)
    makeLuaSprite('TextIntro','bendy/images/introductionbonus2',250,280)

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
    setTextFont('scoreTxt', 'BendyICFont.ttf')
    setTextFont('timeTxt','BendyICFont.ttf')
end