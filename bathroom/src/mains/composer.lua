local widget = require( "widget" )
local json = require( "json" )
require( "src.mains.appointment")
require ( "src.mains.waitqueue")
Composer={}

local ringIconPath = "icon_res/ring.png"
local arrowIconPath = "icon_res/arrow.png"
local usedIconPath = "icon_res/used.png"
local idleIconPath = "icon_res/idle.png"
local closeIconPath = "icon_res/close.png"

local dataListUrl = "/bathtime/list.php"

local maskLayer = nil 
local scrollLayer = nil

local magic = {
	house = {
		button = nil,
		indexToid = {},
		indexToname = {},
		wheel=nil
	},
	floor = {
		button = nil,
		indexToid = {},
		indexToname = {},
		wheel=nil	
	},
	room = {
		button = nil,
		indexToid = {},
		indexToname = {},
		wheel=nil
	}
}

local saveSelectIndex = {}
local tagLable = nil
local tagLine = nil
local houseText = nil
local roomText = nil

local cell_position={}

for i = 1, 12 do
	cell_position[i] = {}
	cell_position[i].x = offsetX + 75 + ((i-1)%4)*110
	local int = math.modf((i-0.5)/4)
	cell_position[i].y = 240 + int*120
end


function Composer:DrawNotice(parent)
	local notice = display.newRect(X+offsetX,26,width,40)
	notice:setFillColor(color("gray"))
	parent:insert(notice)

	local options={
		x = X,
		y = 26,
		text = "欢迎使用掌上澡堂",
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 20,
}
	local noticeText = display.newText(options)
	noticeText:setFillColor(color("black"))

	parent:insert(noticeText)
	local function moveText(event)
		if mainsLayer == nil then
			Runtime:removeEventListener( "enterFrame", moveText )
		else
			noticeText.x = noticeText.x - 2
			if(noticeText.x < -noticeText.contentWidth * 0.5 - offsetX -10 )then
				noticeText.x = noticeText.contentWidth * 0.5 + offsetX + width + 20
			end
		end
	end
	Runtime:addEventListener( "enterFrame", moveText );
end
--start cell


local function shiftUsedIcon(parent,obj,id)
	local x = cell_position[id].x
	local y = cell_position[id].y
	obj['button']:setEnabled(false)

	display.remove(obj['icon'])
	obj['icon'] = nil
	obj['icon'] = display.newImageRect(usedIconPath,26,26)
	obj['icon'].x,obj['icon'].y = x , y - 12
	parent:insert(obj['icon'])

	obj['rect']:setFillColor(color("red"))
	obj['font']:setFillColor(1,1,1)

end

local function shiftSelectedIcon(parent,obj,id)
	local x = cell_position[id].x
	local y = cell_position[id].y

	display.remove(obj['icon'])
	obj['icon'] = nil
	obj['icon'] = display.newImageRect(idleIconPath,26,26)
	obj['icon'].x,obj['icon'].y = x , y - 12
	parent:insert(obj['icon'])

	obj['rect']:setFillColor(color("green"))
	obj['font']:setFillColor(color("black"))
end

local function shiftIdleIcon(parent,obj,id)
	local x = cell_position[id].x
	local y = cell_position[id].y

	display.remove(obj['icon'])
	obj['icon'] = nil
	obj['icon'] = display.newImageRect(idleIconPath,26,26)
	obj['icon'].x,obj['icon'].y = x , y - 12
	parent:insert(obj['icon'])

	obj['rect']:setFillColor(1,1,1)
	obj['font']:setFillColor(color("black"))
end

local function handleCellEvent(event)
	local id = tonumber( event.target.id)
	if "ended" == event.phase then
		if selectCellId ~= nil then
			shiftIdleIcon(scrollLayer,All_cell[selectCellId],selectCellId)
		end
		if selectCellId == id then
			selectCellId = nil
		else
			selectCellId = id
			shiftSelectedIcon(scrollLayer,All_cell[id],id)
		end
	end
	return true
end

local function drawUsedIcon(parent,id)
	local usedLayer = {}
	local usedButton = widget.newButton(
    	{
        	onEvent = handleCellEvent,
        	emboss = false,
        	id = tostring(id),
        	shape = "roundedRect",
        	width = 60,
        	height = 60,
        	cornerRadius = 4,
        	-- fillColor = { default={1,0,0,1}, over={0.8} },
        	strokeColor = { default={color("gray")}, over={0.8} },
        	strokeWidth = 1
    	}
	)
	local x = cell_position[id].x
	local y = cell_position[id].y
	usedButton.x = x
	usedButton.y = y
	usedButton:setEnabled(false)
	parent:insert(usedButton)
	 
	local used = display.newRoundedRect(x,y,60,60,4)
	used:setFillColor(color("red"))
	parent:insert(used)

	local shower = display.newImageRect(usedIconPath,26,26)
	shower.x,shower.y = x , y - 12
	parent:insert(shower)

	local options={
		text = tostring(id),
		x = x,
		y = y + 16,
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 12
	}
	local sequence = display.newText(options)
	parent:insert(sequence)

	usedLayer['button'] = usedButton
	usedLayer['rect'] = used
	usedLayer['icon'] = shower
	usedLayer['font'] = sequence
	return usedLayer
end

local function drawIdleIcon(parent,id)
	local idleLayer= {}

	local idleButton = widget.newButton(
    	{
        	onEvent = handleCellEvent,
        	emboss = false,
        	id = tostring(id),
        	shape = "roundedRect",
        	width = 60,
        	height = 60,
        	cornerRadius = 4,
        	-- fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        	strokeColor = { default={color("gray")}, over={0.8} },
        	strokeWidth = 1
    	}
	)
	local x = cell_position[id].x
	local y = cell_position[id].y
	idleButton.x = x
	idleButton.y = y
	parent:insert(idleButton)

	local idle = display.newRoundedRect(x,y,60,60,4)

	parent:insert(idle)

	local shower = display.newImageRect(idleIconPath,26,26)
	shower.x,shower.y = x,y-12
	parent:insert(shower)

	local options = {
		text = tostring(id),
		x = x,
		y = y +16,
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 12
	}
	local sequence = display.newText(options)
	sequence:setFillColor(color("black"))
	parent:insert(sequence)

	idleLayer['button'] = idleButton
	idleLayer['rect'] = idle
	idleLayer['icon'] = shower
	idleLayer['font'] = sequence

	return idleLayer
end


-- local function drawSelectedIcon(parent,x,y,id)
-- 	local selectedLayer = {}

-- 	local selectedButton = widget.newButton(
--     	{
--         	onEvent = handleCellEvent,
--         	emboss = false,
--         	shape = "roundedRect",
--         	id = id,
--         	width = 60,
--         	height = 60,
--         	cornerRadius = 4,
--         	-- fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
--         	strokeColor = { default={color("gray")}, over={0.8} },
--         	strokeWidth = 1
--     	}
-- 	)
-- 	selectedButton.x = x
-- 	selectedButton.y = y
-- 	parent:insert(selectedButton)

-- 	local selected = display.newRoundedRect(x,y,60,60,4)
-- 	selected:setFillColor(color("green"))
-- 	parent:insert(selected)

-- 	local shower = display.newImageRect(idleIconPath,26,26)
-- 	shower.x,shower.y = x,y-12
-- 	parent:insert(shower)

-- 	local options = {
-- 		text = "12",
-- 		x = x,
-- 		y = y +16,
-- 		width = 0,
-- 		height = 0,
-- 		font = "systemFont",
-- 		fontSize = 12
-- 	}
-- 	local sequence = display.newText(options)
-- 	sequence:setFillColor(color("black"))
-- 	parent:insert(sequence)

-- 	selectedLayer[1] = selectedButton
-- 	selectedLayer[2] = selected
-- 	selectedLayer[3] = shower
-- 	selectedLayer[4] = sequence

-- 	return selected
-- end

local function displayCellMap(parent,data)
	for k,v in ipairs(data) do
		cell_indexToid[k] = v['cell_id']
		cell_idToindex[tonumber(v['cell_id'])] = k
		if v['status'] == "1" then
			All_cell[k] = drawIdleIcon(parent,k)
		else
			All_cell[k] = drawUsedIcon(parent,k)
		end 
	end
end

local function clearCell()
	selectCellId = nil
	for i = 1, 12 do
		if All_cell[i] ~= nil then
			for k,v in pairs(All_cell[i]) do
				if v ~= nil then
					display.remove(v)
					v = nil
				end
			end
			All_cell[i] = nil
		end
	end
end

local function CellNetwork(parent,room_id)
	local url = dataListUrl.."?sql=SELECT%20cell_id,status%20FROM%20`bath_cell`%20WHERE%20room_id%20=%20"..room_id
	local function callback(data)
		if(data ~= nil) then
			if(data['status'] == "true") then
				clearCell()
				displayCellMap(parent,data['data'])
			end
		end
	end
	Util:NetworkDatabase(parent.parent,url,"GET",callback)
end

function Composer:DrawCellHint(parent)
	local idle = display.newRoundedRect(120,145,30,30,4)
	idle:setStrokeColor(color("gray"))
	idle.strokeWidth = 1
	parent:insert(idle)

	local shower = display.newImageRect(idleIconPath,24,24)
	shower.x,shower.y = 120,145
	parent:insert(shower)

	local idleOptions = {
		text = "可用",
		x = 120+40,
		y = 145,
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 16
	}

	local idleText = display.newText(idleOptions)
	idleText:setFillColor(color("black"))
	parent:insert(idleText)


-- used
	local used = display.newRoundedRect(240,145,30,30,4)
	used:setFillColor(color("red"))
	parent:insert(used)

	local shower = display.newImageRect(usedIconPath,24,24)
	shower.x,shower.y = 240 , 145
	parent:insert(shower)

	local usedOptions={
		text = "已用",
		x = 280,
		y = 145,
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 16
	}
	local usedText = display.newText(usedOptions)
	usedText:setFillColor(color("black"))
	parent:insert(usedText)


-- selected 
	local selected = display.newRoundedRect(360,145,30,30,4)
	selected:setFillColor(color("green"))
	parent:insert(selected)

	local shower = display.newImageRect(idleIconPath,24,24)
	shower.x,shower.y = 360 , 145
	parent:insert(shower)

	local usedOptions={
		text = "已选",
		x = 360+40,
		y = 145,
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 16
	}
	local selectedText = display.newText(usedOptions)
	selectedText:setFillColor(color("black"))
	parent:insert(selectedText)


	local line = display.newLine(-offsetX,170,width,170)
	line:setStrokeColor(color("gray"))
	line.strokeWidth = 1
	parent:insert(line)
end

function Composer:DrawBathMap(parent)

	local room_id = Util:getNativeValue("room_id")
	if(room_id ~= nil ) then
		CellNetwork(parent,room_id)
	end
end


--end cell
local function CreateButton(parent,id,x,y,callback)
	local button = widget.newButton(
    {
        id = id,
        label = "      ",
        font = native.systemFont,
        fontSize = 20,
        labelColor = { default={100/255,100/255,100/255}, over={0.5 } },
        textOnly = true,
        onEvent = callback
    }
	)
	button.x = x
	button.y = y
	button:setEnabled(false)
	parent:insert(button)
	return button
end

local function moveTagLable(obj,cate)
	if cate == "house" then
		transition.to(obj,{x = 80,time = 300})
	elseif cate == "floor" then
		transition.to(obj,{x = 200,time = 300})
	else
		transition.to(obj,{x = 350,time = 300})
	end
end

local function moveTagLine(obj,cate)
	if cate == "house" then
		transition.to(obj,{x = 60,time = 300})
	elseif cate == "floor" then
		transition.to(obj,{x = 180 ,time = 300})
	else
		transition.to(obj,{x = 320,time = 300})
	end
end

local function drawDetailWheel(parent,data,cate,onRowTouch)
	local function onRowRender(event)
		local row = event.row
 		local index = row.index
    	local rowHeight = row.contentHeight
    	local rowWidth = row.contentWidth
 		
 		magic[cate]['indexToid'][index] = data[index][cate.."_id"]
 		magic[cate]['indexToname'][index] = data[index]['name'] or data[index][cate.."_id"].."室"
 		local lable = data[index]['name'] or data[index][cate.."_id"].."室"
 		print(index)
 		print(magic[cate]['indexToid'][index])
    	local rowTitle = display.newText( row, lable, 0, 0, native.systemFont, 14 )
    	rowTitle:setFillColor(62/255,62/255,64/255 )
 
    	rowTitle.anchorX = 0
    	rowTitle.x = 30
    	rowTitle.y = rowHeight * 0.5
	end

	local function scrollListener(event)
	end

	local tableView = widget.newTableView(
    {
        left = -offsetX,
        top = 586 + offsetY,
        height = H - 586 + offsetY,
        width = width,
        noLines = true,
        hideBackground = true,
        rowTouchDelay = 30,
        backgroundColor = { 0.6, 0, 0.8 },
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener
    }
	)

	for i = 1, #data do
    	local rowHeight = 36
    	local rowColor = { default={1,1,1}, over={1,0.5,0,0.2} }
    	local lineColor = { 0.5, 0.5, 0.5 }
 
    	tableView:insertRow(
        {
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor
        }
    	)
	end
	parent:insert(tableView)
	return tableView
end

local function displayRoomPanel(parent,data)
	local function onRowTouch( event)
    	local target = event.target
    	local index = target.index
    	if( "release" == event.phase) then
    		saveSelectIndex['room'] = index
    		magic['room']['button']:setLabel(data[index]['name'])
    		Util:setNativeValue("house_id",magic['house']['indexToid'][saveSelectIndex['house']])
    		Util:setNativeValue("floor_id",magic['floor']['indexToid'][saveSelectIndex['floor']])
    		Util:setNativeValue("room_id",magic['room']['indexToid'][saveSelectIndex['room']])
    		local houseName = magic['house']['indexToname'][saveSelectIndex['house']]
    		local floorName = magic['floor']['indexToname'][saveSelectIndex['floor']]
    		local roomName = magic['room']['indexToname'][saveSelectIndex['room']]
    		Util:setNativeValue("house",houseName)
    		Util:setNativeValue("floor",floorName)
    		Util:setNativeValue("room",roomName)
    		Util:setNativeValue("local_sex",data[index]['sex'])
    		local location = Util:getNativeValue("location")
    		local sex = data[index]['sex'] == "1" and "（男）" or "（女）"

    		houseText.text = location.." - "..houseName
    		roomText.text = floorName.." - "..roomName..sex

    		-- refresh cell
    		local room_id = magic['room']['indexToid'][saveSelectIndex['room']]
    		CellNetwork(scrollLayer,room_id)

    		if maskLayer ~= nil then
    			display.remove(maskLayer)
    			maskLayer = nil
    		end

    	end
	end

	local function roomListener(event)
			if(magic['house']['wheel']~=nil)then
				display.remove(magic['house']['wheel'])
				magic['house']['wheel'] = nil
			end
			if(magic['floor']['wheel']~=nil)then
				display.remove(magic['floor']['wheel'])
				magic['floor']['wheel'] = nil
			end
			if magic['house']['button'] ~= nil then
				magic['house']['button']:setEnabled(true)
			end
			if magic['floor']['button'] ~= nil then
				magic['floor']['button']:setEnabled(true)
			end
		magic['room']['button']:setEnabled(false)
		moveTagLine(tagLine,"room")
		magic['room']['wheel'] =  drawDetailWheel(parent,data,"room",onRowTouch)
	end
	magic['room']['button'] = CreateButton(parent,"room",350,565+offsetY,roomListener)

	magic['room']['wheel'] =  drawDetailWheel(parent,data,"room",onRowTouch)
end

local function RoomNetwork(parent,floor_id)
	local sex = Util:getNativeValue("sex") or 1
	local url = dataListUrl.."?sql=SELECT%20room_id,number,sex%20FROM%20`bath_room`%20WHERE%20floor_id%20=%20"..floor_id.."%20and%20sex="..sex
	local function callback(data)
		if(data ~= nil) then
			if(data['status'] == "true") then
				
				if(magic['room']['button']~=nil)then
					display.remove(magic['room']['button'])
					magic['room']['button'] = nil
				end
				
				if(magic['floor']['wheel'] ~= nil) then
					display.remove(magic['floor']['wheel'])
					magic['floor']['wheel'] = nil
				end

				magic['floor']['button']:setEnabled(true)
				displayRoomPanel(parent,data['data'])
			end
		end
	end
	Util:NetworkDatabase(parent.parent,url,"GET",callback)
end

local function displayFloorPanel(parent,data)
	local function onRowTouch( event)
    	local target = event.target
    	local index = target.index
    	if( "release" == event.phase) then

    		saveSelectIndex['floor'] = index 
    		moveTagLine(tagLine,"room")
    		moveTagLable(tagLable,"room") 
    		magic['floor']['button']:setLabel(data[index]['name'])
    		RoomNetwork(parent,magic['floor']['indexToid'][index])
    	end
	end

	local function floorListener(event)
		if event.phase == "ended" then
			if(magic['house']['wheel']~=nil)then
				display.remove(magic['house']['wheel'])
				magic['house']['wheel'] = nil
			end
			if(magic['room']['wheel']~=nil)then
				display.remove(magic['room']['wheel'])
				magic['room']['wheel'] = nil
			end
			if magic['house']['button'] ~= nil then
				magic['house']['button']:setEnabled(true)
			end
			if magic['room']['button'] ~= nil then
				magic['room']['button']:setEnabled(true)
			end
			moveTagLine(tagLine,"floor")
			magic['floor']['button']:setEnabled(false)
			magic['floor']['wheel'] =  drawDetailWheel(parent,data,"floor",onRowTouch)
		end
		return true
	end
	magic['floor']['button'] = CreateButton(parent,"floor",200,565 +offsetY,floorListener)

	magic['floor']['wheel'] =  drawDetailWheel(parent,data,"floor",onRowTouch)
end

local function FloorNetwork(parent,house_id)
	local sex = Util:getNativeValue("sex")
	local url = dataListUrl.."?sql=SELECT%20floor_id,name%20FROM%20`bath_floor`%20WHERE%20house_id%20=%20"..house_id.."%20and%20sex="..tostring(sex)
	local function callback(data)
		if(data ~= nil) then
			if(data['status'] == "true") then
				if(magic['floor']['button']~=nil)then
					display.remove(magic['floor']['button'])
					magic['floor']['button'] = nil
				end
				if(magic['room']['button']~=nil)then
					display.remove(magic['room']['button'])
					magic['room']['button'] = nil
				end


				if(magic['house']['wheel'] ~= nil) then
					display.remove(magic['house']['wheel'])
					magic['house']['wheel'] = nil
				end

				magic['house']['button']:setEnabled(true)
				displayFloorPanel(parent,data['data'])

			end
		end
	end
	Util:NetworkDatabase(parent.parent,url,"GET",callback)
end

local function displayHousePanel(parent,data)
	local function maskListener(event)
		if(event.phase == "ended") then
			if(maskListener ~= nil) then
				display.remove(maskLayer)
				maskListener = nil
			end
		end
		return true
	end

	maskLayer = Util:AddMask(parent.parent,maskListener)

	local panel = display.newRect(maskLayer,X,500+offsetY,width,300)
	panel.anchorY = 0
	panel:setFillColor(1,1,1)
	local function panelListener(event)
		if event.phase == "ended" then
		end
		return true
	end
	panel:addEventListener("touch",panelListener)

	local lableArgs={
		parent = maskLayer,
		text = "浴室位置",
		x = X,
		y = 530+offsetY,
		font = native.systemFont,
		fontSize = 24,
	}
	local text = display.newText(lableArgs)
	text:setFillColor(140/255,140/255,120/255)

	local closeTable = {
		x = W + offsetX - 32,
		y = 530+offsetY,
		width = 32,
        height = 32,
        select = closeIconPath,
        selected = nil,
        label = nil,
	}

	local function closeListener(event)
		if(event.phase == "ended") then
			maskListener(event)
		end
		return true
	end
	local close = Util:CreateButton(maskLayer,closeTable,closeListener)

	local function onRowTouch( event)
    	local target = event.target
    	local index = target.index
    	if( "release" == event.phase) then
    		saveSelectIndex['house'] = index
    		moveTagLine(tagLine,"floor")
    		moveTagLable(tagLable,"floor") 
    		magic['house']['button']:setLabel(data[index]['name'])
    		FloorNetwork(maskLayer,magic['house']['indexToid'][index])
    	end
	end

	local function houseListener(event)
		if event.phase == "ended" then
			if(magic['floor']['wheel']~=nil)then
				display.remove(magic['floor']['wheel'])
				magic['floor']['wheel'] = nil
			end
			if(magic['room']['wheel']~=nil)then
				display.remove(magic['room']['wheel'])
				magic['room']['wheel'] = nil
			end
			if magic['floor']['button'] ~= nil then
				magic['floor']['button']:setEnabled(true)
			end
			if magic['room']['button'] ~= nil then
				magic['room']['button']:setEnabled(true)
			end
			moveTagLine(tagLine,"house")
			magic['house']['button']:setEnabled(false)
			magic['house']['wheel'] = drawDetailWheel(maskLayer,data,"house",onRowTouch)
		end
		return true
	end

	magic['house']['button'] = CreateButton(maskLayer,"house",80-offsetX,565+offsetY,houseListener)
	local opt={
		text = "请选择",
		x = 80-offsetX,
		y = 565+offsetY,
		font = native.systemFont,
		fontSize = 20,
	}
	tagLable = display.newText(opt)
	tagLable:setFillColor(246/255,71/255,23/255)
	maskLayer:insert(tagLable)

	local line = display.newLine(maskLayer,-offsetX,580+offsetY,W+offsetX,580+offsetY)
	line:setStrokeColor(100/255,100/255,100/255)
	line.strokeWidth = 1

	tagLine = display.newLine(maskLayer,40 - offsetX,580+offsetY,40-offsetX+60,580+offsetY)
	tagLine:setStrokeColor(246/255,71/255,23/255)
	tagLine.strokeWidth = 1


	magic['house']['wheel'] = drawDetailWheel(maskLayer,data,"house",onRowTouch)

end

local function locationNetwork(parent)
	local locate_id = Util:getNativeValue("location_id") or 1
	local url = dataListUrl.."?sql=SELECT%20house_id,name%20FROM%20`bath_house`%20WHERE%20local_id%20=%20"..locate_id
	local function callback(data)
		if(data ~= nil) then
			if(data['status'] == "true") then
				displayHousePanel(parent,data['data'])
			end
		end
	end
	Util:NetworkDatabase(parent.parent,url,"GET",callback)
end

function Composer:DrawLocation(parent)
	scrollLayer = parent

	local location = Util:getNativeValue("location") or "请选择.."
	local house = Util:getNativeValue("house") or ""
	local floor = Util:getNativeValue("floor") or ""
	local room = Util:getNativeValue("room") or ""
	local sex = Util:getNativeValue("local_sex")

	if house ~= "" then
		house = " - "..house 
	end

	if room ~= "" then
		room = " - "..room 
	end

	if (sex == nil )then
		sex = ""
	else
		sex = sex and "（男）" or "（女）"
	end

	local function rowListener(event)
		if(event.phase == "ended") then
			locationNetwork(parent)
		end
		return true
	end

	local row = widget.newButton(
    {
    	x = X+offsetX,
    	y = 83,
        onEvent = rowListener,
        emboss = false,
        shape = "rect",
        width = width,
        height = 64,
        cornerRadius = 2,
        fillColor = { default={color('white')}, over={0.9} }
    }
	)
	parent:insert(row)

	local ring = display.newImageRect(ringIconPath,26,26)
	ring.x,ring.y = 28,83
	parent:insert(ring)

	local posTable = {
		text = location..house,
		x = 56,
		y = 70,
		width = 0,
		height = 0,
		font = native.systemFontBold,
		fontSize = 24
	}
	houseText = display.newText(posTable)
	houseText:setFillColor(color("black"))
	houseText.anchorX = 0
	parent:insert(houseText)

	local posTable = {
		text = floor..room..sex,
		x = 56,
		y = 100,
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 20
	}
	roomText = display.newText(posTable)
	roomText:setFillColor(color("blue"))
	roomText.anchorX = 0
	parent:insert(roomText)

	local arrowIcon = display.newImage(arrowIconPath)
	arrowIcon.x,arrowIcon.y = width - 30,83
	parent:insert(arrowIcon)

	local line = display.newLine(-offsetX,120,width,120)
	line:setStrokeColor(color("gray"))
	line.strokeWidth = 1
	parent:insert(line)
end



local function headleDateNetwork(parent,status)
	if status == "true" then
		Util:PopNotice(parent.parent,"预约成功")
		Util:removeMains()
		appoint:Init()
	elseif status == "closeTime" then
		Util:PopNotice(parent.parent,"关门了")
	elseif status == "busy" then
		Util:PopNotice(parent.parent,"哎呦！不好意思，浴位被抢了")
	elseif status == "noSelect" then
		Util:PopNotice(parent.parent,"请选择浴位")
	elseif status == "queue" then
		Util:PopNotice(parent.parent,"排队中")
		Util:removeMains()
		wait:init()
	end
end


function Composer:DateSubmit(parent)
	local function handleDateEvent( event )
    	if ( "ended" == event.phase ) then
    		local house_id = Util:getNativeValue("house_id")
    		local name = Util:getNativeValue("name")
    		local sex = Util:getNativeValue("sex")
    		local cell_id =  selectCellId == nil and -1 or cell_indexToid[selectCellId]

    		Util:setNativeValue("cell_id",cell_id)

    		if house_id and name and sex  and cell_id then
	    		local url = "/bathtime/date.php?name="..name.."&house_id="..house_id.."&sex="..sex.."&cell_id="..cell_id

	    		local function callback(data)
	    			if data ~= nil and data['status'] ~= "false" then
		    			headleDateNetwork(parent,data['status'])
		    		end
	    		end
	    		Util:NetworkDatabase(parent.parent,url,"GET",callback)
	    		-- 判断是否是洗澡时间段 TimeNetwork
	    		-- 判断是否是达到约束条件 contrait
	    	end
    		
    	end
    	return true
	end

	local options = {
		label = "预约",
    	onEvent = handleDateEvent,
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

	local dateButton = widget.newButton(options)
	dateButton.x = X + offsetX
	dateButton.y = 600
	parent:insert(dateButton)

end

local function displayHint(parent,data)
	local text = data[1]['text']
	local options = {
		text = text,
    	x = X+60+offsetX,
    	y = 686,
    	width = 380,
    	height = 52,
    	font = native.systemFont,
    	fontSize = 16
	}
	local hint = display.newText(options)
	hint:setFillColor(0,0,0)
	parent:insert(hint)
end

local function HintNetwork(parent)
	local url = dataListUrl.."?sql=select%20text%20from%20system_hint%20where%20status%20=%201"
	local function callback(data)
		if(data ~= nil) then
			if(data['status'] == "true") then
				displayHint(parent,data['data'])
			end
		end
	end
	Util:NetworkDatabase(parent.parent,url,"GET",callback)
end

function Composer:DrawHint(parent)
	local panel = display.newRoundedRect(X+offsetX,680,440,60,4)
	panel.strokeWidth = 1
	panel:setStrokeColor(123/255,190/255,198/255)
	parent:insert(panel)

	local title = display.newText("温馨提示:",60+offsetX,664,native.systemFont,12)
	title:setFillColor(0,0,0)
	parent:insert(title)

	HintNetwork(parent)

end

