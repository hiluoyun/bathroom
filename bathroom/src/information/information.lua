local widget = require("widget")
Info={}

local arrowIconPath = "icon_res/arrow.png"
local rowLayer = {}

local function DrawInfoDetail(parent,mesg)
	local function scrollListener(event)

	end
	local scrollView = widget.newScrollView(
    {
        top = 68+SH-  offsetY,
        left = 0,
        width = width,
        height = height - 65 - SH,
        scrollWidth = width,
        horizontalScrollDisabled = true,
        bottomPadding =20,
        listener = scrollListener
    }
	)
	parent:insert(scrollView)

	local option = 
	{
	    text = mesg,
	    width = 464,
	    font = native.systemFont,
	    fontSize = 18
	}
	local details = display.newText( option )
	local h = details.contentHeight
	local w = details.contentWidth
	scrollView:insert(details)
	details:setFillColor( 0, 0, 0 )
	details.x, details.y = w*0.5 + 8, h*0.5+8
end

local function DrawRowView(parent,data,len)
	local count = tonumber(len)
	local tableView = nil

	local function onRowRender(event)
		local row = event.row
		local index = row.index
 
    	local rowHeight = row.contentHeight
    	local rowWidth = row.contentWidth
 
    	local rowTitle = display.newText( row, data[index]['name'], 300, 0, native.systemFont, 24 )
    	rowTitle:setFillColor(0,0,0 )
     	rowTitle.anchorX = 0
    	rowTitle.x = 20
    	rowTitle.y = 26

    	local rowTime = display.newText(row, data[index]['time'], 100, 0, native.systemFont, 18 )
    	rowTime:setFillColor(color("gray"))
    	rowTime.anchorX = 0
    	rowTime.x,rowTime.y = 310, 26

    	local rowSketch = display.newText(row,data[index]['sketch'], 360, 0, native.systemFont, 20)
    	rowSketch:setFillColor(color("black"))
    	rowSketch.anchorX = 0
    	rowSketch.x, rowSketch.y = 20, 72

    	local arrow = display.newImageRect(row,arrowIconPath,32,32)
    	arrow.x ,arrow.y = 460, 72
	end

	local function onRowTouch( event)
    	local target = event.target
    	local index = target.index
    	if( "release" == event.phase) then
    		rowLayer[index] = Util:AddPage(parent,data[index]['name'])
    		DrawInfoDetail(rowLayer[index],data[index]['details'])
    	end
	end

	local function scrollListener(event)
	end

	tableView = Util:CreateTableView(parent,onRowRender,onRowTouch,scrollListener,count)
end

local function DrawRowNetwork(parent)
	local sql = "select%20name,time,sketch,details%20from%20info_details%20A,info_outline%20B%20where%20A.id%20=%20B.id%20order%20by%20time%20desc"
	local url = "/bathtime/list.php?sql="..sql
	local function callback(data)
		if data.status == "true" then
			DrawRowView(parent,data.data,#(data.data))
		end
	end
	Util:NetworkDatabase(parent,url,"GET",callback)
end

function Info:Init(parent)
	local messageLayer = Util:AddPage(parent,"消息")
	DrawRowNetwork(messageLayer)
end