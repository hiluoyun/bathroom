local widget = require("widget")
wait={}


local waitLayer = nil
local logoIconPath = "icon_res/logo.png"
local alertIconPath = "icon_res/alert.png"
local spinIconPath = "icon_res/spin.png"
local waitTimer = nil
local timeTotal = 1000*120

local function drawNavi(parent)
	local background = display.newRect(parent,X,Y,width,height)
	background:setFillColor(color("white"))

	local panelbg = display.newRect(parent,X,(86+SH)*0.5 - offsetY,width,86+SH)
	panelbg:setFillColor(color("blue"))

	local logo = display.newImageRect(parent,logoIconPath,50,50)
	logo.x,logo.y = X , SH+33-offsetY

	local panel = display.newRoundedRect(parent,X,140+120,400,240,6)
	panel:setStrokeColor(color("blue"))
	panel.strokeWidth = 1

	local titleArgs = {
		text = "排队中",
		x = X,
		y = 190,
		font = native.systemFont,
		fontSize = 28
	}
	local title = display.newText(titleArgs)
	title:setFillColor(color("green"))
	parent:insert(title)

	local positionArgs = {
		text = "当前位置",
		x = 110,
		y = 250,
		font = native.systemFont,
		fontSize = 22
	}
	local position = display.newText(positionArgs)
	position:setFillColor(color("green"))
	parent:insert(position)

	local estimateArgs = {
		text = "预计时间",
		x = 110,
		y = 310,
		font = native.systemFont,
		fontSize = 22
	}
	local estimate = display.newText(estimateArgs)
	estimate:setFillColor(color("green"))
	parent:insert(estimate)

	local options={
		width = 48,
    	height = 48,
    	numFrames = 1,
    	sheetContentWidth = 48,
    	sheetContentHeight = 48
	}

	local loadingSheet = graphics.newImageSheet(spinIconPath,options)

	spinner = widget.newSpinner(
    {
        width = 32,
        height = 32,
        sheet = loadingSheet,
        startFrame = 1,
        deltaAngle = 10,
        incrementEvery = 30
    }
	)
	spinner.x,spinner.y = 80,190
	parent:insert(spinner)
	spinner:start()

	local hintPanel = display.newRoundedRect(parent,X,450,400,80,6)
	hintPanel:setStrokeColor(255/255,206/255,68/255)
	hintPanel.strokeWidth = 1

	local alert = display.newImageRect(parent,alertIconPath,48,48)
	alert.x,alert.y = 70,450

	local hintArgs = {
		text = "自动排队，将自动飞配空闲浴位，先排队者优先分配",
		x = X,
		y = 450,
		width = 250,
		align = "left",
		font = native.systemFont,
		fontSize = 18
	}
	local hint = display.newText(hintArgs)
	hint:setFillColor(color("black"))
	parent:insert(hint)
end

local function drawDetail(parent)
	local positionArgs = {
		text = "0",
		x = 260,
		y = 250,
		font = native.systemFont,
		fontSize = 22
	}
	local position = display.newText(positionArgs)
	position:setFillColor(color("black"))
	parent:insert(position)

	local estimateArgs = {
		text = "00分00秒",
		x = 260,
		y = 310,
		font = native.systemFont,
		fontSize = 22
	}
	local estimate = display.newText(estimateArgs)
	estimate:setFillColor(color("black"))
	parent:insert(estimate)

	local name = Util:getNativeValue("name")
	local sex = Util:getNativeValue("sex")
	local url = "/bathtime/wait_detail.php?name="..name.."&sex="..sex

	local function timeCallback(data)
		if data.status == "true" then
			local dsf = tonumber(data.estimate)
			if timeTotal > dsf then
				timeTotal = dsf
			end
			position.text = data.position

			timeTotal = timeTotal - 1
			if timeTotal <= 0 then
				timeTotal = 0
			end
			local min = math.modf(timeTotal/60)
			local sec = timeTotal % 60
			if string.len(min) < 2 then
				min = "0"..min
			end
			if string.len(sec) < 2 then
				sec = "0"..sec
			end
			estimate.text = min.."分"..sec.."秒"
		end
		if data.status == "success" then
			timer.cancel(waitTimer)
			Util:PopNotice(parent,"预约成功")
			display.remove(parent)
			parent = nil
			Util:setNativeValue("cell_id",tonumber(data.cell_id))
			appoint:Init(tonumber(data.cell_id))
		end
	end

	local function  timerListener(event)
		Util:NetworkList(url,"GET",timeCallback)
	end
	waitTimer = timer.performWithDelay(1000,timerListener,0)
end

local function CancelNetwork(data)
	if(data.status == "true") then
		timer.cancel(waitTimer)
		Util:PopNotice(waitLayer,"取消排队成功")
		display.remove(waitLayer)
		waitLayer = nil
		Mains:Init(baseLayer)
	end
end

local function WaitQueue(parent)
	local function handleCancelEvent(event)
		if event.phase == "ended" then
			local name = Util:getNativeValue("name")
			local url = "/bathtime/cancel_wait.php?name="..name
			Util:NetworkDatabase(parent,url,"GET",CancelNetwork)
		end
	end

	local options = {
		label = "取消",
    	onEvent = handleCancelEvent,
    	emboss = false,
    	shape = "roundedRect",
    	width = 440,
    	height = 68,
    	cornerRadius = 6,
    	font = native.systemFont,
    	fontSize = 30,
    	labelColor = {default = {1, 1, 1}, over = {1, 1, 1, 0.8}},
    	fillColor = { default={131/255,216/255,67/255}, over={131/255,216/255,67/255,0.8} },
	}

	local Button = widget.newButton(options)
	Button.x = X
	Button.y = 700
	parent:insert(Button)
end

function wait:init()
	waitLayer = display.newGroup()
	baseLayer:insert(waitLayer)
	drawNavi(waitLayer)
	drawDetail(waitLayer)
	WaitQueue(waitLayer)
end