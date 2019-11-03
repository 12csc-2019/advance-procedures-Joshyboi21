-- AS 91897 Advanced Procedure
-- [Josh Cheer]
-- [Game]
-----------------------------------------------------------------------------------------
-- main.lua
-----------------------------------------------------------------------------------------

-- Requires the local libraries
local widget = require("widget")
local physics = require("physics")
physics.start()
physics.setDrawMode( "hybrid" )
-- Constants so there I dont repeat myself
local centerX = display.contentCenterX
local centerY = display.contentCenterY


-- These variables allow charcter choices to be stored in tables
local characterChoice = {}

local nameChoice = {}



display.setDefault("background", 1, 0.5, 0)


local function characterPicker(firstScreen,characterTable)
 	--  counter for the character choice
 	local characterCounter = 1
 	-- settting the character choice to the table number
	characterChoice[1] = characterTable[characterCounter]
	--  displaying the text for the character choice
	local characterText = display.newText(firstScreen,characterTable[1],centerX,centerY + 175,native.systemFont,36)
	-- display the actual charcater image
	local characterImage = display.newImage(firstScreen,"Images/Blue Bunny.png",centerX,centerY)

	
	local function characterButton(event)
		if  event.target.id == "left" and characterCounter > 1 then
 			characterCounter = characterCounter - 1
			characterText.text = characterTable[characterCounter]
			characterImage = display.newImage( "Images/"..characterTable[characterCounter].." Bunny.png",centerX ,centerY)
		elseif event.target.id == "right"  and characterCounter < #characterTable then
			characterCounter = characterCounter + 1
			characterText.text = characterTable[characterCounter]
			characterImage = display.newImage( "Images/"..characterTable[characterCounter].." Bunny.png",centerX ,centerY)	
		end
		--Update value stored in characterTables
		characterChoice[1] = characterTable[characterCounter]
	end
		-- Button to change counter by -1
 	local leftButton = widget.newButton(
 		{
 	    	x = centerX - 100,
 	    	y = centerY + 175,
 	    	id = "left",
 	    	label = "Left",		
 	    	onRelease = characterButton,
 	    	fontSize = 25,
 	    	radius = 30,
 	    	shape = "circle",
 		}
	)
	--Button to change counter by +1
	local rightButton = widget.newButton(
 		{
 	    	x = centerX + 100,
 	    	y = centerY + 175,
 	    	id = "right",
 	    	label = "Right",
 	    	onRelease =  characterButton,
 	    	fontSize = 25,
 	    	radius = 30,
 	    	shape = "circle",
 		}
	)

	-- inserts into group
	firstScreen:insert(leftButton)
	firstScreen:insert(rightButton)
	firstScreen:insert(characterImage)
end

local function displayGameScreen()

	-- creates new group
	local gameScreen = display.newGroup()
	-- displays first level background
	local firstLevel = display.newImage(gameScreen,"Images/background.png")
	-- displays the users chosen character
	local chosenCharacter = display.newImage(gameScreen, "Images/"..characterChoice[1].." Bunny.png",centerX  - 120,centerY - 230 )
	physics.addBody(chosenCharacter)
	chosenCharacter.gravityScale = 0
    

	-- Function to move arround the users character
	local function characterWalking(event)
		if event.target.id == "up" and chosenCharacter.y > centerY - 250 then
			chosenCharacter.y = chosenCharacter.y - 10
		elseif event.target.id == "down" and chosenCharacter.y < centerY + 140 then
			chosenCharacter.y = chosenCharacter.y + 10
		elseif event.target.id == "left" and chosenCharacter.x > centerX - 125 then
			chosenCharacter.x = chosenCharacter.x - 10
		elseif event.target.id == "right" and chosenCharacter.x < centerX + 125 then
			chosenCharacter.x = chosenCharacter.x + 10
		end
	end

	-- Displays the enemy character and adds ohysics to it
	local enemyCharacter = display.newImage(gameScreen, "Images/fox enemy.png",centerX + 85,centerY + 125)
	physics.addBody(enemyCharacter)
	enemyCharacter.gravityScale = 0
	
	-- for loop ot display thwe Trees
	for i = 1, 2 do
		local firstTreei = display.newImage(gameScreen,"Images/Tree.png",math.random(25,325),math.random(50,325))
		physics.addBody(firstTreei, "static",{friction=0.5,bounce = 0.3})
	end

	-- fucntion to end the game when enemy and chosen character touch
	local function characterCollision(event)

	display.remove(gameScreen)
	local endText = display.newText("Game Over",centerX,centerY,native.systemFont,36)

	end
	-- event listener to add the collision to the function
	chosenCharacter.collision = characterCollision
	chosenCharacter:addEventListener("collision")
-- timer allows the enemy character to move towards chosen character
	local mag = 10
	timer.performWithDelay(1000, function()
		-- chosenCharacter
		--enemyCharacter.x = 
		local xDiff = math.abs(enemyCharacter.x - chosenCharacter.x) / (enemyCharacter.x - chosenCharacter.x)
		enemyCharacter.x = enemyCharacter.x - xDiff * mag
		-- print(math.abs(enemyCharacter.x - chosenCharacter.x) / (enemyCharacter.x - chosenCharacter.x))

		local yDiff = math.abs(enemyCharacter.y - chosenCharacter.y) / (enemyCharacter.y - chosenCharacter.y)
		enemyCharacter.y = enemyCharacter.y - yDiff * mag
	end,

	 0)


	-- Buttons to move the character
	local upButton = widget.newButton(
		{

			x = centerX,
			y = centerY + 175,
			id = "up",
			label = "up",
			onPress = characterWalking,
			fontSize = 15,
			radius = 20,
			shape = "circle",
		}
	)

	local downButton = widget.newButton(
		{

			x = centerX ,
			y = centerY + 250,
			id = "down",
			label = "down",
			onPress = characterWalking,
			fontSize = 15,
			radius = 20,
			shape = "circle",
		}
	)

	local leftButton = widget.newButton(
		{

			x = centerX - 35,
			y = centerY + 212.5,
			id = "left",
			label = "left",
			onPress = characterWalking,
			fontSize = 15,
			radius = 20,
			shape = "circle",
		}
	)

	local rightButton = widget.newButton(
		{

			x = centerX + 35,
			y = centerY + 212.5,
			id = "right",
			label = "right",
			onRelease = characterWalking,
			fontSize = 15,
			radius = 20,
			shape = "circle",
		}
	)

	-- add to group
	gameScreen:insert(upButton)
	gameScreen:insert(downButton)
	gameScreen:insert(rightButton)
	gameScreen:insert(leftButton)

end


local function characterTextBox(firstScreen)

	-- text for name choice
	local nameText = display.newText(firstScreen,"Enter your characters name",centerX,centerY  - 225,native.systemFont,24)
		
	-- textbox for user to input character name

	local characterName = native.newTextField(0,0, 275, 45)
	characterName.x = centerX
	characterName.y = (centerY - 175)
	firstScreen:insert(characterName)


	return characterName
end

local function doneButton(firstScreen,characterName)

	-- fucntion to verify done button
	local function doneButtonEvent(event)
		if characterName.text == "" then
			local alert = native.showAlert("Error", "No name value entered")
		elseif string.len (characterName.text) > 15 then
			local alert =  native.showAlert("Error"," Name must be less than 15 characters")
		elseif string.len (characterName.text) < 3 then
			local alert = native.showAlert("Error","Name must be 3 or more characters")
		else 
			nameChoice[1] = characterName.text
			display.remove(firstScreen)
			displayGameScreen()
		end

	end


	local doneButton = widget.newButton(
	{ 	
    	x = centerX ,
    	y = centerY + 250,
        id = "done",
        label = "Done",
        onRelease = doneButtonEvent,
        fontSize = "32",

	})

	firstScreen:insert(doneButton)
end



local function mainLoop()
	-- group for the first screen when the user boots up the program
	local firstScreen =  display.newGroup()
	--  Table for the character choice optons to be stored in
	local characterTable = {"Blue","Red","Green","Purple"}

	local characterName = characterTextBox(firstScreen)
	-- running the characterpicker function while passing over group and table
	characterPicker(firstScreen,characterTable)

	doneButton(firstScreen,characterName)
end

mainLoop()
