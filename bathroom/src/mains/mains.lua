local widget = require("widget")
require("src.mains.composer")
local json = require("json")
Mains={
	
}

-- local mainScenePicturePath = "picture_res/scene_blue.jpg"
local messageIconPath = "icon_res/message.png"
local portraitIconPath = "icon_res/portrait.png"
local logoIconPath = "icon_res/logo.png"
local headIconPath = "picture_res/head.jpg"
local down_arrowIconPath = "icon_res/down_arrow.png"
local arrowIconPath = "icon_res/arrow.png"

local headPic = nil
local scrollView = nil

local rowCount = 4
local rowIcon = {
 	path1 = "icon_res/help.png",
 	path2 = "icon_res/about.png",
 	path3 = "icon_res/feedback.png",
 	path4 = "icon_res/set.png",
}

local rowText = {
	path1 = "用户指南",
	path2 = "关于我们",
	path3 = "意见反馈",
	path4 = "设置",
}

local setText = {
	"软件下载",
	"联系我们",
	"退出登录"
}


local function MoveScene(parent)
	local mask = nil
	transition.to( parent, { x=width*0.8, y=0, time=200 ,transition = easing.inOutQuart} )
	local function backListener(event)
		if("ended" == event.phase) then
			transition.to( parent, { x=0, y=0, time=200 ,transition = easing.inOutQuart } )
			display.remove(mask)
			mask = nil
		end
	end
	mask = Util:AddMask(parent,backListener)
end

local function MainScene(parent)
	local background = display.newRect(parent,X,Y,width,height)
	background:setFillColor(color("white"))


	local panelbg = display.newRect(parent,X,(86+SH)*0.5 - offsetY,width,86+SH)
	panelbg:setFillColor(color("blue"))

	local messageArgs={
		x = W+offsetX-35,
		y = SH+18+15-offsetY,
		width = 36,
		height = 36,
		select = messageIconPath,
		selected = nil,
		name = nil
	}
	local function messageListener(event)
		if("ended" == event.phase) then
			Info:Init(parent)
		end
	end
	local message = Util:CreateButton(parent,messageArgs,messageListener)

	local portraitArgs={
		x = 35-offsetX,
		y = SH+18+15-offsetY,
		width = 36,
		height = 36,
		select = portraitIconPath,
		selected = nil,
		name = nil
	}
	local function portraitListener(event)
		if("ended" == event.phase) then
			MoveScene(parent)
		end
	end
	local portrait = Util:CreateButton(parent,portraitArgs,portraitListener)

	local logo = display.newImageRect(parent,logoIconPath,50,50)
	logo.x,logo.y = X , SH+33-offsetY



	local boundary = display.newLine(parent,0-offsetX,SH+18+15-offsetY+18+12,width,SH+18+15-offsetY+18+12)
	boundary:setStrokeColor(color("blue"))
	boundary.strokeWidth = 1


	local down_arrow = nil
	local refresh_text = nil
	local once = true
	local refresh = false
	local function scrollListener(event)
		local x, y = scrollView:getContentPosition()
		local phase = event.phase
	    if ( phase == "began" ) then
	     	once = true
	     	down_arrow.isVisible = true
	     	down_arrow.rotation = 0
	     	refresh = false
	     	refresh_text.text = "下拉刷新"
	    elseif ( phase == "moved" ) then 
	    	if y >= 76 and once then
				print(">74")
				refresh = true
				once = false
				transition.to(down_arrow, { rotation = 180, time = 160 } )
				refresh_text.text = "松开立即刷新"
			elseif y < 66 and not once then
				print("<60",y)
				once = true
				refresh = false
				transition.to(down_arrow, { rotation = 0, time = 160 } )
				refresh_text.text = "下拉刷新"
			end
	    elseif ( phase == "ended" ) then
	    	if refresh then
			    scrollView:scrollToPosition
				{
				    x = 0,
				    y = 72
				}
				refresh_text.text = "玩命加载中..."
				down_arrow.isVisible = false
				Composer:DrawBathMap(scrollView)
				timer.pause(refresh_timer)
				local function timerListener(event)
					timer.resume(refresh_timer)
					scrollView:scrollToPosition
					{
					    x = 0,
					    y = 0
					}
				end
				timer.performWithDelay(700,timerListener,1)
	    	end
	    end
	end

	local scrollTable={
		top = 63+SH-offsetY,
        left = 0 - offsetX,
        width = width,
        height = height - 63 - SH + offsetY,
        scrollWidth = width,
        scrollHeight = 0,
        backgroundColor ={color("white")},
        hideBackground = false,
        horizontalScrollDisabled = true,
	}

	scrollView = Util:CreateScrollView(parent,scrollTable,scrollListener)

-- here! start draw scene --
	Composer:DrawNotice(scrollView)
	Composer:DrawLocation(scrollView)
	Composer:DrawCellHint(scrollView)
	Composer:DrawBathMap(scrollView)
	Composer:DateSubmit(scrollView)
	Composer:DrawHint(scrollView)

	local function TimerRefreshCell(interval)
		local function timerListener(event)
			Composer:DrawBathMap(scrollView)
		end
		refresh_timer = timer.performWithDelay(interval,timerListener,-1)
	end

	TimerRefreshCell(8000)

	down_arrow = display.newImageRect(down_arrowIconPath,32,32)
	down_arrow.x,down_arrow.y = X+offsetX-80,-50
	scrollView:insert(down_arrow)

	local desc_table={
		text = "下拉刷新",
		x = X + offsetX,
		y = -50,
		font = native.systemFont,
		fontSize = 20	
	}
	refresh_text = display.newText(desc_table)
	refresh_text:setFillColor(169/255,169/255,169/255)
	scrollView:insert(refresh_text)

end


local function AboutUs(parent)
	local function scrollListener(event)

	end
	local scrollView = widget.newScrollView(
    {
        top = 68+SH-offsetY,
        left = 0,
        width = width,
        height = height - 65 - SH,
        scrollWidth = width,
        horizontalScrollDisabled = true,
        listener = scrollListener
    }
	)
	parent:insert(scrollView)

	local sql = "select%20aboutUs%20from%20system%20limit%201"
	local url = "/bathtime/list.php?sql="..sql

	local function aboutText(mesg)
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
		details.x, details.y = w*0.5+8, h*0.5+8
	end

	local function callback(data)
		if data.status == "true" then
			aboutText(data['data'][1]['aboutUs'])
		end
	end
	Util:NetworkDatabase(parent,url,"GET",callback)

end

local function Userhelp(parent)
	local function scrollListener(event)

	end
	local scrollView = widget.newScrollView(
    {
        top = 68+SH-offsetY,
        left = 0,
        width = width,
        height = height - 65 - SH,
        scrollWidth = width,
        horizontalScrollDisabled = true,
        bottomPadding = 20,
        listener = scrollListener
    }
	)
	parent:insert(scrollView)

	local sql = "select%20help%20from%20system%20limit%201"
	local url = "/bathtime/list.php?sql="..sql

	local function helpText(mesg)
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
		details.x, details.y = w*0.5+8, h*0.5+8
	end

	local function callback(data)
		if data.status == "true" then
			helpText(data['data'][1]['help'])
		end
	end
	Util:NetworkDatabase(parent,url,"GET",callback)
end

local function UserFeedback(parent)
	local function textListener( event )
	end

	feedbackBox =  native.newTextBox(X,200,width - 80,200)
	parent:insert(feedbackBox)
	feedbackBox.placeholder = "感谢您的反馈，我们会继续改进"
	feedbackBox.size = 20
	-- feedbackBox.hasBackground = false
	feedbackBox.isEditable = true
	feedbackBox:setTextColor(123/255,190/255,198/255 )
	feedbackBox:addEventListener( "userInput", textListener )

	local function handleSubmitEvent(event)
		if ( "ended" == event.phase ) then
			print("fd: ",feedbackBox.text)
			local name = Util:getNativeValue("name")
			local url = "/bathtime/feedback.php?name="..name.."&content="..tostring(feedbackBox.text)

			local function callback(data)
				if data.status == "true" then
					Util:PopNotice(parent,"感谢您的反馈")
				end
			end
			Util:NetworkDatabase(parent,url,"GET",callback)
		end
	end

	local options = {
		label = "提交",
    	onEvent = handleSubmitEvent,
    	emboss = false,
    	shape = "roundedRect",
    	width = 400,
    	height = 60,
    	cornerRadius = 4,
    	font = native.systemFont,
    	fontSize = 30,
    	labelColor = {default = {1, 1, 1}, over = {1, 1, 1, 0.8}},
    	fillColor = { default={131/255,216/255,67/255}, over={131/255,216/255,67/255,0.8} },
	}

	local submitButton = widget.newButton(options)
	submitButton.x = X
	submitButton.y = 360
	parent:insert(submitButton)
end

local function SafawareDownload( parent )
	local download = display.newImageRect("download.png",system.DocumentsDirectory,200,200)

	local desc = display.newText("扫码下载",0,0,native.systemFont,24)
	desc:setFillColor(0,0,0)
	desc.x, desc.y = X , 430
	parent:insert(desc)


	local function downloadPic()
		local function downloadCallback(filename)
			download  = display.newImageRect(filename,system.DocumentsDirectory,160,160)
			parent:insert(download)
			download.x = X
			download.y = download.contentWidth + 100
		end

		local function callback(data)
			if data.status == "true" then
				local url = data['data'][1]['download']
				Util:NetworkDownload(parent,url,"GET",downloadCallback,"download.png")
			end
		end
		local sql = "select%20download%20from%20system%20limit%201"
		local url = "/bathtime/list.php?sql="..sql
		Util:NetworkDatabase(parent,url,"GET",callback)
	end
	if not download then
		downloadPic()
	else
		parent:insert(download)
		download.x = X
		download.y = download.contentWidth + 100
	end


end

local function UserSet(parent)
	local function onRowRender(event)
    	local row = event.row
     	local rowHeight = row.contentHeight
    	local rowWidth = row.contentWidth

	 	local index = row.index

	 	local arrow = display.newImageRect(row,arrowIconPath,32,32)
    	arrow.x ,arrow.y = width - 30, 30

	 	local options = {
	 		parent = row,
	 		text = setText[index],
	 		x = 100,
	 		y = rowHeight*0.5,
	 		width = 180,
	 		height = 0,
	 		font = native.systemFont,
	 		fontSize = 22,
	 	}

	 	local text = display.newText(options)
	 	text:setFillColor(color("black"))
	end

	local function onRowTouch( event )
		local target = event.target
    	if( "release" == event.phase) then
    		local index = target.index
    		
    		if(target.index == 1) then
    			local layer = Util:AddPage(parent,setText[index])
    			SafawareDownload(layer)
			elseif(target.index == 2) then
    			system.openURL("tel:18380205203")
			elseif(target.index == 3) then
				Util:removeMains()
				Login:Init(baseLayer)
			end
    	end
	end

	local function scrollListener( event )
	end


	local tableView = widget.newTableView(
    {
        left = 0 - offsetX,
        top = 68+SH,
        height = 400,
        width = width,
        noLines = false,
        hideScrollBar = true,
        hideBackground = true,
        topPadding = 10,
        rowTouchDelay = 30,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener
    }
	)

	local rowColor = { default={1,1,1}, over={color("gray"),0.3} }
	for i = 1, 3 do
	    tableView:insertRow{
	    	rowHeight = 60,
            rowColor = rowColor,
		}
	end
	parent:insert(tableView)
end

local function Portrait(parent)
	local portraitX = -(width*0.4+offsetX)

	local name = Util:getNativeValue("name")
	name = tostring(name)

	local background = display.newRect(parent,portraitX,Y,width*0.8,height)
	background:setFillColor(color("white"))

	local panel = display.newRect(parent,portraitX,100-offsetY,width*0.8,200)
	panel:setFillColor(color("sky_blue"))

	local container = display.newContainer(80,80)
	container:translate(portraitX, 0-offsetY+80 +SH )
	parent:insert(container)

	local headIconDown = nil
	local headIcon = nil
	local DownFile = "portrait_"..tostring(name)..".png"

	headIcon  = display.newImage(container,DownFile,system.DocumentsDirectory)
	if not headIcon then
		headIcon = display.newImage(container,headIconPath)
	end
	local iconWidth = headIcon.contentWidth
	local scale = 80/iconWidth
	headIcon:scale(scale,scale)

	

	local function sessionComplete(event)
		if headPic ~= nil then
			display.remove(headPic)
			headPic = nil
		end
		headPic = event.target
		if headPic then
			if headIcon ~= nil then
				display.remove(headIcon)
				headIcon = nil
			end
			if headIconDown ~= nil then
				display.remove(headIconDown)
				headIconDown = nil
			end

			local user_id = nil
			if headPic.width > headPic.height then
				headPic:rotate( -90 )			-- rotate for landscape
			end
			local scale = 80/headPic.contentWidth
			headPic:scale( scale, scale )
			container:insert(headPic)


			display.save(container,{ filename = DownFile, baseDir = system.DocumentsDirectory, captureOffscreenArea=false, backgroundColor={0,0,0,0} })
			
			local function uploadListener(event)
				local url = "/bathtime/upload_portrait.php"
				Util:networkUpload(parent,url,"POST",DownFile)
			end
			
			
			local update_url = "/bathtime/update_portrait.php?name="..name
			local function Icallback(data)
				if data.status == "true" then
					timer.performWithDelay(1000,uploadListener,1)
				end
			end
			Util:NetworkDatabase(parent,update_url,"GET",Icallback)
		end
	end

	local function tapListener(event)
		media.selectPhoto( { listener = sessionComplete, mediaSource = media.PhotoLibrary })
	end
	container:addEventListener( "tap", tapListener )


	local nickTable = {
		parent = parent,
		text = "",
		x = portraitX,
		y = 140 - offsetY +SH,
		width = 0,
		height = 0,
		font = native.systemFont,
		fontSize = 20
	}
	local nick = display.newText(nickTable)
	
	nick.text = name

	local function downloadCallback()
		headIconDown  = display.newImage(container, DownFile,system.DocumentsDirectory)
		if headIconDown ~= nil then
			display.remove(headIcon)
			headIcon = nil
			local iconWidth = headIconDown.contentWidth
			local scale = 80/iconWidth
			headIconDown:scale(scale,scale)
		end
	end

	local function callback(data)
		if data.status == "success" then
			local url = data.portrait
			Util:NetworkDownload(parent,url,"GET",downloadCallback,DownFile)
		end
	end
	local url = "/bathtime/portrait.php?name="..name
	Util:NetworkDatabase(parent,url,"GET",callback)

	local function onRowRender(event)
    	local row = event.row
     	local rowHeight = row.contentHeight
    	local rowWidth = row.contentWidth

	 	local path = "path"..row.index
	 	local icon = display.newImageRect(row, rowIcon[path]  , 30,30)
	 	icon.x,icon.y = 30 , rowHeight* 0.5

	 	local options = {
	 		parent = row,
	 		text = rowText[path],
	 		x = 60+90,
	 		y = rowHeight*0.5,
	 		width = 180,
	 		height = 0,
	 		font = native.systemFont,
	 		fontSize = 24,
	 	}

	 	local text = display.newText(options)
	 	text:setFillColor(color("black"))
	end

	local function onRowTouch( event )
		local target = event.target
    	if( "release" == event.phase) then
    		local path = "path"..target.index
    		local layer = Util:AddPage(parent,rowText[path])
    		if(target.index == 1) then
    			Userhelp(layer)
			elseif(target.index == 2) then
    			AboutUs(layer)
			elseif(target.index == 3) then
				UserFeedback(layer)
			else
				UserSet(layer)
			end
    	end
	end

	local function scrollListener( event )
	end


	local tableView = widget.newTableView(
    {
        left = -0.8*width-offsetX,
        top = 200-offsetY+40,
        height = 400,
        width = 0.8 * width-40,
        noLines = false,
        hideScrollBar = true,
        hideBackground = true,
        topPadding = 10,
        rowTouchDelay = 50,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener
    }
	)

	local rowColor = { default={color("white")}, over={color("gray"),0.3} }
	for i = 1, rowCount do
	    tableView:insertRow{
	    	rowHeight = 80,
            rowColor = rowColor,
		}
	end
	parent:insert(tableView)


end



function Mains:Init(parent)
	display.setStatusBar( display.TranslucentStatusBar )
	mainsLayer = display.newGroup()
	parent:insert(mainsLayer)
	MainScene(mainsLayer)
	Portrait(mainsLayer)
	--MoveScene(parent)

end