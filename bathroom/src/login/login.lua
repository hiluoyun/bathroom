local widget = require( "widget" )
local json = require("json")

Login = 
{

}
local loginUrl = "/bathtime/login.php"
local registerUrl = "/bathtime/register.php"
local locationUrl = "/bathtime/list.php"

local loginLayer = nil
local maskPath = "picture_res/mask.png"
local portraitPath = "picture_res/head.jpg"
local userIconPath = "icon_res/user.png"
local passwordIconPath = "icon_res/password.png"
local positionIconPath = "icon_res/position.png"

local inputPassword = nil
local inputName = nil
local username = nil
local registerName = nil
local registerPassword = nil
local errorMessage = "帐号或者密码错误"
local wheelButton = nil
local pickerWheel = nil
local pickerValues = nil

local localMap = {}
local location = nil
local sex = 1

local function SubmitRegister(parent,name,password)
	if not (name and password and sex and location) then
		Util:PopNotice(parent,"请填写必要信息")
		return nil
	end

	local url = registerUrl.."?username="..tostring(name).."&password="..tostring(password)
	url = url.."&sex="..tostring(sex).."&location="..tostring(location)

	local function registerCallback(data)
		if(data ~= nil)then
			if(data['status'] == "true") then
				Util:setNativeValue("islogin",true)
				Util:setNativeValue("name",name)
				Util:setNativeValue("sex",sex)
				Util:setNativeValue("user_id",data['user_id'])
				Util:setNativeValue("location_id",location)
				Util:setNativeValue("location",pickerValues[1].value)

				Util:PopNotice(parent,"注册成功")
				if(registerName ~= nil) then
					registerName:removeSelf()
					registerName =nil
					registerPassword:removeSelf()
					registerPassword = nil
				end
				display.remove(parent)
				parent = nil
				Mains:Init(baseLayer)
			else
				Util:PopNotice(parent,"注册失败")
			end
		end
	end

	Util:NetworkDatabase(parent,url,"GET",registerCallback)
end



local function confirmWheel(parent)
	-- set constant here
	pickerValues = pickerWheel:getValues()
	location = localMap[pickerValues[1].index]
	local str = pickerValues[1].value
	wheelButton:setLabel(str)
	if(parent ~= nil) then
		display.remove(parent)
		parent = nil
	end
end

local function DrawlocationWheel(parent,data)
	local maskLayer = nil
	local function removeListener(event)
		if(maskLayer ~= nil) then
			display.remove(maskLayer)
			maskLayer = nil
		end

	end
	maskLayer = Util:AddMask(parent,removeListener)
	local columnData = 
	{ 
    	{ 
        	align = "left",
        	width = 400,
        	labelPadding = 200,
        	startIndex = 1,
        	labels = {}
    	}
	}
	for k,v in pairs(data) do
		localMap[k] = v['id']
		columnData[1].labels[k] = v['name']
	end

	pickerWheel = widget.newPickerWheel(
	{
    	left = 0-offsetX,
    	top = height-200,
    	columns = columnData,
    	style = "resizable",
    	width = width+40,
    	rowHeight = 40,
    	font = native.systemFont,
    	fontSize = 24
	})
	maskLayer:insert(pickerWheel)

	local function confirmListener(event)
		if("ended" == event.phase) then
			confirmWheel(maskLayer)
		end
		return true
	end

	local confirm = widget.newButton(
    {
        x = 480 + offsetX - 60,
		y = height - 200+30,
        label = "确认",
        width = 100,
        labelColor = { default={ color("black") }, over={0.9 } },
        font = native.systemFont,
        fontSize = 24,
        onEvent = confirmListener
    }
	)
	maskLayer:insert(confirm)

	local function cancelListener(event)
		if("ended" == event.phase) then
			removeListener(event)
		end
		return true
	end
	local cancel = widget.newButton(
    {
        x = 60-offsetX,
		y = height - 200 + 30,
        label = "取消",
        width = 100,
        labelColor = { default={ color("black") }, over={0.9 } },
        font = native.systemFont,
        fontSize = 24,
        onEvent = cancelListener
    }
	)
	maskLayer:insert(cancel)
end

local function locationNetwork(parent)
	local sql = "SELECT%20*%20FROM%20bath_location"
	local url = "/bathtime/list.php?sql="..sql
	local function callback(data)
		if(data ~= nil) then
			if(data['status'] == "true") then
				DrawlocationWheel(parent,data['data'])
			end
		end
	end
	Util:NetworkDatabase(parent,url,"GET",callback)
end

local function DrawSelection(parent)
	local position = display.newImageRect(parent,positionIconPath,32,32)
	position.x,position.y = 50,180

	local  tables = {
		text = "位置",
		x = 85,
		y = 180,
		font = native.systemFont,
		fontSize = 20,
		-- align = "left"
	}
	local text = display.newText(tables)
	text:setFillColor(color("green"))
	parent:insert(text)

	local function handleButtonEvent( event )
		if ( event.phase == "ended" ) then
    		locationNetwork(parent)
		end
		return true
	end
	 
	wheelButton = widget.newButton(
    	{
        	label = "-请选择-",
        	labelColor = { default={color("black")}, over={ 0.9 } },
        	font = native.systemFont,
        	onEvent = handleButtonEvent,
        	emboss = true,
        	shape = "roundedRect",
        	width = 160,
        	height = 30,
        	cornerRadius = 4,
        	fillColor = { default={1,1,1,1}, over={0.9} },
        	strokeColor = { default={color("gray")}, over={0.8,0.8,1,1} },
        	strokeWidth = 1
    	}
	)
	 
	wheelButton.x = 210
	wheelButton.y = 180
	 
	parent:insert(wheelButton)


 	local function onSwitchPress( event )
    	local switch = event.target
    	sex = switch.id
    	-- print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
	end
	 
	local radioButton1 = widget.newSwitch(
    	{
        	x = 50,
        	y = 230,
        	width = 30,
        	height = 30,
        	style = "radio",
        	id = "1",
        	initialSwitchState = true,
        	onPress = onSwitchPress
    	}
	)
	parent:insert( radioButton1 )

	local  table1 = {
		text = "帅哥",
		x = 94,
		y = 230,
		font = native.systemFont,
		fontSize = 20,
	}
	local radioText1 = display.newText(table1)
	radioText1:setFillColor(color("black"))
	parent:insert(radioText1)
	 
	local radioButton2 = widget.newSwitch(
    	{
        	x = 240,
        	y = 230,
        	width = 30,
        	height = 30,
        	style = "radio",
        	id = "0",
        	onPress = onSwitchPress
    	}
	)
	parent:insert( radioButton2 )

	local  table2 = {
		text = "美眉",
		x = 240+44,
		y = 230,
		font = native.systemFont,
		fontSize = 20,
	}
	local radioText2 = display.newText(table2)
	radioText2:setFillColor(color("black"))
	parent:insert(radioText2)
end

local function register(parent)
	display.setStatusBar( display.TranslucentStatusBar)
	
	local registerLayer = Util:AddPage(parent,"注册")


	DrawSelection(registerLayer)


	registerName = native.newTextField( 50+180+30, 290, 360-30, 36 )
	registerName.font = native.newFont( native.systemFont, 22 )
	registerName:resizeHeightToFitFont()
	-- registerName.size = 30
	registerName.hasBackground = false
	registerName.inputType = "email"
	registerName.placeholder =" 请输入邮箱/手机号码"
	registerLayer:insert(registerName)

	local userIcon = display.newImageRect(registerLayer,userIconPath,32,32)
	userIcon.x,userIcon.y = 50 , 290

	local nameLine  = display.newLine(registerLayer,45,312,410,312)
	nameLine:setStrokeColor( color("gray") ,1 )
	nameLine.strokeWidth = 1


	registerPassword = native.newTextField( 50+180+30, 350, 360-30, 36 )
	registerPassword.font = native.newFont( native.systemFont, 22 )
	registerPassword:resizeHeightToFitFont()
	registerPassword.isSecure = true
	registerPassword.hasBackground = false
	registerPassword.placeholder = " 请输入密码"
	registerLayer:insert(registerPassword)


	local passwrodIcon = display.newImageRect(registerLayer,passwordIconPath,32,32)
	passwrodIcon.x,passwrodIcon.y = 50 , 350

	local passwordLine = display.newLine(registerLayer,45,372,410,372)
	passwordLine:setStrokeColor( color("gray") ,1)
	passwordLine.strokeWidth = 1

	local function nameListener(event)
		if(event.phase == "ended" or event.phase == "submitted") then
			-- native.setKeyboardFocus( registerPassword )
		elseif(event.phase == "editing") then
			if(string.len(event.target.text)>22) then
                event.target.text = string.sub(event.target.text,1,string.len(event.target.text)-1)
            end
		end
	end

	local function passwordListener(event)
		if(event.phase == "ended" or event.phase == "submitted") then
			-- native.setKeyboardFocus(nil)
		elseif("editing" == event.phase)then
			if(string.len(event.target.text)>22) then
                event.target.text = string.sub(event.target.text,1,string.len(event.target.text)-1)
            end
		end
	end

	registerName:addEventListener( "userInput", nameListener )
	registerPassword:addEventListener("userInput",passwordListener)
	

	local function registerListener(event)
		if("ended" == event.phase) then
			local nameString = registerName.text
			local passwordString = registerPassword.text
			SubmitRegister(registerLayer,nameString,passwordString)
		end	
	end

	local registerButton = widget.newButton(
    {
        label = "提交注册",
        onEvent = registerListener,
        emboss = false,
        shape = "roundedRect",
        font = native.systemFontBold,
        fontSize = 24,
        labelColor = { default={1,1,1}, over={1,1,1,0.4} },
        width = 360,
        height = 60,
        cornerRadius = 4,
        fillColor = { default={131/255,216/255,67/255,1}, over={131/255,216/255,67/255,0.4} },
    }
	)
	registerButton.x = X
	registerButton.y = 430
	registerLayer:insert(registerButton)

end




local function CheckUser(parent,name,password)
	local url = loginUrl.."?username="..tostring(name).."&password="..tostring(password)

	local function LoginCallback(data)
		if(data ~= nil) then
			if( data['status'] =="true") then
				
				Util:setNativeValue("islogin",true)
				Util:setNativeValue("name",data['username'])
	
				if(inputName ~= nil and inputPassword ~= nil) then
					inputName:removeSelf()
					inputName = nil
					inputPassword:removeSelf()
					inputPassword = nil
				end
				display.remove(parent)
				parent = nil
				Mains:Init(baseLayer)
			else
				Util:PopNotice(loginLayer,errorMessage)
			end
		end
	end

	Util:NetworkDatabase(parent,url,"GET",LoginCallback)
end

local function NativeInputDraw(parent)


	local profile = display.newImage(portraitPath)
	
	local container = display.newContainer(200,200)
	container:translate(X,100+20-offsetY+SH)
	local w ,h = profile.contentWidth,profile.contentHeight
	profile.xScale,profile.yScale = 200/w,200/h
	parent:insert(container)
	container:insert(profile)


	-- userName = display.newText( "帐号", 100,290,80,32, native.systemFontBold, 26 )
	-- userName:setFillColor( Util:color(131,216,67))
	-- parent:insert(userName)

	-- password = display.newText("密码",100,350,80,32,native.systemFontBold,26)
	-- password:setFillColor( Util:color(131,216,67))
	-- parent:insert(password)


	inputName = native.newTextField( 50+180+30, 290, 360-30, 36 )
	inputName.font = native.newFont( native.systemFont, 22 )
	inputName:resizeHeightToFitFont()
	inputName.hasBackground = false
	inputName.inputType = "email"
	inputName.placeholder =" 邮箱/手机号码"
	parent:insert(inputName)


	local userIcon = display.newImageRect(parent,userIconPath,32,32)
	userIcon.x,userIcon.y = 50 , 290

	local nameLine = display.newLine(parent,45,312,410,312)
	nameLine:setStrokeColor( color("gray") ,1 )
	nameLine.strokeWidth = 1




	inputPassword = native.newTextField( 50+180+30, 350, 360-30, 36 )
	inputPassword.font = native.newFont( native.systemFont, 22 )
	inputPassword:resizeHeightToFitFont()
	inputPassword.isSecure = true
	inputPassword.hasBackground = false
	inputPassword.placeholder = " 密码"
	parent:insert(inputPassword)

	local passwrodIcon = display.newImageRect(parent,passwordIconPath,32,32)
	passwrodIcon.x,passwrodIcon.y = 50 , 350

	local passwordLine = display.newLine(parent,45,372,410,372)
	passwordLine:setStrokeColor( color("gray") ,1)
	passwordLine.strokeWidth = 1

	local function nameListener(event)
		if(event.phase == "ended" or event.phase == "submitted") then
			-- native.setKeyboardFocus( inputPassword )
		elseif(event.phase == "editing") then
			if(string.len(event.target.text)>22) then
                event.target.text = string.sub(event.target.text,1,string.len(event.target.text)-1)
            end
		end
	end

	local function passwordListener(event)
		if(event.phase == "ended" or event.phase == "submitted") then
			-- native.setKeyboardFocus(nil)
		elseif("editing" == event.phase)then
			if(string.len(event.target.text)>22) then
                event.target.text = string.sub(event.target.text,1,string.len(event.target.text)-1)
            end
		end
	end

	inputName:addEventListener( "userInput", nameListener )
	inputPassword:addEventListener("userInput",passwordListener)
	

	local function loginListener(event)
		if("ended" == event.phase) then
			local nameString = inputName.text
			local passwordString = inputPassword.text
			CheckUser(parent,nameString,passwordString)
		end	
	end

	local loginButton = widget.newButton(
    {
        label = "登录",
        onEvent = loginListener,
        emboss = false,
        shape = "roundedRect",
        font = native.systemFontBold,
        fontSize = 24,
        labelColor = { default={1,1,1}, over={1,1,1,0.4} },
        width = 360,
        height = 60,
        cornerRadius = 4,
        fillColor = { default={131/255,216/255,67/255,1}, over={131/255,216/255,67/255,0.4} },
    }
	)
	loginButton.x = X
	loginButton.y = 430
	parent:insert(loginButton)

	local text =  display.newText( parent,"还没有帐号?-注册", X+96, 482, native.systemFont, 21 )
	text:setFillColor( 131/255,216/255,67/255,1 )
	local function testListener(event)
		if("ended"== event.phase)then
			register(parent)
		end
		return true		
	end
	text:addEventListener("touch",testListener)

	
end

function Login:Init(parent)
	display.setStatusBar( display.DarkStatusBar)
	

	loginLayer = display.newGroup()
	parent:insert(loginLayer)
	local background = display.newRect(loginLayer,X,Y,width,height)
	background:setFillColor(Util:color(245,245,245))

	NativeInputDraw(loginLayer)
end