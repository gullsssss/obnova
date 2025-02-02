
script_name("Admin Helper")
script_description('Helper for admins arizona fun')
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
local sampev = require('lib.samp.events')
local ped = PLAYER_PED
require 'widgets'
local dlstatus = require('moonloader').download_status
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
local obnovaMenu = imgui.new.bool(false)

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
    end
end

function sampev.onServerMessage(color, text)

	if text:find('меня заскамили что делать') then sampSendChat('Пишите жалобу на форум') end
    if text:find('Меня заскамили что делать') then sampSendChat('Пишите жалобу на форум') end
    if text:find('меня заскамили помогите') then sampSendChat('Пишите жалобу на форум') end
    if text:find('Меня заскамили помогите') then sampSendChat('Пишите жалобу на форум') end
    if text:find('меня заскамили') then sampSendChat('Пишите жалобу на форум') end
    if text:find('Меня заскамили') then sampSendChat('Пишите жалобу на форум') end
    if text:find('помогите меня заскамили') then sampSendChat('Пишите жалобу на форум') end
    if text:find('Помогите меня заскамили') then sampSendChat('Пишите жалобу на форум') end
	if text:find('как у вас дела') then sampSendChat('Нормально а у вас?') end
    if text:find('Как у вас дела') then sampSendChat('Нормально а у вас?') end
    if text:find('как дела') then sampSendChat('Нормально а у вас?') end
    if text:find('Как дела') then sampSendChat('Нормально а у вас?') end
    if text:find('привет') then sampSendChat('Здраствуйте, уважаемый игрок чем могу помочь?') end
    if text:find('Привет') then sampSendChat('Здраствуйте, уважаемый игрок чем могу помочь?') end
    if text:find('Здраствуйте') then sampSendChat('Здраствуйте, уважаемый игрок чем могу помочь?') end
    if text:find('здраствуйте') then sampSendChat('Здраствуйте, уважаемый игрок чем могу помочь?') end

end

local OBNOVA ={
    url = "https://raw.githubusercontent.com/gullsssss/obnova/refs/heads/main/obnovlenie.json",
   log = {}
}
local upd_res = nil
local obnova_status = 'process'

imgui.OnFrame(function() return obnovaMenu[0] end,
   function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(select(1, getScreenResolution()) / 2, select(2, getScreenResolution()) / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	   imgui.SetNextWindowSize(imgui.ImVec2(700, 400), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'Обновление', obnova, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
         imgui.SetCursorPosX((imgui.GetWindowWidth() - getSize(u8('FunHelper'), 30).x) / 2 )
         imgui.text('FunHelper', 30)
         imgui.Separator()
         imgui.text(u8'Доступно обновление! Новая версия:', 25)
         imgui.SameLine()
         imgui.TextColored(imgui.ImVec4(rainbow(2)), u8'#'..upd_res.version)
         imgui.PopFont()

         imgui.NewLine()

         imgui.text(u8('Список изменений:'), 25)
         imgui.BeginChild('update', imgui.ImVec2(-1, -40), false)
         for k, v in pairs(OBNOVA.log) do 
            for k, v in ipairs(v) do
               imgui.SetCursorPosX(20)
               imgui.text(u8('{TextDisabled}%s) {Text}%s'):format(k, v), 20)
            end
         end
         imgui.EndChild()

         if imgui.Button(u8('Отмена'), imgui.ImVec2(150, -1)) then updateFrame[0] = false end
         imgui.SameLine(imgui.GetWindowWidth() - 155)
         if imgui.Button(u8('Установить'), imgui.ImVec2(150, -1)) then
            obnovaMenu[0] = false
            downloadUpdate(upd_res.url)
         end
      imgui.End()
   end
)

local tab = 1

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1200, 840), imgui.Cond.Always)
    if imgui.Begin('', WinState, imgui.WindowFlags.NoResize) then
        imgui.Image(presentesimple, imgui.ImVec2(200, 100))
        if imgui.BeginTabBar('TB') then
            if imgui.BeginTabItem(fa.USER .. u8( ' Управление персонажем')) then
                tab = 1
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.EARTH_EUROPE .. u8(' Телепорты')) then
                tab = 2
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.CALENDAR_DAYS .. u8(' Мероприятие и челленджы')) then
                tab = 3
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.GEAR .. u8(' Настройки')) then
               tab = 4
               imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.CIRCLE_INFO .. u8(' Прочее')) then
                tab = 5
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem(fa.CODE .. u8(' Читы')) then
                tab = 6
                imgui.EndTabItem()
            end
        end


        if tab == 2 then
            if imgui.Button(fa.BAN .. u8('Телепорт в админ зону'), imgui.ImVec2(300, 60)) then
                sendCommand('az')
            end
            if imgui.Button(fa.HOUSE_USER .. u8(' Телепорт в свой дом'), imgui.ImVec2(300, 60)) then
                sendCommand('spawn')
                sampAddChatMessage('Вы успешно телепортировались в свой дом',-1)
            end
            if imgui.Button (fa.BUILDING_COLUMNS .. u8(' Телепорт в банк'), imgui.ImVec2(300 , 60)) then
                teleportToCoordinates(-2680.46, 800.20, 1501.03)
                sampAddChatMessage('Вы успешно телепортировались в банк', -1)
            end
            if imgui.Button(fa.SACK_DOLLAR .. u8(' БУ рынок'), imgui.ImVec2(300, 60)) then
                teleportToCoordinates(-2150.69, -752.39, 32.02)
                sampAddChatMessage('Вы успешно телепортировались на б/у рынок', -1)
            end
            if imgui.Button(fa.PLANE_DEPARTURE .. u8(' Аэропорт'), imgui.ImVec2(300, 60)) then
                teleportToCoordinates(-1589.67, -294.59, 14.15)
                sampAddChatMessage('Вы успешно телепортировались в аэропорт', -1)
            end
             if imgui.Button(fa.SHOP .. u8(' Центральный рынок'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1128.53, -1426.10, 15.80)
            sampAddChatMessage('Вы успешно телепортировались на центральный рынок', -1)
        end
        if imgui.Button(fa.CAR_BURST .. u8(' Дрифт трасса'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1359.56, 5276.04, 108.92)
            sampAddChatMessage('Вы успешно телепортировались на дрифт трассу', -1)
        end
            if imgui.Text(u8'Изпользовать только на улице') then
            end
        end

       
       if tab == 3 then
        if imgui.Button(fa.BRIDGE .. u8(' Дамба'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(-814.72, 1839.03, 22.92)
            sampAddChatMessage('Вы успешно телепортировались на дамбу', -1)
        end
        if imgui.Button(fa.BRIDGE .. u8(" Мост сф"), imgui.ImVec2(300,60)) then
            teleportToCoordinates(-1663.60, 526.54, 38.48)
            sampAddChatMessage('Вы успешно телепортировались на мост г.Сан-Фиерро', -1)
        end
        if imgui.Button(fa.CITY .. u8(' Небоскёрб'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1541.34, -1349.50, 329.48)
            sampAddChatMessage('Вы успешно телепортировались на небоскрёб', -1)
        end
        if imgui.Button(fa.SHIP .. u8(' Корабль'), imgui.ImVec2(300,60)) then
            teleportToCoordinates(-2415.18, 1544.74, 31.86)
            sampAddChatMessage('Вы успешно телепортировались на корабль', -1)
        end
        if imgui.Button(fa.MOUNTAIN_CITY .. u8(' Чиллад'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(-2298.35, -1639.67, 483.71)
            sampAddChatMessage('Вы успешно телепортировались на гору Чиллиад', -1)
        end
        if imgui.Button(fa.TOWER_OBSERVATION .. u8(' Башеный кран'), imgui.ImVec2(300, 60)) then
            teleportToCoordinates(1239.14, -1257.58, 64.54)
            sampAddChatMessage('Вы успешно телепортировались на башеный кран', -1)
        end
        if imgui.Text(u8'Изпользовать только на улице') then
        end
    end


        if tab == 1 then
            if imgui.Button(fa.CAR .. u8(' Выдать машину'), imgui.ImVec2(300, 60)) then
                sendCommand('plveh 15957')
            end
            if imgui.Button(fa.HEART_PULSE .. u8(' Установить здоровья'), imgui.ImVec2(300, 60)) then
                sendCommand('sethp 999')
            end
            if imgui.Button(fa.GUN .. u8(' Выдать Minigun'), imgui.ImVec2(300, 60)) then
                sendCommand('gg 38 9999')
            end
            if imgui.Button(fa.BRIEFCASE .. u8(' Получить полный доступ'), imgui.ImVec2(300,60)) then
                sendCommand('cb')
            end
            if imgui.Button(fa.CIRCLE_INFO .. u8(' Правила проекта'), imgui.ImVec2(300,60)) then
                pravila[0] = not pravila[0]
            end
        end

        if tab == 4 then
            if imgui.Combo(u8'Выбор темы', theme, new['const char*'][#themeList](themeList), #themeList) then 
                themes[theme[0]+1].func()
                iniSave()
            end
            if imgui.Checkbox(u8'Включить колизию', Checkbox) then
                if Checkbox[0] then
                sendCommand('collision')
            else
                sendCommand('collision')
                end
            end
            if imgui.Checkbox(u8'Стример режим', check) then
                if check[0] then
                sendCommand('tpoff')
             else
                sendCommand('tpon')
                end
            end
                if imgui.Button(fa.ROTATE_RIGHT .. u8(' Перезагрузить Скрипт'), imgui.ImVec2(300,60)) then
                    thisScript():reload()
                    imgui.ShowCursor = false
                end
                if imgui.Button(fa.FILE_ARROW_DOWN .. u8(' Выгрузить Скрипт'), imgui.ImVec2(300,60)) then
                    thisScript():unload()
                    imgui.ShowCursor = false
                end
             end

             if tab == 5 then
                imgui.Text(u8'Автор:gullsssss')
                imgui.Text(fa.PAPER_PLANE .. u8(" t.me/sborkiforrotyanka"))
                imgui.Text(u8'Баги? предложение по скрипту? @gullsssss')
                imgui.Text(u8'Скрипт создан для администрации проекта Arizona Fun')
                imgui.Text(u8'--------------------------------------------------')
                imgui.Text(u8'20.01.25 Обновление скрипта 0.6')
                imgui.Text(u8'1.0 Добавлены новые телепорты а так-же новые места для меорприятие')
                imgui.Text(u8'1.1 Добавленые новые темы и сохранение тем')
                imgui.Text(u8'1.2 Добавленые новые чекбоксы а так же функцию выгрузение скрипта и перезагруску')
                imgui.Text(u8'1.3 Добавлены правила проекта')
                imgui.Text(u8'------------------------------')
                imgui.Text(u8'07.01.25 Бета тест нашего скрипта!!!')

            end
        end
        if tab == 6 then
            if imgui.Checkbox(u8'Полёт', FlyCar.enabled) then
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
    imgui.SetNextWindowPos(imgui.ImVec2(500, 695), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) -- отвечает за положение окна на экране
    imgui.SetNextWindowSize(imgui.ImVec2(350, 500), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Правила Arizona Fun', pravila, imgui.WindowFlags.AlwaysAutoResize)
    if imgui.CollapsingHeader(u8'Правила проекта') then
        imgui.Text(u8'1.0 Попытка ДМ//: /jail 15 минут')
        imgui.Text(u8'1.1 ДМ//: /jail 60 минут')
        imgui.Text(u8'1.2 Махинации//: /ban 2000 дней+обнуление')
        imgui.Text(u8'1.3 Массовый ДМ//: /ban 3 (при повторе /ban 10дней)')
        imgui.Text(u8'1.4 Обман/try, Обман//: /ban 2000 дней+обнуление')
        imgui.Text(u8'1.5 Оскорбление родных//: /ban 5 дней')
        imgui.Text(u8'1.6Упоминание родных//: /mute 150минут-/ban 5 дней')
        imgui.Text(u8'1.7Травля игроков в соц.сетях//: /ban 5 дней+бан ip')
        imgui.Text(u8'1.8 Стримснайп//: /jail 30 минут')
        imgui.Text(u8'1.9 Розжиг обсуждение политики//: /ban 10 дней')
        imgui.Text(u8'1.11 Ремклама промокода//: /mute 120 минут')
        imgui.Text(u8'1.12 Обман администрации и Спец.Администраторов//: /ban 15 дней')
        imgui.Text(u8'1.13 Продажа,Покупка ив//: /ban 2000+обнуление')
        imgui.Text(u8'1.14 Покупка/Передача/Взлом аккаунтов//: /ban 2000 дней+бан по ip+ обнуление')
        imgui.Text(u8'1.15 Обход бана//: /ban всех аккаунтов на 2000 дней')
    end
        if imgui.CollapsingHeader(u8'Правила ДМ зоны') then
        imgui.Text(u8'1.16 Изпользувать охраников в ДМ зоне /jail 60 минут')
        imgui.Text(u8'1.17 Запрещенное оружие в дм зоне(рпг,миниган,огнемет и тд) /jail 120 минут')
        imgui.Text(u8'1.18 Изпользувание бомбы /jail 120 минут')
        imgui.Text(u8'1.19 Изпользувание игрушки на П/У /jail 60 минут')
        imgui.Text(u8"1.20 Езда на транспорте в ДМ зоне /jail 60 минут")
        imgui.Text(u8'1.21 Изпользувание вред.ПО /ban 1 день')
        end
        if imgui.CollapsingHeader(u8'Правила Поведение в /az') then
        imgui.Text(u8'1.22 Стрельба/ДМ игрока /jail 75 минут')
        imgui.Text(u8'1.23 Попрошайничество в /az /mute 15 минут')
        imgui.Text(u8'1.24 Флуд (от 3-?х одинаковых сообщения за 18 секунд)')
        imgui.Text(u8'1.25 Прицеливание на игрока /jail 20 минут')
        imgui.Text(u8'1.26 Стрелять в стену или около игрока /jail 50 минут')
        imgui.Text(u8'1.27 Capslock в /az /mute 30 минут')
        end
        if imgui.CollapsingHeader(u8'Правила фам каптов') then
        imgui.Text(u8'1.28 Стрельба вне зоны /jail 60 минут')
        imgui.Text(u8'1.29 Изпользувать другие оружие со списка')
        imgui.Text(u8'1.30 Кроме м4(31id) deagle(24id) uzi(28id), обрезы(26id)')
        imgui.Text(u8'1.31 Покидать зону во время перестрелки. (Если человек случайным образом покинул фам капт, ему даётся 10 секунд чтобы вернуться) /jail 25 минут')
        imgui.Text(u8'1.32 Использовать игрушки на П/У')
        imgui.Text(u8'1.33 ДБ танки и тд /jail 60')
        imgui.Text(u8'1.34 Изпользувание вред.ПО /ban 3 дня')
        imgui.Text(u8'1.35 Запрещено делать через капты нецензурные вещи на карте удалание семьи + /ban')
        end
        if imgui.CollapsingHeader(u8'Правила Фан Доступов') then
            imgui.Text(u8'1.0 Нельзя продавать/передавать выданные предметы командой /giveitem. // Сняте ФД + Бан')
            imgui.Text(u8'1.1Нельзя кикать людей за неадекватную причину или не по правилам сервера')
            imgui.Text(u8'Нельзя спавнить людей без причины')
            imgui.Text(u8'За неадеквата в /ao //;/mute 300минут')
            imgui.Text(u8'За неадекват Фейк-бан или /kick /ban 5 дней')
            imgui.Text(u8'Скип репорта ради заработка ФК//; снятие ФД + /ban 30 дней')
            imgui.Text(u8'Неадекватный ответ на репорт//; снятие фд')
        end
        if imgui.CollapsingHeader(u8'Команды фд') then
            imgui.Text(u8'/kick id')
            imgui.Text(u8'/fakeban id фейковый бан')
            imgui.Text(u8'/matchitem найти айди предмета')
            imgui.Text(u8'giveitem itemid выдать предмет')
            imgui.Text(u8'/givemoney кол-во денег')
            imgui.Text(u8'/setprefix установить префикс в /ao')
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
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff} Добро пожаловать в FunHelper!", -1)
    wait(1)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff} Вы можете ознакомится с правилами проекта а так-же наказание", -1)
    wait(1)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff}Скрипт загружается...", -1)
    wait(300)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff}Скрипт успешно загружен, активация {ffffff} /ap", -1)
    wait(1)
    sampAddChatMessage("{ff08f3}[FunHelper] {ffffff}Приятного администрирование на проекте ArzionaFun ", -1)
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
    -- == Декор часть == --
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
            name = u8'Черная',
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
        name = u8'Зелёная',
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
        name = u8'Белый',
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
    name = u8"Красный",
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
    name = u8"Оранджевая",
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


