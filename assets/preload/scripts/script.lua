--General Variables
local IndieCrossGameOverStyle = ''
local GameOverActive = false
local enableEnd = true

--Cuphead Variables
local GameOverState = 0
local CupSelection = 0
local AlphaCupEffect = 1



function onCreatePost()  
    if songName == 'Nightmare-Run' or songName == 'Ritual' or songName == 'Terrible-Sin' or songName == 'Imminent-Demise' or songName == 'Last-Reel' or songName == 'Despair' then
        setPropertyFromClass('GameOverSubstate', 'characterName', 'Bendy_GameOver'); --Character json file for the death animation
        setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'bendy/BendyGameOver'); --put in mods/sounds/
        setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'bendy/BendyHeartbeat'); --put in mods/music/
        setPropertyFromClass('GameOverSubstate', 'endSoundName', 'bendy/BendyClick'); --put in mods/music/
        IndieCrossGameOverStyle = 'Bendy'

    elseif songName == 'Whoopee' or songName == 'Sansational' or songName == 'Burning-In-Hell' or songName == 'Final-Stretch' or songName == 'Bad-Time' or songName == 'Bad-To-The-Bone' or songName == 'Bonedoggle' then
        setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'sans/gameovernormal'); --put in mods/sounds/
        setPropertyFromClass('PauseSubState', 'songName', 'sans/pause'); --put in mods/music/
        IndieCrossGameOverStyle = 'Sans'
        

    elseif songName == 'Snake-Eyes' or songName == 'Knockout' or songName == 'Technicolor-Tussle' or songName == 'Devils-Gambit' or songName == 'Satanic-Funkin' then
        
        IndieCrossGameOverStyle = 'Cuphead'
        setPropertyFromClass('GameOverSubstate', 'characterName', 'BF_Ghost'); --Character json file for the death animation
        setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'Cup/CupDeath'); --put in mods/sounds/
        setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
        setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music


        makeAnimatedLuaSprite('BF_Ghost','cup/BF_Ghost',getProperty('boyfriend.x'),getProperty('boyfriend.y'))
        addAnimationByPrefix('BF_Ghost','Death','thrtr instance 1',24,true)

        makeLuaSprite('You re dead','cup/death',200,300)
        setObjectCamera('You re dead','hud')
        scaleObject('You re dead',0.9,0.9)
    
        makeLuaSprite('DeathCard','cup/cuphead_death',450,100)
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
        enableEnd = false
    end
end
function onGameOver()
    if not GameOverActive and IndieCrossGameOverStyle == 'Cuphead' then
        setPropertyFromClass('PlayState', 'instance.vocals.volume', 0)
        playSound('cup/CupDeath')
        setProperty('boyfriend.visible',false)
        addLuaSprite('BF_Ghost',false)
        addLuaSprite('You re dead',false)
        runTimer('GameOverText',2)
        GameOverActive = true
        addLuaSprite('DeathCard',true)
        addLuaSprite('CupExitButton',true)
        addLuaSprite('CupRetryButton',true)
        setPropertyFromClass('PlayState', 'instance.generatedMusic', false)
        setPropertyFromClass('PlayState', 'instance.vocals.volume', 0)
        setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
        return Function_Stop;
    end
    if GameOverActive then
        return Function_Stop
    end
    return Function_Continue;
end

function onPause()
    if GameOverActive and IndieCrossGameOverStyle == 'Cuphead' then
        return Function_Stop
    end
end
function onEndSong()
    if GameOverActive and not enableEnd and IndieCrossGameOverStyle == 'Cuphead' then
        return Function_Stop;
    end
    return Function_Continue;
end


function onUpdate()
    if IndieCrossGameOverStyle == 'Cuphead' then
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
        
                if keyJustPressed('accept') then
                    playSound('cup/select')
                    restartSong(false)
                end
            else
                objectPlayAnimation('CupRetryButton','Normal')
                objectPlayAnimation('CupExitButton','Selected')
                if keyJustPressed('up') or keyJustPressed('down') then
                    playSound('cup/select')
                    CupSelection = 0
                end
                if keyJustPressed('accept') or keyJustPressed('esc') or keyJustPressed('back') then
                    playSound('cup/select')
                    exitSong(false);
                end
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

function onCreate()
    if songName == 'Bad-Time' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Tenzubushi - Bad Time')
    end

    if songName == 'Bad-To-The-Bone' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Yamahearted - Bad To The Bone')
    end

    if songName == 'Bonedoggle' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Saster - Bonedoggle')
    end

    if songName == 'Burning-In-Hell' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - TheInnuendo & Saster - Burning in Hell')
    end

    if songName == 'Despair' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - CDMusic, Joan Atlas & Rozebud - Despair')
    end

    if songName == 'Devils-Gambit' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Saru & TheInnuend0 - Devils Gambit')
    end

    if songName == 'Final-Stretch' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Saru - Final Stretch')
    end

    if songName == 'Freaky-Machine' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - DAGames & Saster - Freaky Machine')
    end

    if songName == 'Gose' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - CrystalSlime - Gose')
    end

    if songName == 'Imminent-Demise' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Saru & CDMusic - Imminent Demise')
    end

    if songName == 'Knockout' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Orenji Music - Knockout')
    end

    if songName == 'Last-Reel' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Joan Atlas - Last Reel')
    end

    if songName == 'Nightmare-Run' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Orenji Music & Rozebud - Nightmare Run')
    end

    if songName == 'Ritual' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - BBPanzu & Brandxns - Ritual')
    end

    if songName == 'Saness' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - CrystalSlime - Saness')
    end

    if songName == 'Sansational' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Tenzubushi - Sansational')
    end

    if songName == 'Satanic-Funkin' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - TheInnuend0 - Satanic Funkin')
    end

    if songName == 'Snake-Eyes' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - Mike Geno - Snake Eyes')
    end

    if songName == 'Technicolor-Tussle' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - BLVKAROT - Technicolor Tussle')
    end

    if songName == 'Terrible-Sin' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - CDMusic & Rozebud - Terrible Sin')
    end

    if songName == 'Whoopee' then
        setPropertyFromClass("openfl.Lib", "application.window.title", 'Indie Cross - YingYang48 & Saster - Whoopee')
    end
end

function onDestroy()
    if songName == 'Whoopee' or 'Terrible-Sin' or 'Technicolor-Tussle' or 'Snake-Eyes' or 'Satanic-Funkin' or 'Sansational' or 'Saness' or 'Ritual' or 'Nightmare-Run' or 'Last-Reel' or 'Knockout' or 'Imminent-Demise' or 'Gose' or 'Freaky-Machine' or 'Final-Stretch' or 'Devils-Gambit' or 'Snake-Eyes' or 'Burning-In-Hell' or 'Bonedoggle' or 'Bad-To-The-Bone' or 'Bad-Time' then
    setPropertyFromClass("openfl.Lib", "application.window.title", "Friday Night Funkin': Psych Engine")
    end
end

--SCRIPT BY WuBraR
--thanks wubrar :D

--easy script configs
IntroTextSize = 35 --Size of the text for the Now Playing thing.
IntroSubTextSize = 35 --size of the text for the Song Name.
IntroTagColor = '808080' --Color of the tag at the end of the box.
IntroTagWidth = 0 --Width of the box's tag thingy.
SongDetectedIC = false
--easy script configs

--actual script
function onCreate()
    --the tag at the end of the box
    makeLuaSprite('JukeBoxTag', 'empty', -305-IntroTagWidth, 0)
    makeGraphic('JukeBoxTag', 300+IntroTagWidth, 100, IntroTagColor)
    setObjectCamera('JukeBoxTag', 'other')
    --addLuaSprite('JukeBoxTag', true)

    --the box
    makeLuaSprite('JukeBox', 'ICImages/musicBar', -305-IntroTagWidth, 500)
    setProperty('JukeBox.alpha', 0.7)
    setObjectCamera('JukeBox', 'other')
    addLuaSprite('JukeBox', true)

    setTextBorder('JukeBoxSubText',0)
    setTextColor('JukeBoxSubText','A8AAAF')

    --the text for the "Now Playing" bit

    if songName == 'Knockout' then
        makeLuaText('JukeBoxText', 'Orenji Music - ', 300, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','CupheadICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)
        addLuaText('JukeBoxText')
        setTextBorder('JukeBoxText',0)
        SongDetectedIC = true

    elseif songName == 'Snake-Eyes' then
        makeLuaText('JukeBoxText', 'Mike Geno - ', 300, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','CupheadICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)
        addLuaText('JukeBoxText')
        setTextBorder('JukeBoxText',0)
        SongDetectedIC = true

    elseif songName == 'Technicolor-Tussle' then
        makeLuaText('JukeBoxText', 'BLVKAROT - ', 300, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','CupheadICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)
        addLuaText('JukeBoxText')
        setTextBorder('JukeBoxText',0)
        SongDetectedIC = true
        
    elseif songName == 'Devils-Gambit' then
        makeLuaText('JukeBoxText', 'Saru & TheInnuend0 - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','CupheadICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)
        
        SongDetectedIC = true

    elseif songName == 'Bad-Time' then
        makeLuaText('JukeBoxText', 'Tenzubushi - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','SansICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true
        
    elseif songName == 'Despair' then
        makeLuaText('JukeBoxText', 'CDMusic, Joan Atlas and Rozebud - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','BendyICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true
        
    elseif songName == 'Whoopee' then

        makeLuaText('JukeBoxText', 'yingyang48 & Saster - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','SansICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true

    elseif songName == 'Sansational' then
        makeLuaText('JukeBoxText', 'Tenzubushi - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','SansICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true

    elseif songName == 'Final-Stretch' then

        makeLuaText('JukeBoxText', 'Saru - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','SansICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true


    elseif songName == 'Burning-In-Hell' then
        makeLuaText('JukeBoxText', 'TheInnuenedo & Saster - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','SansICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true
        


    elseif songName == 'imminent-demise' then
        makeLuaText('JukeBoxText', 'Saur & CDMusic - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','BendyICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        
        SongDetectedIC = true
    elseif songName == 'Last-Reel' then
        makeLuaText('JukeBoxText', 'Joan Atlas - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','BendyICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        
        SongDetectedIC = true

    elseif songName == 'Nightmare-Run' then
        makeLuaText('JukeBoxText', 'Orenji Music & Rozebud - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','BendyICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        
        SongDetectedIC = true

    elseif songName == 'Terrible-Sin' then
        makeLuaText('JukeBoxText', 'CDMusic & Rozebud - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','BendyICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        
        SongDetectedIC = true

    elseif songName == 'Ritual' then
        makeLuaText('JukeBoxText', 'BBPanzu and Brandxns - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','BendyICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true

    elseif songName == 'Freaky-Machine' then
        makeLuaText('JukeBoxText', 'DAGames and Saster - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','BendyICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true

    elseif songName == 'Satanic-Funkin' then
        makeLuaText('JukeBoxText', 'TheInnuend0 - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','CupheadICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)
        
        SongDetectedIC = true

    elseif songName == 'Bonedoggle' then
        makeLuaText('JukeBoxText', 'Saster - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','SansICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true

    elseif songName == 'Bad-To-The-Bone' then
        makeLuaText('JukeBoxText', 'Yamahearted - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','SansICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true

    elseif songName == 'Saness' or songName == 'Gose' then
        makeLuaText('JukeBoxText', 'CrystalSlime - ', 3000, -305-IntroTagWidth, 515)
        setTextFont('JukeBoxText','CupheadICFont.ttf')
        setTextAlignment('JukeBoxText', 'left')
        setObjectCamera('JukeBoxText', 'other')
        setTextSize('JukeBoxText', IntroTextSize)
        setProperty('JukeBoxText.offset.x', getProperty('JukeBox.x') + 250)

        SongDetectedIC = true
        
    end
    
    



    
--makeLuaText('JukeBoxText', 'Now Playing:', 300, -305-IntroTagWidth, 30)
--setTextAlignment('JukeBoxText', 'left')
--setObjectCamera('JukeBoxText', 'other')
--setTextSize('JukeBoxText', IntroTextSize)
--addLuaText('JukeBoxText')

--text for the song name
    if songName == 'Knockout' or songName == 'Snake-Eyes' or songName == 'Technicolor-Tussle' or songName == 'Devils-Gambit' or songName == 'Burning-In-Hell' or songName == 'Sansational' or songName == 'Final-Stretch' or songName == 'Whoopee' or songName == 'Terrible-Sin' or songName == 'Last-Reel' or songName == 'imminent-demise' or songName == 'Nightmare-Run' or songName == 'Despair' or songName == 'Bad-Time' or songName == 'Ritual' or songName == 'Freaky-Machine' or songName == 'Bonedoggle' or songName == 'Bad-To-The-Bone' or songName == 'Satanic-Funkin' or songName == 'Saness' or songName == 'Gose' then

        makeLuaText('JukeBoxSubText', songName, 0, -305-IntroTagWidth, 515)
        setTextAlignment('JukeBoxSubText', 'left')
        setTextFont('JukeBoxSubText','CupheadICFont.ttf')
        setObjectCamera('JukeBoxSubText', 'other')
        setTextSize('JukeBoxSubText', IntroTextSize)
        setProperty('JukeBoxSubText.offset.x', getProperty('JukeBoxText.x') + 5)

    end
    if songName == 'Ritual' or songName == 'Freaky-Machine' or songName == 'Terrible-Sin' or songName == 'Last-Reel' or songName == 'imminent-demise' or songName == 'Nightmare-Run' or songName == 'Despair' then
        setTextFont('JukeBoxSubText','BendyICFont.ttf')
    end
    if songName == 'Bonedoggle' or songName == 'Bad-To-The-Bone' or songName == 'Saness' or songName == 'Final-Stretch' or songName == 'Burning-In-Hell' or songName == 'Whoopee' or songName == 'Sansational' or songName == 'Bad-Time' then
        setTextFont('JukeBoxSubText','SansICFont.ttf')
    end

    if SongDetectedIC then
        setTextBorder('JukeBoxText',0)
        setTextBorder('JukeBoxSubText',0)
        setTextColor('JukeBoxText','A8AAAF')
        setTextColor('JukeBoxSubText','A8AAAF')
        addLuaText('JukeBoxText')
        addLuaText('JukeBoxSubText')
    else
        removeLuaText('JukeBoxText',true)
        removeLuaText('JukeBoxSubText',true)
        removeLuaText('JukeBoxText',true)
        removeLuaSprite('JukeBoxTag',true)
        removeLuaSprite('JukeBox',true)
    end

    doTweenX('MoveInOne', 'JukeBoxTag', 2222, 0.001, 'CircInOut')
    doTweenX('MoveInTwo', 'JukeBox', 2222, 0.001, 'CircInOut')
    doTweenX('MoveInThree', 'JukeBoxText', 2222, 0.001, 'CircInOut')
    doTweenX('MoveInFour', 'JukeBoxSubText', 2222, 0.001, 'CircInOut')
end

--motion functions
function onSongStart()
-- Inst and Vocals start playing, songPosition = 0
    doTweenX('MoveInOne', 'JukeBoxTag', 500, 1, 'CircInOut')
    doTweenX('MoveInTwo', 'JukeBox', 500, 1, 'CircInOut')

    if songName == 'Whoopee' or songName == 'Terrible-Sin' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 620,1,'CircInOut')

    elseif songName == 'Sansational' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 480,1,'CircInOut')


    elseif songName == 'Final-Stretch' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 370,1,'CircInOut')

    elseif songName == 'Burning-In-Hell' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 670,1,'CircInOut')
        
    elseif songName == 'imminent-demise' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 560,1,'CircInOut')

    elseif songName == 'Nightmare-Run' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 630,1,'CircInOut')

    elseif songName == 'Last-Reel' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 450,1,'CircInOut')

    elseif songName == 'Ritual' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 650,1,'CircInOut')

    elseif songName == 'Bonedoggle' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 390,1,'CircInOut')

    elseif songName == 'Freaky-Machine' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 610,1,'CircInOut')


    elseif songName == 'Devils-Gambit' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 620,1,'CircInOut')

    elseif songName == 'Bad-Time' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 480,1,'CircInOut')

    elseif songName == 'Despair' then
        doTweenX('MoveInFour', 'JukeBoxSubText', 800,1,'CircInOut')



    else
        doTweenX('MoveInFour', 'JukeBoxSubText', 500, 1, 'CircInOut')
    end
        
    doTweenX('MoveInThree', 'JukeBoxText', 500, 1, 'CircInOut')


    runTimer('JukeBoxWait', 3, 1)
    end

    function onTimerCompleted(tag, loops, loopsLeft)
    -- A loop from a timer you called has been completed, value "tag" is it's tag
    -- loops = how many loops it will have done when it ends completely
    -- loopsLeft = how many are remaining
    if tag == 'JukeBoxWait' then
        doTweenX('MoveInOne2', 'JukeBoxTag', 3333, 1, 'CircInOut')
        doTweenX('MoveInTwo2', 'JukeBox', 3333, 1, 'CircInOut')
        doTweenX('MoveInThree2', 'JukeBoxText', 3333, 1, 'CircInOut')
        doTweenX('MoveInFour2', 'JukeBoxSubText', 3333, 1, 'CircInOut')
    end
end

function onTweenCompleted(tag)
    if tag == 'MoveInFour2' then
        removeLuaSprite('JukeBoxTag',true)
        removeLuaSprite('JukeBox',true)
        removeLuaText('JukeBoxText',true)
        removeLuaText('JukeBoxSubText',true)
    end
end


local StopAnim = 0
local StopAnimName = ''
local SplashEffect = 1;
local SplashDamage = 0

local BFBendy_Attacking = false
local BFBendy_Dodge = false

local CameraEffect = false

local PiperX = false
local StrikerX = false
local PiperSpawn = 100
local StrikerSpawn = 200
local PiperAttack = 0
local StrikerAttack = 0
local PiperAttackTimeMax = 400
local StrikerAttackTimeMax = 400

local PiperOffsetX = 0
local StrikerOffsetX = 0

local PiperOffsetY = 0
local StrikerOffsetY = 0

local PiperBFX = 500
local StrikerBFX = -300


local PiperAttacking = false
local Dodge1 = 0

local StrikerAttacking = false
local Dodge2 = 0


local PiperHP = 3
local StrikerHP = 3

local enableAttack = false


function onCreatePost()
    if difficulty ~= 0 then
        if songName == 'Last-Reel' then
            PiperOffsetY = 40
            StrikerOffsetY = 50

            PiperOffsetX = 1220
            StrikerOffsetX = -750
            makeAnimatedLuaSprite('Piper','bendy/images/third/Piper',2500,getProperty('boyfriend.y'))
            addAnimationByPrefix('Piper','Walking','pip walk instance 1',24,true)
            addAnimationByPrefix('Piper','Idle','Piperr instance 1',24,false)
            addAnimationByPrefix('Piper','Hurt','Piper gets Hit instance 1',24,false)
            addAnimationByPrefix('Piper','Dead','Piper ded instance 1',24,false)
            addAnimationByPrefix('Piper','Attack','PeepAttack instance 1',24,false)
            addAnimationByPrefix('Piper','Pre-Attack','PipAttack instance 1',24,false)
            scaleObject('Piper',1.8,1.8)
            
            makeAnimatedLuaSprite('Striker','bendy/images/third/Striker',-200,getProperty('boyfriend.y'))
            addAnimationByPrefix('Striker','Walking','Str walk instance 1',24,true)
            addAnimationByPrefix('Striker','Hurt','Sticker  instance 1',24,false)
            addAnimationByPrefix('Striker','Dead','I ded instance 1',24,false)
            addAnimationByPrefix('Striker','Pre-Attack','PunchAttack_container instance 1',24,false)
            addAnimationByPrefix('Striker','Attack','regeg instance 1',24,false)
            addAnimationByPrefix('Striker','Idle','strrr instance 1',24,false)
            scaleObject('Striker',1.8,1.8)

            AttackEnable = true
        end
        if songName == 'Despair' then
            PiperOffsetY = -100
            StrikerOffsetY = -80

            PiperBFX = 350
            StrikerBFX = -400

            PiperOffsetX = 2000
            StrikerOffsetX = 0
            makeAnimatedLuaSprite('Piper','bendy/images/third/PiperDespair',screenWidth + PiperOffsetX,getProperty('boyfriend.y') + PiperOffsetY)
            addAnimationByPrefix('Piper','Walking','pip walk instance 1',24,true)
            addAnimationByPrefix('Piper','Idle','Piperr instance 1',24,false)
            addAnimationByPrefix('Piper','Hurt','Piper gets Hit instance 1',24,false)
            addAnimationByPrefix('Piper','Dead','Piper ded instance 1',24,false)
            addAnimationByPrefix('Piper','Attack','PeepAttack instance 1',24,false)
            addAnimationByPrefix('Piper','Pre-Attack','PipAttack instance 1',24,false)
            scaleObject('Piper',1.8,1.8)
            
            makeAnimatedLuaSprite('Striker','bendy/images/third/StrikerDespair',0 + StrikerOffsetX,getProperty('boyfriend.y') + StrikerOffsetY)
            addAnimationByPrefix('Striker','Walking','Str walk instance 1',24,true)
            addAnimationByPrefix('Striker','Hurt','Sticker  instance 1',24,false)
            addAnimationByPrefix('Striker','Dead','I ded instance 1',24,false)
            addAnimationByPrefix('Striker','Pre-Attack','PunchAttack_container instance 1',24,false)
            addAnimationByPrefix('Striker','Attack','regeg instance 1',24,false)
            addAnimationByPrefix('Striker','Idle','strrr instance 1',24,false)
            scaleObject('Striker',1.8,1.8)



            AttackEnable = false
        end
    end
    if songName == 'Last-Reel' or songName == 'Despair' then
        removeLuaScript('custom_notetypes/BendySplashNote')
        makeAnimatedLuaSprite('AttackButton','IC_Buttons',50,300)
        addAnimationByPrefix('AttackButton','Static','Attack instance 1',24,true)
        addAnimationByPrefix('AttackButton','NA','AttackNA instance 1',30,false)
        objectPlayAnimation('AttackButton','Static',true)
        setObjectCamera('AttackButton','hud')
        addLuaSprite('AttackButton',false)
        scaleObject('AttackButton',0.6,0.6)
        setProperty('AttackButton.alpha',0.5)

    
        makeLuaSprite('SplashScreen1','bendy/images/Damage01',0,0)
        scaleObject('SplashScreen1',0.7,0.7)

        makeLuaSprite('SplashScreen2','bendy/images/Damage02',0,0)
        scaleObject('SplashScreen2',0.7,0.7)

        makeLuaSprite('SplashScreen3','bendy/images/Damage03',0,0)
        scaleObject('SplashScreen3',0.7,0.7)

        makeLuaSprite('SplashScreen4','bendy/images/Damage04',0,0)
        scaleObject('SplashScreen4',0.7,0.7)

        setObjectCamera('SplashScreen1','other')
        setObjectCamera('SplashScreen2','other')
        setObjectCamera('SplashScreen3','other')
        setObjectCamera('SplashScreen4','other')
        
        enableAttack = true
    end
end

function onUpdate(elapsed)

    if enableAttack then
        if (SplashDamage == 1) then
            addLuaSprite('SplashScreen1', true)
        
        elseif (SplashDamage == 2) then
            removeLuaSprite('SplashScreen1', false)
            addLuaSprite('SplashScreen2', true)
        
        elseif (SplashDamage == 3) then
            removeLuaSprite('SplashScreen2', false)
            addLuaSprite('SplashScreen3', true)
        
        elseif (SplashDamage == 4) then
            removeLuaSprite('SplashScreen3', false)
            addLuaSprite('SplashScreen4', true)

        elseif (SplashDamage >= 5) then
            setProperty('health', -1)
            removeLuaSprite('SplashScreen4', false)
        end
    
        if (SplashEffect < 1) then
            SplashEffect = SplashEffect - 0.01
        end
        if (SplashEffect <= 0) then
            SplashEffect = 1
            SplashDamage = 0
            removeLuaSprite('SplashScreen1', false)
            removeLuaSprite('SplashScreen2', false)
            removeLuaSprite('SplashScreen3', false)
            removeLuaSprite('SplashScreen4', false)
        end
        if difficulty ~= 0 then
            if PiperHP == 0 then
                playSound('bendy/butcherSounds/Dead')
                objectPlayAnimation('Piper','Dead',false)
                PiperX = false
                PiperHP = -1
            end

            if StrikerHP == 0 then
                playSound('bendy/butcherSounds/Dead')
                objectPlayAnimation('Striker','Dead',false)
                StrikerX = false
                StrikerHP = -1
            end
        end

        if StopAnim == 2 then
            for i = 0,getProperty('notes.length') do 
                if getPropertyFromGroup('notes', i,'mustPress') == true then
                    setPropertyFromGroup('notes', i, 'noAnimation',true)
                end
            end
        elseif StopAnim == 1 then
            for i = 0,getProperty('notes.length') do 
                if getPropertyFromGroup('notes', i,'mustPress') == true then
                    setPropertyFromGroup('notes', i, 'noAnimation',false)
                end
            end
            StopAnim = 0
        end
        if StopAnim == 2 then
            if getProperty('boyfriend.animation.curAnim.name') == 'attack' and BFBendy_Attacking and getProperty('boyfriend.animation.curAnim.finished') or getProperty('boyfriend.animation.curAnim.name') == 'attack2' and BFBendy_Attacking and getProperty('boyfriend.animation.curAnim.finished') or getProperty('boyfriend.animation.curAnim.name') ~= 'attack' and getProperty('boyfriend.animation.curAnim.name') ~= 'attack2' and BFBendy_Attacking then
                BFBendy_Attacking = false
                StopAnim = 1
                StopAnimName = ''
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'dodge' and BFBendy_Dodge and getProperty('boyfriend.animation.curAnim.finished') or getProperty('boyfriend.animation.curAnim.name') ~= 'dodge' and BFBendy_Dodge then
                StopAnim = 1
                BFBendy_Dodge = false
                StopAnimName = ''
            end
            if getProperty('boyfriend.animation.curAnim.name') ~= StopAnimName then
                StopAnim = 1
            end
        end
    end

    if (AttackEnable) then

        if (PiperSpawn > 0) then
            PiperSpawn = PiperSpawn - 1
        end
        if (StrikerSpawn > 0) then
            StrikerSpawn = StrikerSpawn - 1
        end

        if (PiperSpawn == 0) then
            setProperty('Piper.x', screenWidth + PiperOffsetX)
            setProperty('Piper.y', getProperty('boyfriend.y') + PiperOffsetY)
            PiperHP = 3
            addLuaSprite('Piper', false)
            setObjectOrder('Piper', 14)
            PiperX = false
            PiperSpawn = -1
        end

        if (StrikerSpawn == 0) then
            addLuaSprite('Striker', false)
            setProperty('Striker.x', 0 + StrikerOffsetX)
            setProperty('Striker.y', getProperty('boyfriend.y') + StrikerOffsetY)
            setObjectOrder('Striker', 14)
            StrikerHP = 3
            StrikerX = false
            StrikerSpawn = -1
        end

        if (StrikerHP > 0 and StrikerX == true) then
            if (StrikerAttack < StrikerAttackTimeMax) then
                StrikerAttack = StrikerAttack + 1
            end
            if (StrikerAttack == StrikerAttackTimeMax and StrikerAttacking == false) then
                Dodge2 = 2
                objectPlayAnimation('Striker','Pre-Attack',false)

                StrikerAttacking = true
            end
        end

        if (PiperHP > 0 and PiperX == true and PiperAttacking == false) then
            if (PiperAttack < PiperAttackTimeMax) then
                PiperAttack = PiperAttack + 1
            end
            if (PiperAttack == PiperAttackTimeMax) then
                Dodge1 = 2
                objectPlayAnimation('Piper','Pre-Attack',false)
                PiperAttacking = true

            end
        end
        if PiperHP > 1 then
            if getProperty('Piper.x') > getProperty('boyfriend.x') + PiperBFX and PiperX == false and PiperHP > 0 then
                objectPlayAnimation('Piper','Walking',false)
                setProperty('Piper.x',getProperty('Piper.x') - 1)
            end

            if getProperty('Piper.x') <= getProperty('boyfriend.x') + PiperBFX and PiperX == false and PiperHP > 0 then
                PiperX = true
                objectPlayAnimation('Piper','Idle',false)
                PiperAttack = PiperAttackTimeMax
            end
        end
        if StrikerHP > 1 then
            if getProperty('Striker.x') < getProperty('boyfriend.x') + StrikerBFX and StrikerX == false and StrikerHP > 0 then
                objectPlayAnimation('Striker','Walking',false)
                setProperty('Striker.x',getProperty('Striker.x') + 3)
            end

            if getProperty('Striker.x') >= getProperty('boyfriend.x') + StrikerBFX and StrikerX == false and StrikerHP > 0 then
                StrikerX = true
                objectPlayAnimation('Striker','Idle',false)
                StrikerAttack = StrikerAttackTimeMax
            end
        end



        if (getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') and getProperty('AttackButton.animation.curAnim.name') == 'Static' and BFBendy_Attacking == false) then

            if (keyPressed('left') or not keyPressed('right') and not keyPressed('left') and (PiperX == false and StrikerX == true))  then

                objectPlayAnimation('AttackButton','NA',false)
                setProperty('AttackButton.y',getProperty('AttackButton.y') - 35)

                

                characterPlayAnim('boyfriend','attack',true)
                setProperty('boyfriend.specialAnim',true)
                StopAnim = 2
                StopAnimName = 'attack'

                BFBendy_Attacking = true

                if (StrikerX == true) then
                    objectPlayAnimation('Striker','Hurt',true)
                    StrikerAttacking = false
                    Dodge2 = 0

                    StrikerAttack = StrikerAttack - 100
                    StrikerHP = StrikerHP - 1
                      
                    playSound('bendy/butcherSounds/Hurt0' ..math.random(1,2))
                end
            
            elseif (keyPressed('right') or not keyPressed('right') and not keyPressed('left') and (StrikerX == false and PiperX == true)) then

                objectPlayAnimation('AttackButton','NA',false)
                setProperty('AttackButton.y',getProperty('AttackButton.y') - 35)

                characterPlayAnim('boyfriend','attack2',true)
                setProperty('boyfriend.specialAnim',true)
                StopAnim = 2
                StopAnimName = 'attack2'
                
                
                BFBendy_Attacking = true

                if (PiperX == true) then
                    PiperAttacking = false
                    Dodge1 = 0

                    PiperAttack = PiperAttack - 100
                    PiperHP = PiperHP - 1

                    objectPlayAnimation('Piper', 'Hurt', true)
                    playSound('bendy/butcherSounds/Hurt0' ..math.random(1,2), 50)
                end
            end
        end


        if keyJustPressed('space') and Dodge1 == 2 or Dodge1 == 2 and botPlay then
         Dodge1 = 1
        end

        
        if keyJustPressed('space') and Dodge2 == 2 or Dodge2 == 2 and botPlay then
            Dodge2 = 1
        end


        if getProperty('Piper.animation.curAnim.finished') == true then

            if getProperty('Piper.animation.curAnim.name') == 'Dead' then
                removeLuaSprite('Piper', false)
                if (AttackEnable) then
                    if PiperSpawn == -1 then
                        PiperSpawn = math.random(600,800)
                    end
                end
            end
        
            if getProperty('Piper.animation.curAnim.name') == 'Attack' then
                PiperAttacking = false
                objectPlayAnimation('Piper','Idle',false)
            end

            if  getProperty('Piper.animation.curAnim.name') == 'Hurt' then
                objectPlayAnimation('Piper','Idle',false)
            end

            if (getProperty('Piper.animation.curAnim.name') == 'Pre-Attack') then
                PiperAttack = 0  
                objectPlayAnimation('Piper', 'Attack', false)

                if (Dodge1 == 2) then
                    SplashDamage = SplashDamage + 1
                    playSound('bendy/inked')
                    characterPlayAnim('boyfriend','hurt',true)
                    setProperty('boyfriend.specialAnim',true)
                    runTimer('SplashDestroy',2)
                    SplashEffect = 1
                
                elseif (Dodge1 == 1) then
                    Dodge1 = 0

                    characterPlayAnim('boyfriend', 'dodge', true)
                    setProperty('boyfriend.specialAnim',true)
                    StopAnim = 2
                    StopAnimName = 'dodge'
                    BFBendy_Dodge = true
                end
            end
        end

        if getProperty('Striker.animation.curAnim.finished') == true then

            if getProperty('Striker.animation.curAnim.name') == 'Dead' then
                removeLuaSprite('Striker',false)
                if (AttackEnable) then
                    if (StrikerSpawn == -1) then
                        StrikerSpawn = math.random(600,800)
                    end
                end
            end
        
            if getProperty('Striker.animation.curAnim.name') == 'Attack' then
                StrikerAttacking = false
                objectPlayAnimation('Striker','Idle',false)
            end

            if  getProperty('Striker.animation.curAnim.name') == 'Hurt' then
                objectPlayAnimation('Striker','Idle',false)
            end

            if getProperty('Striker.animation.curAnim.name') == 'Pre-Attack' then
                StrikerAttack = 0
                objectPlayAnimation('Striker','Attack',false)
    
                if (Dodge2 == 2) then
                    SplashDamage = SplashDamage + 1
                    playSound('bendy/inked')
                    characterPlayAnim('boyfriend','hurt',true)
                    setProperty('boyfriend.specialAnim',true)
                    runTimer('SplashDestroy',2)
                    SplashEffect = 1

                elseif (Dodge2 == 1) then
                    Dodge2 = 0
                    characterPlayAnim('boyfriend', 'dodge', true)
                    setProperty('boyfriend.specialAnim',true)
                    StopAnim = 2
                    StopAnimName = 'dodge'
                    BFBendy_Dodge = true
                    
                end
            end
        end
    end
    --CameraEffect
    if (getProperty('Piper.animation.curAnim.name') == 'Pre-Attack' or getProperty('Striker.animation.curAnim.name') == 'Pre-Attack' and BFBendy_Attacking == false) or (getProperty('Striker.animation.curAnim.name') == 'Pre-Attack' or getProperty('Striker.animation.curAnim.name') == 'Pre-Attack' and BFBendy_Attacking == false)then

        doTweenZoom('AttackZoom', 'camGame', '0.8', '1.5', 'QuintOut')
        cameraSetTarget('bf')
        CameraEffect = true
    end
    if CameraEffect then
        if (getProperty('Striker.animation.curAnim.name') ~= 'Pre-Attack' and getProperty('Piper.animation.curAnim.name') ~= 'Pre-Attack' or not AttackEnable) then
            CameraEffect = false
            doTweenZoom('AttackZoom', 'camGame', getProperty('defaultCamZoom'), '1.5', 'QuintOut')
            if not mustHitSection and not gfSection then
                cameraSetTarget('dad')
            end
        end
    end
    --Animation fix
    if getProperty('Piper.animation.curAnim.name') == 'Idle' then
        setProperty('Piper.offset.x',0)
        setProperty('Piper.offset.y',40)
    end

    if getProperty('Piper.animation.curAnim.name') == 'Walking' then
        setProperty('Piper.offset.x',100)
        setProperty('Piper.offset.y',40)
    end

    if getProperty('Piper.animation.curAnim.name') == 'Attack' then
        setProperty('Piper.offset.x',350)
        setProperty('Piper.offset.y',250)
    end
    
    if getProperty('Piper.animation.curAnim.name') == 'Pre-Attack' then
        setProperty('Piper.offset.x',70)
        setProperty('Piper.offset.y',90)
    end

    if getProperty('Piper.animation.curAnim.name') == 'Hurt' then
        setProperty('Piper.offset.x',120)
        setProperty('Piper.offset.y',200)
    end
    if getProperty('Piper.animation.curAnim.name') == 'Dead' then
        setProperty('Piper.offset.x',120)
        setProperty('Piper.offset.y',180)
    end


    
    if getProperty('Striker.animation.curAnim.name') == 'Idle' then
        setProperty('Striker.offset.x',0)
        setProperty('Striker.offset.y',40)
    end

    if getProperty('Striker.animation.curAnim.name') == 'Walking' then
        setProperty('Striker.offset.x',0)
        setProperty('Striker.offset.y',40)
    end

    if getProperty('Striker.animation.curAnim.name') == 'Attack' then
        setProperty('Striker.offset.x',0)
        setProperty('Striker.offset.y',40)
    end
    
    if getProperty('Striker.animation.curAnim.name') == 'Pre-Attack' then
        setProperty('Striker.offset.x',20)
        setProperty('Striker.offset.y',47)
    end

    if getProperty('Striker.animation.curAnim.name') == 'Hurt' then
        setProperty('Striker.offset.x',150)
        setProperty('Striker.offset.y',120)
    end

    if getProperty('Striker.animation.curAnim.name') == 'Dead' then
        setProperty('Striker.offset.x',120)
        setProperty('Striker.offset.y',120)
    end
    --Attack Button Animation
    if getProperty('AttackButton.animation.curAnim.finished') == true then
        attackTimer = 0
        objectPlayAnimation('AttackButton','Static',true)
        setProperty('AttackButton.y',getProperty('AttackButton.y') + 35)
    end

    setProperty('SplashScreen1.alpha', SplashEffect)
    setProperty('SplashScreen2.alpha', SplashEffect)
    setProperty('SplashScreen3.alpha', SplashEffect)
    setProperty('SplashScreen4.alpha', SplashEffect)


end
    
    
function onStepHit()
    if (curStep % 2 == 0) then
        if getProperty('Piper.animation.curAnim.name') == 'Idle' then
            objectPlayAnimation('Piper', 'Idle', false)
        end
        if getProperty('Striker.animation.curAnim.name') == 'Idle' then
            objectPlayAnimation('Striker', 'Idle', false)
        end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if (noteType == 'BendySplashNote') and enableAttack then
		-- put something here if you want
		playSound('bendy/inked')
		SplashDamage = SplashDamage + 1
		SplashEffect = 1
		runTimer('SplashDestroy', 2)
	end
end

function onTimerCompleted(tag)
	if (tag == 'SplashDestroy') then
		SplashEffect = SplashEffect - 0.1
	end
end

function onStepHit()
    if (curStep % 2 == 0) then
        if getProperty('Piper.animation.curAnim.name') == 'Idle' then
            objectPlayAnimation('Piper','Idle',false)
        end
        if getProperty('Striker.animation.curAnim.name') == 'Idle' then
            objectPlayAnimation('Striker','Idle',false)
        end
    end
    if difficulty ~= 0 then
        if (curStep >= 1664 and curStep < 1670 and songName == 'Last-Reel') then
            PiperHP = 0
            StrikerHP = 0
            AttackEnable = false
        end
        if songName == 'Despair' then
            if curStep == 1355 or curStep == 2064 or curStep == 3215 then
                AttackEnable = true
                PiperHP = 3
                StrikerHP = 3
            end
            if curStep == 1680 or curStep == 3023 or curStep == 3912 then
                PiperHP = 0
                StrikerHP = 0
                AttackEnable = false
            end
        end
    end
end

local IndieCrossCountDownStyle = ''
local scaleEffect = 1
local alphaEffect = 0
local alphaEffectDisable = false




function onCreate()
    if songName == 'Snake-Eyes' or songName == 'Knockout' or songName == 'Technicolor-Tussle' or songName == 'Devils-Gambit' or songName == 'Satanic-Funkin' then
        IndieCrossCountDownStyle = 'Cuphead'
        setProperty('skipCountdown', true)
        makeAnimatedLuaSprite('CupTitle','cup/ready_wallop',-600,-150)
        addAnimationByPrefix('CupTitle','Ready?','Ready? WALLOP!',24,false)
        objectPlayAnimation('CupTitle','Ready?',false)
        setLuaSpriteScrollFactor('CupTitle',0,0)
       
        makeAnimatedLuaSprite('CupThing','cup/the_thing2.0',-345,-200)
        setLuaSpriteScrollFactor('CupThing',0,0)
        addAnimationByPrefix('CupThing','BOO','BOO instance 1',20,false)
        objectPlayAnimation('CupThing','BOO',false)
        scaleObject('CupThing',1.6,1.6)
        addLuaSprite('CupThing',true)
        setObjectCamera('CupThing', 'hud');
           
        runTimer('CupReady',0.5)

    elseif songName == 'Whoopee' or songName == 'Sansational' or songName == 'Final-Stretch' or songName == 'Burning-In-Hell' or songName == 'Bad-Time' or songName == 'Bad-To-The-Bone' or songName == 'Bonedoggle' then
        setProperty('introSoundsSuffix','Sans')
    elseif songName == 'imminent-demise' or songName == 'Terrible-Sin' or songName == 'Last-Reel' or songName == 'Last-Reel' or songName == 'Nightmare-Run' or songName == 'Ritual' or songName == 'Despair' or songName == 'Freaky-Machine' or songName == 'build-our-freaky-machine'then
        setProperty('introSoundsSuffix','Sans')
        IndieCrossCountDownStyle = 'Bendy'
    end

    if songName == 'imminent-demise' then
        makeLuaSprite('TextIntro','bendy/images/introductionsong1',360,300)
        scaleEffect = 0.8;
        
    elseif songName == 'Terrible-Sin' then
        makeLuaSprite('TextIntro','bendy/images/introductionsong2',320,280)
        scaleEffect = 0.8;

    elseif songName == 'Last-Reel' then
        makeLuaSprite('TextIntro','bendy/images/introductionsong3',380,300)
        scaleEffect = 0.8;

    elseif songName == 'Nightmare-Run' then
        makeLuaSprite('TextIntro','bendy/images/introductionsong4',400,300)
        scaleEffect = 0.8;

    elseif songName == 'Ritual' then
        makeLuaSprite('TextIntro','bendy/images/introductionbonus2',360,300)
        scaleEffect = 0.75;

    elseif songName == 'Freaky-Machine' or songName == 'build-our-freaky-machine' then
        makeLuaSprite('TextIntro','bendy/images/introductionbonus',340,300) 
        scaleEffect = 0.8;

    elseif songName == 'Despair' then
        makeLuaSprite('TextIntro','bendy/images/introductiondespair',400,320)
        scaleEffect = 0.8;

    end
    if IndieCrossCountDownStyle == 'Bendy' then
        makeLuaSprite('BlackFadeBendy','',0,0)
        makeGraphic('BlackFadeBendy',screenWidth,screenHeight,'000000')
        setObjectCamera('BlackFadeBendy','other')
        addLuaSprite('BlackFadeBendy',true)
        doTweenColor('WhiteToBlack','BlackFadeBendy','000000',0.01,'LinearOut')
        setProperty('skipCountdown',true)
        CountTextCompleted = false
        runTimer('textSongDestroy',2)
        setObjectCamera('TextIntro','other')
        addLuaSprite('TextIntro',true)
        runTimer('playBendySongCountDown',0.2)
    end
end

local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and IndieCrossCountDownStyle == 'Cuphead' or not allowCountdown and IndieCrossCountDownStyle == 'Bendy' then
		return Function_Stop;
	end
    return Function_Continue;
end

function onUpdate()
    if IndieCrossCountDownStyle == 'Bendy' then
        scaleEffect = scaleEffect + 0.0005
        scaleObject('TextIntro',scaleEffect,scaleEffect)
        setProperty('TextIntro.x',getProperty('TextIntro.x') - 0.20)
        setProperty('TextIntro.y',getProperty('TextIntro.y') - 0.05)

        if alphaEffectDisable then
            setProperty('BlackFadeBendy.alpha',alphaEffect)
            alphaEffect = alphaEffect - 0.01
        end
        if alphaEffect < -1 and alphaEffectDisable then
            removeLuaSprite('TextIntro',true)
            removeLuaSprite('BlackFadeBendy',true)
            alphaEffect = null
        end

        if not alphaEffectDisable and alphaEffect < 1 then
            alphaEffect = alphaEffect + 0.01
        end
        setProperty('TextIntro.alpha',alphaEffect * 2)
    elseif IndieCrossCountDownStyle == 'Cuphead' then
        if getProperty('CupTitle.animation.curAnim.finished') == true then
            removeLuaSprite('CupTitle',true)
        end
        if not lowQuality then
            if getProperty('CupThing.animation.curAnim.finished') == true then
                removeLuaSprite('CupThing',true)
            end
        end
    end
end


function onTimerCompleted(tag)
	if tag == 'textSongDestroy' then
		CountTextCompleted = true
		alphaEffectDisable = true
        allowCountdown = true
        startCountdown()
	end
    if tag == 'playBendySongCountDown' then
        playSound('bendy/whoosh')
	end
    if tag == 'CupReady' then
        if songName ~= 'Knockout' then
            playSound('Cup/intros/normal/'..math.random(0,4))
        else
            playSound('Cup/intros/angry/'..math.random(0,1))
        end
        allowCountdown = true
        startCountdown()
        addLuaSprite('CupTitle',true)
		runTimer('CupTitleDestroy',4)
    end
end

local EnableSans = false

function onCreate()
    if difficulty == 2 then
        if songName == 'Whoopee' or songName == 'Sansational' or songName == 'Burning-In-Hell' or songName == 'Final-Strech' or songName == 'Bad-Time' or songName == 'Bad-To-The-Bone' then
            EnableSans = true
        end
    end
end


function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'BlueBoneNote' and EnableSans then
	 setProperty('health',0)
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
    if EnableSans then
        if noteType == 'OrangeBoneNote' or noteType == 'PapyrusNote' then
            setProperty('health',0)
        end
    end
end

local EnableBFFrames = false
local EnableDadFrames = false
local EnabledCharacters = {
    'BF_IC_Cuphead',
    'BF_IC_Rain',
    'BF_Bendy_IC',
    'BF_Bendy_IC_Phase2',
    'BF_Bendy_IC_Phase3',
    'BF_Bendy_NM_Bendy',
    'BF_Sammy',
    'BF_Sans_BS',
    'BF_Sans_Chara',
    'BF_Sans_IC',
    'BF_Sans_WT',
    'BF_Christmas_IC',
    'BoyFriend_DA',
    'BoyFriend_DA - Black and White',
    'BoyFriend_NM',
    'UT-BF',
    'UT-BF_Chara',
    'Bendy_DA',
    'Bendy_DAPhase2',
    'Bendy_IC',
    'Cuphead Pissed',
    'Cuphead',
    'Devil_Cup',
    'Nightmare-Bendy',
    'Nightmare-Cuphead',
    'Nightmare-Sans',
    'Papyrus_IC',
    'Sammy',
    'Sans_IC',
    'Sans_IC_WT',
    'Sans_Phase2_IC',
    'Sans_Phase3',
    'Sans_Phase3_Tired',
    'UT-Sans'}

function onUpdate()
    for Characters = 0,#EnabledCharacters do
        if getProperty('boyfriend.curCharacter') == EnabledCharacters[Characters] then
            EnableBFFrames = true
        end
        if getProperty('dad.curCharacter') == EnabledCharacters[Characters] then
            EnableDadFrames = true
        end
    end
end
function goodNoteHit(id, direction, noteType, isSustainNote)
    if isSustainNote and EnableBFFrames then
        setProperty('boyfriend.animation.curAnim.curFrame',2)
    end
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
    if isSustainNote and EnableDadFrames then
        setProperty('dad.animation.curAnim.curFrame',2)
    end
end

local splashCount = 0;

local splashThing = 'note splash purple 1';

local fuck = 0;

local sickTrack = 0;

local enableNewSystem = true; -- Toggles Psych Splashes or New Splashes On/Off

local texture = 'IC_NoteSplash';


-- No longer messes with your ClientPrefs! Which means Note Splashes no longer randomly turn off!

-- function onCreate()
-- 	preCacheShit()
-- end

function onCreatePost()

	makeAnimatedLuaSprite('noteSplashp', texture, 100, 100);
	addLuaSprite('noteSplashp',false);
	setProperty('noteSplashp.alpha',0.001)
    -- setProperty('noteSplashp.alpha', 0.0)
end

function goodNoteHit(note, direction, type, sus)
	if sickTrack < getProperty('sicks') then
		sickTrack = sickTrack + 1;

		if type == '' then
			spawnCustomSplash(note, direction, type, sus);
		end
	end
end

function spawnCustomSplash(note, direction, type, sus)
	splashCount = splashCount + 1;

	if direction == 0 then
		splashThing = 'note splash purple 1';
	elseif direction == 1 then
		splashThing = 'note splash blue 1';
	elseif direction == 2 then
		splashThing = 'note splash green 1';
	else
		splashThing = 'note splash red 1';
	end

	makeAnimatedLuaSprite('noteSplash' .. splashCount, texture, getPropertyFromGroup('playerStrums', direction, 'x'), getPropertyFromGroup('playerStrums', direction, 'y'));
		
	addAnimationByPrefix('noteSplash' .. splashCount, 'anim', splashThing, 22, false);
	addLuaSprite('noteSplash' .. splashCount);
    -- objectPlayAnimation('noteSplash' .. splashCount, 'anim')

	setProperty('noteSplash' .. splashCount .. '.offset.x', 85);
	setProperty('noteSplash' .. splashCount .. '.offset.y', 85);
	-- setProperty('noteSplash' .. splashCount .. '.scale.y', 0.9);
	-- setProperty('noteSplash' .. splashCount .. '.scale.x', 0.9);
	setProperty('noteSplash' .. splashCount .. '.alpha', 0.6);

	setObjectCamera('noteSplash' .. splashCount, 'hud');
	setObjectOrder('noteSplash' .. splashCount, 9999); -- this better make the splashes go in front-
	setObjectOrder('timeBarBG', 99999);
	setObjectOrder('timeBar', 999999);
	setObjectOrder('timeTxt', 9999999);
end

function onUpdatePost()
	for i = 0, splashCount do
		if getProperty('noteSplash' .. i .. '.animation.curAnim.finished') then
			removeLuaSprite('noteSplash' .. i);
		end
	end
	for s = 0, getProperty('grpNoteSplashes.length')-1 do
		setPropertyFromGroup('grpNoteSplashes', s, 'visible', false);
	end	
end

local changedNotes = -1
local noteStyle = ''

function onUpdate()
    if songName == 'Snake-Eyes' or songName == 'Knockout' or songName == 'Technicolor-Tussle' or songName == 'Devils-Gambit' or songName == 'Satanic-Funkin' then
        changedNotes = 0
        noteStyle = 'Cuphead'

    end
    if changedNotes == 0 then
        for i = 0,7 do
            if noteStyle == 'Cuphead' then
                setPropertyFromGroup('strumLineNotes', i, 'texture', 'cup/Cuphead_NOTE_assets')
            end
        end 
        changedNotes = 1
    end
    if changedNotes >= 0 then
        for j = 0,getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', j, 'noteType') == '' then
                if noteStyle == 'Cuphead' then
                 setPropertyFromGroup('notes', j,'texture','cup/Cuphead_NOTE_assets')
                end
            end
        end
    end
end

local healthBarStyle = ''
function onCreatePost()
    if songName == 'Burning-In-Hell' or songName == 'Final-Stretch' or songName == 'Bad-Time' or songName == 'Whoopee' or songName == 'Sansational' then
		healthBarStyle = 'Sans'

		makeLuaSprite('SansHealthBar', 'health_IC/sanshealthbar', 0, 0)
		setObjectCamera('SansHealthBar', 'hud')
		addLuaSprite('SansHealthBar', true)
	
		makeLuaSprite('SansHealthBarP2','',getProperty('healthBar.x'),getProperty('healthBar.y') - 6.6)
		setObjectCamera('SansHealthBarP2','hud')
		makeGraphic('SansHealthBarP2',getProperty('healthBar.width'),getProperty('healthBar.height'),'FF0000')
		addLuaSprite('SansHealthBarP2',true)
		setObjectOrder('SansHealthBarP2',4)
	
		makeLuaSprite('SansHealthBarP1','',getProperty('healthBar.x'),getProperty('healthBar.y') - 6.6)
		setObjectCamera('SansHealthBarP1','hud')
		makeGraphic('SansHealthBarP1',getProperty('healthBar.width')/2,getProperty('healthBar.height'),'FFFF00')
		addLuaSprite('SansHealthBarP1',true)
		setObjectOrder('SansHealthBarP1',5)
	elseif songName == 'Despair' or songName == 'Nightmare-Run' or songName == 'Last-Reel' or songName == 'Terrible-Sin' or songName == 'imminent-demise' or songName == 'build-our-freaky-machine' then
		healthBarStyle = 'Bendy'
		makeLuaSprite('BendyHealthBar', 'health_IC/bendyhealthbar', 0, 0)
		setObjectCamera('BendyHealthBar', 'hud')
		addLuaSprite('BendyHealthBar', true)
	elseif songName == 'Snake-Eyes' or songName == 'Technicolor-Tussle' or songName == 'Knockout' or songName == 'Devils-Gambit' or songName == 'Satanic-Funkin' then
	    healthBarStyle = 'Cuphead'
		makeLuaSprite('CupheadHealthBar', 'health_IC/cuphealthbar', 0, 0)
		setObjectCamera('CupheadHealthBar', 'hud')
		addLuaSprite('CupheadHealthBar', true)
	end
end

function onUpdate()
	if healthBarStyle == 'Sans' then
		
		setProperty('SansHealthBar.alpha',  getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))



		setProperty('SansHealthBar.x', getProperty('healthBar.x') - 55)
		setProperty('SansHealthBar.y', getProperty('healthBar.y') - 6)

		setProperty('SansHealthBarP1.x',getProperty('healthBar.x'))
		setProperty('SansHealthBarP1.y',getProperty('healthBar.y') - 6.6)
		
		setProperty('SansHealthBarP2.x',getProperty('healthBar.x'))
		setProperty('SansHealthBarP2.y',getProperty('healthBar.y') - 6.6)
	
		
	
		setProperty('SansHealthBar.angle', getProperty('healthBar.angle'))
	
		setObjectOrder('SansHealthBar', 4)

		if getProperty('health') <= 2 then
			scaleObject('SansHealthBarP1',getProperty('health'),getProperty('healthBar.scale.y'))
			scaleObject('SansHealthBarP2',getProperty('healthBar.scale.x'),getProperty('healthBar.scale.y'))
		end
	   
		   setProperty('SansHealthBarP2.width',getProperty('healthBar.width'))
		   setProperty('SansHealthBarP2.height',getProperty('healthBar.height'))
	   
		   setProperty('iconP1.alpha', 0)
		   setProperty('iconP2.alpha', 0)
		   setProperty('healthBar.flipX', true)

	elseif healthBarStyle == 'Bendy' then
	    setProperty('BendyHealthBar.alpha',getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))

		setProperty('BendyHealthBar.x', getProperty('healthBar.x') - 50)

		setProperty('BendyHealthBar.y', getProperty('healthBar.y') - 87)
		setObjectOrder('BendyHealthBar', 4)

    elseif healthBarStyle == 'Cuphead' then
		setProperty('CupheadHealthBar.alpha',getProperty('healthBar.alpha'))

		setProperty('CupheadHealthBar.x', getProperty('healthBar.x') - 25)

		setProperty('CupheadHealthBar.y', getProperty('healthBar.y') - 18)

		setObjectOrder('CupheadHealthBar',4)
	end

	if healthBarStyle ~= '' then

		setProperty('healthBarBG.visible', false)
		setProperty('healthBar.scale.y', 2.2)
		setObjectOrder('healthBar', 3)
		setObjectOrder('healthBarBG', 2)
	end
end

function onCreatePost()
    if songName == 'Snake-Eyes' or songName == 'Technicolor-Tussle' or songName == 'Knockout' or songName == 'Devils-Gambit' or songName == 'Satanic-Funkin' then
        setTextFont('scoreTxt', 'CupheadICFont.ttf')
        setTextFont('timeTxt','CupheadICFont.ttf')
    elseif songName == 'Despair' or songName == 'Nightmare-Run' or songName == 'Last-Reel' or songName == 'Terrible-Sin' or songName == 'imminent-demise' then
        setTextFont('scoreTxt', 'BendyICFont.ttf')
        setTextFont('timeTxt','BendyICFont.ttf')
    elseif songName == 'Burning-In-Hell' or songName == 'Final-Stretch' or songName == 'Bad-Time' or songName == 'Whoopee' or songName == 'Sansational' then
        setTextFont('scoreTxt', 'SansICFont.ttf')
        setTextFont('timeTxt','SansICFont.ttf')
    elseif songName == 'Bonedoggle' or songName == 'Bad-To-The-Bone' then
        setTextFont('scoreTxt', 'PapyrusICFont.ttf')
        setTextFont('timeTxt','PapyrusICFont.ttf')
    end
end

local AlphaEffect = -1
local Timer = 2
local MaxValueEffect = 0.5
function onCreatePost()
    if songName == 'Last-Reel' or songName == 'Nightmare-Run' or songName == 'Despair' or songName == 'Terrible-Sin' or songName == 'imminent-demise' or songName == 'Devils-Gambit' or songName == 'Ritual' or songName == 'Burning-In-Hell' then
        BendyEffect = 1
        makeLuaSprite('BlackSubEffectBendyIC','',0,0)
        makeGraphic('BlackSubEffectBendyIC',screenWidth,screenHeight,'646464')
        setObjectCamera('BlackSubEffectBendyIC','other')
        setProperty('BlackSubEffectBendyIC.alpha',0)
        addLuaSprite('BlackSubEffectBendyIC',true)
        setBlendMode('BlackSubEffectBendyIC','SUBTRACT')
        runTimer('BackToBlackBendy',Timer)
    end
end
function onTimerCompleted(tag)
    if tag == 'BackToWhiteBendy' then
        doTweenAlpha('BlackLightEffect', 'BlackSubEffectBendyIC', 0, Timer,'linear')
        runTimer('BackToBlackBendy',Timer * 1.5)
    end
    if tag == 'BackToBlackBendy' then
        doTweenAlpha('BlackLightEffect', 'BlackSubEffectBendyIC', MaxValueEffect, Timer,'linear')
        runTimer('BackToWhiteBendy',Timer * 1.5)
    end
end