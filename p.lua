
script_name("����� ��������")
script_description('�������� ��� ������������� arizona fun')
script_author("tg: @gullsssss")
script_version("0.7")

local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new
local ffi = require 'ffi'
local new = imgui.new
local themeList = {}
local ped = PLAYER_PED
require 'widgets'
local fa = require('fAwesome6_solid')
local iniFile = 'theme.ini'
local inicfg = require 'inicfg'
local ini = inicfg.load({
    cfgtheme = {
        theme = 0
    }
}, iniFile)

local theme = new.int(ini.cfgtheme.theme)

if not doesDirectoryExist(getWorkingDirectory()..'\\config') then 
    print('Creating the config directory') createDirectory(getWorkingDirectory()..'\\config') 
end
if not doesFileExist('monetloader/config/'..iniFile) then 
    print('Creating/updating the .ini file') inicfg.save(ini, iniFile) 
end
function iniSave()
	ini.cfgtheme.theme = theme[0]
	inicfg.save(ini, iniFile)
    end
 imgui.OnInitialize(function()
    fa.Init()
end)

local WinState = new.bool(false)
local Checkbox = new.bool(false)
local pravila = imgui.new.bool(false)
local check = new.bool(false)
local re = imgui.new.bool(false)

local sliderBuf = new.int()
local function sendCommand(cmd)
    if isSampAvailable() then
        sampSendChat('/' .. cmd)
    end
end
local FlyCar = {
    enabled = new.bool(false),
    cars = 0
  }
  
  FlyCar.processFlyCar = function()
    local car = storeCarCharIsInNoSave(PLAYER_PED)
    local speed = getCarSpeed(car)
  
    local result, var_1, var_2 = isWidgetPressedEx(WIDGET_VEHICLE_STEER_ANALOG, 0)
    if result then
      local var_1 = var_1 / -64.0
      local var_2 = var_2 / 64.0
      setCarRotationVelocity(car, var_2, 0.0, var_1)
    end
  
    if isWidgetPressed(WIDGET_ACCELERATE) and speed <= 200.0 then
      FlyCar.cars = FlyCar.cars + 0.4
    end
    if isWidgetPressed(WIDGET_BRAKE) then
      FlyCar.cars = FlyCar.cars - 0.3
      if FlyCar.cars < 0 then FlyCar.cars = 0 end
    end
    if isWidgetPressed(WIDGET_HANDBRAKE) then
      FlyCar.cars = 0
      setCarRotationVelocity(car, 0.0, 0.0, 0.0)
      setCarRoll(car, 0.0)
    end
  
    setCarForwardSpeed(car, FlyCar.cars)
  end
  
  FlyCar.activate = function()
    lua_thread.create(function()
      while FlyCar.enabled[0] do
        if isCharInAnyCar(ped) then
          FlyCar.processFlyCar()
        else
          FlyCar.cars = 0
        end
  
        wait(0)
        end
    end)
end
  FlyCar.reset = function()
    FlyCar.cars = 0
  end

local function teleportToCoordinates(x, y, z)
    if ped then
        setCharCoordinates(ped, x, y, z) 
        sampAddChatMessage("{C8C8C8}�� ���� ������� ���������������!", -1)
    else
        sampAddChatMessage("{C8C8C8}������: �� ������� ����������������� �� �����������!", -1)
    end
end

local tab = 1

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1200, 840), imgui.Cond.Always)
    if imgui.Begin('', WinState, imgui.WindowFlags.NoResize) then
        imgui.Image(presentesimple, imgui.ImVec2(200, 100))
        if imgui.BeginTabBar('TB') then
            if imgui.BeginTabItem(fa.USER .. u8( ' ���������� ����������')) then
                tab = 1
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.EARTH_EUROPE .. u8(' ���������')) then
                tab = 2
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.CALENDAR_DAYS .. u8(' ����������� � ���������')) then
                tab = 3
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.GEAR .. u8(' ���������')) then
               tab = 4
               imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.CIRCLE_INFO .. u8(' ������')) then
                tab = 5
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.CODE .. u8(' ����')) then
                tab = 6
                imgui.EndTabItem()
            end
        end


        if tab == 2 then
            if imgui.Button(fa.BAN .. u8('�������� � ����� ����'), imgui.ImVec2(300, 60)) then
                sendCommand('az')
            end
            if imgui.Button(fa.HOUSE_USER .. u8(' �������� � ���� ���'), imgui.ImVec2(300, 60)) then
                sendCommand('spawn')
            end
            if imgui.Button (fa.BUILDING_COLUMNS .. u8(' �������� � ����'), imgui.ImVec2(300 , 60)) then
                teleportToCoordinates(-2680.46, 800.20, 1501.03)
            end
            if imgui.Button(fa.SACK_DOLLAR .. u8(' �� �����'), imgui.ImVec2(300, 60)) then
                teleportToCoordinates(-2150.69, -752.39, 32.02)
            end
            if imgui.Button(fa.PLANE_DEPARTURE .. u8(' ��������'), imgui.ImVec2(300, 60)) then
                teleportToCoordinates(-1589.67, -294.59, 14.15)
            end
             if imgui.Button(fa.SHOP .. u8(' ����������� �����'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1128.53, -1426.10, 15.80)
        end
        if imgui.Button(fa.CAR_BURST .. u8(' ����� ������'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1359.56, 5276.04, 108.92)
        end
            if imgui.Text(u8'������������ ������ �� �����') then
            end
        end

       
       if tab == 3 then
        if imgui.Button(fa.BRIDGE .. u8(' �����'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(-814.72, 1839.03, 22.92)
        end
        if imgui.Button(fa.BRIDGE .. u8(" ���� ��"), imgui.ImVec2(300,60)) then
            teleportToCoordinates(-1663.60, 526.54, 38.48)
        end
        if imgui.Button(fa.CITY .. u8(' ��������'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1541.34, -1349.50, 329.48)
        end
        if imgui.Button(fa.SHIP .. u8(' �������'), imgui.ImVec2(300,60)) then
            teleportToCoordinates(-2415.18, 1544.74, 31.86)
        end
        if imgui.Button(fa.MOUNTAIN_CITY .. u8(' ������'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(-2298.35, -1639.67, 483.71)
        end
        if imgui.Button(fa.TOWER_OBSERVATION .. u8(' ������� ����'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1239.14, -1257.58, 64.54)
        end
        if imgui.Text(u8'������������ ������ �� �����') then
        end
    end


        if tab == 1 then
            if imgui.Button(fa.CAR .. u8(' ������ ������'), imgui.ImVec2(300, 60)) then
                sendCommand('plveh 15957')
            end
            if imgui.Button(fa.HEART_PULSE .. u8(' ���������� ��������'), imgui.ImVec2(300, 60)) then
                sendCommand('sethp 999')
            end
            if imgui.Button(fa.GUN .. u8(' ������ Minigun'), imgui.ImVec2(300, 60)) then
                sendCommand('gg 38 9999')
            end
            if imgui.Button(fa.BRIEFCASE .. u8(' �������� ������ ������'), imgui.ImVec2(300,60)) then
                sendCommand('cb')
            end
            if imgui.Button(fa.CIRCLE_INFO .. u8(' ������� �������'), imgui.ImVec2(300,60)) then
                pravila[0] = not pravila[0]
            end
        end

        if tab == 4 then
            if imgui.Combo(u8'����� ����', theme, new['const char*'][#themeList](themeList), #themeList) then 
                themes[theme[0]+1].func()
                iniSave()
            end
            if imgui.Checkbox(u8'�������� �������', Checkbox) then
                if Checkbox[0] then
                sendCommand('collision')
            else
                sendCommand('collision')
                end
            end
            if imgui.Checkbox(u8'������� �����', check) then
                if check[0] then
                sendCommand('tpoff')
             else
                sendCommand('tpon')
                end
            end
                if imgui.Button(fa.ROTATE_RIGHT .. u8(' ������������� ������'), imgui.ImVec2(300,60)) then
                    thisScript():reload()
                    imgui.ShowCursor = false
                end
                if imgui.Button(fa.FILE_ARROW_DOWN .. u8(' ��������� ������'), imgui.ImVec2(300,60)) then
                    thisScript():unload()
                    imgui.ShowCursor = false
                end
             end

             if tab == 5 then
                imgui.Text(u8'�����:gullsssss')
                imgui.Text(fa.PAPER_PLANE .. u8(" t.me/sborkiforrotyanka"))
                imgui.Text(u8'����? ����������� �� �������? @gullsssss')
                imgui.Text(u8'������ ������ ��� ������������� ������� Arizona Fun')
                imgui.Text(u8'--------------------------------------------------')
                imgui.Text(u8'20.01.25 ���������� ������� 0.6')
                imgui.Text(u8'1.0 ��������� ����� ��������� � ���-�� ����� ����� ��� �����������')
                imgui.Text(u8'1.1 ���������� ����� ���� � ���������� ���')
                imgui.Text(u8'1.2 ���������� ����� �������� � ��� �� ������� ���������� ������� � ������������')
                imgui.Text(u8'1.3 ��������� ������� �������')
                imgui.Text(u8'------------------------------')
                imgui.Text(u8'07.01.25 ���� ���� ������ �������!!!')

            end
        end
        if tab == 6 then
            if imgui.Checkbox(u8'����', FlyCar.enabled) then
                if FlyCar.enabled[0] then
                  FlyCar.activate()
                else
                  FlyCar.reset()
                end
              end

        imgui.End()
            end
end)


local otherFrame = imgui.OnFrame(
function() return pravila[0] end,
function(self)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 695), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) -- �������� �� ��������� ���� �� ������
    imgui.SetNextWindowSize(imgui.ImVec2(350, 500), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'������� Arizona Fun', pravila, imgui.WindowFlags.AlwaysAutoResize)
    if imgui.CollapsingHeader(u8'������� �������') then
        imgui.Text(u8'1.0 ������� ��//: /jail 15 �����')
        imgui.Text(u8'1.1 ��//: /jail 60 �����')
        imgui.Text(u8'1.2 ���������//: /ban 2000 ����+���������')
        imgui.Text(u8'1.3 �������� ��//: /ban 3 (��� ������� /ban 10����)')
        imgui.Text(u8'1.4 �����/try, �����//: /ban 2000 ����+���������')
        imgui.Text(u8'1.5 ����������� ������//: /ban 5 ����')
        imgui.Text(u8'1.6���������� ������//: /mute 150�����-/ban 5 ����')
        imgui.Text(u8'1.7������ ������� � ���.�����//: /ban 5 ����+��� ip')
        imgui.Text(u8'1.8 ����������//: /jail 30 �����')
        imgui.Text(u8'1.9 ������ ���������� ��������//: /ban 10 ����')
        imgui.Text(u8'1.11 �������� ���������//: /mute 120 �����')
        imgui.Text(u8'1.12 ����� ������������� � ����.���������������//: /ban 15 ����')
        imgui.Text(u8'1.13 �������,������� ��//: /ban 2000+���������')
        imgui.Text(u8'1.14 �������/��������/����� ���������//: /ban 2000 ����+��� �� ip+ ���������')
        imgui.Text(u8'1.15 ����� ����//: /ban ���� ��������� �� 2000 ����')
    end
        if imgui.CollapsingHeader(u8'������� �� ����') then
        imgui.Text(u8'1.16 ������������ ��������� � �� ���� /jail 60 �����')
        imgui.Text(u8'1.17 ����������� ������ � �� ����(���,�������,������� � ��) /jail 120 �����')
        imgui.Text(u8'1.18 ������������� ����� /jail 120 �����')
        imgui.Text(u8'1.19 ������������� ������� �� �/� /jail 60 �����')
        imgui.Text(u8"1.20 ���� �� ���������� � �� ���� /jail 60 �����")
        imgui.Text(u8'1.21 ������������� ����.�� /ban 1 ����')
        end
        if imgui.CollapsingHeader(u8'������� ��������� � /az') then
        imgui.Text(u8'1.22 ��������/�� ������ /jail 75 �����')
        imgui.Text(u8'1.23 ���������������� � /az /mute 15 �����')
        imgui.Text(u8'1.24 ���� (�� 3-?� ���������� ��������� �� 18 ������)')
        imgui.Text(u8'1.25 ������������ �� ������ /jail 20 �����')
        imgui.Text(u8'1.26 �������� � ����� ��� ����� ������ /jail 50 �����')
        imgui.Text(u8'1.27 Capslock � /az /mute 30 �����')
        end
        if imgui.CollapsingHeader(u8'������� ��� ������') then
        imgui.Text(u8'1.28 �������� ��� ���� /jail 60 �����')
        imgui.Text(u8'1.29 ������������ ������ ������ �� ������')
        imgui.Text(u8'1.30 ����� �4(31id) deagle(24id) uzi(28id), ������(26id)')
        imgui.Text(u8'1.31 �������� ���� �� ����� �����������. (���� ������� ��������� ������� ������� ��� ����, ��� ����� 10 ������ ����� ���������) /jail 25 �����')
        imgui.Text(u8'1.32 ������������ ������� �� �/�')
        imgui.Text(u8'1.33 �� ����� � �� /jail 60')
        imgui.Text(u8'1.34 ������������� ����.�� /ban 3 ���')
        imgui.Text(u8'1.35 ��������� ������ ����� ����� ����������� ���� �� ����� �������� ����� + /ban')
        end
        if imgui.CollapsingHeader(u8'������� ��� ��������') then
            imgui.Text(u8'1.0 ������ ���������/���������� �������� �������� �������� /giveitem. // ����� �� + ���')
            imgui.Text(u8'1.1������ ������ ����� �� ������������ ������� ��� �� �� �������� �������')
            imgui.Text(u8'������ �������� ����� ��� �������')
            imgui.Text(u8'�� ���������� � /ao //;/mute 300�����')
            imgui.Text(u8'�� ��������� ����-��� ��� /kick /ban 5 ����')
            imgui.Text(u8'���� ������� ���� ��������� ��//; ������ �� + /ban 30 ����')
            imgui.Text(u8'������������ ����� �� ������//; ������ ��')
        end
        if imgui.CollapsingHeader(u8'������� ��') then
            imgui.Text(u8'/kick id')
            imgui.Text(u8'/fakeban id �������� ���')
            imgui.Text(u8'/finditem ����� ���� ��������')
            imgui.Text(u8'giveitem itemid ������ �������')
            imgui.Text(u8'/givemoney ���-�� �����')
            imgui.Text(u8'/setprefix ���������� ������� � /ao')
        end
    end)

  

function main()
     while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand('ap', function()
        WinState[0] = not WinState[0]
    end)
    repeat
        wait(0)
    until sampIsLocalPlayerSpawned()
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff} ����� ���������� � FunHelper!", -1)
    wait(1)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff} �� ������ ����������� � ��������� ������� � ���-�� ���������", -1)
    wait(1)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff}������ �����������...", -1)
    wait(300)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff}������ ������� ��������, ��������� {ffffff} /ap", -1)
    wait(1)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff}��������� ����������������� �� ������� ArzionaFun ", -1)
    wait(-1)
end
imgui.OnInitialize(function()
    presentesimple = imgui.CreateTextureFromFile(u8(getWorkingDirectory() .. '/images/logo.png'))
    decor()
    for i, v in ipairs(themes) do
        table.insert(themeList, v.name)
    end
    themes[theme[0]+1].func()
end)



function decor()
    -- == ����� ����� == --
    local gs = imgui.GetStyle()
    gs.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    gs.WindowRounding = 10.0
    gs.ChildRounding = 6.0
    gs.FrameRounding = 12
    gs.PopupRounding = 8
    gs.ScrollbarRounding = 8
    gs.ScrollbarSize = 13.0
    gs.GrabRounding = 8.0
end

themes = {
	     {
            name = u8'������',
            func = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
            imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
            imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
            imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
            imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
        end
    },
    {
        name = u8'������',
        func = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(0.85, 0.93, 0.85, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.55, 0.65, 0.55, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.13, 0.22, 0.13, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.17, 0.27, 0.17, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.15, 0.24, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.18, 0.28, 0.18, 1.00)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.55, 0.75, 0.55, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.28, 0.38, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.15, 0.25, 0.15, 0.80)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
        end
	},
    {
        name = u8'�����',
        func = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00);
            imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
            imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
            imgui.GetStyle().Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.94, 0.94, 0.94, 0.78);
            imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
            imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
            imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.00, 0.00, 0.00, 0.51);
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.00);
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.31, 0.31, 0.31, 1.00);
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1.00);
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1.00);
            imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.20, 0.20, 0.20, 1.00);
            imgui.GetStyle().Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.00, 0.48, 0.85, 1.00);
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.80, 0.80, 0.80, 1.00);
            imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.88, 0.88, 0.88, 1.00);
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
            imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
            imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(0.88, 0.88, 0.88, 1.00);
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
            imgui.GetStyle().Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
            imgui.GetStyle().Colors[imgui.Col.Separator] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.10, 0.40, 0.75, 0.78);
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.10, 0.40, 0.75, 1.00);
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.00, 0.00, 0.00, 0.25);
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.00, 0.00, 0.00, 0.67);
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.00, 0.00, 0.00, 0.95);
            imgui.GetStyle().Colors[imgui.Col.Tab] = imgui.ImVec4(0.88, 0.88, 0.88, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TabHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TabActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.07, 0.10, 0.15, 0.97);
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.14, 0.26, 0.42, 1.00);
            imgui.GetStyle().Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1.00);
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1.00, 0.43, 0.35, 1.00);
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00);
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.00, 0.47, 0.84, 1.00);
            imgui.GetStyle().Colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90);
            imgui.GetStyle().Colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
            imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70);
            imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20);
            imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.35);
        end
    },
{
    name = u8"�������",
    func = function()
        local ImVec4 = imgui.ImVec4
        imgui.SwitchContext()
        imgui.GetStyle().Colors[imgui.Col.Text] = imgui.ImVec4(0.95, 0.96, 0.98, 1.00)
        imgui.GetStyle().Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.60, 0.60, 0.60, 1.00)
        imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.15, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.20, 0.15, 0.15, 1.00)
        imgui.GetStyle().Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.15, 0.10, 0.10, 0.95)
        imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.70, 0.30, 0.30, 0.50)
        imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
        imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.25, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.40, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.60, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.15, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.25, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.15, 0.10, 0.10, 0.75)
        imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.15, 0.10, 0.10, 0.60)
        imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.80, 0.20, 0.20, 0.80)
        imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.90, 0.30, 0.30, 0.80)
        imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.95, 0.40, 0.40, 1.00)
        imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.20, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.30, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.40, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(0.20, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.40, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.60, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.Tab] = imgui.ImVec4(0.20, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.TabHovered] = imgui.ImVec4(0.40, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.TabActive] = imgui.ImVec4(0.60, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
        imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.90, 0.30, 0.30, 1.00)
        imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
        imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0.90, 0.30, 0.30, 1.00)
        imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.30, 0.60, 0.85, 0.35)
        imgui.GetStyle().Colors[imgui.Col.DragDropTarget] = imgui.ImVec4(0.85, 0.60, 0.40, 0.90)
        imgui.GetStyle().Colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.80, 0.30, 0.30, 1.00)
        imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(0.90, 0.50, 0.50, 0.70)
        imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.20, 0.20, 0.25, 0.20)
        imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.90, 0.10, 0.10, 1.00)
        imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.20, 0.20, 0.25, 0.35)
    end
},
{
    name = u8"����������",
    func = function()
    local ImVec4 = imgui.ImVec4
     imgui.SwitchContext()
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 0.90, 0.85, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.75, 0.60, 0.55, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 0.30)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.55, 0.35, 0.25, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.20, 0.10, 0.05, 1.00)
imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(1.00, 0.70, 0.55, 1.00)
imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.65, 0.40, 0.30, 1.00)
imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.65, 0.40, 0.30, 1.00)
imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.25, 0.15, 0.10, 0.80)
imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
end
}
}


