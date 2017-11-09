local widget = require("widget")
appoint={}

local appointLayer = nil
local maxMin = 8
local logoIconPath = "icon_res/logo.png"
local alertIconPath = "icon_res/alert.png"
local cancelTimer = nil

local function drawNavi(parent)
	local background = display.newRect(parent,X,Y,width,height)
	background:setFillColor(color("white"))

	local panelbg = display.newRect(parent,X,(86+SH)*0.5 - offsetY,width,86+SH)
	panelbg:setFillColor(color("blue"))

	local logo = display.newImageRect(parent,logoIconPath,50,50)
	logo.x,logo.y = X , SH+33-offsetY

	local panel = display.newRoundedRect(parent,X,140+150,400,280,6)
	panel:setStrokeColor(color("gray"))
	panel.strokeWidth = 1

	local titleArgs = {
		text = "待服务",
		x = X,
		y = 190,
		font = native.systemFont,
		fontSize = 28
	}
	local title = display.newText(titleArgs)
	title:setFillColor(color("green"))
	parent:insert(title)
end

local function CountDown(parent)
	local timePanelArgs = {
		text = "倒计时",
		x = 100,
		y = 250,
		align = "left",
		font = native.systemFont,
		fontSize = 20
	}
	local timePanel = display.newText(timePanelArgs)
	timePanel:setFillColor(color("blue"))
	parent:insert(timePanel)

	local timeArgs = {
		text = "08分00秒",
		x = 260,
		y = 250,
		align = "left",
		font = native.systemFont,
		fontSize = 24
	}
	local timePanel = display.newText(timeArgs)
	timePanel:setFillColor(color("green"))
	parent:insert(timePanel)

	local function timeCallback(data)
		local timestr = data['data'][1]['time']
		local res, len = Util:split(timestr,":")

		local date = os.date("*t")
		date.hour = tonumber(res[1])
		date.min = tonumber(res[2])
		date.sec = tonumber(res[3])
		date.min = date.min + 8
		local t3 = os.time(date)

		local now = os.date("*t")
		local t2 = os.time(now)

		local dsf = os.difftime(t3,t2)
		local min = math.modf(dsf/60)
		local sec = dsf % 60
		local minute = min
		local seconds = sec
		if string.len(min) < 2 then
			minute = "0"..min
		end
		if string.len(sec) < 2 then
			seconds = "0"..sec
		end
		timePanel.text = minute.."分"..seconds.."秒"
		if dsf <= 0 then
			timer.cancel(cancelTimer)
			Util:PopNotice(appointLayer,"超时没有赶到浴室，已经自动取消")
			display.remove(appointLayer)
			appointLayer = nil
			Mains:Init(baseLayer)
		end
	end

	local name = Util:getNativeValue("name")
	local sql = "select%20time%20from%20date_queue%20where%20name%20='"..name.."'"
	local url = "/bathtime/list.php?sql="..sql
	
	local function  timerListener(event)
		Util:NetworkList(url,"GET",timeCallback)
	end
	cancelTimer = timer.performWithDelay(1000,timerListener,0)
end

local function drawMesgPanel(parent,cell_id)
	local cellArgs = {
		text = "浴位编号",
		x = 100,
		y = 310,
		align = "left",
		font = native.systemFont,
		fontSize = 20
	}
	local cellPanel = display.newText(cellArgs)
	cellPanel:setFillColor(color("blue"))
	parent:insert(cellPanel)

	local seqArgs = {
		text = "",
		x = 260,
		y = 310,
		align = "left",
		font = native.systemFont,
		fontSize = 20
	}
	local seq_panel = display.newText(seqArgs)
	seq_panel:setFillColor(color("black"))
	parent:insert(seq_panel)

	local room = Util:getNativeValue("room")

	if cell_id then
		selectCellId = cell_idToindex[cell_id]
	end
	if selectCellId then
		seq_panel.text = room..selectCellId.."号"
	end

	local houseArgs = {
		text = "浴室位置",
		x = 100,  
		y = 370,
		font = native.systemFont,
		fontSize = 20
	}
	local housePanel = display.newText(houseArgs)
	housePanel:setFillColor(color("blue"))
	parent:insert(housePanel)

	local housemesg = {
		text = "",
		x = 260,  
		y = 370,
		font = native.systemFont,
		fontSize = 20
	}
	local housename = display.newText(housemesg)
	housename:setFillColor(color("black"))
	parent:insert(housename)

	local house = Util:getNativeValue("house")
	local floor = Util:getNativeValue("floor")
	housename.text = house..floor

end

local function drawHint(parent)

	local hintPanel = display.newRoundedRect(parent,X,500,400,80,6)
	hintPanel:setStrokeColor(255/255,206/255,68/255)
	hintPanel.strokeWidth = 1

	local alert = display.newImageRect(parent,alertIconPath,48,48)
	alert.x,alert.y = 70,500

	local hintArgs = {
		text = "请在规定时间内到达浴室，预期将自动取消",
		x = X,
		y = 500,
		width = 250,
		align = "left",
		font = native.systemFont,
		fontSize = 18
	}
	local hint = display.newText(hintArgs)
	hint:setFillColor(color("black"))
	parent:insert(hint)
end

local function CancelNetwork(data)
	if(data.status == "true") then
		timer.cancel(cancelTimer)
		Util:PopNotice(appointLayer,"取消预约成功")
		display.remove(appointLayer)
		appointLayer = nil
		Mains:Init(baseLayer)
	end
end

local function CancelDate(parent)
	local function handleCancelEvent(event)
		if event.phase == "ended" then
			local cell_id = Util:getNativeValue("cell_id")
			local name = Util:getNativeValue("name")
			local url = "/bathtime/cancel_date.php?cell_id="..cell_id.."&name='"..name.."'"
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

function appoint:Init(cell_id)
	appointLayer = display.newGroup()
	baseLayer:insert(appointLayer)
	drawNavi(appointLayer)
	CountDown(appointLayer)
	drawMesgPanel(appointLayer,cell_id)
	drawHint(appointLayer)
	CancelDate(appointLayer)

end