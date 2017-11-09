-----------------------------------------------------------------------------------------
--
-- main.lua program launch!
-- author-- luohui Sichuan university
-- 2017.2.25
-----------------------------------------------------------------------------------------
width = display.actualContentWidth
height = display.actualContentHeight

W = display.contentWidth
H = display.contentHeight
offsetX = (width - W)*0.5
offsetY = (height - H)*0.5

X = display.contentCenterX
Y = display.contentCenterY
-- SH = display.topStatusBarContentHeight
SH = 20

IP = "http://123.207.117.106"
-- IP = "http://localhost"

-- 定时器
refresh_timer = nil  
selectCellId = nil
cell_indexToid = {}
cell_idToindex = {}
mainsLayer = nil
All_cell={}

feedbackBox = nil



baseLayer = display.newGroup()

function color(types)
	if( types =="white") then
		return 245/255,245/255,245/255
	elseif ( types == "black") then
		return 62/255,62/255,64/255
	elseif ( types == "gray") then
		return 202/255,205/255,211/255
	elseif (types == "blue") then
		return 9/255,163/255,220/255
	elseif (types == "sky_blue") then
		return 123/255,190/255,198/255
	elseif (types == "red") then
		return 246/255,71/255,23/255
	elseif (types == "hui") then
		return	140/255,140/255,120/255
	else
		return 131/255,216/255,67/255
	end
end



local json = require( "json" )
local widget = require( "widget" )
widget.setTheme( "widget_theme_android_holo_light" )
require("src.util.util")
require ("src.login.login")
require ("src.information.information")
require("src.mains.mains")


local islogin = true
local logoPicturePath = "picture_res/logo.jpg"




local function logoScene()
	local logoLayer = display.newGroup()
	local logo = display.newImageRect(logoPicturePath,width,height)
	logo.x,logo.y = X,Y
	logoLayer:insert(logo)
	return logoLayer
end


local function startScene()

	
	islogin = Util:getNativeValue("islogin")

	-- islogin = false
	if not islogin then
		Login:Init(baseLayer)
    else
    	-- appoint:Init()
    	Mains:Init(baseLayer)
    	-- wait:init()
	end
end

function main(...)
	display.setStatusBar( display.HiddenStatusBar )

	Util:InitFile()  -- new save file 

	local logoLayer = logoScene()
	baseLayer:insert(logoLayer)
	local function listener(event)
		startScene()
		baseLayer:remove(logoLayer)
		logoLayer = nil
	end
	timer.performWithDelay( 500, listener, 1 )
end

--launch program--
main()



