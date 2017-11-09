local widget = require( "widget" )
local json = require("json")
Util={}

local loadingIconPath = "icon_res/loading.png"
local backIconPath = "icon_res/back.png"
local filePath = "data.json"
local spinner = nil
local maskLayer = nil


function Util:color( r,b,g )
	return r/255,b/255,g/255
end


function Util:InitFile()
    local path = system.pathForFile( filePath, system.DocumentsDirectory )
    local exist = io.open( path ,"r")
    print("exist",exist)
    if(exist == nil) then
        local file = io.open( path, "w" )
        io.close( file )
        file = nil
    else
        io.close(exist)
        exist = nil
    end
end

function Util:setNativeValue(key,value)
    local path = system.pathForFile( filePath, system.DocumentsDirectory )
    
    -- read
    local file, errorString = io.open( path, "r" )
 
    if not file then
        print( "File error: " .. errorString )
        return nil
    end
    local data = file:read( "*a" )
    local head = json.decode( data )
    io.close( file )
    file = nil

    -- write
    file, errorString = io.open( path, "w" )
 
    if not file then
        print( "File error: " .. errorString )
        return false
    end

    print("table: ",head)
    if( not head ) then
        head = {}
    end
    head[key] = value
    local save = json.encode( head )

    file:write(save)
    io.close( file )
    file = nil
    return true
end



function Util:getNativeValue(key)
    local path = system.pathForFile( filePath, system.DocumentsDirectory )
    local file, errorString = io.open( path, "r" )
 
    if not file then
        print( "File error: " .. errorString )
        return nil
    end
    local data = file:read( "*a" )
    local head = json.decode( data )
    io.close( file )
    file = nil
    if(head == nil or head[key] == nil   ) then
        return nil
    else
        return head[key]
    end
end

function Util:AddMask(parent,callback)
	maskLayer = display.newGroup()
	parent:insert(maskLayer)
	local background = display.newRect(maskLayer,X,Y,width,height)
	background:setFillColor(Util:color(39,40,34))
	background.alpha = 0.3
	local function TouchListener(event)
		if(event.phase == "ended") then
			callback(event)
		end
		return true
	end
	background:addEventListener( "touch", TouchListener )
	return maskLayer
end

function Util:LoadingMask( parent )
	local maskLayer = display.newGroup()
	parent:insert(maskLayer)
	local background = display.newRect(maskLayer,X,Y,width,height)
	background:setFillColor(Util:color(39,40,34))
	background.alpha = 0.1
	local mask = display.newRoundedRect(maskLayer,X,Y,width*0.3,width*0.25,8)
	mask:setFillColor(Util:color(39,40,34))
	mask.alpha = 0.6

	local options={
		width = 200,
    	height = 200,
    	numFrames = 1,
    	sheetContentWidth = 200,
    	sheetContentHeight = 200
	}

	local loadingSheet = graphics.newImageSheet(loadingIconPath,options)

	spinner = widget.newSpinner(
    {
        width = 98,
        height = 98,
        sheet = loadingSheet,
        startFrame = 1,
        deltaAngle = 8,
        incrementEvery = 30
    }
	)
	spinner.x,spinner.y = X,Y
	maskLayer:insert(spinner)
	spinner:start()

	local function TouchListener(event)
		return true
	end
	background:addEventListener( "touch", TouchListener )
	return maskLayer
end

function Util:RemoveMask( layer )
	if( spinner ~= nil ) then
		spinner:stop()
	end
	if (layer ~=nil ) then
		display.remove(layer)
		layer = nil
	end
end

function Util:CreateScrollView(parent,table,callback)
	local scrollView = widget.newScrollView(
    {
        top = table.top,
        left = table.left,
        width = table.width,
        height = table.height,
        scrollWidth = table.scrollWidth,
        scrollHeight = table.scrollHeight,
        hideBackground = table.hideBackground,
        backgroundColor = table.backgroundColor,
        horizontalScrollDisabled = true,
        listener = callback
    }
	)
	parent:insert(scrollView)
	return scrollView
end

function Util:CreateTableView(parent,onRowRender,onRowTouch,scrollListener,count)
	local tableView = widget.newTableView(
    {
        left = 0-offsetX,
        top = 65-offsetY+SH,
        height = height -80 - SH,
        width = width,
        rowTouchDelay = 30,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener
    }
	)

	for i = 1, count do
    	local rowHeight = 100
    	local rowColor = { default={1,1,1}, over={0.8} }
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

function Util:CreateButton(parent,table,callback)
	local button = widget.newButton(
	{
		width = table.width,
        height = table.height,
        defaultFile = table.select,
        overFile = table.selected,
        label = table.name,
        onEvent = callback
	}
	)
	button.x,button.y = table.x,table.y
	parent:insert(button)
	return button
end

local function removeFeedBackBox()
	if feedbackBox ~= nil then
		feedbackBox:removeSelf()
		feedbackBox = nil
	end
end

function Util:AddPage(parent,name)
	local pageLayer = display.newGroup()
	local background = display.newRect(pageLayer,X,Y,width,height)

	background:setFillColor(Util:color(245,245,245))

	pageLayer.x = width
	baseLayer:insert(pageLayer)
	local function TouchListener(event)
		return true
	end
	background:addEventListener( "touch", TouchListener )

	local backgroundNavi = display.newRect( X,(63)*0.5-offsetY+SH*0.5,width,63+SH)
	backgroundNavi.anchorY = 0
	backgroundNavi.y = 0-offsetY
	backgroundNavi:setFillColor(Util:color(62,62,64))
	pageLayer:insert(backgroundNavi)
	


	local backArgs ={
		x = 27-offsetX,
		y = -offsetY+33+SH,
		width = 30,
		height = 30,
		select = backIconPath,
		selected = nil,
		name = nil
	}
	local function backListener( event)
		if("ended" == event.phase) then
			Util:RemoveMask(maskLayer)
			removeFeedBackBox()
			transition.to( parent, { x = 0, y=0, time=200 ,transition = easing.inOutQuart} )
			transition.to( pageLayer, { x = width, y=0, time=200 ,transition = easing.inOutQuart} )
			display.remove(pageLayer)
			pageLayer = nil
		end
	end
	local back = Util:CreateButton(pageLayer,backArgs,backListener)

	local name = display.newText(pageLayer,name,X,-offsetY+31+SH,native.systemFontBold,28)

	transition.to( parent, { x = -width, y=0, time=200 ,transition = easing.inOutQuart} )
	transition.to( pageLayer, { x = 0 , y=0, time=200 ,transition = easing.inOutQuart} )
	return pageLayer
end

function Util:PopNotice(parent,mesg)
	local panel = display.newRoundedRect(parent,X,Y,200,60,10)
	panel:setFillColor(62/255,62/255,64/255,0.4)
	local options = 
	{
		parent = parent,	
	    text = mesg,     
	    x = X,
	    y = Y,
	    width = 160,
	    font = native.systemFont,   
	    fontSize = 16,
	    align = "center"  
	}

	local text = display.newText(options)
	text:setFillColor( 1, 1, 1,0.8 )
	local function removeListener(obj)
		if(panel ~= nil and text ~= nil) then
			display.remove(panel)
			panel = nil
			display.remove(text)
			text = nil
		end
	end

	local function callback()
		transition.to(panel,{time = 1000,alpha =0, onComplete = removeListener })
		transition.to(text,{time = 1000,alpha =0})
	end
	timer.performWithDelay(300,callback,1)
end

function Util:NetworkDatabase(parent,url,type,callback)
	print(IP..url)
	local mask = nil
	local function networkListener(event)
		-- Util:RemoveMask(mask)
    	if ( event.isError ) then
    		Util:PopNotice(parent,"网络无法连接")
        	print( "Network error: ", event.response )
    	else
    		local data = json.decode(event.response)
    		print ( "RESPONSE: " .. event.response )
    		callback(data)
    	end
	end
	-- mask = Util:LoadingMask(parent)
	network.request( IP..url, type, networkListener)
end

function Util:NetworkList(url,type,callback)
	print(IP..url)
	local function networkListener(event)
		if not event.isError then
			local data = json.decode(event.response)
			print("RESPONSE: " .. event.response )
			callback(data)
		end
	end
	network.request(IP..url,type,networkListener)
end

function Util:networkUpload(parent,url,type,filename)
	local function networkListener( event )
    	if ( event.isError ) then
    		Util:PopNotice(parent,"网络无法连接")
        	print( "Network error: ", event.response )
        else
    		if ( event.phase == "ended" ) then
    			Util:PopNotice(parent,"上传头像成功")
        		print ( "Upload complete!" )
	        end
    	end
	end
  	local params = {}
	params.progress = true

	network.upload( 
    	url, 
    	type,
    	params, 
    	filename, 
    	system.DocumentsDirectory, 
    	"image/png"
	)

end

function Util:NetworkDownload(parent,url,type,callback,filename)
	local url = IP..url
	local function networkListener( event )
		if ( event.isError ) then
	        Util:PopNotice(parent,"网络无法连接")
	        print( "Network error: ", event.response )
	    else
		    if ( event.phase == "ended" ) then
		        callback()
		    end
		end
	end
	 
	local params = {}
	params.progress = true
	 
	network.download(
	    url,
	    type,
	    networkListener,
	    params,
	    filename,
	    system.DocumentsDirectory
	)
end

function Util:split(str,sign)
	local len = string.len(str)
	local res = {}
	local index = 1
	while(len > 0) do
		local pos = string.find(str,sign)
		if (pos == nil )then
			res[index] = str
			break
		end
		res[index] = string.sub(str,1,pos-1)
		str = string.sub(str,pos+1)
		index = index + 1
	end
	return res,#res
end

function Util:SetStatusBar(deftype)
	-- display.HiddenStatusBar
	-- display.DefaultStatusBar
	-- display.TranslucentStatusBar
	-- display.DarkStatusBar
	display.setStatusBar( deftype )
end

function Util:removeMains()
	if mainsLayer ~= nil then
		display.remove(mainsLayer)
		mainsLayer = nil
	end
	timer.cancel(refresh_timer)
	All_cell = {}
	for i = 1, baseLayer.numChildren do
		display.remove(baseLayer[i])
		baseLayer[i] = nil
	end
end