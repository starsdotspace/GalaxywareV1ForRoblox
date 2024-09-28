local GuiLibrary = shared.GuiLibrary
local vapeAssert = function(argument, title, text, duration, hault, moduledisable, module) 
	if not argument then
    local suc, res = pcall(function()
    local notification = GuiLibrary.CreateNotification(title or "Nebulaware", text or "Failed to call function.", duration or 20, "assets/WarningNotification.png")
    notification.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
    notification.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
    if moduledisable and (module and GuiLibrary.ObjectsThatCanBeSaved[module.."OptionsButton"].Api.Enabled) then GuiLibrary.ObjectsThatCanBeSaved[module.."OptionsButton"].Api.ToggleButton(false) end
    end)
    if hault then while true do task.wait() end end
end
end



local identifyexecutor = identifyexecutor or function() return "Unknown" end
local httprequest = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function() end 
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local setclipboard = setclipboard or function(data) writefile("clipboard.txt", data) end
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local delfolder = delfolder or function() end
local antiguibypass = GuiLibrary.SelfDestruct
local httpService = game:GetService("HttpService")
local playersService = game:GetService("Players")
local textService = game:GetService("TextService")
local lightingService = game:GetService("Lighting")
local textChatService = game:GetService("TextChatService")
local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local collectionService = game:GetService("CollectionService")
local replicatedStorageService = game:GetService("ReplicatedStorage")
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vapeConnections = {}
local vapeCachedAssets = {}
local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new("BindableEvent")
		return self[index]
	end
})
local vapeTargetInfo = shared.VapeTargetInfo
local vapeInjected = true
local NebulawareFunctions = {WhitelistLoaded = false, WhitelistRefreshEvent = Instance.new("BindableEvent")}
local NebulawareWhitelistStore = {
	Hash = "Nebulawareprivatemoment",
	BlacklistTable = {},
	Tab = {},
	Rank = "OWNER",
	Priority = {
		DEFAULT = 0,
		STANDARD = 1,
		BETA = 1.5,
		PRIVATE = 2,
		OWNER = 3
	},
	RankChangeEvent = Instance.new("BindableEvent"),
	chatstrings = {
		Nebulawaremoment = "Nebulaware",
		Nebulawareprivatemoment = "Nebulaware Private"
	},
	LocalPlayer = {Rank = "OWNER", Attackable = false, Priority = 1, TagText = "Nebulaware USER", TagColor = "0000FF", TagHidden = false, HWID = "ABCDEFG", Accounts = {}, BlacklistedProducts = {}, UID = 0},
	Players = {}
}
local tags = {}
local NebulawareStore = {
	maindirectory = "vape/Nebulaware",
	VersionInfo = {
        MainVersion = "3.1",
        PatchVersion = "0",
        Nickname = "Private",
		BuildType = "Stable",
		VersionID = "3.1"
    },
	FolderTable = {"vape/Nebulaware", "vape/Nebulaware/data"},
	SystemFiles = {"vape/NewMainScript.lua", "vape/MainScript.lua", "vape/GuiLibrary.lua", "vape/Universal.lua"},
	teleportinprogress = false,
	watermark = function(text) return ("[Nebulaware] "..text) end,
	Tweening = false,
	map = "Unknown",
	EnumFonts = {"SourceSans"},
	QueueTypes = {"bedwars_to4"},
	TimeLoaded = tick(),
	ServerRegion = "none",
	GameStarted = nil,
	GameFinished = shared.NebulawareStore and shared.NebulawareStore.GameFinished or false,
	CurrentPing = 0,
	TargetObject = shared.NebulawareTargetObject,
	bedtable = {},
	HumanoidDied = Instance.new("BindableEvent"),
	ReceivedTick = tick(),
	ServerDelay = 0,
	SentTick = tick(),
	Tag = function(name, player, color)
		name = name or "Nebulaware USER"
		player = player or lplr
		color = color or "FF0000"
		tags[player] = {}
		tags[player].TagText = name
		tags[player].TagColor = color
	end,
	MobileInUse = (inputService:GetPlatform() == Enum.Platform.Android or inputService:GetPlatform() == Enum.Platform.IOS) and true or false,
	InfiniteScythe = 0,
	vapePrivateCommands = {},
	Enums = {},
	jumpTick = tick(),
	Api = {},
	AverageFPS = 60,
	FrameRate = 60,
	SwordMeta = {
		wood = 1,
		stone = 2,
		iron = 3,
		diamond = 4,
		rageblade = 5
	},
	AliveTick = tick(),
	DeathFunction = nil,
	projectileAuraTick = tick()
}
NebulawareStore.FolderTable = {"vape/Nebulaware", NebulawareStore.maindirectory, NebulawareStore.maindirectory.."/".."data"}
shared.NebulawareStore = shared.NebulawareStore or {
	ConfigUsers = {},
	BlatantModules = {},
	Messages = {},
	GameFinished = false,
	WhitelistChatSent = {},
	HookedFunctions = {}
}
shared.NebulawareStore.ModuleType = "BedwarsMain"
local NebulawareRank = NebulawareWhitelistStore.Rank
local NebulawarePriority = NebulawareWhitelistStore.Priority
local bedwars = {}
local bedwarsStore = {
	attackReach = 0,
	attackReachUpdate = tick(),
	blocks = {},
	blockPlacer = {},
	blockPlace = tick(),
	blockRaycast = RaycastParams.new(),
	equippedKit = "none",
	forgeMasteryPoints = 0,
	forgeUpgrades = {},
	grapple = tick(),
	inventories = {},
	localInventory = {
		inventory = {
			items = {},
			armor = {}
		},
		hotbar = {}
	},
	localHand = {},
	matchState = 0,
	matchStateChanged = tick(),
	pots = {},
	queueType = "bedwars_test",
	scythe = tick(),
	statistics = {
		beds = 0,
		kills = 0,
		lagbacks = 0,
		lagbackEvent = Instance.new("BindableEvent"),
		reported = 0,
		universalLagbacks = 0
	},
	whitelist = {
		chatStrings1 = {helloimusinginhaler = "vape"},
		chatStrings2 = {vape = "helloimusinginhaler"},
		clientUsers = {},
		oldChatFunctions = {}
	},
	zephyrOrb = 0
}
bedwarsStore.blockRaycast.FilterType = Enum.RaycastFilterType.Include
local AutoLeave = {Enabled = false}

table.insert(vapeConnections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA("Camera")
end))

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	vapeInjected = false
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)

local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end

function NebulawareFunctions:LoadTime()
	if shared.VapeFullyLoaded then
		return (tick() - NebulawareStore.TimeLoaded)
	else
		return 0
	end
end

task.spawn(function()
	local lastrank = NebulawareWhitelistStore.Rank:upper()
	repeat
	NebulawareRank = NebulawareWhitelistStore.Rank:upper()
	if NebulawareRank ~= lastrank then
		NebulawareWhitelistStore.RankChangeEvent:Fire(NebulawareRank)
		lastrank = NebulawareRank
	end
	task.wait()
	until not vapeInjected
end)

function NebulawareFunctions:FireWebhook(tab)
	if not tab then tab = {} end
		tab.Url = tab.Url or ""
		tab.content = tab.content or ""
		local newdata = httpService:JSONEncode(tab)
		local headers = {
			["content-type"] = "application/json"
		}
	local data = {Url = tab.Url, Body = newdata, Method = "POST", Headers = headers}
	local suc, res = pcall(httprequest, data)
	return suc and res ~= false
end

local function betterhttpget(url)
	local supportedexploit, body = syn and syn.request or http_requst or request or fluxus and fluxus.request, ""
	if supportedexploit then
		local data = httprequest({Url = url, Method = "GET"})
		if data.Body then
			body = data.Body
		else
			return game:HttpGet(url, true)
		end
	else
		body = game:HttpGet(url, true)
	end
	return body
end

function NebulawareFunctions:GetPlayerType(plr)
	if not NebulawareFunctions.WhitelistLoaded then return "DEFAULT", true, 0, "SPECIAL USER", "FFFFFF", true, 0, false, "ABCDEFGH" end
	plr = plr or lplr
	local tab = NebulawareWhitelistStore.Players[plr.UserId]
	if tab == nil then
		return "DEFAULT", true, 0, "SPECIAL USER", "FFFFFF", true, 0, false, "ABCDEFGH"
	else
		tab.Priority = NebulawarePriority[tab.Rank:upper()]
		return tab.Rank, tab.Attackable, tab.Priority, tab.TagText, tab.TagColor, tab.TagHidden, tab.UID, tab.HWID
	end
end

 function NebulawareFunctions:GetCommitHash(repo)
	 local commit, repo = "main", repo or "Nebulaware"
	 local req, res = pcall(function() return game:HttpGet("https://github.com/NebulawareConfig/"..repo) end)
	 if not req or not res then return commit end
	 for i,v in pairs(res:split("\n")) do 
	    if v:find("commit") and v:find("fragment") then 
	    local str = v:split("/")[5]
	    commit = str:sub(0, v:split("/")[5]:find('"') - 1)
        break
	    end
	end
	return commit
end

function NebulawareFunctions:SpecialInGame()
	local specialtable = {}
	for i,v in pairs(playersService:GetPlayers()) do
		if v ~= lplr and ({NebulawareFunctions:GetPlayerType(v)})[3] > 1.5 then
			table.insert(specialtable, v)
		end
	end
	return #specialtable > 0 and specialtable
end

function NebulawareFunctions:GetClientUsers()
	local users = {}
	for i,v in pairs(playersService:GetPlayers()) do
		if v ~= lplr and table.find(shared.NebulawareStore.ConfigUsers, v) then
			table.insert(users, plr)
		end
	end
	return users
end

function NebulawareFunctions:RefreshWhitelist()
	local commit, hwidstring = NebulawareFunctions:GetCommitHash("whitelist"), string.split(HWID, "-")[5]
	local suc, whitelist = pcall(function() return httpService:JSONDecode(betterhttpget("https://raw.githubusercontent.com/NebulawareConfig/WhitelistsV2/"..commit.."/Whitelists.json")) end)
	local attributelist = {"Rank", "Attackable", "TagText", "TagColor", "TagHidden", "UID"}
	local defaultattributelist = {Rank = "DEFAULT", Attackable = true, Priority = 1, TagText = "Nebulaware USER", TagColor = "FFFFFF", TagHidden = true, UID = 0, HWID = "ABCDEFGH"}
	if suc and whitelist then
		for i,v in pairs(whitelist) do
			if i == hwidstring and not table.find(v.BlacklistedProducts, NebulawareWhitelistStore.Hash) then 
				NebulawareWhitelistStore.Rank = v.Rank:upper()
				NebulawareWhitelistStore.Tab = v
				NebulawareWhitelistStore.Players[lplr.UserId] = v
				NebulawareWhitelistStore.LocalPlayer = v
				NebulawareWhitelistStore.LocalPlayer.HWID = i
				NebulawareWhitelistStore.Players[lplr.UserId].HWID = i
				NebulawareWhitelistStore.Players[lplr.UserId].Priority = NebulawareRank[v.Rank:upper()]
			end
			for i2, v2 in pairs(playersService:GetPlayers()) do
				if NebulawareWhitelistStore.Players[v2.UserId] == nil then
				   NebulawareWhitelistStore.Players[v2.UserId] = defaultattributelist
			        if table.find(v.Accounts, tostring(v2.UserId)) and not table.find(v.BlacklistedProducts, NebulawareWhitelistStore.Hash) then
					 NebulawareWhitelistStore.Players[v2.UserId] = v
					if NebulawarePriority[NebulawareWhitelistStore.Rank:upper()] >= NebulawarePriority[v2.Rank] then
					 NebulawareWhitelistStore.Players[v2.UserId].Attackable = true
					end
			       end
			   end
		    end
		end
		table.insert(vapeConnections, playersService.PlayerAdded:Connect(function(v2)
			for i,v in pairs(whitelist) do
				if NebulawareWhitelistStore.Players[v2.UserId] == nil then
					NebulawareWhitelistStore.Players[v2.UserId] = defaultattributelist
					 if table.find(v.Accounts, tostring(v2.UserId)) and not table.find(v.BlacklistedProducts, NebulawareWhitelistStore.Hash) then
					 NebulawareWhitelistStore.Players[v2.UserId] = v
					 if NebulawarePriority[NebulawareWhitelistStore.Rank:upper()] >= NebulawarePriority[v.Rank] then
						NebulawareWhitelistStore.Players[v2.UserId].Attackable = true
					end
					  NebulawareWhitelistStore.HWID = i
					end
				end
			end
		end))
		table.insert(vapeConnections, playersService.PlayerRemoving:Connect(function(v2)
			if NebulawareWhitelistStore.Players[v2.UserId] ~= nil then
				NebulawareWhitelistStore.Players[v2.UserId] = nil
			end
		end))
	end
	return suc, whitelist
end

local function to_base64(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
 
local function from_base64(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end


function NebulawareFunctions:GetFile(file, online, path)
	if not isfolder("vape") then makefolder("vape") end
	if not isfolder("vape/Nebulaware") then makefolder("vape/Nebulaware") end
	local repo = NebulawareStore.VersionInfo.BuildType == "Beta" and "NebulawareBeta" or "Nebulaware"
	local directory = NebulawareStore.maindirectory or "vape/Nebulaware"
	if not isfolder(directory) then makefolder(directory) end
	local existent = pcall(function() return readfile(path or directory.."/"..file) end)
	local Nebulawarever = "main"
	local str = string.split(file, "/") or {}
	local lastfolder = nil
	local foldersplit2
	if not existent and not online then
		Nebulawarever = NebulawareFunctions:GetCommitHash(repo)
		local github, data = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/NebulawareConfig/"..repo.."/"..Nebulawarever.."/"..file, true) end)
		if github and data ~= "404: Not Found" then
		if not isfolder("vape") then makefolder("vape") end
		if not isfolder("vape/Nebulaware") then makefolder("vape/Nebulaware") end
		if not isfolder(directory) then makefolder(directory) end
		if #str > 0 and not path and data ~= "404: Not Found" then
		for i,v in pairs(str) do
			local foldersplit = lastfolder ~= nil and directory.."/"..lastfolder.."/" or ""
			foldersplit2 = string.gsub(foldersplit, directory.."/", "")
			local str2 = string.split(v, ".") or {}
			if #str2 == 1 then
				if not isfolder(directory..foldersplit2..v) then
					makefolder(directory.."/"..foldersplit2..v)
				end
				lastfolder = v and foldersplit2..v or lastfolder
			end
		end
	end
			data = file:find(".lua") and "-- Nebulaware Custom Modules Signed File\n"..data or data
			writefile(path or directory.."/"..file, data)
		else
			vapeAssert(false, "Nebulaware", "Failed to download "..directory.."/"..file.." | "..data, 60)
			return ""
		end
	end
	return online and betterhttpget("https://raw.githubusercontent.com/NebulawareConfig/"..repo.."/"..Nebulawarever.."/"..file) or readfile(path or directory.."/"..file)
end

function NebulawareFunctions:FireWebhook(tab)
	if not tab then tab = {} end
		tab.Url = tab.Url or ""
		tab.content = tab.content or ""
		local newdata = httpService:JSONEncode(tab)
		local headers = {
			["content-type"] = "application/json"
		}
	local data = {Url = tab.Url, Body = newdata, Method = "POST", Headers = headers}
	local suc, res = pcall(httprequest, data)
	return suc and res ~= false
end

task.spawn(function()
	local response = false
	local whitelistloaded, err
	local suc, res
	task.spawn(function()
		whitelistloaded, err = NebulawareFunctions:RefreshWhitelist()
		response = true
	end)
	task.delay(15, function() if not response then suc, res = pcall(function() whitelistloaded, err = NebulawareFunctions:RefreshWhitelist() end) response = true end end)
	repeat task.wait() until response
	if not whitelistloaded then
		task.spawn(error, "[Nebulaware] Failed to load whitelist functions: "..err)
	end
	task.wait(0.3)
	NebulawareFunctions.WhitelistLoaded = true
end)

task.spawn(function()
	repeat task.wait(11)
		task.spawn(function()
		NebulawareFunctions:RefreshWhitelist()
		local suc, res = pcall(function() return httpService:JSONDecode(betterhttpget("https://raw.githubusercontent.com/NebulawareConfig/WhitelistsV2/"..NebulawareFunctions:GetCommitHash("whitelist").."/Modulestrings.json")) end)
		if suc and res then
			NebulawareWhitelistStore.chatstrings = res
		end
		if NebulawareFunctions.WhitelistLoaded then
			NebulawareFunctions.WhitelistRefreshEvent:Fire()
		end
		task.wait(0.5)
		NebulawareFunctions.WhitelistLoaded = true
		end)
	until not vapeInjected 
end)

task.spawn(function()
	repeat task.wait() until NebulawareFunctions.WhitelistLoaded
	repeat task.wait()
	if ({NebulawareFunctions:GetPlayerType()})[3] < 1.5 and NebulawareStore.VersionInfo.BuildType == "Beta" then
		task.spawn(function() lplr:Kick("This build of Nebulaware is currently restricted for you.") end)
		pcall(antiguibypass)
		task.wait(1.5)
		game:Shutdown()
		task.wait(2)
		while true do end
	end
	if ({NebulawareFunctions:GetPlayerType()})[3] < 1.5 and NebulawareStore.VersionInfo.BuildType ~= "BETA" then
		pcall(delfolder, "vape/Nebulaware/beta")
	end
until not vapeInjected
task.wait(3)
end)

task.spawn(function()
	local blacklist = false
	repeat task.wait() until NebulawareFunctions.WhitelistLoaded
	pcall(function()
	repeat
	local suc, tab = pcall(function() return httpService:JSONDecode(betterhttpget("raw.githubusercontent.com/NebulawareConfig/WhitelistsV2/"..NebulawareFunctions:GetCommitHash("whitelist").."Blacklists.json")) end)
	if suc then
		blacklist = false
		for i,v in pairs(tab) do
			if HWID:find(i) or i == tostring(lplr.UserId) or lplr.Name:find(i) then
				blacklist = true
				if v.Priority and v.Priority > 1 then
				task.spawn(function() lplr:Kick(v.Error or "Nebulaware is currently restricted for you. Join discord.gg/Nebulaware for updates.") end)
				local uninjected = pcall(antiguibypass)
				if not uninjected then while true do end end
				else
					if not isfile(NebulawareStore.maindirectory.."/kickdata.vw") or readfile(NebulawareStore.maindirectory.."/kickdata.vw") ~= tostring(v.ID) then
						if not isfolder("vape") then makefolder("vape") end
						if not isfolder("vape/Nebulaware") then makefolder("vape/Nebulaware") end
						if not isfolder(NebulawareStore.maindirectory) then makefolder(NebulawareStore.maindirectory) end
						pcall(writefile, NebulawareStore.maindirectory.."/kickdata.vw", tostring(v.ID))
						task.spawn(function() lplr:Kick(v.Error or "Nebulaware Whitelist has requested disconnect.") end)
						local uninjected = pcall(antiguibypass)
						task.wait(1)
				        if not uninjected or shared.GuiLibrary then while true do end end
					end
				end
			end
		end
		if not blacklist then
			pcall(delfile, NebulawareStore.maindirectory.."/kickdata.vw")
		end
	end
	task.wait(10)
	until not vapeInjected
end)
end)

local function GetCurrentProfile()
	local profile = "default"
	if isfile("vape/Profiles/6872274481.vapeprofiles.txt") then
		pcall(function()
		local profiledata = readfile("vape/Profiles/6872274481.vapeprofiles.txt")
		local data = httpService:JSONDecode(profiledata)
		for i,v in pairs(data) do
			if v.Selected == true then
				profile = i
			end
		end
	end)
	end
	return profile
end

for i,v in pairs(NebulawareWhitelistStore.chatstrings) do
	if v == "Nebulaware Lite" and GetCurrentProfile() == "Ghost" then
		NebulawareWhitelistStore.Hash = i
		break
	end
	if v == "Nebulaware" then
		NebulawareWhitelistStore.Hash = i
	end
end

local function NebulawareNewPlayer(plr)
	repeat task.wait() until NebulawareFunctions.WhitelistLoaded
	pcall(function()
	plr = plr or lplr
	if ({NebulawareFunctions:GetPlayerType(plr)})[3] > 1.5 and not ({NebulawareFunctions:GetPlayerType(plr)})[6] then
		local tagtext, tagcolor = ({NebulawareFunctions:GetPlayerType(plr)})[4], ({NebulawareFunctions:GetPlayerType(plr)})[5]
		task.spawn(NebulawareStore.Tag, tagtext, plr, tagcolor)
	end
	if plr ~= lplr and ({NebulawareFunctions:GetPlayerType()})[3] < 2 and ({NebulawareFunctions:GetPlayerType(plr)})[3] > 1.5 then
		local oldchannel = textChatService.ChatInputBarConfiguration.TargetTextChannel
		local whisperallowed = game:GetService("RobloxReplicatedStorage").ExperienceChat.WhisperChat:InvokeServer(plr.UserId)
		if whisperallowed then
			if not plr:GetAttribute("LobbyConnected") then repeat task.wait() until plr:GetAttribute("LobbyConnected") end
			task.wait(5)
			if not table.find(shared.NebulawareStore.WhitelistChatSent, plr) then
			whisperallowed:SendAsync(NebulawareWhitelistStore.Hash)	
			textChatService.ChatInputBarConfiguration.TargetTextChannel = oldchannel
			table.insert(shared.NebulawareStore.WhitelistChatSent, plr)
			end
		end
	end
end)
end

task.spawn(function()
local oldwhitelists = {}
for i,v in pairs(playersService:GetPlayers()) do
	task.spawn(NebulawareNewPlayer, v)
	oldwhitelists[v] = NebulawarePriority[({NebulawareFunctions:GetPlayerType(v)})[3]]
end

table.insert(vapeConnections, playersService.PlayerAdded:Connect(function(v)
	oldwhitelists[v] = NebulawarePriority[({NebulawareFunctions:GetPlayerType(v)})[3]]
	task.spawn(NebulawareNewPlayer, v)
end))

table.insert(vapeConnections, NebulawareFunctions.WhitelistRefreshEvent.Event:Connect(function()
for i,v in pairs(playersService:GetPlayers()) do
	if ({NebulawareFunctions:GetPlayerType(v)}) ~= oldwhitelists[v] then
	tags[v] = nil
	task.spawn(NebulawareNewPlayer, v)
	end
end
end))

table.insert(vapeConnections, playersService.PlayerRemoving:Connect(function(v)
	if table.find(shared.NebulawareStore.ConfigUsers, v) then
		table.remove(shared.NebulawareStore.ConfigUsers, v)
	end
end))
end)

task.spawn(function()
    if not shared.VapeFullyLoaded and NebulawareStore.MobileInUse then repeat task.wait() until shared.VapeFullyLoaded or not vapeInjected end
	if not vapeInjected then return end
	task.wait(NebulawareStore.MobileInUse and 4.5 or 0.1)
	repeat task.wait() until NebulawareFunctions.WhitelistLoaded
	repeat
	pcall(function()
	if NebulawareFunctions:GetPlayerType() == "OWNER" then
		if not isfolder("Nebulaware") then makefolder("Nebulaware") end
		if not isfolder("Nebulaware/src") then makefolder("Nebulaware/src") end
		local filedata = readfile("vape/CustomModules/6872274481.lua")
		if filedata:find("NebulawareStore") then
		writefile("Nebulaware/src/Bedwars.lua", filedata)
		end
		filedata = readfile("vape/Universal.lua")
		if filedata:find("NebulawareStore") then
			writefile("Nebulaware/src/Universal.lua", filedata)
		end
		filedata = readfile("vape/CustomModules/6872265039.lua")
		if filedata:find("NebulawareStore") then
			writefile("Nebulaware/src/BedwarsLobby.lua", filedata)
		end
	end
end)
	task.wait(5)
	until not vapeInjected
end)

task.spawn(function()
    if not shared.VapeFullyLoaded and NebulawareStore.MobileInUse then repeat task.wait() until shared.VapeFullyLoaded or not vapeInjected end
	task.wait(NebulawareStore.MobileInUse and 4.5 or 0.1)
	repeat task.wait() until NebulawareFunctions.WhitelistLoaded
    if not vapeInjected then return end
    local versiondata = NebulawareStore.VersionInfo
    repeat
    local NebulawareOwner = NebulawareFunctions:GetPlayerType() == "OWNER"
	if NebulawareOwner then return end
    if not isfolder("vape") then makefolder("vape") end
    if not isfolder("vape/Nebulaware") then pcall(makefolder, "vape/Nebulaware") end
	if not isfolder(NebulawareStore.maindirectory) then makefolder(NebulawareStore.maindirectory) end
    versiondata = NebulawareFunctions:GetFile("System/Version.vw", true)
    if versiondata ~= "404: Not Found" and versiondata ~= "" then versiondata = httpService:JSONDecode(versiondata) else versiondata = {} end
    local currentcommit = NebulawareFunctions:GetCommitHash(NebulawareStore.VersionInfo.BuildType == "Beta" and "NebulawareBeta" or "Nebulaware")
    if not isfile(NebulawareStore.maindirectory.."/".."commithash.vw") or readfile(NebulawareStore.maindirectory.."/".."commithash.vw") ~= currentcommit or not isfile(NebulawareStore.maindirectory.."/".."commithash.vw") then
        pcall(delfolder, NebulawareStore.maindirectory.."/".."data")
        pcall(delfolder, NebulawareStore.maindirectory.."/".."Libraries")
		if isfolder("vape") then
			for i,v in pairs(NebulawareStore.SystemFiles) do
				local body = NebulawareFunctions:GetFile("System/"..(string.gsub(v, "vape/", "")), true)
				if body ~= "" and body ~= "404: Not Found" and body ~= "400: Bad Request" then
					body = "-- Nebulaware Custom Modules Signed File\n"..body
					pcall(writefile, v, body)
				end
			end
			if isfolder("vape/CustomModules") then
			local supportedfiles = {"vape/CustomModules/6872274481.lua", "vape/CustomModules/6872265039.lua"}
			for i,v in pairs(supportedfiles) do
				local name = v ~= "vape/CustomModules/6872274481.lua" and "BedwarsLobby.lua" or "Bedwars.lua"
				local body = NebulawareFunctions:GetFile("System/"..name, true)
				if body ~= "" and body ~= "404: Not Found" and body ~= "400: Bad Request" then
					body = name ~= "Bedwars.lua" and "-- Nebulaware Custom Modules Signed File\n"..body or "-- Nebulaware Custom Modules Main File\n"..body
					pcall(writefile, v, body)
				end
			end
			end
		end
        pcall(writefile, NebulawareStore.maindirectory.."/".."commithash.vw", currentcommit)
		if NebulawareStore.VersionInfo.BuildType == "Beta" and versiondata.VersionID and versiondata.VersionID ~= NebulawareStore.VersionInfo.VersionID and not NebulawareOwner then
			task.spawn(InfoNotification, "Nebulaware", "Your Beta build of Nebulaware has been updated. Changes will apply on relaunch.", 7)
			table.insert(shared.NebulawareStore.Messages, "Nebulaware Beta has successfully been upgraded from "..NebulawareStore.VersionInfo.VersionID.." to "..versiondata.VersionID)
		end
		if not NebulawareOwner and NebulawareStore.VersionInfo.BuildType ~= "Beta" and versiondata.VersionType ~= NebulawareStore.VersionInfo.MainVersion then
			if NebulawareFunctions:LoadTime() <= 10 then
				local uninject = pcall(antiguibypass)
				if uninject and isfile("vape/NewMainScript.lua") then
					loadstring(readfile("vape/NewMainScript.lua"))()
				end
			else
			   task.spawn(InfoNotification, "Nebulaware", "Nebulaware has been updated from "..NebulawareStore.VersionInfo.MainVersion.." to "..versiondata.VersionType..". changes will apply on relaunch.", 7)
			end
			table.insert(shared.NebulawareStore.Messages, "Nebulaware has successfully been upgraded from "..NebulawareStore.VersionInfo.VersionID.." to "..versiondata.VersionID)
		end
    end 
    task.wait(NebulawareStore.MobileInUse and 10 or 5)
    until not vapeInjected
end)

task.spawn(function()
    pcall(function()
    if not shared.VapeFullyLoaded and NebulawareStore.MobileInUse then repeat task.wait() until shared.VapeFullyLoaded or not vapeInjected end
	task.wait(NebulawareStore.MobileInUse and 4.5 or 0.1)
	repeat task.wait() until NebulawareFunctions.WhitelistLoaded
    if not vapeInjected then return end
    if NebulawareFunctions:GetPlayerType(v) == "OWNER" then return end
    repeat
    task.wait(1)
    for i,v in pairs(NebulawareStore.SystemFiles) do
        if not isfile(v) or not readfile(v):find("-- Nebulaware Custom Modules Signed File") then
        local namesplit = string.gsub(v, "vape/", "")
        local data = NebulawareFunctions:GetFile("System/"..namesplit, true)
        if data and data ~= "404: Not Found" and data ~= "" then
        data = "-- Nebulaware Custom Modules Signed File\n"..data
        pcall(writefile, v, data)
        end
    end
    end
    task.wait(NebulawareStore.MobileInUse and 10 or 5)
    until not vapeInjected
end)
end)

local networkownerswitch = tick()
local isnetworkowner = isnetworkowner or function(part)
	local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()
end
local getcustomasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local synapsev3 = syn and syn.toast_notification and "V3" or ""
local worldtoscreenpoint = function(pos)
	if synapsev3 == "V3" then 
		local scr = worldtoscreen({pos})
		return scr[1] - Vector3.new(0, 36, 0), scr[1].Z > 0
	end
	return gameCamera.WorldToScreenPoint(gameCamera, pos)
end
local worldtoviewportpoint = function(pos)
	if synapsev3 == "V3" then 
		local scr = worldtoscreen({pos})
		return scr[1], scr[1].Z > 0
	end
	return gameCamera.WorldToViewportPoint(gameCamera, pos)
end

local function vapeGithubRequest(scripturl)
	if not isfile("vape/"..scripturl) then
		local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..readfile("vape/commithash.txt").."/"..scripturl, true) end)
		assert(suc, res)
		assert(res ~= "404: Not Found", res)
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("vape/"..scripturl, res)
	end
	return readfile("vape/"..scripturl)
end

local function downloadVapeAsset(path)
	if not isfile(path) then
		task.spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary.MainGui
			repeat task.wait() until isfile(path)
			textlabel:Destroy()
		end)
		local suc, req = pcall(function() return vapeGithubRequest(path:gsub("vape/assets", "assets")) end)
        if suc and req then
		    writefile(path, req)
        else
            return ""
        end
	end
	if not vapeCachedAssets[path] then vapeCachedAssets[path] = getcustomasset(path) end
	return vapeCachedAssets[path] 
end

local function warningNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title or "Nebulaware", text or "Successfully called function", delay or 7, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
		frame.Frame.Frame.ImageColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
		return frame
	end)
	return (suc and res)
end

local function InfoNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title or "Nebulaware", text or "Successfully called function", delay or 7, "assets/InfoNotification.png")
		return frame
	end)
	return (suc and res)
end

local function CustomNotification(title, delay, text, icon, color)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title or "Nebulaware", text or "Thanks you for using Nebulaware "..lplr.Name.."!", delay or 5.6, icon or "assets/InfoNotification.png")
		frame.Frame.Frame.ImageColor3 = color and Hex2Color3(color) or Color3.new()
		return frame
	end)
	return (suc and res)
end

local announcements = {}
function NebulawareFunctions:Announcement(tab)
	tab = tab or {}
	tab.Text = tab.Text or ""
	tab.Duration = tab.Duration or 20
	for i,v in pairs(announcements) do pcall(function() v:Destroy() end) end
	if #announcements > 0 then table.clear(announcements) end
	local announcemainframe = Instance.new("Frame")
	announcemainframe.Position = UDim2.new(0.2, 0, -5, 0.1)
	announcemainframe.Size = UDim2.new(0, 1227, 0, 62)
	announcemainframe.Parent = GuiLibrary.MainGui
	local announcemaincorner = Instance.new("UICorner")
	announcemaincorner.CornerRadius = UDim.new(0, 20)
	announcemaincorner.Parent = announcemainframe
	local announceuigradient = Instance.new("UIGradient")
	announceuigradient.Parent = announcemainframe
	announceuigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(234, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 0, 0))})
	announceuigradient.Enabled = true
	local announceiconframe = Instance.new("Frame")
	announceiconframe.BackgroundColor3 = Color3.fromRGB(106, 0, 0)
	announceiconframe.BorderColor3 = Color3.fromRGB(85, 0, 0)
	announceiconframe.Position = UDim2.new(0.007, 0, 0.097, 0)
	announceiconframe.Size = UDim2.new(0, 58, 0, 50)
	announceiconframe.Parent = announcemainframe
	local annouceiconcorner = Instance.new("UICorner")
	annouceiconcorner.CornerRadius = UDim.new(0, 20)
	annouceiconcorner.Parent = announceiconframe
	local announceNebulawareicon = Instance.new("ImageButton")
	announceNebulawareicon.Parent = announceiconframe
	announceNebulawareicon.Image = "rbxassetid://13391474085"
	announceNebulawareicon.Position = UDim2.new(-0, 0, 0, 0)
	announceNebulawareicon.Size = UDim2.new(0, 59, 0, 50)
	announceNebulawareicon.BackgroundTransparency = 1
	local announcetextfont = Font.new("rbxasset://fonts/families/Ubuntu.json")
	announcetextfont.Weight = Enum.FontWeight.Bold
	local announcemaintext = Instance.new("TextButton")
	announcemaintext.Text = tab.Text
	announcemaintext.FontFace = announcetextfont
	announcemaintext.TextXAlignment = Enum.TextXAlignment.Left
	announcemaintext.BackgroundTransparency = 1
	announcemaintext.TextSize = 30
	announcemaintext.AutoButtonColor = false
	announcemaintext.Position = UDim2.new(0.063, 0, 0.097, 0)
	announcemaintext.Size = UDim2.new(0, 1140, 0, 50)
	announcemaintext.RichText = true
	announcemaintext.TextColor3 = Color3.fromRGB(255, 255, 255)
	announcemaintext.Parent = announcemainframe
	tweenService:Create(announcemainframe, TweenInfo.new(1), {Position = UDim2.new(0.2, 0, 0.042, 0.1)}):Play()
	local sound = Instance.new("Sound")
	sound.PlayOnRemove = true
	sound.SoundId = "rbxassetid://6732495464"
	sound.Parent = announcemainframe
	sound:Destroy()
	local function announcementdestroy()
		local sound = Instance.new("Sound")
		sound.PlayOnRemove = true
		sound.SoundId = "rbxassetid://6732690176"
		sound.Parent = announcemainframe
		sound:Destroy()
		announcemainframe:Destroy()
	end
	announcemaintext.MouseButton1Click:Connect(announcementdestroy)
	announceNebulawareicon.MouseButton1Click:Connect(announcementdestroy)
	game:GetService("Debris"):AddItem(announcemainframe, tab.Duration)
	table.insert(announcements, announcemainframe)
	return announcemainframe
end


local function runFunction(func) func() end
local function runcode(func) func() end

local function isFriend(plr, recolor)
	if GuiLibrary.ObjectsThatCanBeSaved["Use FriendsToggle"].Api.Enabled then
		local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectList, plr.Name)
		friend = friend and GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectListEnabled[friend]
		if recolor then
			friend = friend and GuiLibrary.ObjectsThatCanBeSaved["Recolor visualsToggle"].Api.Enabled
		end
		return friend
	end
	return nil
end

local function isTarget(plr)
	local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectList, plr.Name)
	friend = friend and GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectListEnabled[friend]
	return friend
end

local function isVulnerable(plr)
	return plr.Humanoid.Health > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
end

local function getPlayerColor(plr)
	if isFriend(plr, true) then
		return Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Value)
	end
	return tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color
end

local function LaunchAngle(v, g, d, h, higherArc)
	local v2 = v * v
	local v4 = v2 * v2
	local root = -math.sqrt(v4 - g*(g*d*d + 2*h*v2))
	return math.atan((v2 + root) / (g * d))
end

local function LaunchDirection(start, target, v, g)
	local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
	local h = target.Y - start.Y
	local d = horizontal.Magnitude
	local a = LaunchAngle(v, g, d, h)

	if a ~= a then 
		return g == 0 and (target - start).Unit * v
	end

	local vec = horizontal.Unit * v
	local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
	return CFrame.fromAxisAngle(rotAxis, a) * vec
end

local physicsUpdate = 1 / 60

local function predictGravity(playerPosition, vel, bulletTime, targetPart, Gravity)
	local estimatedVelocity = vel.Y
	local rootSize = (targetPart.Humanoid.HipHeight + (targetPart.RootPart.Size.Y / 2))
	local velocityCheck = (tick() - targetPart.JumpTick) < 0.2
	vel = vel * physicsUpdate

	for i = 1, math.ceil(bulletTime / physicsUpdate) do 
		if velocityCheck then 
			estimatedVelocity = estimatedVelocity - (Gravity * physicsUpdate)
		else
			estimatedVelocity = 0
			playerPosition = playerPosition + Vector3.new(0, -0.03, 0) -- bw hitreg is so bad that I have to add this LOL fr
			rootSize = rootSize - 0.03
		end

		local floorDetection = workspace:Raycast(playerPosition, Vector3.new(vel.X, (estimatedVelocity * physicsUpdate) - rootSize, vel.Z), bedwarsStore.blockRaycast)
		if floorDetection then 
			playerPosition = Vector3.new(playerPosition.X, floorDetection.Position.Y + rootSize, playerPosition.Z)
			local bouncepad = floorDetection.Instance:FindFirstAncestor("gumdrop_bounce_pad")
			if bouncepad and bouncepad:GetAttribute("PlacedByUserId") == targetPart.Player.UserId then 
				estimatedVelocity = 130 - (Gravity * physicsUpdate)
				velocityCheck = true
			else
				estimatedVelocity = targetPart.Humanoid.JumpPower - (Gravity * physicsUpdate)
				velocityCheck = targetPart.Jumping
			end
		end

		playerPosition = playerPosition + Vector3.new(vel.X, velocityCheck and estimatedVelocity * physicsUpdate or 0, vel.Z)
	end

	return playerPosition, Vector3.new(0, 0, 0)
end

local entityLibrary = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist
local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = runService.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = runService.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = runService.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end


local function getItem(itemName, inv)
	for slot, item in pairs(inv or bedwarsStore.localInventory.inventory.items) do
		if item.itemType == itemName then
			return item, slot
		end
	end
	return nil
end

local function getItemNear(itemName, inv)
	for slot, item in pairs(inv or bedwarsStore.localInventory.inventory.items) do
		if item.itemType == itemName or item.itemType:find(itemName) then
			return item, slot
		end
	end
	return nil
end

local function getHotbarSlot(itemName)
	for slotNumber, slotTable in pairs(bedwarsStore.localInventory.hotbar) do
		if slotTable.item and slotTable.item.itemType == itemName then
			return slotNumber - 1
		end
	end
	return nil
end

local function getShieldAttribute(char)
	local returnedShield = 0
	for attributeName, attributeValue in pairs(char:GetAttributes()) do 
		if attributeName:find("Shield") and type(attributeValue) == "number" then 
			returnedShield = returnedShield + attributeValue
		end
	end
	return returnedShield
end

local function getPickaxe()
	return getItemNear("pick")
end

local function getAxe()
	local bestAxe, bestAxeSlot = nil, nil
	for slot, item in pairs(bedwarsStore.localInventory.inventory.items) do
		if item.itemType:find("axe") and item.itemType:find("pickaxe") == nil and item.itemType:find("void") == nil then
			bextAxe, bextAxeSlot = item, slot
		end
	end
	return bestAxe, bestAxeSlot
end

local function getSword()
	local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
	for slot, item in pairs(bedwarsStore.localInventory.inventory.items) do
		local swordMeta = bedwars.ItemTable[item.itemType].sword
		if swordMeta then
			local swordDamage = swordMeta.damage or 0
			if swordDamage > bestSwordDamage then
				bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
			end
		end
	end
	return bestSword, bestSwordSlot
end

local function getBow()
	local bestBow, bestBowSlot, bestBowStrength = nil, nil, 0
	for slot, item in pairs(bedwarsStore.localInventory.inventory.items) do
		if item.itemType:find("bow") then 
			local tab = bedwars.ItemTable[item.itemType].projectileSource
			local ammo = tab.projectileType("arrow")	
			local dmg = bedwars.ProjectileMeta[ammo].combat.damage
			if dmg > bestBowStrength then
				bestBow, bestBowSlot, bestBowStrength = item, slot, dmg
			end
		end
	end
	return bestBow, bestBowSlot
end

local function getWool()
	local wool = getItemNear("wool")
	return wool and wool.itemType, wool and wool.amount
end

local function getBlock()
	for slot, item in pairs(bedwarsStore.localInventory.inventory.items) do
		if bedwars.ItemTable[item.itemType].block then
			return item.itemType, item.amount
		end
	end
end

local function attackValue(vec)
	return {value = vec}
end

local function getSpeed()
	local speed = 0
	if lplr.Character then 
		local SpeedDamageBoost = lplr.Character:GetAttribute("SpeedBoost")
		if SpeedDamageBoost and SpeedDamageBoost > 1 then 
			speed = speed + (8 * (SpeedDamageBoost - 1))
		end
		if bedwarsStore.grapple > tick() then
			speed = speed + 90
		end
		if bedwarsStore.scythe > tick() then 
			speed = speed + 25
		end
		if lplr.Character:GetAttribute("GrimReaperChannel") then 
			speed = speed + 20
		end
		local armor = bedwarsStore.localInventory.inventory.armor[3]
		if type(armor) ~= "table" then armor = {itemType = ""} end
		if armor.itemType == "speed_boots" then 
			speed = speed + 12
		end
		if bedwarsStore.zephyrOrb ~= 0 then 
			speed = speed + 12
		end
	end
	return speed
end

local Reach = {Enabled = false}
local blacklistedblocks = {
	bed = true,
	ceramic = true
}
local cachedNormalSides = {}
for i,v in pairs(Enum.NormalId:GetEnumItems()) do if v.Name ~= "Bottom" then table.insert(cachedNormalSides, v) end end
local updateitem = Instance.new("BindableEvent")
local inputobj = nil
local tempconnection
tempconnection = inputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		inputobj = input
		tempconnection:Disconnect()
	end
end)
table.insert(vapeConnections, updateitem.Event:Connect(function(inputObj)
	if inputService:IsMouseButtonPressed(0) then
		game:GetService("ContextActionService"):CallFunction("block-break", Enum.UserInputState.Begin, inputobj)
	end
end))

local function getPlacedBlock(pos)
	local roundedPosition = bedwars.BlockController:getBlockPosition(pos)
	return bedwars.BlockController:getStore():getBlockAt(roundedPosition), roundedPosition
end

local oldpos = Vector3.zero

local function getScaffold(vec, diagonaltoggle)
	local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
	local speedCFrame = (oldpos - realvec)
	local returedpos = realvec
	if entityLibrary.isAlive then
		local angle = math.deg(math.atan2(-entityLibrary.character.Humanoid.MoveDirection.X, -entityLibrary.character.Humanoid.MoveDirection.Z))
		local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
		if goingdiagonal and ((speedCFrame.X == 0 and speedCFrame.Z ~= 0) or (speedCFrame.X ~= 0 and speedCFrame.Z == 0)) and diagonaltoggle then
			return oldpos
		end
	end
    return realvec
end

local function getBestTool(block)
	local tool = nil
	local blockmeta = bedwars.ItemTable[block]
	local blockType = blockmeta.block and blockmeta.block.breakType
	if blockType then
		local best = 0
		for i,v in pairs(bedwarsStore.localInventory.inventory.items) do
			local meta = bedwars.ItemTable[v.itemType]
			if meta.breakBlock and meta.breakBlock[blockType] and meta.breakBlock[blockType] >= best then
				best = meta.breakBlock[blockType]
				tool = v
			end
		end
	end
	return tool
end

local function getOpenApps()
	local count = 0
	for i,v in pairs(bedwars.AppController:getOpenApps()) do if (not tostring(v):find("Billboard")) and (not tostring(v):find("GameNametag")) then count = count + 1 end end
	return count
end

local function switchItem(tool)
	if lplr.Character.HandInvItem.Value ~= tool then
		bedwars.ClientHandler:Get(bedwars.EquipItemRemote):CallServerAsync({
			hand = tool
		})
		local started = tick()
		repeat task.wait() until (tick() - started) > 0.3 or lplr.Character.HandInvItem.Value == tool
	end
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (entityLibrary.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool.tool) then
		if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars.ClientStoreHandler:dispatch({
					type = "InventorySelectHotbarSlot", 
					slot = getHotbarSlot(tool.itemType)
				})
				vapeEvents.InventoryChanged.Event:Wait()
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end
		switchItem(tool.tool)
	end
end

local function isBlockCovered(pos)
	local coveredsides = 0
	for i, v in pairs(cachedNormalSides) do
		local blockpos = (pos + (Vector3.FromNormalId(v) * 3))
		local block = getPlacedBlock(blockpos)
		if block then
			coveredsides = coveredsides + 1
		end
	end
	return coveredsides == #cachedNormalSides
end

local function GetPlacedBlocksNear(pos, normal)
	local blocks = {}
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getPlacedBlock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			if bedwars.BlockController:isBlockBreakable({blockPosition = blockpos}, lplr) and (not blacklistedblocks[extrablock.Name]) then
				table.insert(blocks, extrablock.Name)
			end
			lastfound = extrablock
			if not covered then
				break
			end
		else
			break
		end
	end
	return blocks
end

local function getLastCovered(pos, normal)
	local lastfound, lastpos = nil, nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock, extrablockpos = getPlacedBlock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			lastfound, lastpos = extrablock, extrablockpos
			if not covered then
				break
			end
		else
			break
		end
	end
	return lastfound, lastpos
end

local function getBestBreakSide(pos)
	local softest, softestside = 9e9, Enum.NormalId.Top
	for i,v in pairs(cachedNormalSides) do
		local sidehardness = 0
		for i2,v2 in pairs(GetPlacedBlocksNear(pos, v)) do	
			local blockmeta = bedwars.ItemTable[v2].block
			sidehardness = sidehardness + (blockmeta and blockmeta.health or 10)
            if blockmeta then
                local tool = getBestTool(v2)
                if tool then
                    sidehardness = sidehardness - bedwars.ItemTable[tool.itemType].breakBlock[blockmeta.breakType]
                end
            end
		end
		if sidehardness <= softest then
			softest = sidehardness
			softestside = v
		end	
	end
	return softestside, softest
end

local function EntityNearPosition(distance, ignore, overridepos)
	local closestEntity, closestMagnitude = nil, distance
	if entityLibrary.isAlive then
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then
					mag = (overridepos - v.RootPart.Position).magnitude
				end
                if mag <= closestMagnitude then
					closestEntity, closestMagnitude = v, mag
                end
            end
        end
		if not ignore then
			for i, v in pairs(collectionService:GetTagged("Monster")) do
				if v.PrimaryPart and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then 
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("DiamondGuardian")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then 
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "DiamondGuardian", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("GolemBoss")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then 
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "GolemBoss", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("Drone")) do
				if v.PrimaryPart and tonumber(v:GetAttribute("PlayerUserId")) ~= lplr.UserId then
					local droneplr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
					if droneplr and droneplr.Team == lplr.Team then continue end
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then 
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "Drone", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
		end
	end
	return closestEntity
end

local function EntityNearMouse(distance)
	local closestEntity, closestMagnitude = nil, distance
    if entityLibrary.isAlive then
		local mousepos = inputService.GetMouseLocation(inputService)
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local vec, vis = worldtoscreenpoint(v.RootPart.Position)
				local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
                if vis and mag <= closestMagnitude then
					closestEntity, closestMagnitude = v, v.Target and -1 or mag
                end
            end
        end
    end
	return closestEntity
end

local function AllNearPosition(distance, amount, sortfunction, prediction)
	local returnedplayer = {}
	local currentamount = 0
    if entityLibrary.isAlive then
		local sortedentities = {}
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local playerPosition = v.RootPart.Position
				local mag = (entityLibrary.character.HumanoidRootPart.Position - playerPosition).magnitude
				if prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - playerPosition).magnitude
				end
                if mag <= distance then
					table.insert(sortedentities, v)
                end
            end
        end
		for i, v in pairs(collectionService:GetTagged("Monster")) do
			if v.PrimaryPart then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
				if prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - v.PrimaryPart.Position).magnitude
				end
                if mag <= distance then
					if v:GetAttribute("Team") == lplr:GetAttribute("Team") then continue end
                    table.insert(sortedentities, {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645), GetAttribute = function() return "none" end}, Character = v, RootPart = v.PrimaryPart, Humanoid = v.Humanoid})
                end
			end
		end
		for i, v in pairs(collectionService:GetTagged("DiamondGuardian")) do
			if v.PrimaryPart then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
				if prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - v.PrimaryPart.Position).magnitude
				end
                if mag <= distance then
                    table.insert(sortedentities, {Player = {Name = "DiamondGuardian", UserId = 1443379645, GetAttribute = function() return "none" end}, Character = v, RootPart = v.PrimaryPart, Humanoid = v.Humanoid})
                end
			end
		end
		for i, v in pairs(collectionService:GetTagged("GolemBoss")) do
			if v.PrimaryPart then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
				if prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - v.PrimaryPart.Position).magnitude
				end
                if mag <= distance then
                    table.insert(sortedentities, {Player = {Name = "GolemBoss", UserId = 1443379645, GetAttribute = function() return "none" end}, Character = v, RootPart = v.PrimaryPart, Humanoid = v.Humanoid})
                end
			end
		end
		for i, v in pairs(collectionService:GetTagged("Drone")) do
			if v.PrimaryPart then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
				if prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - v.PrimaryPart.Position).magnitude
				end
                if mag <= distance then
					if tonumber(v:GetAttribute("PlayerUserId")) == lplr.UserId then continue end
					local droneplr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
					if droneplr and droneplr.Team == lplr.Team then continue end
                    table.insert(sortedentities, {Player = {Name = "Drone", UserId = 1443379645}, GetAttribute = function() return "none" end, Character = v, RootPart = v.PrimaryPart, Humanoid = v.Humanoid})
                end
			end
		end
		for i, v in pairs(bedwarsStore.pots) do
			if v.PrimaryPart then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
				if prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - v.PrimaryPart.Position).magnitude
				end
                if mag <= distance then
                    table.insert(sortedentities, {Player = {Name = "Pot", UserId = 1443379645, GetAttribute = function() return "none" end}, Character = v, RootPart = v.PrimaryPart, Humanoid = {Health = 100, MaxHealth = 100}})
                end
			end
		end
		if sortfunction then
			table.sort(sortedentities, sortfunction)
		end
		for i,v in pairs(sortedentities) do 
			table.insert(returnedplayer, v)
			currentamount = currentamount + 1
			if currentamount >= amount then break end
		end
	end
	return returnedplayer
end

--pasted from old source since gui code is hard
local function CreateAutoHotbarGUI(children2, argstable)
	local buttonapi = {}
	buttonapi["Hotbars"] = {}
	buttonapi["CurrentlySelected"] = 1
	local currentanim
	local amount = #children2:GetChildren()
	local sortableitems = {
		{itemType = "swords", itemDisplayType = "diamond_sword"},
		{itemType = "pickaxes", itemDisplayType = "diamond_pickaxe"},
		{itemType = "axes", itemDisplayType = "diamond_axe"},
		{itemType = "shears", itemDisplayType = "shears"},
		{itemType = "wool", itemDisplayType = "wool_white"},
		{itemType = "iron", itemDisplayType = "iron"},
		{itemType = "diamond", itemDisplayType = "diamond"},
		{itemType = "emerald", itemDisplayType = "emerald"},
		{itemType = "bows", itemDisplayType = "wood_bow"},
	}
	local items = bedwars.ItemTable
	if items then
		for i2,v2 in pairs(items) do
			if (i2:find("axe") == nil or i2:find("void")) and i2:find("bow") == nil and i2:find("shears") == nil and i2:find("wool") == nil and v2.sword == nil and v2.armor == nil and v2["dontGiveItem"] == nil and bedwars.ItemTable[i2] and bedwars.ItemTable[i2].image then
				table.insert(sortableitems, {itemType = i2, itemDisplayType = i2})
			end
		end
	end
	local buttontext = Instance.new("TextButton")
	buttontext.AutoButtonColor = false
	buttontext.BackgroundTransparency = 1
	buttontext.Name = "ButtonText"
	buttontext.Text = ""
	buttontext.Name = argstable["Name"]
	buttontext.LayoutOrder = 1
	buttontext.Size = UDim2.new(1, 0, 0, 40)
	buttontext.Active = false
	buttontext.TextColor3 = Color3.fromRGB(162, 162, 162)
	buttontext.TextSize = 17
	buttontext.Font = Enum.Font.SourceSans
	buttontext.Position = UDim2.new(0, 0, 0, 0)
	buttontext.Parent = children2
	local toggleframe2 = Instance.new("Frame")
	toggleframe2.Size = UDim2.new(0, 200, 0, 31)
	toggleframe2.Position = UDim2.new(0, 10, 0, 4)
	toggleframe2.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	toggleframe2.Name = "ToggleFrame2"
	toggleframe2.Parent = buttontext
	local toggleframe1 = Instance.new("Frame")
	toggleframe1.Size = UDim2.new(0, 198, 0, 29)
	toggleframe1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	toggleframe1.BorderSizePixel = 0
	toggleframe1.Name = "ToggleFrame1"
	toggleframe1.Position = UDim2.new(0, 1, 0, 1)
	toggleframe1.Parent = toggleframe2
	local addbutton = Instance.new("ImageLabel")
	addbutton.BackgroundTransparency = 1
	addbutton.Name = "AddButton"
	addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	addbutton.Position = UDim2.new(0, 93, 0, 9)
	addbutton.Size = UDim2.new(0, 12, 0, 12)
	addbutton.ImageColor3 = Color3.fromRGB(5, 133, 104)
	addbutton.Image = downloadVapeAsset("vape/assets/AddItem.png")
	addbutton.Parent = toggleframe1
	local children3 = Instance.new("Frame")
	children3.Name = argstable["Name"].."Children"
	children3.BackgroundTransparency = 1
	children3.LayoutOrder = amount
	children3.Size = UDim2.new(0, 220, 0, 0)
	children3.Parent = children2
	local uilistlayout = Instance.new("UIListLayout")
	uilistlayout.Parent = children3
	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		children3.Size = UDim2.new(1, 0, 0, uilistlayout.AbsoluteContentSize.Y)
	end)
	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 5)
	uicorner.Parent = toggleframe1
	local uicorner2 = Instance.new("UICorner")
	uicorner2.CornerRadius = UDim.new(0, 5)
	uicorner2.Parent = toggleframe2
	buttontext.MouseEnter:Connect(function()
		tweenService:Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(79, 78, 79)}):Play()
	end)
	buttontext.MouseLeave:Connect(function()
		tweenService:Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
	end)
	local ItemListBigFrame = Instance.new("Frame")
	ItemListBigFrame.Size = UDim2.new(1, 0, 1, 0)
	ItemListBigFrame.Name = "ItemList"
	ItemListBigFrame.BackgroundTransparency = 1
	ItemListBigFrame.Visible = false
	ItemListBigFrame.Parent = GuiLibrary.MainGui
	local ItemListFrame = Instance.new("Frame")
	ItemListFrame.Size = UDim2.new(0, 660, 0, 445)
	ItemListFrame.Position = UDim2.new(0.5, -330, 0.5, -223)
	ItemListFrame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListFrame.Parent = ItemListBigFrame
	local ItemListExitButton = Instance.new("ImageButton")
	ItemListExitButton.Name = "ItemListExitButton"
	ItemListExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
	ItemListExitButton.Size = UDim2.new(0, 24, 0, 24)
	ItemListExitButton.AutoButtonColor = false
	ItemListExitButton.Image = downloadVapeAsset("vape/assets/ExitIcon1.png")
	ItemListExitButton.Visible = true
	ItemListExitButton.Position = UDim2.new(1, -31, 0, 8)
	ItemListExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListExitButton.Parent = ItemListFrame
	local ItemListExitButtonround = Instance.new("UICorner")
	ItemListExitButtonround.CornerRadius = UDim.new(0, 16)
	ItemListExitButtonround.Parent = ItemListExitButton
	ItemListExitButton.MouseEnter:Connect(function()
		tweenService:Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	ItemListExitButton.MouseLeave:Connect(function()
		tweenService:Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
	end)
	ItemListExitButton.MouseButton1Click:Connect(function()
		ItemListBigFrame.Visible = false
		GuiLibrary.MainGui.ScaledGui.ClickGui.Visible = true
	end)
	local ItemListFrameShadow = Instance.new("ImageLabel")
	ItemListFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	ItemListFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	ItemListFrameShadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
	ItemListFrameShadow.BackgroundTransparency = 1
	ItemListFrameShadow.ZIndex = -1
	ItemListFrameShadow.Size = UDim2.new(1, 6, 1, 6)
	ItemListFrameShadow.ImageColor3 = Color3.new(0, 0, 0)
	ItemListFrameShadow.ScaleType = Enum.ScaleType.Slice
	ItemListFrameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	ItemListFrameShadow.Parent = ItemListFrame
	local ItemListFrameText = Instance.new("TextLabel")
	ItemListFrameText.Size = UDim2.new(1, 0, 0, 41)
	ItemListFrameText.BackgroundTransparency = 1
	ItemListFrameText.Name = "WindowTitle"
	ItemListFrameText.Position = UDim2.new(0, 0, 0, 0)
	ItemListFrameText.TextXAlignment = Enum.TextXAlignment.Left
	ItemListFrameText.Font = Enum.Font.SourceSans
	ItemListFrameText.TextSize = 17
	ItemListFrameText.Text = "    New AutoHotbar"
	ItemListFrameText.TextColor3 = Color3.fromRGB(201, 201, 201)
	ItemListFrameText.Parent = ItemListFrame
	local ItemListBorder1 = Instance.new("Frame")
	ItemListBorder1.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
	ItemListBorder1.BorderSizePixel = 0
	ItemListBorder1.Size = UDim2.new(1, 0, 0, 1)
	ItemListBorder1.Position = UDim2.new(0, 0, 0, 41)
	ItemListBorder1.Parent = ItemListFrame
	local ItemListFrameCorner = Instance.new("UICorner")
	ItemListFrameCorner.CornerRadius = UDim.new(0, 4)
	ItemListFrameCorner.Parent = ItemListFrame
	local ItemListFrame1 = Instance.new("Frame")
	ItemListFrame1.Size = UDim2.new(0, 112, 0, 113)
	ItemListFrame1.Position = UDim2.new(0, 10, 0, 71)
	ItemListFrame1.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	ItemListFrame1.Name = "ItemListFrame1"
	ItemListFrame1.Parent = ItemListFrame
	local ItemListFrame2 = Instance.new("Frame")
	ItemListFrame2.Size = UDim2.new(0, 110, 0, 111)
	ItemListFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ItemListFrame2.BorderSizePixel = 0
	ItemListFrame2.Name = "ItemListFrame2"
	ItemListFrame2.Position = UDim2.new(0, 1, 0, 1)
	ItemListFrame2.Parent = ItemListFrame1
	local ItemListFramePicker = Instance.new("ScrollingFrame")
	ItemListFramePicker.Size = UDim2.new(0, 495, 0, 220)
	ItemListFramePicker.Position = UDim2.new(0, 144, 0, 122)
	ItemListFramePicker.BorderSizePixel = 0
	ItemListFramePicker.ScrollBarThickness = 3
	ItemListFramePicker.ScrollBarImageTransparency = 0.8
	ItemListFramePicker.VerticalScrollBarInset = Enum.ScrollBarInset.None
	ItemListFramePicker.BackgroundTransparency = 1
	ItemListFramePicker.Parent = ItemListFrame
	local ItemListFramePickerGrid = Instance.new("UIGridLayout")
	ItemListFramePickerGrid.CellPadding = UDim2.new(0, 4, 0, 3)
	ItemListFramePickerGrid.CellSize = UDim2.new(0, 51, 0, 52)
	ItemListFramePickerGrid.Parent = ItemListFramePicker
	ItemListFramePickerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ItemListFramePicker.CanvasSize = UDim2.new(0, 0, 0, ItemListFramePickerGrid.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
	end)
	local ItemListcorner = Instance.new("UICorner")
	ItemListcorner.CornerRadius = UDim.new(0, 5)
	ItemListcorner.Parent = ItemListFrame1
	local ItemListcorner2 = Instance.new("UICorner")
	ItemListcorner2.CornerRadius = UDim.new(0, 5)
	ItemListcorner2.Parent = ItemListFrame2
	local selectedslot = 1
	local hoveredslot = 0
	
	local refreshslots
	local refreshList
	refreshslots = function()
		local startnum = 144
		local oldhovered = hoveredslot
		for i2,v2 in pairs(ItemListFrame:GetChildren()) do
			if v2.Name:find("ItemSlot") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(ItemListFramePicker:GetChildren()) do
			if v3:IsA("TextButton") then
				v3:Remove()
			end
		end
		for i4,v4 in pairs(sortableitems) do
			local ItemFrame = Instance.new("TextButton")
			ItemFrame.Text = ""
			ItemFrame.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
			ItemFrame.Parent = ItemListFramePicker
			ItemFrame.AutoButtonColor = false
			local ItemFrameIcon = Instance.new("ImageLabel")
			ItemFrameIcon.Size = UDim2.new(0, 32, 0, 32)
			ItemFrameIcon.Image = bedwars.getIcon({itemType = v4.itemDisplayType}, true) 
			ItemFrameIcon.ResampleMode = (bedwars.getIcon({itemType = v4.itemDisplayType}, true):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemFrameIcon.Position = UDim2.new(0, 10, 0, 10)
			ItemFrameIcon.BackgroundTransparency = 1
			ItemFrameIcon.Parent = ItemFrame
			local ItemFramecorner = Instance.new("UICorner")
			ItemFramecorner.CornerRadius = UDim.new(0, 5)
			ItemFramecorner.Parent = ItemFrame
			ItemFrame.MouseButton1Click:Connect(function()
				for i5,v5 in pairs(buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"]) do
					if v5.itemType == v4.itemType then
						buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i5)] = nil
					end
				end
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(selectedslot)] = v4
				refreshslots()
				refreshList()
			end)
		end
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)]
			local ItemListFrame3 = Instance.new("Frame")
			ItemListFrame3.Size = UDim2.new(0, 55, 0, 56)
			ItemListFrame3.Position = UDim2.new(0, startnum - 2, 0, 380)
			ItemListFrame3.BackgroundTransparency = (selectedslot == i and 0 or 1)
			ItemListFrame3.BackgroundColor3 = Color3.fromRGB(35, 34, 35)
			ItemListFrame3.Name = "ItemSlot"
			ItemListFrame3.Parent = ItemListFrame
			local ItemListFrame4 = Instance.new("TextButton")
			ItemListFrame4.Size = UDim2.new(0, 51, 0, 52)
			ItemListFrame4.BackgroundColor3 = (oldhovered == i and Color3.fromRGB(31, 30, 31) or Color3.fromRGB(20, 20, 20))
			ItemListFrame4.BorderSizePixel = 0
			ItemListFrame4.AutoButtonColor = false
			ItemListFrame4.Text = ""
			ItemListFrame4.Name = "ItemListFrame4"
			ItemListFrame4.Position = UDim2.new(0, 2, 0, 2)
			ItemListFrame4.Parent = ItemListFrame3
			local ItemListImage = Instance.new("ImageLabel")
			ItemListImage.Size = UDim2.new(0, 32, 0, 32)
			ItemListImage.BackgroundTransparency = 1
			local img = (item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or "")
			ItemListImage.Image = img
			ItemListImage.ResampleMode = (img:find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemListImage.Position = UDim2.new(0, 10, 0, 10)
			ItemListImage.Parent = ItemListFrame4
			local ItemListcorner3 = Instance.new("UICorner")
			ItemListcorner3.CornerRadius = UDim.new(0, 5)
			ItemListcorner3.Parent = ItemListFrame3
			local ItemListcorner4 = Instance.new("UICorner")
			ItemListcorner4.CornerRadius = UDim.new(0, 5)
			ItemListcorner4.Parent = ItemListFrame4
			ItemListFrame4.MouseEnter:Connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				hoveredslot = i
			end)
			ItemListFrame4.MouseLeave:Connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				hoveredslot = 0
			end)
			ItemListFrame4.MouseButton1Click:Connect(function()
				selectedslot = i
				refreshslots()
			end)
			ItemListFrame4.MouseButton2Click:Connect(function()
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)] = nil
				refreshslots()
				refreshList()
			end)
			startnum = startnum + 55
		end
	end	

	local function createHotbarButton(num, items)
		num = tonumber(num) or #buttonapi["Hotbars"] + 1
		local hotbarbutton = Instance.new("TextButton")
		hotbarbutton.Size = UDim2.new(1, 0, 0, 30)
		hotbarbutton.BackgroundTransparency = 1
		hotbarbutton.LayoutOrder = num
		hotbarbutton.AutoButtonColor = false
		hotbarbutton.Text = ""
		hotbarbutton.Parent = children3
		buttonapi["Hotbars"][num] = {["Items"] = items or {}, Object = hotbarbutton, ["Number"] = num}
		local hotbarframe = Instance.new("Frame")
		hotbarframe.BackgroundColor3 = (num == buttonapi["CurrentlySelected"] and Color3.fromRGB(54, 53, 54) or Color3.fromRGB(31, 30, 31))
		hotbarframe.Size = UDim2.new(0, 200, 0, 27)
		hotbarframe.Position = UDim2.new(0, 10, 0, 1)
		hotbarframe.Parent = hotbarbutton
		local uicorner3 = Instance.new("UICorner")
		uicorner3.CornerRadius = UDim.new(0, 5)
		uicorner3.Parent = hotbarframe
		local startpos = 11
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][num]["Items"][tostring(i)]
			local hotbarbox = Instance.new("ImageLabel")
			hotbarbox.Name = i
			hotbarbox.Size = UDim2.new(0, 17, 0, 18)
			hotbarbox.Position = UDim2.new(0, startpos, 0, 5)
			hotbarbox.BorderSizePixel = 0
			hotbarbox.Image = (item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or "")
			hotbarbox.ResampleMode = ((item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or ""):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			hotbarbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			hotbarbox.Parent = hotbarframe
			startpos = startpos + 18
		end
		hotbarbutton.MouseButton1Click:Connect(function()
			if buttonapi["CurrentlySelected"] == num then
				ItemListBigFrame.Visible = true
				GuiLibrary.MainGui.ScaledGui.ClickGui.Visible = false
				refreshslots()
			end
			buttonapi["CurrentlySelected"] = num
			refreshList()
		end)
		hotbarbutton.MouseButton2Click:Connect(function()
			if buttonapi["CurrentlySelected"] == num then
				buttonapi["CurrentlySelected"] = (num == 2 and 0 or 1)
			end
			table.remove(buttonapi["Hotbars"], num)
			refreshList()
		end)
	end

	refreshList = function()
		local newnum = 0
		local newtab = {}
		for i3,v3 in pairs(buttonapi["Hotbars"]) do
			newnum = newnum + 1
			newtab[newnum] = v3
		end
		buttonapi["Hotbars"] = newtab
		for i,v in pairs(children3:GetChildren()) do
			if v:IsA("TextButton") then
				v:Remove()
			end
		end
		for i2,v2 in pairs(buttonapi["Hotbars"]) do
			createHotbarButton(i2, v2["Items"])
		end
		GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	end
	buttonapi["RefreshList"] = refreshList

	buttontext.MouseButton1Click:Connect(function()
		createHotbarButton()
	end)

	GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	GuiLibrary.ObjectsThatCanBeSaved[children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["Api"] = buttonapi, Object = buttontext}

	return buttonapi
end

GuiLibrary.LoadSettingsEvent.Event:Connect(function(res)
	for i,v in pairs(res) do
		local obj = GuiLibrary.ObjectsThatCanBeSaved[i]
		if obj and v.Type == "ItemList" and obj.Api then
			obj.Api.Hotbars = v.Items
			obj.Api.CurrentlySelected = v.CurrentlySelected
			obj.Api.RefreshList()
		end
	end
end)

runFunction(function()
	local function getWhitelistedBed(bed)
		if bed then
			for i,v in pairs(playersService:GetPlayers()) do
				if v:GetAttribute("Team") and bed and bed:GetAttribute("Team"..(v:GetAttribute("Team") or 0).."NoBreak") then
					local plrtype, plrattackable = WhitelistFunctions:GetWhitelist(v)
					if not plrattackable or not ({NebulawareFunctions:GetPlayerType(v)})[2] then 
						return true
					end
				end
			end
		end
		return false
	end

	local function dumpRemote(tab)
		for i,v in pairs(tab) do
			if v == "Client" then
				return tab[i + 1]
			end
		end
		return ""
	end

	local KnitGotten, KnitClient
	repeat
		KnitGotten, KnitClient = pcall(function()
			return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
		end)
		if KnitGotten then break end
		task.wait()
	until KnitGotten
	repeat task.wait() until debug.getupvalue(KnitClient.Start, 1)
	local Flamework = require(replicatedStorageService["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
	local Client = require(replicatedStorageService.TS.remotes).default.Client
	local InventoryUtil = require(replicatedStorageService.TS.inventory["inventory-util"]).InventoryUtil
	local oldRemoteGet = getmetatable(Client).Get

	getmetatable(Client).Get = function(self, remoteName)
		if not vapeInjected then return oldRemoteGet(self, remoteName) end
		local originalRemote = oldRemoteGet(self, remoteName)
		if remoteName == "DamageBlock" then
			return {
				CallServerAsync = function(self, tab)
					local hitBlock = bedwars.BlockController:getStore():getBlockAt(tab.blockRef.blockPosition)
					if hitBlock and hitBlock.Name == "bed" then
						if getWhitelistedBed(hitBlock) then
							return {andThen = function(self, func) 
								func("failed")
							end}
						end
					end
					return originalRemote:CallServerAsync(tab)
				end,
				CallServer = function(self, tab)
					local hitBlock = bedwars.BlockController:getStore():getBlockAt(tab.blockRef.blockPosition)
					if hitBlock and hitBlock.Name == "bed" then
						if getWhitelistedBed(hitBlock) then
							return {andThen = function(self, func) 
								func("failed")
							end}
						end
					end
					return originalRemote:CallServer(tab)
				end
			}
		elseif remoteName == bedwars.AttackRemote then
			return {
				instance = originalRemote.instance,
				SendToServer = function(self, attackTable, ...)
					local suc, plr = pcall(function() return playersService:GetPlayerFromCharacter(attackTable.entityInstance) end)
					if suc and plr then
						local playertype, playerattackable = WhitelistFunctions:GetWhitelist(plr)
						if not playerattackable then 
							return nil 
						end
						if not ({NebulawareFunctions:GetPlayerType(plr)})[2] then
							return nil
						end
						if Reach.Enabled then
							local attackMagnitude = ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - attackTable.validate.targetPosition.value).magnitude
							if attackMagnitude > 18 then
								return nil 
							end
							attackTable.validate.selfPosition = attackValue(attackTable.validate.selfPosition.value + (attackMagnitude > 14.4 and (CFrame.lookAt(attackTable.validate.selfPosition.value, attackTable.validate.targetPosition.value).lookVector * 4) or Vector3.zero))
						end
						bedwarsStore.attackReach = math.floor((attackTable.validate.selfPosition.value - attackTable.validate.targetPosition.value).magnitude * 100) / 100
						bedwarsStore.attackReachUpdate = tick() + 1
					end
					return originalRemote:SendToServer(attackTable, ...)
				end
			}
		end
		return originalRemote
	end

	bedwars = {
		AnimationType = require(replicatedStorageService.TS.animation["animation-type"]).AnimationType,
		AnimationUtil = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]).AnimationUtil,
		AppController = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
		AbilityController = Flamework.resolveDependency("@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController"),
		AbilityUIController = Flamework.resolveDependency("@easy-games/game-core:client/controllers/ability/ability-ui-controller@AbilityUIController"),
		AttackRemote = dumpRemote(debug.getconstants(KnitClient.Controllers.SwordController.sendServerRequest)),
		BalloonController = KnitClient.Controllers.BalloonController,
		BalanceFile = require(replicatedStorageService.TS.balance["balance-file"]).BalanceFile,
		BatteryEffectController = KnitClient.Controllers.BatteryEffectsController,
		BatteryRemote = dumpRemote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.BatteryController.KnitStart, 1), 1))),
		BlockBreaker = KnitClient.Controllers.BlockBreakController.blockBreaker,
		BlockController = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
		BlockCpsController = KnitClient.Controllers.BlockCpsController,
		BlockPlacer = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
		BlockEngine = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
		BlockEngineClientEvents = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents,
		BlockPlacementController = KnitClient.Controllers.BlockPlacementController,
		BowConstantsTable = debug.getupvalue(KnitClient.Controllers.ProjectileController.enableBeam, 6),
		ProjectileController = KnitClient.Controllers.ProjectileController,
		ChestController = KnitClient.Controllers.ChestController,
		CannonHandController = KnitClient.Controllers.CannonHandController,
		CannonAimRemote = dumpRemote(debug.getconstants(debug.getproto(KnitClient.Controllers.CannonController.startAiming, 5))),
		CannonLaunchRemote = dumpRemote(debug.getconstants(KnitClient.Controllers.CannonHandController.launchSelf)),
		ClickHold = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.lib.util["click-hold"]).ClickHold,
		ClientHandler = Client,
		ClientConstructor = require(replicatedStorageService["rbxts_include"]["node_modules"]["@rbxts"].net.out.client),
		ClientHandlerDamageBlock = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.shared.remotes).BlockEngineRemotes.Client,
		ClientStoreHandler = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
		CombatConstant = require(replicatedStorageService.TS.combat["combat-constant"]).CombatConstant,
		CombatController = KnitClient.Controllers.CombatController,
		ConstantManager = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].constant["constant-manager"]).ConstantManager,
		ConsumeSoulRemote = dumpRemote(debug.getconstants(KnitClient.Controllers.GrimReaperController.consumeSoul)),
		CooldownController = Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController"),
		DamageIndicator = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
		DamageIndicatorController = KnitClient.Controllers.DamageIndicatorController,
		DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.game.locker["kill-effect"].effects["default-kill-effect"]),
		DropItem = KnitClient.Controllers.ItemDropController.dropItemInHand,
		DropItemRemote = dumpRemote(debug.getconstants(KnitClient.Controllers.ItemDropController.dropItemInHand)),
		DragonSlayerController = KnitClient.Controllers.DragonSlayerController,
		DragonRemote = dumpRemote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.DragonSlayerController.KnitStart, 2), 1))),
		EatRemote = dumpRemote(debug.getconstants(debug.getproto(KnitClient.Controllers.ConsumeController.onEnable, 1))),
		EquipItemRemote = dumpRemote(debug.getconstants(debug.getproto(require(replicatedStorageService.TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem, 3))),
		EmoteMeta = require(replicatedStorageService.TS.locker.emote["emote-meta"]).EmoteMeta,
		FishermanTable = KnitClient.Controllers.FishermanController,
		FovController = KnitClient.Controllers.FovController,
		ForgeController = KnitClient.Controllers.ForgeController,
		ForgeConstants = debug.getupvalue(KnitClient.Controllers.ForgeController.getPurchaseableForgeUpgrades, 2),
		ForgeUtil = debug.getupvalue(KnitClient.Controllers.ForgeController.getPurchaseableForgeUpgrades, 5),
		GameAnimationUtil = require(replicatedStorageService.TS.animation["animation-util"]).GameAnimationUtil,
		EntityUtil = require(replicatedStorageService.TS.entity["entity-util"]).EntityUtil,
		getIcon = function(item, showinv)
			local itemmeta = bedwars.ItemTable[item.itemType]
			if itemmeta and showinv then
				return itemmeta.image or ""
			end
			return ""
		end,
		getInventory = function(plr)
			local suc, result = pcall(function() 
				return InventoryUtil.getInventory(plr) 
			end)
			return (suc and result or {
				items = {},
				armor = {},
				hand = nil
			})
		end,
		GrimReaperController = KnitClient.Controllers.GrimReaperController,
		GuitarHealRemote = dumpRemote(debug.getconstants(KnitClient.Controllers.GuitarController.performHeal)),
		HangGliderController = KnitClient.Controllers.HangGliderController,
		HighlightController = KnitClient.Controllers.EntityHighlightController,
		ItemTable = debug.getupvalue(require(replicatedStorageService.TS.item["item-meta"]).getItemMeta, 1),
		InfernalShieldController = KnitClient.Controllers.InfernalShieldController,
		KatanaController = KnitClient.Controllers.DaoController,
		KillEffectMeta = require(replicatedStorageService.TS.locker["kill-effect"]["kill-effect-meta"]).KillEffectMeta,
		KillEffectController = KnitClient.Controllers.KillEffectController,
		KnockbackUtil = require(replicatedStorageService.TS.damage["knockback-util"]).KnockbackUtil,
		LobbyClientEvents = KnitClient.Controllers.QueueController,
		MapController = KnitClient.Controllers.MapController,
		MatchEndScreenController = Flamework.resolveDependency("client/controllers/game/match/match-end-screen-controller@MatchEndScreenController"),
		MinerRemote = dumpRemote(debug.getconstants(debug.getproto(KnitClient.Controllers.MinerController.onKitEnabled, 1))),
		MageRemote = dumpRemote(debug.getconstants(debug.getproto(KnitClient.Controllers.MageController.registerTomeInteraction, 1))),
		MageKitUtil = require(replicatedStorageService.TS.games.bedwars.kit.kits.mage["mage-kit-util"]).MageKitUtil,
		MageController = KnitClient.Controllers.MageController,
		MissileController = KnitClient.Controllers.GuidedProjectileController,
		PickupMetalRemote = dumpRemote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.MetalDetectorController.KnitStart, 1), 2))),
		PickupRemote = dumpRemote(debug.getconstants(KnitClient.Controllers.ItemDropController.checkForPickup)),
		ProjectileMeta = require(replicatedStorageService.TS.projectile["projectile-meta"]).ProjectileMeta,
		ProjectileRemote = dumpRemote(debug.getconstants(debug.getupvalue(KnitClient.Controllers.ProjectileController.launchProjectileWithValues, 2))),
		QueryUtil = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
		QueueCard = require(lplr.PlayerScripts.TS.controllers.global.queue.ui["queue-card"]).QueueCard,
		QueueMeta = require(replicatedStorageService.TS.game["queue-meta"]).QueueMeta,
		RavenTable = KnitClient.Controllers.RavenController,
		RelicController = KnitClient.Controllers.RelicVotingController,
		ReportRemote = dumpRemote(debug.getconstants(require(lplr.PlayerScripts.TS.controllers.global.report["report-controller"]).default.reportPlayer)),
		ResetRemote = dumpRemote(debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))),
		Roact = require(replicatedStorageService["rbxts_include"]["node_modules"]["@rbxts"]["roact"].src),
		RuntimeLib = require(replicatedStorageService["rbxts_include"].RuntimeLib),
		ScytheController = KnitClient.Controllers.ScytheController,
		Shop = require(replicatedStorageService.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
		ShopItems = debug.getupvalue(debug.getupvalue(require(replicatedStorageService.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem, 1), 2),
		SoundList = require(replicatedStorageService.TS.sound["game-sound"]).GameSound,
		SoundManager = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager,
		SpawnRavenRemote = dumpRemote(debug.getconstants(KnitClient.Controllers.RavenController.spawnRaven)),
		SprintController = KnitClient.Controllers.SprintController,
		StopwatchController = KnitClient.Controllers.StopwatchController,
		SwordController = KnitClient.Controllers.SwordController,
		TreeRemote = dumpRemote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.BigmanController.KnitStart, 1), 2))),
		TrinityRemote = dumpRemote(debug.getconstants(debug.getproto(KnitClient.Controllers.AngelController.onKitEnabled, 1))),
		TopBarController = KnitClient.Controllers.TopBarController,
		ViewmodelController = KnitClient.Controllers.ViewmodelController,
		WeldTable = require(replicatedStorageService.TS.util["weld-util"]).WeldUtil,
		ZephyrController = KnitClient.Controllers.WindWalkerController,
		NetManaged = replicatedStorageService.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
	}

	bedwarsStore.blockPlacer = bedwars.BlockPlacer.new(bedwars.BlockEngine, "wool_white")
	bedwars.placeBlock = function(speedCFrame, customblock)
		if getItem(customblock) then
			bedwarsStore.blockPlacer.blockType = customblock
			return bedwarsStore.blockPlacer:placeBlock(Vector3.new(speedCFrame.X / 3, speedCFrame.Y / 3, speedCFrame.Z / 3))
		end
	end

	local healthbarblocktable = {
		blockHealth = -1,
		breakingBlockPosition = Vector3.zero
	}

	local failedBreak = 0
	bedwars.breakBlock = function(pos, effects, normal, bypass, anim)
		if GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled then 
			return
		end
		if lplr:GetAttribute("DenyBlockBreak") then
			return
		end
		local block, blockpos = nil, nil
		if not bypass then block, blockpos = getLastCovered(pos, normal) end
		if not block then block, blockpos = getPlacedBlock(pos) end
		if blockpos and block then
			if bedwars.BlockEngineClientEvents.DamageBlock:fire(block.Name, blockpos, block):isCancelled() then
				return
			end
			local blockhealthbarpos = {blockPosition = Vector3.zero}
			local blockdmg = 0
			if block and block.Parent ~= nil then
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - (blockpos * 3)).magnitude > 30 then return end
				bedwarsStore.blockPlace = tick() + 0.1
				switchToAndUseTool(block)
				blockhealthbarpos = {
					blockPosition = blockpos
				}
				task.spawn(function()
					bedwars.ClientHandlerDamageBlock:Get("DamageBlock"):CallServerAsync({
						blockRef = blockhealthbarpos, 
						hitPosition = blockpos * 3, 
						hitNormal = Vector3.FromNormalId(normal)
					}):andThen(function(result)
						if result ~= "failed" then
							failedBreak = 0
							if healthbarblocktable.blockHealth == -1 or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition then
								local blockdata = bedwars.BlockController:getStore():getBlockData(blockhealthbarpos.blockPosition)
								local blockhealth = blockdata and blockdata:GetAttribute(lplr.Name .. "_Health") or block:GetAttribute("Health")
								healthbarblocktable.blockHealth = blockhealth
								healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
							end
							healthbarblocktable.blockHealth = result == "destroyed" and 0 or healthbarblocktable.blockHealth
							blockdmg = bedwars.BlockController:calculateBlockDamage(lplr, blockhealthbarpos)
							healthbarblocktable.blockHealth = math.max(healthbarblocktable.blockHealth - blockdmg, 0)
							if effects then
								bedwars.BlockBreaker:updateHealthbar(blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg, block)
								if healthbarblocktable.blockHealth <= 0 then
									bedwars.BlockBreaker.breakEffect:playBreak(block.Name, blockhealthbarpos.blockPosition, lplr)
									bedwars.BlockBreaker.healthbarMaid:DoCleaning()
									healthbarblocktable.breakingBlockPosition = Vector3.zero
								else
									bedwars.BlockBreaker.breakEffect:playHit(block.Name, blockhealthbarpos.blockPosition, lplr)
								end
							end
							local animation
							if anim then
								animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
								bedwars.ViewmodelController:playAnimation(15)
							end
							task.wait(0.3)
							if animation ~= nil then
								animation:Stop()
								animation:Destroy()
							end
						else
							failedBreak = failedBreak + 1
						end
					end)
				end)
				task.wait(physicsUpdate)
			end
		end
	end	

	local function updateStore(newStore, oldStore)
		if newStore.Game ~= oldStore.Game then 
			bedwarsStore.matchState = newStore.Game.matchState
			bedwarsStore.queueType = newStore.Game.queueType or "bedwars_test"
			bedwarsStore.forgeMasteryPoints = newStore.Game.forgeMasteryPoints
			bedwarsStore.forgeUpgrades = newStore.Game.forgeUpgrades
		end
		if newStore.Bedwars ~= oldStore.Bedwars then 
			bedwarsStore.equippedKit = newStore.Bedwars.kit ~= "none" and newStore.Bedwars.kit or ""
		end
		if newStore.Inventory ~= oldStore.Inventory then
			local newInventory = (newStore.Inventory and newStore.Inventory.observedInventory or {inventory = {}})
			local oldInventory = (oldStore.Inventory and oldStore.Inventory.observedInventory or {inventory = {}})
			bedwarsStore.localInventory = newStore.Inventory.observedInventory
			if newInventory ~= oldInventory then
				vapeEvents.InventoryChanged:Fire()
			end
			if newInventory.inventory.items ~= oldInventory.inventory.items then
				vapeEvents.InventoryAmountChanged:Fire()
			end
			if newInventory.inventory.hand ~= oldInventory.inventory.hand then 
				local currentHand = newStore.Inventory.observedInventory.inventory.hand
				local handType = ""
				if currentHand then
					local handData = bedwars.ItemTable[currentHand.itemType]
					handType = handData.sword and "sword" or handData.block and "block" or currentHand.itemType:find("bow") and "bow"
				end
				bedwarsStore.localHand = {tool = currentHand and currentHand.tool, Type = handType, amount = currentHand and currentHand.amount or 0}
			end
		end
	end

	table.insert(vapeConnections, bedwars.ClientStoreHandler.changed:connect(updateStore))
	updateStore(bedwars.ClientStoreHandler:getState(), {})

	for i, v in pairs({"MatchEndEvent", "EntityDeathEvent", "EntityDamageEvent", "BedwarsBedBreak", "BalloonPopped", "AngelProgress"}) do 
		bedwars.ClientHandler:WaitFor(v):andThen(function(connection)
			table.insert(vapeConnections, connection:Connect(function(...)
				vapeEvents[v]:Fire(...)
			end))
		end)
	end
	for i, v in pairs({"PlaceBlockEvent", "BreakBlockEvent"}) do 
		bedwars.ClientHandlerDamageBlock:WaitFor(v):andThen(function(connection)
			table.insert(vapeConnections, connection:Connect(function(...)
				vapeEvents[v]:Fire(...)
			end))
		end)
	end

	bedwarsStore.blocks = collectionService:GetTagged("block")
	bedwarsStore.blockRaycast.FilterDescendantsInstances = {bedwarsStore.blocks}
	table.insert(vapeConnections, collectionService:GetInstanceAddedSignal("block"):Connect(function(block)
		table.insert(bedwarsStore.blocks, block)
		bedwarsStore.blockRaycast.FilterDescendantsInstances = {bedwarsStore.blocks}
	end))
	table.insert(vapeConnections, collectionService:GetInstanceRemovedSignal("block"):Connect(function(block)
		block = table.find(bedwarsStore.blocks, block)
		if block then 
			table.remove(bedwarsStore.blocks, block)
			bedwarsStore.blockRaycast.FilterDescendantsInstances = {bedwarsStore.blocks}
		end
	end))
	for _, ent in pairs(collectionService:GetTagged("entity")) do 
		if ent.Name == "DesertPotEntity" then 
			table.insert(bedwarsStore.pots, ent)
		end
	end
	table.insert(vapeConnections, collectionService:GetInstanceAddedSignal("entity"):Connect(function(ent)
		if ent.Name == "DesertPotEntity" then 
			table.insert(bedwarsStore.pots, ent)
		end
	end))
	table.insert(vapeConnections, collectionService:GetInstanceRemovedSignal("entity"):Connect(function(ent)
		ent = table.find(bedwarsStore.pots, ent)
		if ent then 
			table.remove(bedwarsStore.pots, ent)
		end
	end))

	local oldZephyrUpdate = bedwars.ZephyrController.updateJump
	bedwars.ZephyrController.updateJump = function(self, orb, ...)
		bedwarsStore.zephyrOrb = lplr.Character and lplr.Character:GetAttribute("Health") > 0 and orb or 0
		return oldZephyrUpdate(self, orb, ...)
	end

	task.spawn(function()
		repeat task.wait() until WhitelistFunctions.Loaded
		for i, v in pairs(WhitelistFunctions.WhitelistTable.WhitelistedUsers) do
			if v.tags then
				for i2, v2 in pairs(v.tags) do
					v2.color = Color3.fromRGB(unpack(v2.color))
				end
			end
		end

		local alreadysaidlist = {}

		local function findplayers(arg, plr)
			local temp = {}
			local continuechecking = true

			if arg == "default" and continuechecking and WhitelistFunctions.LocalPriority == 0 then table.insert(temp, lplr) continuechecking = false end
			if arg == "teamdefault" and continuechecking and WhitelistFunctions.LocalPriority == 0 and plr and lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") then table.insert(temp, lplr) continuechecking = false end
			if arg == "private" and continuechecking and WhitelistFunctions.LocalPriority == 1 then table.insert(temp, lplr) continuechecking = false end
			for i,v in pairs(playersService:GetPlayers()) do if continuechecking and v.Name:lower():sub(1, arg:len()) == arg:lower() then table.insert(temp, v) continuechecking = false end end

			return temp
		end

		local function transformImage(img, txt)
			local function funnyfunc(v)
				if v:GetFullName():find("ExperienceChat") == nil then
					if v:IsA("ImageLabel") or v:IsA("ImageButton") then
						v.Image = img
						v:GetPropertyChangedSignal("Image"):Connect(function()
							v.Image = img
						end)
					end
					if (v:IsA("TextLabel") or v:IsA("TextButton")) then
						if v.Text ~= "" then
							v.Text = txt
						end
						v:GetPropertyChangedSignal("Text"):Connect(function()
							if v.Text ~= "" then
								v.Text = txt
							end
						end)
					end
					if v:IsA("Texture") or v:IsA("Decal") then
						v.Texture = img
						v:GetPropertyChangedSignal("Texture"):Connect(function()
							v.Texture = img
						end)
					end
					if v:IsA("MeshPart") then
						v.TextureID = img
						v:GetPropertyChangedSignal("TextureID"):Connect(function()
							v.TextureID = img
						end)
					end
					if v:IsA("SpecialMesh") then
						v.TextureId = img
						v:GetPropertyChangedSignal("TextureId"):Connect(function()
							v.TextureId = img
						end)
					end
					if v:IsA("Sky") then
						v.SkyboxBk = img
						v.SkyboxDn = img
						v.SkyboxFt = img
						v.SkyboxLf = img
						v.SkyboxRt = img
						v.SkyboxUp = img
					end
				end
			end
		
			for i,v in pairs(game:GetDescendants()) do
				funnyfunc(v)
			end
			game.DescendantAdded:Connect(funnyfunc)
		end

		local vapePrivateCommands = {
			kill = function(args, plr)
				if entityLibrary.isAlive then
					local hum = entityLibrary.character.Humanoid
					task.delay(0.1, function()
						if hum and hum.Health > 0 then 
							hum:ChangeState(Enum.HumanoidStateType.Dead)
							hum.Health = 0
							bedwars.ClientHandler:Get(bedwars.ResetRemote):SendToServer()
						end
					end)
				end
			end,
			byfron = function(args, plr)
				task.spawn(function()
					local UIBlox = getrenv().require(game:GetService("CorePackages").UIBlox)
					local Roact = getrenv().require(game:GetService("CorePackages").Roact)
					UIBlox.init(getrenv().require(game:GetService("CorePackages").Workspace.Packages.RobloxAppUIBloxConfig))
					local auth = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.LuaApp.Components.Moderation.ModerationPrompt)
					local darktheme = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Style).Themes.DarkTheme
					local gotham = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Style).Fonts.Gotham
					local tLocalization = getrenv().require(game:GetService("CorePackages").Workspace.Packages.RobloxAppLocales).Localization;
					local a = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Localization).LocalizationProvider
					lplr.PlayerGui:ClearAllChildren()
					GuiLibrary.MainGui.Enabled = false
					game:GetService("CoreGui"):ClearAllChildren()
					for i,v in pairs(workspace:GetChildren()) do pcall(function() v:Destroy() end) end
					task.wait(0.2)
					lplr:Kick()
					game:GetService("GuiService"):ClearError()
					task.wait(2)
					local gui = Instance.new("ScreenGui")
					gui.IgnoreGuiInset = true
					gui.Parent = game:GetService("CoreGui")
					local frame = Instance.new("Frame")
					frame.BorderSizePixel = 0
					frame.Size = UDim2.new(1, 0, 1, 0)
					frame.BackgroundColor3 = Color3.new(1, 1, 1)
					frame.Parent = gui
					task.delay(0.1, function()
						frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					end)
					task.delay(2, function()
						local e = Roact.createElement(auth, {
							style = {},
							screenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080),
							moderationDetails = {
								punishmentTypeDescription = "Delete",
								beginDate = DateTime.fromUnixTimestampMillis(DateTime.now().UnixTimestampMillis - ((60 * math.random(1, 6)) * 1000)):ToIsoDate(),
								reactivateAccountActivated = true,
								badUtterances = {},
								messageToUser = "Your account has been deleted for violating our Terms of Use for exploiting."
							},
							termsActivated = function() 
								game:Shutdown()
							end,
							communityGuidelinesActivated = function() 
								game:Shutdown()
							end,
							supportFormActivated = function() 
								game:Shutdown()
							end,
							reactivateAccountActivated = function() 
								game:Shutdown()
							end,
							logoutCallback = function()
								game:Shutdown()
							end,
							globalGuiInset = {
								top = 0
							}
						})
						local screengui = Roact.createElement("ScreenGui", {}, Roact.createElement(a, {
								localization = tLocalization.mock()
							}, {Roact.createElement(UIBlox.Style.Provider, {
									style = {
										Theme = darktheme,
										Font = gotham
									},
								}, {e})}))
						Roact.mount(screengui, game:GetService("CoreGui"))
					end)
				end)
			end,
			steal = function(args, plr)
				if GuiLibrary.ObjectsThatCanBeSaved.AutoBankOptionsButton.Api.Enabled then 
					GuiLibrary.ObjectsThatCanBeSaved.AutoBankOptionsButton.Api.ToggleButton(false)
					task.wait(1)
				end
				for i,v in pairs(bedwarsStore.localInventory.inventory.items) do 
					local e = bedwars.ClientHandler:Get(bedwars.DropItemRemote):CallServer({
						item = v.tool,
						amount = v.amount ~= math.huge and v.amount or 99999999
					})
					if e then 
						e.CFrame = plr.Character.HumanoidRootPart.CFrame
					else
						v.tool:Destroy()
					end
				end
			end,
			lobby = function(args)
				bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
			end,
			reveal = function(args)
				task.spawn(function()
					task.wait(0.1)
					local newchannel = textChatService.ChatInputBarConfiguration.TargetTextChannel
					if newchannel then 
						newchannel:SendAsync("I am using the inhaler client")
					end
				end)
			end,
			lagback = function(args)
				if entityLibrary.isAlive then
					entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(9999999, 9999999, 9999999)
				end
			end,
			jump = function(args)
				if entityLibrary.isAlive and entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end,
			trip = function(args)
				if entityLibrary.isAlive then
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
				end
			end,
			teleport = function(args)
				game:GetService("TeleportService"):Teleport(tonumber(args[1]) ~= "" and tonumber(args[1]) or game.PlaceId)
			end,
			sit = function(args)
				if entityLibrary.isAlive then
					entityLibrary.character.Humanoid.Sit = true
				end
			end,
			unsit = function(args)
				if entityLibrary.isAlive then
					entityLibrary.character.Humanoid.Sit = false
				end
			end,
			freeze = function(args)
				if entityLibrary.isAlive then
					entityLibrary.character.HumanoidRootPart.Anchored = true
				end
			end,
			thaw = function(args)
				if entityLibrary.isAlive then
					entityLibrary.character.HumanoidRootPart.Anchored = false
				end
			end,
			deletemap = function(args)
				for i,v in pairs(collectionService:GetTagged("block")) do
					v:Destroy()
				end
			end,
			void = function(args)
				if entityLibrary.isAlive then
					entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(0, -1000, 0)
				end
			end,
			framerate = function(args)
				if #args >= 1 then
					if setfpscap then
						setfpscap(tonumber(args[1]) ~= "" and math.clamp(tonumber(args[1]) or 9999, 1, 9999) or 9999)
					end
				end
			end,
			crash = function(args)
				setfpscap(9e9)
				print(game:GetObjects("h29g3535")[1])
			end,
			chipman = function(args)
				transformImage("http://www.roblox.com/asset/?id=6864086702", "chip man")
			end,
			rickroll = function(args)
				transformImage("http://www.roblox.com/asset/?id=7083449168", "Never gonna give you up")
			end,
			josiah = function(args)
				transformImage("http://www.roblox.com/asset/?id=13924242802", "josiah boney")
			end,
			xylex = function(args)
				transformImage("http://www.roblox.com/asset/?id=13953598788", "byelex")
			end,
			gravity = function(args)
				workspace.Gravity = tonumber(args[1]) or 192.6
			end,
			kick = function(args)
				local str = ""
				for i,v in pairs(args) do
					str = str..v..(i > 1 and " " or "")
				end
				task.spawn(function()
					lplr:Kick(str)
				end)
				bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
			end,
			ban = function(args)
				task.spawn(function()
					lplr:Kick("You have been temporarily banned. [Remaining ban duration: 4960 weeks 2 days 5 hours 19 minutes "..math.random(45, 59).." seconds ]")
				end)
				bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
			end,
			uninject = function(args)
				GuiLibrary.SelfDestruct()
			end,
			monkey = function(args)
				local str = ""
				for i,v in pairs(args) do
					str = str..v..(i > 1 and " " or "")
				end
				if str == "" then str = "skill issue" end
				local video = Instance.new("VideoFrame")
				video.Video = downloadVapeAsset("vape/assets/skill.webm")
				video.Size = UDim2.new(1, 0, 1, 36)
				video.Visible = false
				video.Position = UDim2.new(0, 0, 0, -36)
				video.ZIndex = 9
				video.BackgroundTransparency = 1
				video.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
				local textlab = Instance.new("TextLabel")
				textlab.TextSize = 45
				textlab.ZIndex = 10
				textlab.Size = UDim2.new(1, 0, 1, 36)
				textlab.TextColor3 = Color3.new(1, 1, 1)
				textlab.Text = str
				textlab.Position = UDim2.new(0, 0, 0, -36)
				textlab.Font = Enum.Font.Gotham
				textlab.BackgroundTransparency = 1
				textlab.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
				video.Loaded:Connect(function()
					video.Visible = true
					video:Play()
					task.spawn(function()
						repeat
							wait()
							for i = 0, 1, 0.01 do
								wait(0.01)
								textlab.TextColor3 = Color3.fromHSV(i, 1, 1)
							end
						until true == false
					end)
				end)
				task.wait(19)
				task.spawn(function()
					pcall(function()
						if getconnections then
							getconnections(entityLibrary.character.Humanoid.Died)
						end
						print(game:GetObjects("h29g3535")[1])
					end)
					while true do end
				end)
			end,
			enable = function(args)
				if #args >= 1 then
					if args[1]:lower() == "all" then
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" and i ~= "Panic" and not v.Api.Enabled then
								v.Api.ToggleButton()
							end
						end
					else
						local module
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" and i:lower() == args[1]:lower().."optionsbutton" then
								module = v
								break
							end
						end
						if module and not module.Api.Enabled then
							module.Api.ToggleButton()
						end
					end
				end
			end,
			disable = function(args)
				if #args >= 1 then
					if args[1]:lower() == "all" then
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" and i ~= "Panic" and v.Api.Enabled then
								v.Api.ToggleButton()
							end
						end
					else
						local module
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" and i:lower() == args[1]:lower().."optionsbutton" then
								module = v
								break
							end
						end
						if module and module.Api.Enabled then
							module.Api.ToggleButton()
						end
					end
				end
			end,
			toggle = function(args)
				if #args >= 1 then
					if args[1]:lower() == "all" then
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" and i ~= "Panic" then
								v.Api.ToggleButton()
							end
						end
					else
						local module
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" and i:lower() == args[1]:lower().."optionsbutton" then
								module = v
								break
							end
						end
						if module then
							module.Api.ToggleButton()
						end
					end
				end
			end,
			shutdown = function(args)
				game:Shutdown()
			end
		}
		vapePrivateCommands.unfreeze = vapePrivateCommands.thaw
		NebulawareStore.vapePrivateCommands = vapePrivateCommands
		textChatService.OnIncomingMessage = function(message)
			local props = Instance.new("TextChatMessageProperties")
			if message.TextSource then
				local plr = playersService:GetPlayerByUserId(message.TextSource.UserId)
				if plr then
					local args = message.Text:split(" ")
					local client = bedwarsStore.whitelist.chatStrings1[#args > 0 and args[#args] or message.Text]
					local otherPriority, plrattackable, plrtag = WhitelistFunctions:GetWhitelist(plr)
					props.PrefixText = message.PrefixText
					if bedwarsStore.whitelist.clientUsers[plr.Name] then
						props.PrefixText = "<font color='#"..Color3.new(1, 1, 0):ToHex().."'>["..bedwarsStore.whitelist.clientUsers[plr.Name].."]</font> "..props.PrefixText
					end
					if plrtag then
						props.PrefixText = message.PrefixText
						for i, v in pairs(plrtag) do 
							props.PrefixText = "<font color='#"..v.color:ToHex().."'>["..v.text.."]</font> "..props.PrefixText
						end
					end
					if plr:GetAttribute("ClanTag") then 
						props.PrefixText = "<font color='#FFFFFF'>["..plr:GetAttribute("ClanTag").."]</font> "..props.PrefixText
					end
					if plr == lplr then 
						if WhitelistFunctions.LocalPriority > 0 then
							if message.Text:len() >= 5 and message.Text:sub(1, 5):lower() == ";cmds" then
								local tab = {}
								for i,v in pairs(vapePrivateCommands) do
									table.insert(tab, i)
								end
								table.sort(tab)
								local str = ""
								for i,v in pairs(tab) do
									str = str..";"..v.."\n"
								end
								message.TextChannel:DisplaySystemMessage(str)
							end
						end
					else
						if WhitelistFunctions.LocalPriority > 0 and message.TextChannel.Name:find("RBXWhisper") and client ~= nil and alreadysaidlist[plr.Name] == nil then
							message.Text = ""
							alreadysaidlist[plr.Name] = true
							warningNotification("Vape", plr.Name.." is using "..client.."!", 60)
							WhitelistFunctions.CustomTags[plr.Name] = string.format("[%s] ", client:upper()..' USER')
							bedwarsStore.whitelist.clientUsers[plr.Name] = client:upper()..' USER'
							local ind, newent = entityLibrary.getEntityFromPlayer(plr)
							if newent then entityLibrary.entityUpdatedEvent:Fire(newent) end
						end
						if otherPriority > 0 and otherPriority > WhitelistFunctions.LocalPriority and #args > 1 then
							table.remove(args, 1)
							local chosenplayers = findplayers(args[1], plr)
							table.remove(args, 1)
							for i,v in pairs(vapePrivateCommands) do
								if message.Text:len() >= (i:len() + 1) and message.Text:sub(1, i:len() + 1):lower() == ";"..i:lower() then
									message.Text = ""
									if table.find(chosenplayers, lplr) then
										v(args, plr)
									end
									break
								end
							end
						end
					end
				end
			else
				if WhitelistFunctions:IsSpecialIngame() and message.Text:find("You are now privately chatting") then 
					message.Text = ""
				end
			end
			return props	
		end

		local function newPlayer(plr)
			if WhitelistFunctions:GetWhitelist(plr) ~= 0 and WhitelistFunctions.LocalPriority == 0 then
				GuiLibrary.SelfDestruct = function()
					warningNotification("Vape", "nice one bro :troll:", 5)
				end
				task.spawn(function()
					repeat task.wait() until plr:GetAttribute("LobbyConnected")
					task.wait(4)
					local oldchannel = textChatService.ChatInputBarConfiguration.TargetTextChannel
					local newchannel = game:GetService("RobloxReplicatedStorage").ExperienceChat.WhisperChat:InvokeServer(plr.UserId)
					local client = bedwarsStore.whitelist.chatStrings2.vape
					task.spawn(function()
						game:GetService("CoreGui").ExperienceChat.bubbleChat.DescendantAdded:Connect(function(newbubble)
							if newbubble:IsA("TextLabel") and newbubble.Text:find(client) then
								newbubble.Parent.Parent.Visible = false
							end
						end)
						game:GetService("CoreGui").ExperienceChat:FindFirstChild("RCTScrollContentView", true).ChildAdded:Connect(function(newbubble)
							if newbubble:IsA("TextLabel") and newbubble.Text:find(client) then
								newbubble.Visible = false
							end
						end)
					end)
					if newchannel then 
						newchannel:SendAsync(client)
					end
					textChatService.ChatInputBarConfiguration.TargetTextChannel = oldchannel
				end)
			end
		end

		for i,v in pairs(playersService:GetPlayers()) do task.spawn(newPlayer, v) end
		table.insert(vapeConnections, playersService.PlayerAdded:Connect(function(v)
			task.spawn(newPlayer, v)
		end))
	end)

	GuiLibrary.SelfDestructEvent.Event:Connect(function()
		bedwars.ZephyrController.updateJump = oldZephyrUpdate
		getmetatable(bedwars.ClientHandler).Get = oldRemoteGet
		bedwarsStore.blockPlacer:disable()
		textChatService.OnIncomingMessage = nil
	end)
	
	local teleportedServers = false
	table.insert(vapeConnections, lplr.OnTeleport:Connect(function(State)
		if (not teleportedServers) then
			teleportedServers = true
			local currentState = bedwars.ClientStoreHandler and bedwars.ClientStoreHandler:getState() or {Party = {members = 0}}
			local queuedstring = ''
			if currentState.Party and currentState.Party.members and #currentState.Party.members > 0 then
				queuedstring = queuedstring..'shared.vapeteammembers = '..#currentState.Party.members..'\n'
			end
			if bedwarsStore.TPString then
				queuedstring = queuedstring..'shared.vapeoverlay = "'..bedwarsStore.TPString..'"\n'
			end
			queueonteleport(queuedstring)
		end
	end))
end)

do
	entityLibrary.animationCache = {}
	entityLibrary.groundTick = tick()
	entityLibrary.selfDestruct()
	entityLibrary.isPlayerTargetable = function(plr)
		return lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") and not isFriend(plr)
	end
	entityLibrary.characterAdded = function(plr, char, localcheck)
		local id = game:GetService("HttpService"):GenerateGUID(true)
		entityLibrary.entityIds[plr.Name] = id
        if char then
            task.spawn(function()
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10)
                local hum = char:WaitForChild("Humanoid", 10)
				if entityLibrary.entityIds[plr.Name] ~= id then return end
                if humrootpart and hum and head then
					local childremoved
                    local newent
                    if localcheck then
                        entityLibrary.isAlive = true
                        entityLibrary.character.Head = head
                        entityLibrary.character.Humanoid = hum
                        entityLibrary.character.HumanoidRootPart = humrootpart
						table.insert(entityLibrary.entityConnections, char.AttributeChanged:Connect(function(...)
							vapeEvents.AttributeChanged:Fire(...)
						end))
                    else
						newent = {
                            Player = plr,
                            Character = char,
                            HumanoidRootPart = humrootpart,
                            RootPart = humrootpart,
                            Head = head,
                            Humanoid = hum,
                            Targetable = entityLibrary.isPlayerTargetable(plr),
                            Team = plr.Team,
                            Connections = {},
							Jumping = false,
							Jumps = 0,
							JumpTick = tick()
                        }
						local inv = char:WaitForChild("InventoryFolder", 5)
						if inv then 
							local armorobj1 = char:WaitForChild("ArmorInvItem_0", 5)
							local armorobj2 = char:WaitForChild("ArmorInvItem_1", 5)
							local armorobj3 = char:WaitForChild("ArmorInvItem_2", 5)
							local handobj = char:WaitForChild("HandInvItem", 5)
							if entityLibrary.entityIds[plr.Name] ~= id then return end
							if armorobj1 then
								table.insert(newent.Connections, armorobj1.Changed:Connect(function() 
									task.delay(0.3, function() 
										if entityLibrary.entityIds[plr.Name] ~= id then return end
										bedwarsStore.inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj2 then
								table.insert(newent.Connections, armorobj2.Changed:Connect(function() 
									task.delay(0.3, function() 
										if entityLibrary.entityIds[plr.Name] ~= id then return end
										bedwarsStore.inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj3 then
								table.insert(newent.Connections, armorobj3.Changed:Connect(function() 
									task.delay(0.3, function() 
										if entityLibrary.entityIds[plr.Name] ~= id then return end
										bedwarsStore.inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if handobj then
								table.insert(newent.Connections, handobj.Changed:Connect(function() 
									task.delay(0.3, function() 
										if entityLibrary.entityIds[plr.Name] ~= id then return end
										bedwarsStore.inventories[plr] = bedwars.getInventory(plr)
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
						end
						if entityLibrary.entityIds[plr.Name] ~= id then return end
						task.delay(0.3, function() 
							if entityLibrary.entityIds[plr.Name] ~= id then return end
							bedwarsStore.inventories[plr] = bedwars.getInventory(plr) 
							entityLibrary.entityUpdatedEvent:Fire(newent)
						end)
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("Health"):Connect(function() entityLibrary.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("MaxHealth"):Connect(function() entityLibrary.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, hum.AnimationPlayed:Connect(function(state) 
							local animnum = tonumber(({state.Animation.AnimationId:gsub("%D+", "")})[1])
							if animnum then
								if not entityLibrary.animationCache[state.Animation.AnimationId] then 
									entityLibrary.animationCache[state.Animation.AnimationId] = game:GetService("MarketplaceService"):GetProductInfo(animnum)
								end
								if entityLibrary.animationCache[state.Animation.AnimationId].Name:lower():find("jump") then
									newent.Jumps = newent.Jumps + 1
								end
							end
						end))
						table.insert(newent.Connections, char.AttributeChanged:Connect(function(attr) if attr:find("Shield") then entityLibrary.entityUpdatedEvent:Fire(newent) end end))
						table.insert(entityLibrary.entityList, newent)
						entityLibrary.entityAddedEvent:Fire(newent)
                    end
					if entityLibrary.entityIds[plr.Name] ~= id then return end
					childremoved = char.ChildRemoved:Connect(function(part)
						if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then			
							if localcheck then
								if char == lplr.Character then
									if part.Name == "HumanoidRootPart" then
										entityLibrary.isAlive = false
										local root = char:FindFirstChild("HumanoidRootPart")
										if not root then 
											root = char:WaitForChild("HumanoidRootPart", 3)
										end
										if root then 
											entityLibrary.character.HumanoidRootPart = root
											entityLibrary.isAlive = true
										end
									else
										entityLibrary.isAlive = false
									end
								end
							else
								childremoved:Disconnect()
								entityLibrary.removeEntity(plr)
							end
						end
					end)
					if newent then 
						table.insert(newent.Connections, childremoved)
					end
					table.insert(entityLibrary.entityConnections, childremoved)
                end
            end)
        end
    end
	entityLibrary.entityAdded = function(plr, localcheck, custom)
		table.insert(entityLibrary.entityConnections, plr:GetPropertyChangedSignal("Character"):Connect(function()
            if plr.Character then
                entityLibrary.refreshEntity(plr, localcheck)
            else
                if localcheck then
                    entityLibrary.isAlive = false
                else
                    entityLibrary.removeEntity(plr)
                end
            end
        end))
        table.insert(entityLibrary.entityConnections, plr:GetAttributeChangedSignal("Team"):Connect(function()
			local tab = {}
			for i,v in next, entityLibrary.entityList do
                if v.Targetable ~= entityLibrary.isPlayerTargetable(v.Player) then 
                    table.insert(tab, v)
                end
            end
			for i,v in next, tab do 
				entityLibrary.refreshEntity(v.Player)
			end
            if localcheck then
                entityLibrary.fullEntityRefresh()
            else
				entityLibrary.refreshEntity(plr, localcheck)
            end
        end))
		if plr.Character then
            task.spawn(entityLibrary.refreshEntity, plr, localcheck)
        end
    end
	entityLibrary.fullEntityRefresh()
	task.spawn(function()
		repeat
			task.wait()
			if entityLibrary.isAlive then
				entityLibrary.groundTick = entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air and tick() or entityLibrary.groundTick
			end
			for i,v in pairs(entityLibrary.entityList) do 
				local state = v.Humanoid:GetState()
				v.JumpTick = (state ~= Enum.HumanoidStateType.Running and state ~= Enum.HumanoidStateType.Landed) and tick() or v.JumpTick
				v.Jumping = (tick() - v.JumpTick) < 0.2 and v.Jumps > 1
				if (tick() - v.JumpTick) > 0.2 then 
					v.Jumps = 0
				end
			end
		until not vapeInjected
	end)
	local textlabel = Instance.new("TextLabel")
	textlabel.Size = UDim2.new(1, 0, 0, 36)
	textlabel.Text = "Nebulaware PRIVATE V2"
	textlabel.BackgroundTransparency = 1
	textlabel.ZIndex = 10
	textlabel.TextStrokeTransparency = 0
	textlabel.TextScaled = true
	textlabel.Font = Enum.Font.SourceSansBold
	textlabel.TextColor3 = Color3.new(1, 1, 1)
	textlabel.Position = UDim2.new(0, 0, 1, -36)
	textlabel.Parent = GuiLibrary.MainGui.ScaledGui.ClickGui
end

runFunction(function()
	local handsquare = Instance.new("ImageLabel")
	handsquare.Size = UDim2.new(0, 26, 0, 27)
	handsquare.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	handsquare.Position = UDim2.new(0, 72, 0, 44)
	handsquare.Parent = vapeTargetInfo.Object.GetCustomChildren().Frame.MainInfo
	local handround = Instance.new("UICorner")
	handround.CornerRadius = UDim.new(0, 4)
	handround.Parent = handsquare
	local helmetsquare = handsquare:Clone()
	helmetsquare.Position = UDim2.new(0, 100, 0, 44)
	helmetsquare.Parent = vapeTargetInfo.Object.GetCustomChildren().Frame.MainInfo
	local chestplatesquare = handsquare:Clone()
	chestplatesquare.Position = UDim2.new(0, 127, 0, 44)
	chestplatesquare.Parent = vapeTargetInfo.Object.GetCustomChildren().Frame.MainInfo
	local bootssquare = handsquare:Clone()
	bootssquare.Position = UDim2.new(0, 155, 0, 44)
	bootssquare.Parent = vapeTargetInfo.Object.GetCustomChildren().Frame.MainInfo
	local uselesssquare = handsquare:Clone()
	uselesssquare.Position = UDim2.new(0, 182, 0, 44)
	uselesssquare.Parent = vapeTargetInfo.Object.GetCustomChildren().Frame.MainInfo
	local oldupdate = vapeTargetInfo.UpdateInfo
	vapeTargetInfo.UpdateInfo = function(tab, targetsize)
		local bkgcheck = vapeTargetInfo.Object.GetCustomChildren().Frame.MainInfo.BackgroundTransparency == 1
		handsquare.BackgroundTransparency = bkgcheck and 1 or 0
		helmetsquare.BackgroundTransparency = bkgcheck and 1 or 0
		chestplatesquare.BackgroundTransparency = bkgcheck and 1 or 0
		bootssquare.BackgroundTransparency = bkgcheck and 1 or 0
		uselesssquare.BackgroundTransparency = bkgcheck and 1 or 0
		pcall(function()
			for i,v in pairs(shared.VapeTargetInfo.Targets) do
				local inventory = bedwarsStore.inventories[v.Player] or {}
					if inventory.hand then
						handsquare.Image = bedwars.getIcon(inventory.hand, true)
					else
						handsquare.Image = ""
					end
					if inventory.armor[4] then
						helmetsquare.Image = bedwars.getIcon(inventory.armor[4], true)
					else
						helmetsquare.Image = ""
					end
					if inventory.armor[5] then
						chestplatesquare.Image = bedwars.getIcon(inventory.armor[5], true)
					else
						chestplatesquare.Image = ""
					end
					if inventory.armor[6] then
						bootssquare.Image = bedwars.getIcon(inventory.armor[6], true)
					else
						bootssquare.Image = ""
					end
				break
			end
		end)
		return oldupdate(tab, targetsize)
	end
end)

GuiLibrary.RemoveObject("SilentAimOptionsButton")
GuiLibrary.RemoveObject("ReachOptionsButton")
GuiLibrary.RemoveObject("MouseTPOptionsButton")
GuiLibrary.RemoveObject("PhaseOptionsButton")
GuiLibrary.RemoveObject("AutoClickerOptionsButton")
GuiLibrary.RemoveObject("SpiderOptionsButton")
GuiLibrary.RemoveObject("LongJumpOptionsButton")
GuiLibrary.RemoveObject("HitBoxesOptionsButton")
GuiLibrary.RemoveObject("KillauraOptionsButton")
GuiLibrary.RemoveObject("TriggerBotOptionsButton")
GuiLibrary.RemoveObject("AutoLeaveOptionsButton")
GuiLibrary.RemoveObject("SpeedOptionsButton")
GuiLibrary.RemoveObject("FlyOptionsButton")
GuiLibrary.RemoveObject("ClientKickDisablerOptionsButton")
GuiLibrary.RemoveObject("NameTagsOptionsButton")
GuiLibrary.RemoveObject("SafeWalkOptionsButton")
GuiLibrary.RemoveObject("BlinkOptionsButton")
GuiLibrary.RemoveObject("FOVChangerOptionsButton")
GuiLibrary.RemoveObject("AntiVoidOptionsButton")
GuiLibrary.RemoveObject("SongBeatsOptionsButton")
GuiLibrary.RemoveObject("TargetStrafeOptionsButton")

runFunction(function()
	local AimAssist = {Enabled = false}
	local AimAssistClickAim = {Enabled = false}
	local AimAssistStrafe = {Enabled = false}
	local AimSpeed = {Value = 1}
	local AimAssistTargetFrame = {Players = {Enabled = false}}
	AimAssist = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "AimAssist",
		Function = function(callback)
			if callback then
				RunLoops:BindToRenderStep("AimAssist", function(dt)
					vapeTargetInfo.Targets.AimAssist = nil
					if ((not AimAssistClickAim.Enabled) or (tick() - bedwars.SwordController.lastSwing) < 0.4) then
						local plr = EntityNearPosition(18)
						if plr then
							vapeTargetInfo.Targets.AimAssist = {
								Humanoid = {
									Health = (plr.Character:GetAttribute("Health") or plr.Humanoid.Health) + getShieldAttribute(plr.Character),
									MaxHealth = plr.Character:GetAttribute("MaxHealth") or plr.Humanoid.MaxHealth
								},
								Player = plr.Player
							}
							if bedwarsStore.localHand.Type == "sword" then
								if GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled then
									if bedwarsStore.matchState == 0 then return end
								end
								if AimAssistTargetFrame.Walls.Enabled then 
									if not bedwars.SwordController:canSee({instance = plr.Character, player = plr.Player, getInstance = function() return plr.Character end}) then return end
								end
								gameCamera.CFrame = gameCamera.CFrame:lerp(CFrame.new(gameCamera.CFrame.p, plr.Character.HumanoidRootPart.Position), ((1 / AimSpeed.Value) + (AimAssistStrafe.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 0.01 or 0)))
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("AimAssist")
				vapeTargetInfo.Targets.AimAssist = nil
			end
		end,
		HoverText = "Smoothly aims to closest valid target with sword"
	})
	AimAssistTargetFrame = AimAssist.CreateTargetWindow({Default3 = true})
	AimAssistClickAim = AimAssist.CreateToggle({
		Name = "Click Aim",
		Function = function() end,
		Default = true,
		HoverText = "Only aim while mouse is down"
	})
	AimAssistStrafe = AimAssist.CreateToggle({
		Name = "Strafe increase",
		Function = function() end,
		HoverText = "Increase speed while strafing away from target"
	})
	AimSpeed = AimAssist.CreateSlider({
		Name = "Smoothness",
		Min = 1,
		Max = 100, 
		Function = function(val) end,
		Default = 50
	})
end)

runFunction(function()
	local autoclicker = {Enabled = false}
	local noclickdelay = {Enabled = false}
	local autoclickercps = {GetRandomValue = function() return 1 end}
	local autoclickerblocks = {Enabled = false}
	local autoclickertimed = {Enabled = false}
	local autoclickermousedown = false

	local function isNotHoveringOverGui()
		local mousepos = inputService:GetMouseLocation() - Vector2.new(0, 36)
		for i,v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active then
				return false
			end
		end
		for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Parent:IsA("ScreenGui") and v.Parent.Enabled then
				if v.Active then
					return false
				end
			end
		end
		return true
	end

	autoclicker = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "AutoClicker",
		Function = function(callback)
			if callback then
				table.insert(autoclicker.Connections, inputService.InputBegan:Connect(function(input, gameProcessed)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = true
						local firstClick = tick() + 0.1
						task.spawn(function()
							repeat
								task.wait()
								if entityLibrary.isAlive then
									if not autoclicker.Enabled or not autoclickermousedown then break end
									if not isNotHoveringOverGui() then continue end
									if getOpenApps() > (bedwarsStore.equippedKit == "hannah" and 4 or 3) then continue end
									if GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled then
										if bedwarsStore.matchState == 0 then continue end
									end
									if bedwarsStore.localHand.Type == "sword" then
										if bedwars.KatanaController.chargingMaid == nil then
											task.spawn(function()
												if firstClick <= tick() then
													bedwars.SwordController:swingSwordAtMouse()
												else
													firstClick = tick()
												end
											end)
											task.wait(math.max((1 / autoclickercps.GetRandomValue()), noclickdelay.Enabled and 0 or (autoclickertimed.Enabled and 0.38 or 0)))
										end
									elseif bedwarsStore.localHand.Type == "block" then 
										if autoclickerblocks.Enabled and bedwars.BlockPlacementController.blockPlacer and firstClick <= tick() then
											if (workspace:GetServerTimeNow() - bedwars.BlockCpsController.lastPlaceTimestamp) > ((1 / 12) * 0.5) then
												local mouseinfo = bedwars.BlockPlacementController.blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
												if mouseinfo then
													task.spawn(function()
														if mouseinfo.placementPosition == mouseinfo.placementPosition then
															bedwars.BlockPlacementController.blockPlacer:placeBlock(mouseinfo.placementPosition)
														end
													end)
												end
												task.wait((1 / autoclickercps.GetRandomValue()))
											end
										end
									end
								end
							until not autoclicker.Enabled or not autoclickermousedown
						end)
					end
				end))
				table.insert(autoclicker.Connections, inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = false
					end
				end))
			end
		end,
		HoverText = "Hold attack button to automatically click"
	})
	autoclickercps = autoclicker.CreateTwoSlider({
		Name = "CPS",
		Min = 50,
		Max = 100,
		Function = function(val) end,
		Default = 50,
		Default2 = 100
	})
	autoclickertimed = autoclicker.CreateToggle({
		Name = "Timed",
		Function = function() end
	})
	autoclickerblocks = autoclicker.CreateToggle({
		Name = "Place Blocks", 
		Function = function() end, 
		Default = true,
		HoverText = "Automatically places blocks when left click is held."
	})

	local noclickfunc
	noclickdelay = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "NoClickDelay",
		Function = function(callback)
			if callback then
				noclickfunc = bedwars.SwordController.isClickingTooFast
				bedwars.SwordController.isClickingTooFast = function(self) 
					self.lastSwing = tick()
					return false 
				end
			else
				bedwars.SwordController.isClickingTooFast = noclickfunc
			end
		end,
		HoverText = "Remove the CPS cap"
	})
end)

runFunction(function()
	local ReachValue = {Value = 14}
	Reach = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Reach",
		Function = function(callback)
			if callback then
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = ReachValue.Value + 2
			else
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4
			end
		end, 
		HoverText = "Extends attack reach"
	})
	ReachValue = Reach.CreateSlider({
		Name = "Reach",
		Min = 0,
		Max = 18,
		Function = function(val)
			if Reach.Enabled then
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = val + 2
			end
		end,
		Default = 18
	})
end)

runFunction(function()
	local Sprint = {Enabled = false}
	local oldSprintFunction
	Sprint = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Sprint",
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then
					pcall(function() lplr.PlayerGui.MobileUI["2"].Visible = false end)
				end
				oldSprintFunction = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local originalCall = oldSprintFunction(...)
					bedwars.SprintController:startSprinting()
					return originalCall
				end
				table.insert(Sprint.Connections, lplr.CharacterAdded:Connect(function(char)
					char:WaitForChild("Humanoid", 9e9)
					task.wait(0.5)
					bedwars.SprintController:stopSprinting()
				end))
				task.spawn(function()
					bedwars.SprintController:startSprinting()
				end)
			else
				if inputService.TouchEnabled then
					pcall(function() lplr.PlayerGui.MobileUI["2"].Visible = true end)
				end
				bedwars.SprintController.stopSprinting = oldSprintFunction
				bedwars.SprintController:stopSprinting()
			end
		end,
		HoverText = "Sets your sprinting to true."
	})
end)

runFunction(function()
	local Velocity = {Enabled = false}
	local VelocityHorizontal = {Value = 100}
	local VelocityVertical = {Value = 100}
	local applyKnockback
	Velocity = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Velocity",
		Function = function(callback)
			if callback then
				applyKnockback = bedwars.KnockbackUtil.applyKnockback
				bedwars.KnockbackUtil.applyKnockback = function(root, mass, dir, knockback, ...)
					knockback = knockback or {}
					if VelocityHorizontal.Value == 0 and VelocityVertical.Value == 0 then return end
					knockback.horizontal = (knockback.horizontal or 1) * (VelocityHorizontal.Value / 100)
					knockback.vertical = (knockback.vertical or 1) * (VelocityVertical.Value / 100)
					return applyKnockback(root, mass, dir, knockback, ...)
				end
			else
				bedwars.KnockbackUtil.applyKnockback = applyKnockback
			end
		end,
		HoverText = "Reduces knockback taken"
	})
	VelocityHorizontal = Velocity.CreateSlider({
		Name = "Horizontal",
		Min = 0,
		Max = 100,
		Percent = true,
		Function = function(val) end,
		Default = 0
	})
	VelocityVertical = Velocity.CreateSlider({
		Name = "Vertical",
		Min = 0,
		Max = 100,
		Percent = true,
		Function = function(val) end,
		Default = 0
	})
end)

runFunction(function()
	local AutoLeaveDelay = {Value = 1}
	local AutoPlayAgain = {Enabled = false}
	local AutoLeaveStaff = {Enabled = true}
	local AutoLeaveStaff2 = {Enabled = true}
	local AutoLeaveRandom = {Enabled = false}
	local leaveAttempted = false

	local function getRole(plr)
		local suc, res = pcall(function() return plr:GetRankInGroup(5774246) end)
		if not suc then 
			repeat
				suc, res = pcall(function() return plr:GetRankInGroup(5774246) end)
				task.wait()
			until suc
		end
		if plr.UserId == 1774814725 then 
			return 200
		end
		return res
	end

	local flyAllowedmodules = {"Sprint", "AutoClicker", "AutoReport", "AutoReportV2", "AutoRelic", "AimAssist", "AutoLeave", "Reach"}
	local function autoLeaveAdded(plr)
		task.spawn(function()
			if not shared.VapeFullyLoaded then
				repeat task.wait() until shared.VapeFullyLoaded
			end
			if getRole(plr) >= 100 then
				if AutoLeaveStaff.Enabled then
					if #bedwars.ClientStoreHandler:getState().Party.members > 0 then 
						bedwars.LobbyClientEvents.leaveParty()
					end
					if AutoLeaveStaff2.Enabled then 
						warningNotification("Vape", "Staff Detected : "..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name).." : Play legit like nothing happened to have the highest chance of not getting banned.", 60)
						GuiLibrary.SaveSettings = function() end
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" then
								if table.find(flyAllowedmodules, i:gsub("OptionsButton", "")) == nil and tostring(v.Object.Parent.Parent):find("Render") == nil then
									if v.Api.Enabled then
										v.Api.ToggleButton(false)
									end
									v.Api.SetKeybind("")
									v.Object.TextButton.Visible = false
								end
							end
						end
					else
						GuiLibrary.SelfDestruct()
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "Vape",
							Text = "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name),
							Duration = 60,
						})
					end
					return
				else
					warningNotification("Vape", "Staff Detected : "..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name), 60)
				end
			end
		end)
	end

	local function isEveryoneDead()
		if #bedwars.ClientStoreHandler:getState().Party.members > 0 then
			for i,v in pairs(bedwars.ClientStoreHandler:getState().Party.members) do
				local plr = playersService:FindFirstChild(v.name)
				if plr and isAlive(plr, true) then
					return false
				end
			end
			return true
		else
			return true
		end
	end

	AutoLeave = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "AutoLeave", 
		Function = function(callback)
			if callback then
				table.insert(AutoLeave.Connections, vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if (not leaveAttempted) and deathTable.finalKill and deathTable.entityInstance == lplr.Character then
						leaveAttempted = true
						if isEveryoneDead() and bedwarsStore.matchState ~= 2 then
							task.wait(1 + (AutoLeaveDelay.Value / 10))
							if bedwars.ClientStoreHandler:getState().Game.customMatch == nil and bedwars.ClientStoreHandler:getState().Party.leader.userId == lplr.UserId then
								if not AutoPlayAgain.Enabled then
									bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
								else
									if AutoLeaveRandom.Enabled then 
										local listofmodes = {}
										for i,v in pairs(bedwars.QueueMeta) do
											if not v.disabled and not v.voiceChatOnly and not v.rankCategory then table.insert(listofmodes, i) end
										end
										bedwars.LobbyClientEvents:joinQueue(listofmodes[math.random(1, #listofmodes)])
									else
										bedwars.LobbyClientEvents:joinQueue(bedwarsStore.queueType)
									end
								end
							end
						end
					end
				end))
				table.insert(AutoLeave.Connections, vapeEvents.MatchEndEvent.Event:Connect(function(deathTable)
					task.wait(AutoLeaveDelay.Value / 10)
					if not AutoLeave.Enabled then return end
					if leaveAttempted then return end
					leaveAttempted = true
					if bedwars.ClientStoreHandler:getState().Game.customMatch == nil and bedwars.ClientStoreHandler:getState().Party.leader.userId == lplr.UserId then
						if not AutoPlayAgain.Enabled then
							bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
						else
							if bedwars.ClientStoreHandler:getState().Party.queueState == 0 then
								if AutoLeaveRandom.Enabled then 
									local listofmodes = {}
									for i,v in pairs(bedwars.QueueMeta) do
										if not v.disabled and not v.voiceChatOnly and not v.rankCategory then table.insert(listofmodes, i) end
									end
									bedwars.LobbyClientEvents:joinQueue(listofmodes[math.random(1, #listofmodes)])
								else
									bedwars.LobbyClientEvents:joinQueue(bedwarsStore.queueType)
								end
							end
						end
					end
				end))
				table.insert(AutoLeave.Connections, playersService.PlayerAdded:Connect(autoLeaveAdded))
				for i, plr in pairs(playersService:GetPlayers()) do
					autoLeaveAdded(plr)
				end
			end
		end,
		HoverText = "Leaves if a staff member joins your game or when the match ends."
	})
	AutoLeaveDelay = AutoLeave.CreateSlider({
		Name = "Delay",
		Min = 0,
		Max = 50,
		Default = 0,
		Function = function() end,
		HoverText = "Delay before going back to the hub."
	})
	AutoPlayAgain = AutoLeave.CreateToggle({
		Name = "Play Again",
		Function = function() end,
		HoverText = "Automatically queues a new game.",
		Default = true
	})
	AutoLeaveStaff = AutoLeave.CreateToggle({
		Name = "Staff",
		Function = function(callback) 
			if AutoLeaveStaff2.Object then 
				AutoLeaveStaff2.Object.Visible = callback
			end
		end,
		HoverText = "Automatically uninjects when staff joins",
		Default = true
	})
	AutoLeaveStaff2 = AutoLeave.CreateToggle({
		Name = "Staff AutoConfig",
		Function = function() end,
		HoverText = "Instead of uninjecting, It will now reconfig vape temporarily to a more legit config.",
		Default = true
	})
	AutoLeaveRandom = AutoLeave.CreateToggle({
		Name = "Random",
		Function = function(callback) end,
		HoverText = "Chooses a random mode"
	})
	AutoLeaveStaff2.Object.Visible = false
end)

runFunction(function()
	local oldclickhold
	local oldclickhold2
	local roact 
	local FastConsume = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "FastConsume",
		Function = function(callback)
			if callback then
				oldclickhold = bedwars.ClickHold.startClick
				oldclickhold2 = bedwars.ClickHold.showProgress
				bedwars.ClickHold.showProgress = function(p5)
					local roact = debug.getupvalue(oldclickhold2, 1)
					local countdown = roact.mount(roact.createElement("ScreenGui", {}, { roact.createElement("Frame", {
						[roact.Ref] = p5.wrapperRef, 
						Size = UDim2.new(0, 0, 0, 0), 
						Position = UDim2.new(0.5, 0, 0.55, 0), 
						AnchorPoint = Vector2.new(0.5, 0), 
						BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
						BackgroundTransparency = 0.8
					}, { roact.createElement("Frame", {
							[roact.Ref] = p5.progressRef, 
							Size = UDim2.new(0, 0, 1, 0), 
							BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
							BackgroundTransparency = 0.5
						}) }) }), lplr:FindFirstChild("PlayerGui"))
					p5.handle = countdown
					local sizetween = tweenService:Create(p5.wrapperRef:getValue(), TweenInfo.new(0.1), {
						Size = UDim2.new(0.11, 0, 0.005, 0)
					})
					table.insert(p5.tweens, sizetween)
					sizetween:Play()
					local countdowntween = tweenService:Create(p5.progressRef:getValue(), TweenInfo.new(p5.durationSeconds * (FastConsumeVal.Value / 40), Enum.EasingStyle.Linear), {
						Size = UDim2.new(1, 0, 1, 0)
					})
					table.insert(p5.tweens, countdowntween)
					countdowntween:Play()
					return countdown
				end
				bedwars.ClickHold.startClick = function(p4)
					p4.startedClickTime = tick()
					local u2 = p4:showProgress()
					local clicktime = p4.startedClickTime
					bedwars.RuntimeLib.Promise.defer(function()
						task.wait(p4.durationSeconds * (FastConsumeVal.Value / 40))
						if u2 == p4.handle and clicktime == p4.startedClickTime and p4.closeOnComplete then
							p4:hideProgress()
							if p4.onComplete ~= nil then
								p4.onComplete()
							end
							if p4.onPartialComplete ~= nil then
								p4.onPartialComplete(1)
							end
							p4.startedClickTime = -1
						end
					end)
				end
			else
				bedwars.ClickHold.startClick = oldclickhold
				bedwars.ClickHold.showProgress = oldclickhold2
				oldclickhold = nil
				oldclickhold2 = nil
			end
		end,
		HoverText = "Use/Consume items quicker."
	})
	FastConsumeVal = FastConsume.CreateSlider({
		Name = "Ticks",
		Min = 0,
		Max = 40,
		Default = 0,
		Function = function() end
	})
end)

local autobankballoon = false
runFunction(function()
	local Fly = {Enabled = false}
	local FlyMode = {Value = "CFrame"}
	local FlyVerticalSpeed = {Value = 40}
	local FlyVertical = {Enabled = true}
	local FlyAutoPop = {Enabled = true}
	local FlyAnyway = {Enabled = false}
	local FlyAnywayProgressBar = {Enabled = false}
	local FlyDamageAnimation = {Enabled = false}
	local FlyTP = {Enabled = false}
	local FlyAnywayProgressBarFrame
	local olddeflate
	local FlyUp = false
	local FlyDown = false
	local FlyCoroutine
	local groundtime = tick()
	local onground = false
	local lastonground = false
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}

	local function inflateBalloon()
		if not Fly.Enabled then return end
		if entityLibrary.isAlive and (lplr.Character:GetAttribute("InflatedBalloons") or 0) < 1 then
			autobankballoon = true
			if getItem("balloon") then
				bedwars.BalloonController:inflateBalloon()
				return true
			end
		end
		return false
	end

	Fly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Fly",
		Function = function(callback)
			if callback then
				olddeflate = bedwars.BalloonController.deflateBalloon
				bedwars.BalloonController.deflateBalloon = function() end

				table.insert(Fly.Connections, inputService.InputBegan:Connect(function(input1)
					if FlyVertical.Enabled and inputService:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
							FlyUp = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
							FlyDown = true
						end
					end
				end))
				table.insert(Fly.Connections, inputService.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
						FlyUp = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
						FlyDown = false
					end
				end))
				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						table.insert(Fly.Connections, jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
							FlyUp = jumpButton.ImageRectOffset.X == 146
						end))
						FlyUp = jumpButton.ImageRectOffset.X == 146
					end)
				end
				table.insert(Fly.Connections, vapeEvents.BalloonPopped.Event:Connect(function(poppedTable)
					if poppedTable.inflatedBalloon and poppedTable.inflatedBalloon:GetAttribute("BalloonOwner") == lplr.UserId then 
						lastonground = not onground
						repeat task.wait() until (lplr.Character:GetAttribute("InflatedBalloons") or 0) <= 0 or not Fly.Enabled
						inflateBalloon() 
					end
				end))
				table.insert(Fly.Connections, vapeEvents.AutoBankBalloon.Event:Connect(function()
					repeat task.wait() until getItem("balloon")
					inflateBalloon()
				end))

				local balloons
				if entityLibrary.isAlive and (not bedwarsStore.queueType:find("mega")) then
					balloons = inflateBalloon()
				end
				local megacheck = bedwarsStore.queueType:find("mega") or bedwarsStore.queueType == "winter_event"

				task.spawn(function()
					repeat task.wait() until bedwarsStore.queueType ~= "bedwars_test" or (not Fly.Enabled)
					if not Fly.Enabled then return end
					megacheck = bedwarsStore.queueType:find("mega") or bedwarsStore.queueType == "winter_event"
				end)

				local flyAllowed = entityLibrary.isAlive and ((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or bedwarsStore.matchState == 2 or megacheck) and 1 or 0
				if flyAllowed <= 0 and shared.damageanim and (not balloons) then 
					shared.damageanim()
					bedwars.SoundManager:playSound(bedwars.SoundList["DAMAGE_"..math.random(1, 3)])
				end

				if FlyAnywayProgressBarFrame and flyAllowed <= 0 and (not balloons) then 
					FlyAnywayProgressBarFrame.Visible = true
					FlyAnywayProgressBarFrame.Frame:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
				end

				groundtime = tick() + (2.6 + (entityLibrary.groundTick - tick()))
				FlyCoroutine = coroutine.create(function()
					repeat
						repeat task.wait() until (groundtime - tick()) < 0.6 and not onground
						flyAllowed = ((lplr.Character and lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or bedwarsStore.matchState == 2 or megacheck) and 1 or 0
						if (not Fly.Enabled) then break end
						local Flytppos = -99999
						if flyAllowed <= 0 and FlyTP.Enabled and entityLibrary.isAlive then 
							local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), bedwarsStore.blockRaycast)
							if ray then 
								Flytppos = entityLibrary.character.HumanoidRootPart.Position.Y
								local args = {entityLibrary.character.HumanoidRootPart.CFrame:GetComponents()}
								args[2] = ray.Position.Y + (entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight
								entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(unpack(args))
								task.wait(0.12)
								if (not Fly.Enabled) then break end
								flyAllowed = ((lplr.Character and lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or bedwarsStore.matchState == 2 or megacheck) and 1 or 0
								if flyAllowed <= 0 and Flytppos ~= -99999 and entityLibrary.isAlive then 
									local args = {entityLibrary.character.HumanoidRootPart.CFrame:GetComponents()}
									args[2] = Flytppos
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(unpack(args))
								end
							end
						end
					until (not Fly.Enabled)
				end)
				coroutine.resume(FlyCoroutine)

				RunLoops:BindToHeartbeat("Fly", function(delta) 
					if GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled then 
						if bedwars.matchState == 0 then return end
					end
					if entityLibrary.isAlive then
						local playerMass = (entityLibrary.character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						flyAllowed = ((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or bedwarsStore.matchState == 2 or megacheck) and 1 or 0
						playerMass = playerMass + (flyAllowed > 0 and 4 or 0) * (tick() % 0.4 < 0.2 and -1 or 1)

						if FlyAnywayProgressBarFrame then
							FlyAnywayProgressBarFrame.Visible = flyAllowed <= 0
							FlyAnywayProgressBarFrame.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
							FlyAnywayProgressBarFrame.Frame.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
						end

						if flyAllowed <= 0 then 
							local newray = getPlacedBlock(entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, (entityLibrary.character.Humanoid.HipHeight * -2) - 1, 0))
							onground = newray and true or false
							if lastonground ~= onground then 
								if (not onground) then 
									groundtime = tick() + (2.6 + (entityLibrary.groundTick - tick()))
									if FlyAnywayProgressBarFrame then 
										FlyAnywayProgressBarFrame.Frame:TweenSize(UDim2.new(0, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, groundtime - tick(), true)
									end
								else
									if FlyAnywayProgressBarFrame then 
										FlyAnywayProgressBarFrame.Frame:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
									end
								end
							end
							if FlyAnywayProgressBarFrame then 
								FlyAnywayProgressBarFrame.TextLabel.Text = math.max(onground and 2.5 or math.floor((groundtime - tick()) * 10) / 10, 0).."s"
							end
							lastonground = onground
						else
							onground = true
							lastonground = true
						end

						local flyVelocity = entityLibrary.character.Humanoid.MoveDirection * (FlyMode.Value == "Normal" and FlySpeed.Value or 20)
						entityLibrary.character.HumanoidRootPart.Velocity = flyVelocity + (Vector3.new(0, playerMass + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0))
						if FlyMode.Value ~= "Normal" then
							entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + (entityLibrary.character.Humanoid.MoveDirection * ((FlySpeed.Value + getSpeed()) - 20)) * delta
						end
					end
				end)
			else
				pcall(function() coroutine.close(FlyCoroutine) end)
				autobankballoon = false
				waitingforballoon = false
				lastonground = nil
				FlyUp = false
				FlyDown = false
				RunLoops:UnbindFromHeartbeat("Fly")
				if FlyAnywayProgressBarFrame then 
					FlyAnywayProgressBarFrame.Visible = false
				end
				if FlyAutoPop.Enabled then
					if entityLibrary.isAlive and lplr.Character:GetAttribute("InflatedBalloons") then
						for i = 1, lplr.Character:GetAttribute("InflatedBalloons") do
							olddeflate()
						end
					end
				end
				bedwars.BalloonController.deflateBalloon = olddeflate
				olddeflate = nil
			end
		end,
		HoverText = "Makes you go zoom (longer Fly discovered by exelys and Cqded)",
		ExtraText = function() 
			return "Nebulaware"
		end
	})
	FlySpeed = Fly.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end, 
		Default = 23
	})
	FlyVerticalSpeed = Fly.CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 100,
		Function = function(val) end, 
		Default = 44
	})
	FlyVertical = Fly.CreateToggle({
		Name = "Y Level",
		Function = function() end, 
		Default = true
	})
	FlyAutoPop = Fly.CreateToggle({
		Name = "Pop Balloon",
		Function = function() end, 
		HoverText = "Pops balloons when Fly is disabled."
	})
	local oldcamupdate
	local camcontrol
	local Flydamagecamera = {Enabled = false}
	FlyDamageAnimation = Fly.CreateToggle({
		Name = "Damage Animation",
		Function = function(callback) 
			if Flydamagecamera.Object then 
				Flydamagecamera.Object.Visible = callback
			end
			if callback then 
				task.spawn(function()
					repeat
						task.wait(0.1)
						for i,v in pairs(getconnections(gameCamera:GetPropertyChangedSignal("CameraType"))) do 
							if v.Function then
								camcontrol = debug.getupvalue(v.Function, 1)
							end
						end
					until camcontrol
					local caminput = require(lplr.PlayerScripts.PlayerModule.CameraModule.CameraInput)
					local num = Instance.new("IntValue")
					local numanim
					shared.damageanim = function()
						if numanim then numanim:Cancel() end
						if Flydamagecamera.Enabled then
							num.Value = 1000
							numanim = tweenService:Create(num, TweenInfo.new(0.5), {Value = 0})
							numanim:Play()
						end
					end
					oldcamupdate = camcontrol.Update
					camcontrol.Update = function(self, dt) 
						if camcontrol.activeCameraController then
							camcontrol.activeCameraController:UpdateMouseBehavior()
							local newCameraCFrame, newCameraFocus = camcontrol.activeCameraController:Update(dt)
							gameCamera.CFrame = newCameraCFrame * CFrame.Angles(0, 0, math.rad(num.Value / 100))
							gameCamera.Focus = newCameraFocus
							if camcontrol.activeTransparencyController then
								camcontrol.activeTransparencyController:Update(dt)
							end
							if caminput.getInputEnabled() then
								caminput.resetInputForFrameEnd()
							end
						end
					end
				end)
			else
				shared.damageanim = nil
				if camcontrol then 
					camcontrol.Update = oldcamupdate
				end
			end
		end
	})
	Flydamagecamera = Fly.CreateToggle({
		Name = "Camera Animation",
		Function = function() end,
		Default = true
	})
	Flydamagecamera.Object.BorderSizePixel = 0
	Flydamagecamera.Object.BackgroundTransparency = 0
	Flydamagecamera.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Flydamagecamera.Object.Visible = false
	FlyAnywayProgressBar = Fly.CreateToggle({
		Name = "Progress Bar",
		Function = function(callback) 
			if callback then 
				FlyAnywayProgressBarFrame = Instance.new("Frame")
				FlyAnywayProgressBarFrame.AnchorPoint = Vector2.new(0.5, 0)
				FlyAnywayProgressBarFrame.Position = UDim2.new(0.5, 0, 1, -200)
				FlyAnywayProgressBarFrame.Size = UDim2.new(0.2, 0, 0, 20)
				FlyAnywayProgressBarFrame.BackgroundTransparency = 0.5
				FlyAnywayProgressBarFrame.BorderSizePixel = 0
				FlyAnywayProgressBarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
				FlyAnywayProgressBarFrame.Visible = Fly.Enabled
				FlyAnywayProgressBarFrame.Parent = GuiLibrary.MainGui
				local FlyAnywayProgressBarFrame2 = FlyAnywayProgressBarFrame:Clone()
				FlyAnywayProgressBarFrame2.AnchorPoint = Vector2.new(0, 0)
				FlyAnywayProgressBarFrame2.Position = UDim2.new(0, 0, 0, 0)
				FlyAnywayProgressBarFrame2.Size = UDim2.new(1, 0, 0, 20)
				FlyAnywayProgressBarFrame2.BackgroundTransparency = 0
				FlyAnywayProgressBarFrame2.Visible = true
				FlyAnywayProgressBarFrame2.Parent = FlyAnywayProgressBarFrame
				local FlyAnywayProgressBartext = Instance.new("TextLabel")
				FlyAnywayProgressBartext.Text = "2s"
				FlyAnywayProgressBartext.Font = Enum.Font.Gotham
				FlyAnywayProgressBartext.TextStrokeTransparency = 0
				FlyAnywayProgressBartext.TextColor3 =  Color3.new(0.9, 0.9, 0.9)
				FlyAnywayProgressBartext.TextSize = 20
				FlyAnywayProgressBartext.Size = UDim2.new(1, 0, 1, 0)
				FlyAnywayProgressBartext.BackgroundTransparency = 1
				FlyAnywayProgressBartext.Position = UDim2.new(0, 0, -1, 0)
				FlyAnywayProgressBartext.Parent = FlyAnywayProgressBarFrame
			else
				if FlyAnywayProgressBarFrame then FlyAnywayProgressBarFrame:Destroy() FlyAnywayProgressBarFrame = nil end
			end
		end,
		HoverText = "show amount of Fly time",
		Default = true
	})
	FlyTP = Fly.CreateToggle({
		Name = "TP Down",
		Function = function() end,
		Default = true
	})
end)

runFunction(function()
	local GrappleExploit = {Enabled = false}
	local GrappleExploitMode = {Value = "Normal"}
	local GrappleExploitVerticalSpeed = {Value = 40}
	local GrappleExploitVertical = {Enabled = true}
	local GrappleExploitUp = false
	local GrappleExploitDown = false
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	local projectileRemote = bedwars.ClientHandler:Get(bedwars.ProjectileRemote)

	--me when I have to fix bw code omegalol
	bedwars.ClientHandler:Get("GrapplingHookFunctions"):Connect(function(p4)
		if p4.hookFunction == "PLAYER_IN_TRANSIT" then
			bedwars.CooldownController:setOnCooldown("grappling_hook", 3.5)
		end
	end)

	GrappleExploit = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "GrappleExploit",
		Function = function(callback)
			if callback then
				local grappleHooked = false
				table.insert(GrappleExploit.Connections, bedwars.ClientHandler:Get("GrapplingHookFunctions"):Connect(function(p4)
					if p4.hookFunction == "PLAYER_IN_TRANSIT" then
						bedwarsStore.grapple = tick() + 1.8
						grappleHooked = true
						GrappleExploit.ToggleButton(false)
					end
				end))

				local fireball = getItem("grappling_hook")
				if fireball then 
					task.spawn(function()
						repeat task.wait() until bedwars.CooldownController:getRemainingCooldown("grappling_hook") == 0 or (not GrappleExploit.Enabled)
						if (not GrappleExploit.Enabled) then return end
						switchItem(fireball.tool)
						local pos = entityLibrary.character.HumanoidRootPart.CFrame.p
						local offsetshootpos = (CFrame.new(pos, pos + Vector3.new(0, -60, 0)) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).p
						projectileRemote:CallServerAsync(fireball["tool"], nil, "grappling_hook_projectile", offsetshootpos, pos, Vector3.new(0, -60, 0), game:GetService("HttpService"):GenerateGUID(true), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
					end)
				else
					warningNotification("GrappleExploit", "missing grapple hook", 3)
					GrappleExploit.ToggleButton(false)
					return
				end

				local startCFrame = entityLibrary.isAlive and entityLibrary.character.HumanoidRootPart.CFrame
				RunLoops:BindToHeartbeat("GrappleExploit", function(delta) 
					if GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled then 
						if bedwars.matchState == 0 then return end
					end
					if entityLibrary.isAlive then
						entityLibrary.character.HumanoidRootPart.Velocity = Vector3.zero
						entityLibrary.character.HumanoidRootPart.CFrame = startCFrame
					end
				end)
			else
				GrappleExploitUp = false
				GrappleExploitDown = false
				RunLoops:UnbindFromHeartbeat("GrappleExploit")
			end
		end,
		HoverText = "Makes you go zoom (longer GrappleExploit discovered by exelys and Cqded)",
		ExtraText = function() 
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"]["Api"].Enabled then 
				return alternatelist[table.find(GrappleExploitMode["List"], GrappleExploitMode.Value)]
			end
			return GrappleExploitMode.Value 
		end
	})
end)

runFunction(function()
	local InfiniteFly = {Enabled = false}
	local InfiniteFlyMode = {Value = "CFrame"}
	local InfiniteFlySpeed = {Value = 23}
	local InfiniteFlyVerticalSpeed = {Value = 40}
	local InfiniteFlyVertical = {Enabled = true}
	local InfiniteFlyUp = false
	local InfiniteFlyDown = false
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	local clonesuccess = false
	local disabledproper = true
	local oldcloneroot
	local cloned
	local clone
	local bodyvelo
	local FlyOverlap = OverlapParams.new()
	FlyOverlap.MaxParts = 9e9
	FlyOverlap.FilterDescendantsInstances = {}
	FlyOverlap.RespectCanCollide = true

	local function disablefunc()
		if bodyvelo then bodyvelo:Destroy() end
		RunLoops:UnbindFromHeartbeat("InfiniteFlyOff")
		disabledproper = true
		if not oldcloneroot or not oldcloneroot.Parent then return end
		lplr.Character.Parent = game
		oldcloneroot.Parent = lplr.Character
		lplr.Character.PrimaryPart = oldcloneroot
		lplr.Character.Parent = workspace
		oldcloneroot.CanCollide = true
		for i,v in pairs(lplr.Character:GetDescendants()) do 
			if v:IsA("Weld") or v:IsA("Motor6D") then 
				if v.Part0 == clone then v.Part0 = oldcloneroot end
				if v.Part1 == clone then v.Part1 = oldcloneroot end
			end
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		for i,v in pairs(oldcloneroot:GetChildren()) do 
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		local oldclonepos = clone.Position.Y
		if clone then 
			clone:Destroy()
			clone = nil
		end
		lplr.Character.Humanoid.HipHeight = hip or 2
		local origcf = {oldcloneroot.CFrame:GetComponents()}
		origcf[2] = oldclonepos
		oldcloneroot.CFrame = CFrame.new(unpack(origcf))
		oldcloneroot = nil
	end

	InfiniteFly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "InfiniteFly",
		Function = function(callback)
			if callback then
				if not entityLibrary.isAlive then 
					disabledproper = true
				end
				if not disabledproper then 
					warningNotification("InfiniteFly", "Wait for the last fly to finish", 3)
					InfiniteFly.ToggleButton(false)
					return 
				end
				table.insert(InfiniteFly.Connections, inputService.InputBegan:Connect(function(input1)
					if InfiniteFlyVertical.Enabled and inputService:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
							InfiniteFlyUp = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
							InfiniteFlyDown = true
						end
					end
				end))
				table.insert(InfiniteFly.Connections, inputService.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
						InfiniteFlyUp = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
						InfiniteFlyDown = false
					end
				end))
				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						table.insert(InfiniteFly.Connections, jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
							InfiniteFlyUp = jumpButton.ImageRectOffset.X == 146
						end))
						InfiniteFlyUp = jumpButton.ImageRectOffset.X == 146
					end)
				end
				clonesuccess = false
				if entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and isnetworkowner(entityLibrary.character.HumanoidRootPart) then
					cloned = lplr.Character
					oldcloneroot = entityLibrary.character.HumanoidRootPart
					if not lplr.Character.Parent then 
						InfiniteFly.ToggleButton(false)
						return
					end
					lplr.Character.Parent = game
					clone = oldcloneroot:Clone()
					clone.Parent = lplr.Character
					oldcloneroot.Parent = gameCamera
					bedwars.QueryUtil:setQueryIgnored(oldcloneroot, true)
					clone.CFrame = oldcloneroot.CFrame
					lplr.Character.PrimaryPart = clone
					lplr.Character.Parent = workspace
					for i,v in pairs(lplr.Character:GetDescendants()) do 
						if v:IsA("Weld") or v:IsA("Motor6D") then 
							if v.Part0 == oldcloneroot then v.Part0 = clone end
							if v.Part1 == oldcloneroot then v.Part1 = clone end
						end
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					for i,v in pairs(oldcloneroot:GetChildren()) do 
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					if hip then 
						lplr.Character.Humanoid.HipHeight = hip
					end
					hip = lplr.Character.Humanoid.HipHeight
					clonesuccess = true
				end
				if not clonesuccess then 
					warningNotification("InfiniteFly", "Character missing", 3)
					InfiniteFly.ToggleButton(false)
					return 
				end
				local goneup = false
				RunLoops:BindToHeartbeat("InfiniteFly", function(delta) 
					if GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled then 
						if bedwarsStore.matchState == 0 then return end
					end
					if entityLibrary.isAlive then
						if isnetworkowner(oldcloneroot) then 
							local playerMass = (entityLibrary.character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
							
							local flyVelocity = entityLibrary.character.Humanoid.MoveDirection * (InfiniteFlyMode.Value == "Normal" and InfiniteFlySpeed.Value or 20)
							entityLibrary.character.HumanoidRootPart.Velocity = flyVelocity + (Vector3.new(0, playerMass + (InfiniteFlyUp and InfiniteFlyVerticalSpeed.Value or 0) + (InfiniteFlyDown and -InfiniteFlyVerticalSpeed.Value or 0), 0))
							if InfiniteFlyMode.Value ~= "Normal" then
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + (entityLibrary.character.Humanoid.MoveDirection * ((InfiniteFlySpeed.Value + getSpeed()) - 20)) * delta
							end

							local speedCFrame = {oldcloneroot.CFrame:GetComponents()}
							speedCFrame[1] = clone.CFrame.X
							if speedCFrame[2] < 1000 or (not goneup) then 
								task.spawn(warningNotification, "InfiniteFly", "Teleported Up", 3)
								speedCFrame[2] = 100000
								goneup = true
							end
							speedCFrame[3] = clone.CFrame.Z
							oldcloneroot.CFrame = CFrame.new(unpack(speedCFrame))
							oldcloneroot.Velocity = Vector3.new(clone.Velocity.X, oldcloneroot.Velocity.Y, clone.Velocity.Z)
						else
							InfiniteFly.ToggleButton(false)
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("InfiniteFly")
				if clonesuccess and oldcloneroot and clone and lplr.Character.Parent == workspace and oldcloneroot.Parent ~= nil and disabledproper and cloned == lplr.Character then 
					local rayparams = RaycastParams.new()
					rayparams.FilterDescendantsInstances = {lplr.Character, gameCamera}
					rayparams.RespectCanCollide = true
					local ray = workspace:Raycast(Vector3.new(oldcloneroot.Position.X, clone.CFrame.p.Y, oldcloneroot.Position.Z), Vector3.new(0, -1000, 0), rayparams)
					local origcf = {clone.CFrame:GetComponents()}
					origcf[1] = oldcloneroot.Position.X
					origcf[2] = ray and ray.Position.Y + (entityLibrary.character.Humanoid.HipHeight + (oldcloneroot.Size.Y / 2)) or clone.CFrame.p.Y
					origcf[3] = oldcloneroot.Position.Z
					oldcloneroot.CanCollide = true
					bodyvelo = Instance.new("BodyVelocity")
					bodyvelo.MaxForce = Vector3.new(0, 9e9, 0)
					bodyvelo.Velocity = Vector3.new(0, -1, 0)
					bodyvelo.Parent = oldcloneroot
					oldcloneroot.Velocity = Vector3.new(clone.Velocity.X, -1, clone.Velocity.Z)
					RunLoops:BindToHeartbeat("InfiniteFlyOff", function(dt)
						if oldcloneroot then 
							oldcloneroot.Velocity = Vector3.new(clone.Velocity.X, -1, clone.Velocity.Z)
							local bruh = {clone.CFrame:GetComponents()}
							bruh[2] = oldcloneroot.CFrame.Y
							local newcf = CFrame.new(unpack(bruh))
							FlyOverlap.FilterDescendantsInstances = {lplr.Character, gameCamera}
							local allowed = true
							for i,v in pairs(workspace:GetPartBoundsInRadius(newcf.p, 2, FlyOverlap)) do 
								if (v.Position.Y + (v.Size.Y / 2)) > (newcf.p.Y + 0.5) then 
									allowed = false
									break
								end
							end
							if allowed then
								oldcloneroot.CFrame = newcf
							end
						end
					end)
					oldcloneroot.CFrame = CFrame.new(unpack(origcf))
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
					disabledproper = false
					if isnetworkowner(oldcloneroot) then 
						warningNotification("InfiniteFly", "Waiting 1.5s to not flag", 3)
						task.delay(1.5, disablefunc)
					else
						disablefunc()
					end
				end
				InfiniteFlyUp = false
				InfiniteFlyDown = false
			end
		end,
		HoverText = "Makes you go zoom",
		ExtraText = function()
			return "Nebulaware"
		end
	})
	InfiniteFlySpeed = InfiniteFly.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end, 
		Default = 23
	})
	InfiniteFlyVerticalSpeed = InfiniteFly.CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 100,
		Function = function(val) end, 
		Default = 44
	})
	InfiniteFlyVertical = InfiniteFly.CreateToggle({
		Name = "Y Level",
		Function = function() end, 
		Default = true
	})
end)

local killauraNearPlayer
runFunction(function()
	local killauraboxes = {}
    local killauratargetframe = {Players = {Enabled = false}}
	local killaurasortmethod = {Value = "Distance"}
    local killaurarealremote = bedwars.ClientHandler:Get(bedwars.AttackRemote).instance
	local killauraparticlecolor = {Hue = 0, Sat = 0, Value = 0}
    local killauramethod = {Value = "Normal"}
	local killauraothermethod = {Value = "Normal"}
    local killauraanimmethod = {Value = "Normal"}
    local killaurarange = {Value = 14}
    local killauraangle = {Value = 360}
    local killauratargets = {Value = 10}
	local killauraautoblock = {Enabled = false}
    local killauramouse = {Enabled = false}
    local killauracframe = {Enabled = false}
    local killauragui = {Enabled = false}
    local killauratarget = {Enabled = false}
    local killaurasound = {Enabled = false}
    local killauraswing = {Enabled = false}
	local killaurasync = {Enabled = false}
    local killaurahandcheck = {Enabled = false}
    local killauraanimation = {Enabled = false}
	local killauraanimationtween = {Enabled = false}
	local killauracolor = {Value = 0.44}
	local killauranovape = {Enabled = false}
	local killauranoNebulaware = {Enabled = false}
	local killauratargethighlight = {Enabled = false}
	local killaurarangecircle = {Enabled = false}
	local killaurarangecirclepart
	local killauraaimcircle = {Enabled = false}
	local killauraaimcirclepart
	local killauraparticle = {Enabled = false}
	local killauraparticlepart
    local Killauranear = false
    local killauraplaying = false
    local oldViewmodelAnimation = function() end
    local oldPlaySound = function() end
    local originalArmC0 = nil
	local killauracurrentanim
	local animationdelay = tick()

	local function getStrength(plr)
		local inv = bedwarsStore.inventories[plr.Player]
		local strength = 0
		local strongestsword = 0
		if inv then
			for i,v in pairs(inv.items) do 
				local itemmeta = bedwars.ItemTable[v.itemType]
				if itemmeta and itemmeta.sword and itemmeta.sword.damage > strongestsword then 
					strongestsword = itemmeta.sword.damage / 100
				end	
			end
			strength = strength + strongestsword
			for i,v in pairs(inv.armor) do 
				local itemmeta = bedwars.ItemTable[v.itemType]
				if itemmeta and itemmeta.armor then 
					strength = strength + (itemmeta.armor.damageReductionMultiplier or 0)
				end
			end
			strength = strength
		end
		return strength
	end

	local kitpriolist = {
		hannah = 5,
		spirit_assassin = 4,
		dasher = 3,
		jade = 2,
		regent = 1
	}

	local killaurasortmethods = {
		Distance = function(a, b)
			return (a.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position).Magnitude < (b.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position).Magnitude
		end,
		Health = function(a, b) 
			return a.Humanoid.Health < b.Humanoid.Health
		end,
		Threat = function(a, b) 
			return getStrength(a) > getStrength(b)
		end,
		Kit = function(a, b)
			return (kitpriolist[a.Player:GetAttribute("PlayingAsKit")] or 0) > (kitpriolist[b.Player:GetAttribute("PlayingAsKit")] or 0)
		end
	}

	local originalNeckC0
	local originalRootC0
	local smoothanims = {
		Exhibition = 0.25,
		["Exhibition Old"] = 0.25,
		Smooth = 0.25,
		Shake = 0.25,
		PopV3 = 0.25,
        Remake = 0.19
	}
	local anims = {
		Normal = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.05},
			{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.05}
		},
		Slow = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.15},
			{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.15}
		},
		New = {
			{CFrame = CFrame.new(0.69, -0.77, 1.47) * CFrame.Angles(math.rad(-33), math.rad(57), math.rad(-81)), Time = 0.12},
			{CFrame = CFrame.new(0.74, -0.92, 0.88) * CFrame.Angles(math.rad(147), math.rad(71), math.rad(53)), Time = 0.12}
		},
		Latest = {
			{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-51)), Time = 0.1},
			{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-179), math.rad(54), math.rad(33)), Time = 0.1}
		},
		["Vertical Spin"] = {
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(180), math.rad(3), math.rad(13)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(-5), math.rad(8)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(-0), math.rad(-0)), Time = 0.1}
		},
		Exhibition = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
		},
		["Exhibition Old"] = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
			{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
		},
		Funny = {
			{CFrame = CFrame.new(0, 0, 1.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),Time = 0.15},
			{CFrame = CFrame.new(0, 0, -1.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),Time = 0.15},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.15},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-55), math.rad(0), math.rad(0)), Time = 0.15}
		},
		FunnyFuture = {
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-60), math.rad(0), math.rad(0)),Time = 0.25},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),Time = 0.25}
		},
		Goofy = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.25},
			{CFrame = CFrame.new(-1, -1, 1) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),Time = 0.25},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(-33)),Time = 0.25}
		},
		Future = {
			{CFrame = CFrame.new(0.69, -0.7, 0.10) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.20},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),Time = 0.25}
		},
		Pop = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),Time = 0.25},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-30), math.rad(80), math.rad(-90)), Time = 0.35},
			{CFrame = CFrame.new(0, 1, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.35}
		},
		FunnyV2 = {
			{CFrame = CFrame.new(0.10, -0.5, -1) * CFrame.Angles(math.rad(295), math.rad(80), math.rad(300)), Time = 0.45},
			{CFrame = CFrame.new(-5, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.45},
			{CFrame = CFrame.new(5, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.45},
		},
		Smooth = {
			{CFrame = CFrame.new(-0.42, 0, 0.30) * CFrame.Angles(math.rad(0), math.rad(80), math.rad(60)), Time = 0.25},
			{CFrame = CFrame.new(-0.42, 0, 0.30) * CFrame.Angles(math.rad(0), math.rad(100), math.rad(60)), Time = 0.25},
			{CFrame = CFrame.new(-0.42, 0, 0.30) * CFrame.Angles(math.rad(0), math.rad(60), math.rad(60)), Time = 0.25},
		},
		FasterSmooth = {
			{CFrame = CFrame.new(-0.42, 0, 0.30) * CFrame.Angles(math.rad(0), math.rad(80), math.rad(60)), Time = 0.11},
			{CFrame = CFrame.new(-0.42, 0, 0.30) * CFrame.Angles(math.rad(0), math.rad(100), math.rad(60)), Time = 0.11},
			{CFrame = CFrame.new(-0.42, 0, 0.30) * CFrame.Angles(math.rad(0), math.rad(60), math.rad(60)), Time = 0.11},
		},
		PopV2 = {
			{CFrame = CFrame.new(0.10, -0.3, -0.30) * CFrame.Angles(math.rad(295), math.rad(80), math.rad(290)), Time = 0.09},
			{CFrame = CFrame.new(0.10, 0.10, -1) * CFrame.Angles(math.rad(295), math.rad(80), math.rad(300)), Time = 0.1},
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
		},
		Bob = {
			{CFrame = CFrame.new(-0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2},
			{CFrame = CFrame.new(-0.7, -2.5, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
		},
		Knife = {
			{CFrame = CFrame.new(-0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2},
			{CFrame = CFrame.new(1, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2},
			{CFrame = CFrame.new(4, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2},
		},
		FunnyExhibition = {
			{CFrame = CFrame.new(-1.5, -0.50, 0.20) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.10},
			{CFrame = CFrame.new(-0.55, -0.20, 1.5) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2},
		},
		Remake = {
			{CFrame = CFrame.new(-0.10, -0.45, -0.20) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-50)), Time = 0.01},
			{CFrame = CFrame.new(0.7, -0.71, -1) * CFrame.Angles(math.rad(-90), math.rad(50), math.rad(-38)), Time = 0.2},
			{CFrame = CFrame.new(0.63, -0.1, 1.50) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
		},
		PopV3 = {
			{CFrame = CFrame.new(0.69, -0.10, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
			{CFrame = CFrame.new(0.69, -2, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
		},
		Shake = {
			{CFrame = CFrame.new(0.69, -0.8, 0.6) * CFrame.Angles(math.rad(-60), math.rad(30), math.rad(-35)), Time = 0.05},
			{CFrame = CFrame.new(0.8, -0.71, 0.30) * CFrame.Angles(math.rad(-60), math.rad(39), math.rad(-55)), Time = 0.02},
			{CFrame = CFrame.new(0.8, -2, 0.45) * CFrame.Angles(math.rad(-60), math.rad(30), math.rad(-55)), Time = 0.03}
		},
		SlowerShake = {
			{CFrame = CFrame.new(0.69, -5, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
		},
		Idk = {
			{CFrame = CFrame.new(0, -0.1, -0.30) * CFrame.Angles(math.rad(-20), math.rad(20), math.rad(0)), Time = 0.30},
			{CFrame = CFrame.new(0, -0.50, -0.30) * CFrame.Angles(math.rad(-40), math.rad(41), math.rad(0)), Time = 0.32},
			{CFrame = CFrame.new(0, -0.1, -0.30) * CFrame.Angles(math.rad(-60), math.rad(0), math.rad(0)), Time = 0.32}
		}
	}


	local function closestpos(block, pos)
		local blockpos = block:GetRenderCFrame()
		local startpos = (blockpos * CFrame.new(-(block.Size / 2))).p
		local endpos = (blockpos * CFrame.new((block.Size / 2))).p
		local speedCFrame = block.Position + (pos - block.Position)
		local x = startpos.X > endpos.X and endpos.X or startpos.X
		local y = startpos.Y > endpos.Y and endpos.Y or startpos.Y
		local z = startpos.Z > endpos.Z and endpos.Z or startpos.Z
		local x2 = startpos.X < endpos.X and endpos.X or startpos.X
		local y2 = startpos.Y < endpos.Y and endpos.Y or startpos.Y
		local z2 = startpos.Z < endpos.Z and endpos.Z or startpos.Z
		return Vector3.new(math.clamp(speedCFrame.X, x, x2), math.clamp(speedCFrame.Y, y, y2), math.clamp(speedCFrame.Z, z, z2))
	end

	local function getAttackData()
		if GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled then 
			if bedwarsStore.matchState == 0 then return false end
		end
		if killauramouse.Enabled then
			if not inputService:IsMouseButtonPressed(0) then return false end
		end
		if killauragui.Enabled then
			if getOpenApps() > (bedwarsStore.equippedKit == "hannah" and 4 or 3) then return false end
		end
		local sword = killaurahandcheck.Enabled and bedwarsStore.localHand or getSword()
		if not sword or not sword.tool then return false end
		local swordmeta = bedwars.ItemTable[sword.tool.Name]
		if killaurahandcheck.Enabled then
			if bedwarsStore.localHand.Type ~= "sword" or bedwars.KatanaController.chargingMaid then return false end
		end
		return sword, swordmeta
	end

	local function autoBlockLoop()
		if not killauraautoblock.Enabled or not Killaura.Enabled then return end
		repeat
			if bedwarsStore.blockPlace < tick() and entityLibrary.isAlive then
				local shield = getItem("infernal_shield")
				if shield then 
					switchItem(shield.tool)
					if not lplr.Character:GetAttribute("InfernalShieldRaised") then
						bedwars.InfernalShieldController:raiseShield()
					end
				end
			end
			task.wait()
		until (not Killaura.Enabled) or (not killauraautoblock.Enabled)
	end

    Killaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        Name = "Killaura",
        Function = function(callback)
            if callback then
				if killauraaimcirclepart then killauraaimcirclepart.Parent = gameCamera end
				if killaurarangecirclepart then killaurarangecirclepart.Parent = gameCamera end
				if killauraparticlepart then killauraparticlepart.Parent = gameCamera end
				task.spawn(function()
					local oldNearPlayer
					repeat
						task.wait()
						if (killauraanimation.Enabled) then
							if killauraNearPlayer then
								pcall(function()
									if originalArmC0 == nil then
										originalArmC0 = gameCamera.Viewmodel.RightHand.RightWrist.C0
									end
									if killauraplaying == false then
										killauraplaying = true
										for i,v in pairs(anims[killauraanimmethod.Value]) do 
											if (not Killaura.Enabled) or (not killauraNearPlayer) then break end
											if not oldNearPlayer and killauraanimationtween.Enabled then
												gameCamera.Viewmodel.RightHand.RightWrist.C0 = originalArmC0 * v.CFrame
												continue
											end
											killauracurrentanim = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(v.Time), {C0 = originalArmC0 * v.CFrame})
											killauracurrentanim:Play()
											task.wait(v.Time - 0.01)
										end
										killauraplaying = false
									end
								end)	
							end
							oldNearPlayer = killauraNearPlayer
						end
					until Killaura.Enabled == false
				end)

                oldViewmodelAnimation = bedwars.ViewmodelController.playAnimation
                oldPlaySound = bedwars.SoundManager.playSound
                bedwars.SoundManager.playSound = function(tab, soundid, ...)
                    if (soundid == bedwars.SoundList.SWORD_SWING_1 or soundid == bedwars.SoundList.SWORD_SWING_2) and Killaura.Enabled and killaurasound.Enabled and killauraNearPlayer then
                        return nil
                    end
                    return oldPlaySound(tab, soundid, ...)
                end
                bedwars.ViewmodelController.playAnimation = function(Self, id, ...)
                    if id == 15 and killauraNearPlayer and killauraswing.Enabled and entityLibrary.isAlive then
                        return nil
                    end
                    if id == 15 and killauraNearPlayer and killauraanimation.Enabled and entityLibrary.isAlive then
                        return nil
                    end
                    return oldViewmodelAnimation(Self, id, ...)
                end

				local targetedPlayer
				RunLoops:BindToHeartbeat("Killaura", function()
					for i,v in pairs(killauraboxes) do 
						if v:IsA("BoxHandleAdornment") and v.Adornee then
							local cf = v.Adornee and v.Adornee.CFrame
							local onex, oney, onez = cf:ToEulerAnglesXYZ() 
							v.CFrame = CFrame.new() * CFrame.Angles(-onex, -oney, -onez)
						end
					end
					if entityLibrary.isAlive then
						if killauraaimcirclepart then 
							killauraaimcirclepart.Position = targetedPlayer and closestpos(targetedPlayer.RootPart, entityLibrary.character.HumanoidRootPart.Position) or Vector3.new(99999, 99999, 99999)
						end
						if killauraparticlepart then 
							killauraparticlepart.Position = targetedPlayer and targetedPlayer.RootPart.Position or Vector3.new(99999, 99999, 99999)
						end
						local Root = entityLibrary.character.HumanoidRootPart
						if Root then
							if killaurarangecirclepart then 
								killaurarangecirclepart.Position = Root.Position - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0)
							end
							local Neck = entityLibrary.character.Head:FindFirstChild("Neck")
							local LowerTorso = Root.Parent and Root.Parent:FindFirstChild("LowerTorso")
							local RootC0 = LowerTorso and LowerTorso:FindFirstChild("Root")
							if Neck and RootC0 then
								if originalNeckC0 == nil then
									originalNeckC0 = Neck.C0.p
								end
								if originalRootC0 == nil then
									originalRootC0 = RootC0.C0.p
								end
								if originalRootC0 and killauracframe.Enabled then
									if targetedPlayer ~= nil then
										local targetPos = targetedPlayer.RootPart.Position + Vector3.new(0, 2, 0)
										local direction = (Vector3.new(targetPos.X, targetPos.Y, targetPos.Z) - entityLibrary.character.Head.Position).Unit
										local direction2 = (Vector3.new(targetPos.X, Root.Position.Y, targetPos.Z) - Root.Position).Unit
										local lookCFrame = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace(direction)))
										local lookCFrame2 = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace(direction2)))
										Neck.C0 = CFrame.new(originalNeckC0) * CFrame.Angles(lookCFrame.LookVector.Unit.y, 0, 0)
										RootC0.C0 = lookCFrame2 + originalRootC0
									else
										Neck.C0 = CFrame.new(originalNeckC0)
										RootC0.C0 = CFrame.new(originalRootC0)
									end
								end
							end
						end
					end
				end)
				if killauraautoblock.Enabled then 
					task.spawn(autoBlockLoop)
				end
                task.spawn(function()
					repeat
						task.wait()
						if not Killaura.Enabled then break end
						vapeTargetInfo.Targets.Killaura = nil
						local plrs = AllNearPosition(killaurarange.Value, 10, killaurasortmethods[killaurasortmethod.Value], true)
						local firstPlayerNear
						if #plrs > 0 then
							local sword, swordmeta = getAttackData()
							if sword then
								switchItem(sword.tool)
								for i, plr in pairs(plrs) do
									local root = plr.RootPart
									if not root then 
										continue
									end
									local localfacing = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
									local vec = (plr.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position).unit
									local angle = math.acos(localfacing:Dot(vec))
									if angle >= (math.rad(killauraangle.Value) / 2) then
										continue
									end
									local selfrootpos = entityLibrary.character.HumanoidRootPart.Position
									if killauratargetframe.Walls.Enabled then
										if not bedwars.SwordController:canSee({player = plr.Player, getInstance = function() return plr.Character end}) then continue end
									end
									if not ({NebulawareFunctions:GetPlayerType(plr.Player)})[2] then continue end
									if not ({WhitelistFunctions:GetWhitelist(plr.Player)})[2] then
										continue
									end
									if killauranovape.Enabled and bedwarsStore.whitelist.clientUsers[plr.Player.Name] then
										continue
									end
									if killauranoNebulaware.Enabled and table.find(shared.NebulawareStore.ConfigUsers, plr.Player) then
										continue
									end
									if not firstPlayerNear then 
										firstPlayerNear = true 
										killauraNearPlayer = true
										targetedPlayer = plr
										vapeTargetInfo.Targets.Killaura = {
											Humanoid = {
												Health = (plr.Character:GetAttribute("Health") or plr.Humanoid.Health) + getShieldAttribute(plr.Character),
												MaxHealth = plr.Character:GetAttribute("MaxHealth") or plr.Humanoid.MaxHealth
											},
											Player = plr.Player
										}
										if not killaurasync.Enabled then 
											if animationdelay <= tick() then
												animationdelay = tick() + 0.19
												if not killauraswing.Enabled then 
													bedwars.SwordController:playSwordEffect(swordmeta)
												end
											end
										end
									end
									if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) < 0.02 then 
										break
									end
									local selfpos = selfrootpos + (killaurarange.Value > 14 and (selfrootpos - root.Position).magnitude > 14.4 and (CFrame.lookAt(selfrootpos, root.Position).lookVector * ((selfrootpos - root.Position).magnitude - 14)) or Vector3.zero)
									if killaurasync.Enabled then 
										if animationdelay <= tick() then
											animationdelay = tick() + 0.19
											if not killauraswing.Enabled then 
												bedwars.SwordController:playSwordEffect(swordmeta)
											end
										end
									end
									bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
									bedwarsStore.attackReach = math.floor((selfrootpos - root.Position).magnitude * 100) / 100
									bedwarsStore.attackReachUpdate = tick() + 1
									killaurarealremote:FireServer({
										weapon = sword.tool,
										chargedAttack = {chargeRatio = swordmeta.sword.chargedAttack and not swordmeta.sword.chargedAttack.disableOnGrounded and 1 or 0},
										entityInstance = plr.Character,
										validate = {
											raycast = {
												cameraPosition = attackValue(root.Position), 
												cursorDirection = attackValue(CFrame.new(selfpos, root.Position).lookVector)
											},
											targetPosition = attackValue(root.Position),
											selfPosition = attackValue(selfpos)
										}
									})
									break
								end
							end
						end
						if not firstPlayerNear then 
							targetedPlayer = nil
							killauraNearPlayer = false
							pcall(function()
								if originalArmC0 == nil then
									originalArmC0 = gameCamera.Viewmodel.RightHand.RightWrist.C0
								end
								if gameCamera.Viewmodel.RightHand.RightWrist.C0 ~= originalArmC0 then
									pcall(function()
										killauracurrentanim:Cancel()
									end)
									if killauraanimationtween.Enabled then 
										gameCamera.Viewmodel.RightHand.RightWrist.C0 = originalArmC0
									else
										killauracurrentanim = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(smoothanims[killauraanimmethod.Value] or 0.1), {C0 = originalArmC0})
										killauracurrentanim:Play()
									end
								end
							end)
						end
						for i,v in pairs(killauraboxes) do 
							local attacked = killauratarget.Enabled and plrs[i] or nil
							v.Adornee = attacked and ((not killauratargethighlight.Enabled) and attacked.RootPart or (not GuiLibrary.ObjectsThatCanBeSaved.ChamsOptionsButton.Api.Enabled) and attacked.Character or nil)
						end
					until (not Killaura.Enabled)
				end)
            else
				vapeTargetInfo.Targets.Killaura = nil
				RunLoops:UnbindFromHeartbeat("Killaura") 
                killauraNearPlayer = false
				for i,v in pairs(killauraboxes) do v.Adornee = nil end
				if killauraaimcirclepart then killauraaimcirclepart.Parent = nil end
				if killaurarangecirclepart then killaurarangecirclepart.Parent = nil end
				if killauraparticlepart then killauraparticlepart.Parent = nil end
                bedwars.ViewmodelController.playAnimation = oldViewmodelAnimation
                bedwars.SoundManager.playSound = oldPlaySound
                oldViewmodelAnimation = nil
                pcall(function()
					if entityLibrary.isAlive then
						local Root = entityLibrary.character.HumanoidRootPart
						if Root then
							local Neck = Root.Parent.Head.Neck
							if originalNeckC0 and originalRootC0 then 
								Neck.C0 = CFrame.new(originalNeckC0)
								Root.Parent.LowerTorso.Root.C0 = CFrame.new(originalRootC0)
							end
						end
					end
                    if originalArmC0 == nil then
                        originalArmC0 = gameCamera.Viewmodel.RightHand.RightWrist.C0
                    end
                    if gameCamera.Viewmodel.RightHand.RightWrist.C0 ~= originalArmC0 then
						pcall(function()
							killauracurrentanim:Cancel()
						end)
						if killauraanimationtween.Enabled then 
							gameCamera.Viewmodel.RightHand.RightWrist.C0 = originalArmC0
						else
							killauracurrentanim = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = originalArmC0})
							killauracurrentanim:Play()
						end
                    end
                end)
            end
        end,
        HoverText = "Attack players around you\nwithout aiming at them."
    })
    killauratargetframe = Killaura.CreateTargetWindow({})
	local sortmethods = {"Distance"}
	for i,v in pairs(killaurasortmethods) do if i ~= "Distance" then table.insert(sortmethods, i) end end
	killaurasortmethod = Killaura.CreateDropdown({
		Name = "Sort",
		Function = function() end,
		List = sortmethods
	})
    killaurarange = Killaura.CreateSlider({
        Name = "Attack range",
        Min = 1,
        Max = 18,
        Function = function(val) 
			if killaurarangecirclepart then 
				killaurarangecirclepart.Size = Vector3.new(val * 0.7, 0.01, val * 0.7)
			end
		end, 
        Default = 18
    })
    killauraangle = Killaura.CreateSlider({
        Name = "Max angle",
        Min = 1,
        Max = 360,
        Function = function(val) end,
        Default = 360
    })
	local animmethods = {}
	for i,v in pairs(anims) do table.insert(animmethods, i) end
    killauraanimmethod = Killaura.CreateDropdown({
        Name = "Animation", 
        List = animmethods,
        Function = function(val) end
    })
	local oldviewmodel
	local oldraise
	local oldeffect
	killauraautoblock = Killaura.CreateToggle({
		Name = "AutoBlock",
		Function = function(callback)
			if callback then 
				oldviewmodel = bedwars.ViewmodelController.setHeldItem
				bedwars.ViewmodelController.setHeldItem = function(self, newItem, ...)
					if newItem and newItem.Name == "infernal_shield" then 
						return
					end
					return oldviewmodel(self, newItem)
				end
				oldraise = bedwars.InfernalShieldController.raiseShield
				bedwars.InfernalShieldController.raiseShield = function(self)
					if os.clock() - self.lastShieldRaised < 0.4 then
						return
					end
					self.lastShieldRaised = os.clock()
					self.infernalShieldState:SendToServer({raised = true})
					self.raisedMaid:GiveTask(function()
						self.infernalShieldState:SendToServer({raised = false})
					end)
				end
				oldeffect = bedwars.InfernalShieldController.playEffect
				bedwars.InfernalShieldController.playEffect = function()
					return
				end
				if bedwars.ViewmodelController.heldItem and bedwars.ViewmodelController.heldItem.Name == "infernal_shield" then 
					local sword, swordmeta = getSword()
					if sword then 
						bedwars.ViewmodelController:setHeldItem(sword.tool)
					end
				end
				task.spawn(autoBlockLoop)
			else
				bedwars.ViewmodelController.setHeldItem = oldviewmodel
				bedwars.InfernalShieldController.raiseShield = oldraise
				bedwars.InfernalShieldController.playEffect = oldeffect
			end
		end,
		Default = true
	})
    killauramouse = Killaura.CreateToggle({
        Name = "Require mouse down",
        Function = function() end,
		HoverText = "Only attacks when left click is held.",
        Default = false
    })
    killauragui = Killaura.CreateToggle({
        Name = "GUI Check",
        Function = function() end,
		HoverText = "Attacks when you are not in a GUI."
    })
    killauratarget = Killaura.CreateToggle({
        Name = "Show target",
        Function = function(callback) 
			if killauratargethighlight.Object then 
				killauratargethighlight.Object.Visible = callback
			end
		end,
		HoverText = "Shows a red box over the opponent."
    })
	killauratargethighlight = Killaura.CreateToggle({
		Name = "Use New Highlight",
		Function = function(callback) 
			for i,v in pairs(killauraboxes) do 
				v:Remove()
			end
			for i = 1, 10 do 
				local killaurabox
				if callback then 
					killaurabox = Instance.new("Highlight")
					killaurabox.FillTransparency = 0.39
					killaurabox.FillColor = Color3.fromHSV(killauracolor.Hue, killauracolor.Sat, killauracolor.Value)
					killaurabox.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					killaurabox.OutlineTransparency = 1
					killaurabox.Parent = GuiLibrary.MainGui
				else
					killaurabox = Instance.new("BoxHandleAdornment")
					killaurabox.Transparency = 0.39
					killaurabox.Color3 = Color3.fromHSV(killauracolor.Hue, killauracolor.Sat, killauracolor.Value)
					killaurabox.Adornee = nil
					killaurabox.AlwaysOnTop = true
					killaurabox.Size = Vector3.new(3, 6, 3)
					killaurabox.ZIndex = 11
					killaurabox.Parent = GuiLibrary.MainGui
				end
				killauraboxes[i] = killaurabox
			end
		end
	})
	killauratargethighlight.Object.BorderSizePixel = 0
	killauratargethighlight.Object.BackgroundTransparency = 0
	killauratargethighlight.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	killauratargethighlight.Object.Visible = false
	killauracolor = Killaura.CreateColorSlider({
		Name = "Target Color",
		Function = function(hue, sat, val) 
			for i,v in pairs(killauraboxes) do 
				v[(killauratargethighlight.Enabled and "FillColor" or "Color3")] = Color3.fromHSV(hue, sat, val)
			end
			if killauraaimcirclepart then 
				killauraaimcirclepart.Color = Color3.fromHSV(hue, sat, val)
			end
			if killaurarangecirclepart then 
				killaurarangecirclepart.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		Default = 1
	})
	for i = 1, 10 do 
		local killaurabox = Instance.new("BoxHandleAdornment")
		killaurabox.Transparency = 0.5
		killaurabox.Color3 = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
		killaurabox.Adornee = nil
		killaurabox.AlwaysOnTop = true
		killaurabox.Size = Vector3.new(3, 6, 3)
		killaurabox.ZIndex = 11
		killaurabox.Parent = GuiLibrary.MainGui
		killauraboxes[i] = killaurabox
	end
    killauracframe = Killaura.CreateToggle({
        Name = "Face target",
        Function = function() end,
		HoverText = "Makes your character face the opponent."
    })
	killaurarangecircle = Killaura.CreateToggle({
		Name = "Range Visualizer",
		Function = function(callback)
			if callback then 
				killaurarangecirclepart = Instance.new("MeshPart")
				killaurarangecirclepart.MeshId = "rbxassetid://3726303797"
				killaurarangecirclepart.Color = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
				killaurarangecirclepart.CanCollide = false
				killaurarangecirclepart.Anchored = true
				killaurarangecirclepart.Material = Enum.Material.Neon
				killaurarangecirclepart.Size = Vector3.new(killaurarange.Value * 0.7, 0.01, killaurarange.Value * 0.7)
				if Killaura.Enabled then 
					killaurarangecirclepart.Parent = gameCamera
				end
				bedwars.QueryUtil:setQueryIgnored(killaurarangecirclepart, true)
			else
				if killaurarangecirclepart then 
					killaurarangecirclepart:Destroy()
					killaurarangecirclepart = nil
				end
			end
		end
	})
	killauraaimcircle = Killaura.CreateToggle({
		Name = "Aim Visualizer",
		Function = function(callback)
			if callback then 
				killauraaimcirclepart = Instance.new("Part")
				killauraaimcirclepart.Shape = Enum.PartType.Ball
				killauraaimcirclepart.Color = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
				killauraaimcirclepart.CanCollide = false
				killauraaimcirclepart.Anchored = true
				killauraaimcirclepart.Material = Enum.Material.Neon
				killauraaimcirclepart.Size = Vector3.new(0.5, 0.5, 0.5)
				if Killaura.Enabled then 
					killauraaimcirclepart.Parent = gameCamera
				end
				bedwars.QueryUtil:setQueryIgnored(killauraaimcirclepart, true)
			else
				if killauraaimcirclepart then 
					killauraaimcirclepart:Destroy()
					killauraaimcirclepart = nil
				end
			end
		end
	})
	killauraparticle = Killaura.CreateToggle({
		Name = "Crit Particle",
		Function = function(callback)
			if callback then 
				killauraparticlepart = Instance.new("Part")
				killauraparticlepart.Transparency = 1
				killauraparticlepart.CanCollide = false
				killauraparticlepart.Anchored = true
				killauraparticlepart.Size = Vector3.new(3, 6, 3)
				killauraparticlepart.Parent = cam
				bedwars.QueryUtil:setQueryIgnored(killauraparticlepart, true)
				local particle = Instance.new("ParticleEmitter")
				particle.Lifetime = NumberRange.new(0.5)
				particle.Rate = 500
				particle.Speed = NumberRange.new(0)
				particle.RotSpeed = NumberRange.new(180)
				particle.Enabled = true
				particle.Size = NumberSequence.new(0.3)
				particle.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(67, 10, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 98, 255))})
				particle.Parent = killauraparticlepart
			else
				if killauraparticlepart then 
					killauraparticlepart:Destroy()
					killauraparticlepart = nil
				end
			end
		end
	})
	killauraparticle.Object.Visible = killauraparticle.Enabled
	killauraparticlecolor = Killaura.CreateColorSlider({
		Name = "Crit Particle Color",
		Function = function() end
	})
    killaurasound = Killaura.CreateToggle({
        Name = "No Swing Sound",
        Function = function() end,
		HoverText = "Removes the swinging sound."
    })
    killauraswing = Killaura.CreateToggle({
        Name = "No Swing",
        Function = function() end,
		HoverText = "Removes the swinging animation."
    })
    killaurahandcheck = Killaura.CreateToggle({
        Name = "Limit to items",
        Function = function() end,
		HoverText = "Only attacks when your sword is held."
    })
    killauraanimation = Killaura.CreateToggle({
        Name = "Custom Animation",
        Function = function(callback)
			if killauraanimationtween.Object then killauraanimationtween.Object.Visible = callback end
		end,
		HoverText = "Uses a custom animation for swinging"
    })
	killauraanimationtween = Killaura.CreateToggle({
		Name = "No Tween",
		Function = function() end,
		HoverText = "Disable's the in and out ease"
	})
	killauraanimationtween.Object.Visible = false
	killaurasync = Killaura.CreateToggle({
        Name = "Synced Animation",
        Function = function() end,
		HoverText = "Times animation with hit attempt"
    })
	killauranovape = Killaura.CreateToggle({
		Name = "No Vape",
		Function = function() end,
		HoverText = "no hit vape user"
	})
	killauranoNebulaware = Killaura.CreateToggle({
		Name = "Ignore Nebulaware",
		Function = function() if Killaura.Enabled then Killaura.ToggleButton(false) Killaura.ToggleButton(false) end end,
		HoverText = "ignores Nebulaware users under your rank.\n(despite the fact they can't attack you back :omegalol:)"
	})
	killauranovape.Object.Visible = false
	killauranoNebulaware.Object.Visible = false
	task.spawn(function()
		repeat task.wait() until WhitelistFunctions.Loaded
		killauranovape.Object.Visible = WhitelistFunctions.LocalPriority ~= 0
	end)
	task.spawn(function()
		repeat task.wait() until NebulawareFunctions.WhitelistLoaded
		killauranoNebulaware.Object.Visible = ({NebulawareFunctions:GetPlayerType()})[3] > 1.5
	end)
end)

local LongJump = {Enabled = false}
runFunction(function()
	local damagetimer = 0
	local damagetimertick = 0
	local directionvec
	local LongJumpSpeed = {Value = 1.5}
	local projectileRemote = bedwars.ClientHandler:Get(bedwars.ProjectileRemote)

	local function calculatepos(vec)
		local returned = vec
		if entityLibrary.isAlive then 
			local newray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, returned, bedwarsStore.blockRaycast)
			if newray then returned = (newray.Position - entityLibrary.character.HumanoidRootPart.Position) end
		end
		return returned
	end

	local damagemethods = {
		fireball = function(fireball, pos)
			if not LongJump.Enabled then return end
			pos = pos - (entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 0.2)
			if not (getPlacedBlock(pos - Vector3.new(0, 3, 0)) or getPlacedBlock(pos - Vector3.new(0, 6, 0))) then
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://4809574295"
				sound.Parent = workspace
				sound.Ended:Connect(function()
					sound:Destroy()
				end)
				sound:Play()
			end
			local origpos = pos
			local offsetshootpos = (CFrame.new(pos, pos + Vector3.new(0, -60, 0)) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).p
			local ray = workspace:Raycast(pos, Vector3.new(0, -30, 0), bedwarsStore.blockRaycast)
			if ray then
				pos = ray.Position
				offsetshootpos = pos
			end
			task.spawn(function()
				switchItem(fireball.tool)
				bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta.fireball, "fireball", "fireball", offsetshootpos, "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
				projectileRemote:CallServerAsync(fireball.tool, "fireball", "fireball", offsetshootpos, pos, Vector3.new(0, -60, 0), game:GetService("HttpService"):GenerateGUID(true), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
			end)
		end,
		tnt = function(tnt, pos2)
			if not LongJump.Enabled then return end
			local pos = Vector3.new(pos2.X, getScaffold(Vector3.new(0, pos2.Y - (((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight) - 1.5), 0)).Y, pos2.Z)
			local block = bedwars.placeBlock(pos, "tnt")
		end,
		cannon = function(tnt, pos2)
			task.spawn(function()
				local pos = Vector3.new(pos2.X, getScaffold(Vector3.new(0, pos2.Y - (((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight) - 1.5), 0)).Y, pos2.Z)
				local block = bedwars.placeBlock(pos, "cannon")
				task.delay(0.1, function()
					local block, pos2 = getPlacedBlock(pos)
					if block and block.Name == "cannon" and (entityLibrary.character.HumanoidRootPart.CFrame.p - block.Position).Magnitude < 20 then 
						switchToAndUseTool(block)
						local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
						local damage = bedwars.BlockController:calculateBlockDamage(lplr, {
							blockPosition = pos2
						})
						bedwars.ClientHandler:Get(bedwars.CannonAimRemote):SendToServer({
							cannonBlockPos = pos2,
							lookVector = vec
						})
						local broken = 0.1
						if damage < block:GetAttribute("Health") then 
							task.spawn(function()
								broken = 0.4
								bedwars.breakBlock(block.Position, true, getBestBreakSide(block.Position), true, true)
							end)
						end
						task.delay(broken, function()
							for i = 1, 3 do 
								local call = bedwars.ClientHandler:Get(bedwars.CannonLaunchRemote):CallServer({cannonBlockPos = bedwars.BlockController:getBlockPosition(block.Position)})
								if call then
									bedwars.breakBlock(block.Position, true, getBestBreakSide(block.Position), true, true)
									task.delay(0.1, function()
										damagetimer = LongJumpSpeed.Value * 5
										damagetimertick = tick() + 2.5
										directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
									end)
									break
								end
								task.wait(0.1)
							end
						end)
					end
				end)	
			end)
		end,
		wood_dao = function(tnt, pos2)
			task.spawn(function()
				switchItem(tnt.tool)
				if not (not lplr.Character:GetAttribute("CanDashNext") or lplr.Character:GetAttribute("CanDashNext") < workspace:GetServerTimeNow()) then
					repeat task.wait() until (not lplr.Character:GetAttribute("CanDashNext") or lplr.Character:GetAttribute("CanDashNext") < workspace:GetServerTimeNow()) or not LongJump.Enabled
				end
				if LongJump.Enabled then
					local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
					replicatedStorageService["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer("dash", {
						direction = vec,
						origin = entityLibrary.character.HumanoidRootPart.CFrame.p,
						weapon = tnt.itemType
					})
					damagetimer = LongJumpSpeed.Value * 3.5
					damagetimertick = tick() + 2.5
					directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
				end
			end)
		end,
		jade_hammer = function(tnt, pos2)
			task.spawn(function()
				if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then
					repeat task.wait() until bedwars.AbilityController:canUseAbility("jade_hammer_jump") or not LongJump.Enabled
					task.wait(0.1)
				end
				if bedwars.AbilityController:canUseAbility("jade_hammer_jump") and LongJump.Enabled then
					bedwars.AbilityController:useAbility("jade_hammer_jump")
					local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
					damagetimer = LongJumpSpeed.Value * 2.75
					damagetimertick = tick() + 2.5
					directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
				end
			end)
		end,
		void_axe = function(tnt, pos2)
			task.spawn(function()
				if not bedwars.AbilityController:canUseAbility("void_axe_jump") then
					repeat task.wait() until bedwars.AbilityController:canUseAbility("void_axe_jump") or not LongJump.Enabled
					task.wait(0.1)
				end
				if bedwars.AbilityController:canUseAbility("void_axe_jump") and LongJump.Enabled then
					bedwars.AbilityController:useAbility("void_axe_jump")
					local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
					damagetimer = LongJumpSpeed.Value * 2.75
					damagetimertick = tick() + 2.5
					directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
				end
			end)
		end
	}
	damagemethods.stone_dao = damagemethods.wood_dao
	damagemethods.iron_dao = damagemethods.wood_dao
	damagemethods.diamond_dao = damagemethods.wood_dao
	damagemethods.emerald_dao = damagemethods.wood_dao

	local oldgrav
	local LongJumpacprogressbarframe = Instance.new("Frame")
	LongJumpacprogressbarframe.AnchorPoint = Vector2.new(0.5, 0)
	LongJumpacprogressbarframe.Position = UDim2.new(0.5, 0, 1, -200)
	LongJumpacprogressbarframe.Size = UDim2.new(0.2, 0, 0, 20)
	LongJumpacprogressbarframe.BackgroundTransparency = 0.5
	LongJumpacprogressbarframe.BorderSizePixel = 0
	LongJumpacprogressbarframe.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
	LongJumpacprogressbarframe.Visible = LongJump.Enabled
	LongJumpacprogressbarframe.Parent = GuiLibrary.MainGui
	local LongJumpacprogressbarframe2 = LongJumpacprogressbarframe:Clone()
	LongJumpacprogressbarframe2.AnchorPoint = Vector2.new(0, 0)
	LongJumpacprogressbarframe2.Position = UDim2.new(0, 0, 0, 0)
	LongJumpacprogressbarframe2.Size = UDim2.new(1, 0, 0, 20)
	LongJumpacprogressbarframe2.BackgroundTransparency = 0
	LongJumpacprogressbarframe2.Visible = true
	LongJumpacprogressbarframe2.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
	LongJumpacprogressbarframe2.Parent = LongJumpacprogressbarframe
	local LongJumpacprogressbartext = Instance.new("TextLabel")
	LongJumpacprogressbartext.Text = "2.5s"
	LongJumpacprogressbartext.Font = Enum.Font.Gotham
	LongJumpacprogressbartext.TextStrokeTransparency = 0
	LongJumpacprogressbartext.TextColor3 =  Color3.new(0.9, 0.9, 0.9)
	LongJumpacprogressbartext.TextSize = 20
	LongJumpacprogressbartext.Size = UDim2.new(1, 0, 1, 0)
	LongJumpacprogressbartext.BackgroundTransparency = 1
	LongJumpacprogressbartext.Position = UDim2.new(0, 0, -1, 0)
	LongJumpacprogressbartext.Parent = LongJumpacprogressbarframe
	LongJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "LongJump",
		Function = function(callback)
			if callback then
				table.insert(LongJump.Connections, vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
					if damageTable.entityInstance == lplr.Character and (not damageTable.knockbackMultiplier or not damageTable.knockbackMultiplier.disabled) then 
						local knockbackBoost = damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal and damageTable.knockbackMultiplier.horizontal * LongJumpSpeed.Value or LongJumpSpeed.Value
						if damagetimertick < tick() or knockbackBoost >= damagetimer then
							damagetimer = knockbackBoost
							damagetimertick = tick() + 2.5
							local newDirection = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
							directionvec = Vector3.new(newDirection.X, 0, newDirection.Z).Unit
						end
					end
				end))
				task.spawn(function()
					task.spawn(function()
						repeat
							task.wait()
							if LongJumpacprogressbarframe then
								LongJumpacprogressbarframe.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
								LongJumpacprogressbarframe2.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value)
							end
						until (not LongJump.Enabled)
					end)
					local LongJumpOrigin = entityLibrary.isAlive and entityLibrary.character.HumanoidRootPart.Position
					local tntcheck
					for i,v in pairs(damagemethods) do 
						local item = getItem(i)
						if item then
							if i == "tnt" then 
								local pos = getScaffold(LongJumpOrigin)
								tntcheck = Vector3.new(pos.X, LongJumpOrigin.Y, pos.Z)
								v(item, pos)
							else
								v(item, LongJumpOrigin)
							end
							break
						end
					end
					local changecheck
					LongJumpacprogressbarframe.Visible = true
					RunLoops:BindToHeartbeat("LongJump", function(dt)
						if entityLibrary.isAlive then 
							if entityLibrary.character.Humanoid.Health <= 0 then 
								LongJump.ToggleButton(false)
								return
							end
							if not LongJumpOrigin then 
								LongJumpOrigin = entityLibrary.character.HumanoidRootPart.Position
							end
							local newval = damagetimer ~= 0
							if changecheck ~= newval then 
								if newval then 
									LongJumpacprogressbarframe2:TweenSize(UDim2.new(0, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 2.5, true)
								else
									LongJumpacprogressbarframe2:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
								end
								changecheck = newval
							end
							if newval then 
								local newnum = math.max(math.floor((damagetimertick - tick()) * 10) / 10, 0)
								if LongJumpacprogressbartext then 
									LongJumpacprogressbartext.Text = newnum.."s"
								end
								if directionvec == nil then 
									directionvec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
								end
								local longJumpCFrame = Vector3.new(directionvec.X, 0, directionvec.Z)
								local newvelo = longJumpCFrame.Unit == longJumpCFrame.Unit and longJumpCFrame.Unit * (newnum > 1 and damagetimer or 20) or Vector3.zero
								newvelo = Vector3.new(newvelo.X, 0, newvelo.Z)
								longJumpCFrame = longJumpCFrame * (getSpeed() + 3) * dt
								local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, longJumpCFrame, bedwarsStore.blockRaycast)
								if ray then 
									longJumpCFrame = Vector3.zero
									newvelo = Vector3.zero
								end

								entityLibrary.character.HumanoidRootPart.Velocity = newvelo
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + longJumpCFrame
							else
								LongJumpacprogressbartext.Text = "2.5s"
								entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(LongJumpOrigin, LongJumpOrigin + entityLibrary.character.HumanoidRootPart.CFrame.lookVector)
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								if tntcheck then 
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(tntcheck + entityLibrary.character.HumanoidRootPart.CFrame.lookVector, tntcheck + (entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 2))
								end
							end
						else
							if LongJumpacprogressbartext then 
								LongJumpacprogressbartext.Text = "2.5s"
							end
							LongJumpOrigin = nil
							tntcheck = nil
						end
					end)
				end)
			else
				LongJumpacprogressbarframe.Visible = false
				RunLoops:UnbindFromHeartbeat("LongJump")
				directionvec = nil
				tntcheck = nil
				LongJumpOrigin = nil
				damagetimer = 0
				damagetimertick = 0
			end
		end, 
		HoverText = "Lets you jump farther (Not landing on same level & Spamming can lead to lagbacks)"
	})
	LongJumpSpeed = LongJump.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 52,
		Function = function() end,
		Default = 52
	})
end)

runFunction(function()
	local NoFall = {Enabled = false}
	local oldfall
	NoFall = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "NoFall",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait(0.5)
						bedwars.ClientHandler:Get("GroundHit"):SendToServer()
					until (not NoFall.Enabled)
				end)
			end
		end, 
		HoverText = "Prevents taking fall damage."
	})
end)

runFunction(function()
	local NoSlowdown = {Enabled = false}
	local OldSetSpeedFunc
	NoSlowdown = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "NoSlowdown",
		Function = function(callback)
			if callback then
				OldSetSpeedFunc = bedwars.SprintController.setSpeed
				bedwars.SprintController.setSpeed = function(tab1, val1)
					local hum = entityLibrary.character.Humanoid
					if hum then
						hum.WalkSpeed = math.max(20 * tab1.moveSpeedMultiplier, 20)
					end
				end
				bedwars.SprintController:setSpeed(20)
			else
				bedwars.SprintController.setSpeed = OldSetSpeedFunc
				bedwars.SprintController:setSpeed(20)
				OldSetSpeedFunc = nil
			end
		end, 
		HoverText = "Prevents slowing down when using items."
	})
end)

local spiderActive = false
local holdingshift = false
runFunction(function()
	local activatePhase = false
	local oldActivatePhase = false
	local PhaseDelay = tick()
	local Phase = {Enabled = false}
	local PhaseStudLimit = {Value = 1}
	local PhaseModifiedParts = {}
	local raycastparameters = RaycastParams.new()
	raycastparameters.RespectCanCollide = true
	raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
	local overlapparams = OverlapParams.new()
	overlapparams.RespectCanCollide = true

	local function isPointInMapOccupied(p)
		overlapparams.FilterDescendantsInstances = {lplr.Character, gameCamera}
		local possible = workspace:GetPartBoundsInBox(CFrame.new(p), Vector3.new(1, 2, 1), overlapparams)
		return (#possible == 0)
	end

	Phase = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Phase",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("Phase", function()
					if entityLibrary.isAlive and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero and (not GuiLibrary.ObjectsThatCanBeSaved.SpiderOptionsButton.Api.Enabled or holdingshift) then
						if PhaseDelay <= tick() then
							raycastparameters.FilterDescendantsInstances = {bedwarsStore.blocks, collectionService:GetTagged("spawn-cage"), workspace.SpectatorPlatform}
							local PhaseRayCheck = workspace:Raycast(entityLibrary.character.Head.CFrame.p, entityLibrary.character.Humanoid.MoveDirection * 1.15, raycastparameters)
							if PhaseRayCheck then
								local PhaseDirection = (PhaseRayCheck.Normal.Z ~= 0 or not PhaseRayCheck.Instance:GetAttribute("GreedyBlock")) and "Z" or "X"
								if PhaseRayCheck.Instance.Size[PhaseDirection] <= PhaseStudLimit.Value * 3 and PhaseRayCheck.Instance.CanCollide and PhaseRayCheck.Normal.Y == 0 then
									local PhaseDestination = entityLibrary.character.HumanoidRootPart.CFrame + (PhaseRayCheck.Normal * (-(PhaseRayCheck.Instance.Size[PhaseDirection]) - (entityLibrary.character.HumanoidRootPart.Size.X / 1.5)))
									if isPointInMapOccupied(PhaseDestination.p) then
										PhaseDelay = tick() + 1
										entityLibrary.character.HumanoidRootPart.CFrame = PhaseDestination
									end
								end
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("Phase")
			end
		end,
		HoverText = "Lets you Phase/Clip through walls. (Hold shift to use Phase over spider)"
	})
	PhaseStudLimit = Phase.CreateSlider({
		Name = "Blocks",
		Min = 1,
		Max = 3,
		Function = function() end
	})
end)

runFunction(function()
	local oldCalculateAim
	local BowAimbotProjectiles = {Enabled = false}
	local BowAimbotPart = {Value = "HumanoidRootPart"}
	local BowAimbotFOV = {Value = 1000}
	local BowAimbot = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "ProjectileAimbot",
		Function = function(callback)
			if callback then
				oldCalculateAim = bedwars.ProjectileController.calculateImportantLaunchValues
				bedwars.ProjectileController.calculateImportantLaunchValues = function(self, projmeta, worldmeta, shootpospart, ...)
					local plr = EntityNearMouse(BowAimbotFOV.Value)
					if plr then
						local startPos = self:getLaunchPosition(shootpospart)
						if not startPos then
							return oldCalculateAim(self, projmeta, worldmeta, shootpospart, ...)
						end

						if (not BowAimbotProjectiles.Enabled) and projmeta.projectile:find("arrow") == nil then
							return oldCalculateAim(self, projmeta, worldmeta, shootpospart, ...)
						end
						if not ({NebulawareFunctions:GetPlayerType(plr)})[2] then
							return oldCalculateAim(self, projmeta, worldmeta, shootpospart, ...)
						end
						local projmetatab = projmeta:getProjectileMeta()
						local projectilePrediction = (worldmeta and projmetatab.predictionLifetimeSec or projmetatab.lifetimeSec or 3)
						local projectileSpeed = (projmetatab.launchVelocity or 100)
						local gravity = (projmetatab.gravitationalAcceleration or 196.2)
						local projectileGravity = gravity * projmeta.gravityMultiplier
						local offsetStartPos = startPos + projmeta.fromPositionOffset
						local pos = plr.Character[BowAimbotPart.Value].Position
						local playerGravity = workspace.Gravity
						local balloons = plr.Character:GetAttribute("InflatedBalloons")

						if balloons and balloons > 0 then 
							playerGravity = (workspace.Gravity * (1 - ((balloons >= 4 and 1.2 or balloons >= 3 and 1 or 0.975))))
						end

						if plr.Character.PrimaryPart:FindFirstChild("rbxassetid://8200754399") then 
							playerGravity = (workspace.Gravity * 0.3)
						end

						local shootpos, shootvelo = predictGravity(pos, plr.Character.HumanoidRootPart.Velocity, (pos - offsetStartPos).Magnitude / projectileSpeed, plr, playerGravity)
						if projmeta.projectile == "telepearl" then
							shootpos = pos
							shootvelo = Vector3.zero
						end
						
						local newlook = CFrame.new(offsetStartPos, shootpos) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, 0))
						shootpos = newlook.p + (newlook.lookVector * (offsetStartPos - shootpos).magnitude)
						local calculated = LaunchDirection(offsetStartPos, shootpos, projectileSpeed, projectileGravity, false)
						oldmove = plr.Character.Humanoid.MoveDirection
						if calculated then
							return {
								initialVelocity = calculated,
								positionFrom = offsetStartPos,
								deltaT = projectilePrediction,
								gravitationalAcceleration = projectileGravity,
								drawDurationSeconds = 5
							}
						end
					end
					return oldCalculateAim(self, projmeta, worldmeta, shootpospart, ...)
				end
			else
				bedwars.ProjectileController.calculateImportantLaunchValues = oldCalculateAim
			end
		end
	})
	BowAimbotPart = BowAimbot.CreateDropdown({
		Name = "Part",
		List = {"HumanoidRootPart", "Head"},
		Function = function() end
	})
	BowAimbotFOV = BowAimbot.CreateSlider({
		Name = "FOV",
		Function = function() end,
		Min = 1,
		Max = 1000,
		Default = 1000
	})
	BowAimbotProjectiles = BowAimbot.CreateToggle({
		Name = "Other Projectiles",
		Function = function() end,
		Default = true
	})
end)

--until I find a way to make the spam switch item thing not bad I'll just get rid of it, sorry.

local Scaffold = {Enabled = false}
runFunction(function()
	local scaffoldtext = Instance.new("TextLabel")
	scaffoldtext.Font = Enum.Font.SourceSans
	scaffoldtext.TextSize = 20
	scaffoldtext.BackgroundTransparency = 1
	scaffoldtext.TextColor3 = Color3.fromRGB(255, 0, 0)
	scaffoldtext.Size = UDim2.new(0, 0, 0, 0)
	scaffoldtext.Position = UDim2.new(0.5, 0, 0.5, 30)
	scaffoldtext.Text = "0"
	scaffoldtext.Visible = false
	scaffoldtext.Parent = GuiLibrary.MainGui
	local ScaffoldExpand = {Value = 1}
	local ScaffoldDiagonal = {Enabled = false}
	local ScaffoldTower = {Enabled = false}
	local ScaffoldDownwards = {Enabled = false}
	local ScaffoldStopMotion = {Enabled = false}
	local ScaffoldBlockCount = {Enabled = false}
	local ScaffoldHandCheck = {Enabled = false}
	local ScaffoldMouseCheck = {Enabled = false}
	local ScaffoldAnimation = {Enabled = false}
	local scaffoldstopmotionval = false
	local scaffoldposcheck = tick()
	local scaffoldstopmotionpos = Vector3.zero
	local scaffoldposchecklist = {}
	task.spawn(function()
		for x = -3, 3, 3 do 
			for y = -3, 3, 3 do 
				for z = -3, 3, 3 do 
					if Vector3.new(x, y, z) ~= Vector3.new(0, 0, 0) then 
						table.insert(scaffoldposchecklist, Vector3.new(x, y, z)) 
					end 
				end 
			end 
		end
	end)

	local function checkblocks(pos)
		for i,v in pairs(scaffoldposchecklist) do
			if getPlacedBlock(pos + v) then
				return true
			end
		end
		return false
	end

	local function closestpos(block, pos)
		local startpos = block.Position - (block.Size / 2) - Vector3.new(1.5, 1.5, 1.5)
		local endpos = block.Position + (block.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		local speedCFrame = block.Position + (pos - block.Position)
		return Vector3.new(math.clamp(speedCFrame.X, startpos.X, endpos.X), math.clamp(speedCFrame.Y, startpos.Y, endpos.Y), math.clamp(speedCFrame.Z, startpos.Z, endpos.Z))
	end

	local function getclosesttop(newmag, pos)
		local closest, closestmag = pos, newmag * 3
		if entityLibrary.isAlive then 
			for i,v in pairs(bedwarsStore.blocks) do 
				local close = closestpos(v, pos)
				local mag = (close - pos).magnitude
				if mag <= closestmag then 
					closest = close
					closestmag = mag
				end
			end
		end
		return closest
	end

	local oldspeed
	Scaffold = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Scaffold",
		Function = function(callback)
			if callback then
				scaffoldtext.Visible = ScaffoldBlockCount.Enabled
				if entityLibrary.isAlive then 
					scaffoldstopmotionpos = entityLibrary.character.HumanoidRootPart.CFrame.p
				end
				task.spawn(function()
					repeat
						task.wait()
						if ScaffoldHandCheck.Enabled then 
							if bedwarsStore.localHand.Type ~= "block" then continue end
						end
						if ScaffoldMouseCheck.Enabled then 
							if not inputService:IsMouseButtonPressed(0) then continue end
						end
						if entityLibrary.isAlive then
							local wool, woolamount = getWool()
							if bedwarsStore.localHand.Type == "block" then
								wool = bedwarsStore.localHand.tool.Name
								woolamount = getItem(bedwarsStore.localHand.tool.Name).amount or 0
							elseif (not wool) then 
								wool, woolamount = getBlock()
							end

							scaffoldtext.Text = (woolamount and tostring(woolamount) or "0")
							scaffoldtext.TextColor3 = woolamount and (woolamount >= 128 and Color3.fromRGB(9, 255, 198) or woolamount >= 64 and Color3.fromRGB(255, 249, 18)) or Color3.fromRGB(255, 0, 0)
							if not wool then continue end

							local towering = ScaffoldTower.Enabled and inputService:IsKeyDown(Enum.KeyCode.Space) and game:GetService("UserInputService"):GetFocusedTextBox() == nil
							if towering then
								if (not scaffoldstopmotionval) and ScaffoldStopMotion.Enabled then
									scaffoldstopmotionval = true
									scaffoldstopmotionpos = entityLibrary.character.HumanoidRootPart.CFrame.p
								end
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 28, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								if ScaffoldStopMotion.Enabled and scaffoldstopmotionval then
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(scaffoldstopmotionpos.X, entityLibrary.character.HumanoidRootPart.CFrame.p.Y, scaffoldstopmotionpos.Z))
								end
							else
								scaffoldstopmotionval = false
							end
							
							for i = 1, ScaffoldExpand.Value do
								local speedCFrame = getScaffold((entityLibrary.character.HumanoidRootPart.Position + ((scaffoldstopmotionval and Vector3.zero or entityLibrary.character.Humanoid.MoveDirection) * (i * 3.5))) + Vector3.new(0, -((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight + (inputService:IsKeyDown(Enum.KeyCode.LeftShift) and ScaffoldDownwards.Enabled and 4.5 or 1.5))), 0)
								speedCFrame = Vector3.new(speedCFrame.X, speedCFrame.Y - (towering and 4 or 0), speedCFrame.Z)
								if speedCFrame ~= oldpos then
									if not checkblocks(speedCFrame) then
										local oldspeedCFrame = speedCFrame
										speedCFrame = getScaffold(getclosesttop(20, speedCFrame))
										if getPlacedBlock(speedCFrame) then speedCFrame = oldspeedCFrame end
									end
									if ScaffoldAnimation.Enabled then 
										if not getPlacedBlock(speedCFrame) then
										bedwars.ViewmodelController:playAnimation(bedwars.AnimationType.FP_USE_ITEM)
										end
									end
									task.spawn(bedwars.placeBlock, speedCFrame, wool, ScaffoldAnimation.Enabled)
									if ScaffoldExpand.Value > 1 then 
										task.wait()
									end
									oldpos = speedCFrame
								end
							end
						end
					until (not Scaffold.Enabled)
				end)
			else
				scaffoldtext.Visible = false
				oldpos = Vector3.zero
				oldpos2 = Vector3.zero
			end
		end, 
		HoverText = "Helps you make bridges/scaffold walk."
	})
	ScaffoldExpand = Scaffold.CreateSlider({
		Name = "Expand",
		Min = 1,
		Max = 8,
		Function = function(val) end,
		Default = 1,
		HoverText = "Build range"
	})
	ScaffoldDiagonal = Scaffold.CreateToggle({
		Name = "Diagonal", 
		Function = function(callback) end,
		Default = true
	})
	ScaffoldTower = Scaffold.CreateToggle({
		Name = "Tower", 
		Function = function(callback) 
			if ScaffoldStopMotion.Object then
				ScaffoldTower.Object.ToggleArrow.Visible = callback
				ScaffoldStopMotion.Object.Visible = callback
			end
		end
	})
	ScaffoldMouseCheck = Scaffold.CreateToggle({
		Name = "Require mouse down", 
		Function = function(callback) end,
		HoverText = "Only places when left click is held.",
	})
	ScaffoldDownwards  = Scaffold.CreateToggle({
		Name = "Downwards", 
		Function = function(callback) end,
		HoverText = "Goes down when left shift is held."
	})
	ScaffoldStopMotion = Scaffold.CreateToggle({
		Name = "Stop Motion",
		Function = function() end,
		HoverText = "Stops your movement when going up"
	})
	ScaffoldStopMotion.Object.BackgroundTransparency = 0
	ScaffoldStopMotion.Object.BorderSizePixel = 0
	ScaffoldStopMotion.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ScaffoldStopMotion.Object.Visible = ScaffoldTower.Enabled
	ScaffoldBlockCount = Scaffold.CreateToggle({
		Name = "Block Count",
		Function = function(callback) 
			if Scaffold.Enabled then
				scaffoldtext.Visible = callback 
			end
		end,
		HoverText = "Shows the amount of blocks in the middle."
	})
	ScaffoldHandCheck = Scaffold.CreateToggle({
		Name = "Whitelist Only",
		Function = function() end,
		HoverText = "Only builds with blocks in your hand."
	})
	ScaffoldAnimation = Scaffold.CreateToggle({
		Name = "Animation",
		Function = function() end
	})
end)

local antivoidvelo
runFunction(function()
	local Speed = {Enabled = false}
	local SpeedMode = {Value = "CFrame"}
	local SpeedValue = {Value = 1}
	local SpeedValueLarge = {Value = 1}
	local SpeedDamageBoost = {Enabled = false}
	local SpeedJump = {Enabled = false}
	local SpeedJumpHeight = {Value = 20}
	local SpeedJumpAlways = {Enabled = false}
	local SpeedJumpSound = {Enabled = false}
	local SpeedJumpVanilla = {Enabled = false}
	local SpeedAnimation = {Enabled = false}
	local raycastparameters = RaycastParams.new()
	local damagetick = tick()

	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	Speed = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Speed",
		Function = function(callback)
			if callback then
				table.insert(Speed.Connections, vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
					if damageTable.entityInstance == lplr.Character and (damageTable.damageType ~= 0 or damageTable.extra and damageTable.extra.chargeRatio ~= nil) and (not (damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.disabled or damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal == 0)) and SpeedDamageBoost.Enabled then 
						damagetick = tick() + 0.4
					end
				end))
				RunLoops:BindToHeartbeat("Speed", function(delta)
					if GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled then
						if bedwarsStore.matchState == 0 then return end
					end
					if entityLibrary.isAlive then
						if not (isnetworkowner(entityLibrary.character.HumanoidRootPart) and entityLibrary.character.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing and (not spiderActive) and (not GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled) and (not GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled)) then return end
						if GuiLibrary.ObjectsThatCanBeSaved.GrappleExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.GrappleExploitOptionsButton.Api.Enabled then return end
						if LongJump.Enabled then return end
						if SpeedAnimation.Enabled then
							for i, v in pairs(entityLibrary.character.Humanoid:GetPlayingAnimationTracks()) do
								if v.Name == "WalkAnim" or v.Name == "RunAnim" then
									v:AdjustSpeed(entityLibrary.character.Humanoid.WalkSpeed / 16)
								end
							end
						end

						local speedValue = SpeedValue.Value + getSpeed()
						if damagetick > tick() then speedValue = speedValue + 20 end

						local speedVelocity = entityLibrary.character.Humanoid.MoveDirection * (SpeedMode.Value == "Normal" and SpeedValue.Value or 20)
						entityLibrary.character.HumanoidRootPart.Velocity = antivoidvelo or Vector3.new(speedVelocity.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, speedVelocity.Z)
						if SpeedMode.Value ~= "Normal" then 
							local speedCFrame = entityLibrary.character.Humanoid.MoveDirection * (speedValue - 20) * delta
							raycastparameters.FilterDescendantsInstances = {lplr.Character}
							local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, speedCFrame, raycastparameters)
							if ray then speedCFrame = (ray.Position - entityLibrary.character.HumanoidRootPart.Position) end
							entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + speedCFrame
						end

						if SpeedJump.Enabled and (not Scaffold.Enabled) and (SpeedJumpAlways.Enabled or killauraNearPlayer) then
							if (entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero then
								if SpeedJumpSound.Enabled then 
									pcall(function() entityLibrary.character.HumanoidRootPart.Jumping:Play() end)
								end
								if SpeedJumpVanilla.Enabled then 
									entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								else
									entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, SpeedJumpHeight.Value, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								end
							end 
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("Speed")
			end
		end, 
		HoverText = "Increases your movement.",
		ExtraText = function() 
			return "Nebulaware"
		end
	})
	SpeedValue = Speed.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end,
		Default = 23
	})
	SpeedValueLarge = Speed.CreateSlider({
		Name = "Big Mode Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end,
		Default = 23
	})
	SpeedDamageBoost = Speed.CreateToggle({
		Name = "Damage Boost",
		Function = function() end,
		Default = true
	})
	SpeedJump = Speed.CreateToggle({
		Name = "AutoJump", 
		Function = function(callback) 
			if SpeedJumpHeight.Object then SpeedJumpHeight.Object.Visible = callback end
			if SpeedJumpAlways.Object then
				SpeedJump.Object.ToggleArrow.Visible = callback
				SpeedJumpAlways.Object.Visible = callback
			end
			if SpeedJumpSound.Object then SpeedJumpSound.Object.Visible = callback end
			if SpeedJumpVanilla.Object then SpeedJumpVanilla.Object.Visible = callback end
		end,
		Default = true
	})
	SpeedJumpHeight = Speed.CreateSlider({
		Name = "Jump Height",
		Min = 0,
		Max = 30,
		Default = 25,
		Function = function() end
	})
	SpeedJumpAlways = Speed.CreateToggle({
		Name = "Always Jump",
		Function = function() end
	})
	SpeedJumpSound = Speed.CreateToggle({
		Name = "Jump Sound",
		Function = function() end
	})
	SpeedJumpVanilla = Speed.CreateToggle({
		Name = "Real Jump",
		Function = function() end
	})
	SpeedAnimation = Speed.CreateToggle({
		Name = "Slowdown Anim",
		Function = function() end
	})
end)

runFunction(function()
	local function roundpos(dir, pos, size)
		local suc, res = pcall(function() return Vector3.new(math.clamp(dir.X, pos.X - (size.X / 2), pos.X + (size.X / 2)), math.clamp(dir.Y, pos.Y - (size.Y / 2), pos.Y + (size.Y / 2)), math.clamp(dir.Z, pos.Z - (size.Z / 2), pos.Z + (size.Z / 2))) end)
		return suc and res or Vector3.zero
	end

	local Spider = {Enabled = false}
	local SpiderSpeed = {Value = 0}
	local SpiderMode = {Value = "Normal"}
	local SpiderPart
	Spider = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Spider",
		Function = function(callback)
			if callback then
				table.insert(Spider.Connections, inputService.InputBegan:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.LeftShift then 
						holdingshift = true
					end
				end))
				table.insert(Spider.Connections, inputService.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.LeftShift then 
						holdingshift = false
					end
				end))
				RunLoops:BindToHeartbeat("Spider", function()
					if entityLibrary.isAlive and (GuiLibrary.ObjectsThatCanBeSaved.PhaseOptionsButton.Api.Enabled == false or holdingshift == false) then
						if SpiderMode.Value == "Normal" then
							local vec = entityLibrary.character.Humanoid.MoveDirection * 2
							local newray = getPlacedBlock(entityLibrary.character.HumanoidRootPart.Position + (vec + Vector3.new(0, 0.1, 0)))
							local newray2 = getPlacedBlock(entityLibrary.character.HumanoidRootPart.Position + (vec - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0)))
							if newray and (not newray.CanCollide) then newray = nil end 
							if newray2 and (not newray2.CanCollide) then newray2 = nil end 
							if spiderActive and (not newray) and (not newray2) then
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 0, entityLibrary.character.HumanoidRootPart.Velocity.Z)
							end
							spiderActive = ((newray or newray2) and true or false)
							if (newray or newray2) then
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(newray2 and newray == nil and entityLibrary.character.HumanoidRootPart.Velocity.X or 0, SpiderSpeed.Value, newray2 and newray == nil and entityLibrary.character.HumanoidRootPart.Velocity.Z or 0)
							end
						else
							if not SpiderPart then 
								SpiderPart = Instance.new("TrussPart")
								SpiderPart.Size = Vector3.new(2, 2, 2)
								SpiderPart.Transparency = 1
								SpiderPart.Anchored = true
								SpiderPart.Parent = gameCamera
							end
							local newray2, newray2pos = getPlacedBlock(entityLibrary.character.HumanoidRootPart.Position + ((entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 1.5) - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0)))
							if newray2 and (not newray2.CanCollide) then newray2 = nil end
							spiderActive = (newray2 and true or false)
							if newray2 then 
								newray2pos = newray2pos * 3
								local newpos = roundpos(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(newray2pos.X, math.min(entityLibrary.character.HumanoidRootPart.Position.Y, newray2pos.Y), newray2pos.Z), Vector3.new(1.1, 1.1, 1.1))
								SpiderPart.Position = newpos
							else
								SpiderPart.Position = Vector3.zero
							end
						end
					end
				end)
			else
				if SpiderPart then SpiderPart:Destroy() end
				RunLoops:UnbindFromHeartbeat("Spider")
				holdingshift = false
			end
		end,
		HoverText = "Lets you climb up walls"
	})
	SpiderMode = Spider.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "Classic"},
		Function = function() 
			if SpiderPart then SpiderPart:Destroy() end
		end
	})
	SpiderSpeed = Spider.CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 40,
		Function = function() end,
		Default = 40
	})
end)

runFunction(function()
	local TargetStrafe = {Enabled = false}
	local TargetStrafeRange = {Value = 18}
	local oldmove
	local controlmodule
	local block
	TargetStrafe = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "TargetStrafe",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					if not controlmodule then
						local suc = pcall(function() controlmodule = require(lplr.PlayerScripts.PlayerModule).controls end)
						if not suc then controlmodule = {} end
					end
					oldmove = controlmodule.moveFunction
					local ang = 0
					local oldplr
					block = Instance.new("Part")
					block.Anchored = true
					block.CanCollide = false
					block.Parent = gameCamera
					controlmodule.moveFunction = function(Self, vec, facecam, ...)
						if entityLibrary.isAlive then
							local plr = AllNearPosition(TargetStrafeRange.Value + 5, 10)[1]
							plr = plr and (not workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, (plr.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position), bedwarsStore.blockRaycast)) and workspace:Raycast(plr.RootPart.Position, Vector3.new(0, -70, 0), bedwarsStore.blockRaycast) and plr or nil
							if plr ~= oldplr then
								if plr then
									local x, y, z = CFrame.new(plr.RootPart.Position, entityLibrary.character.HumanoidRootPart.Position):ToEulerAnglesXYZ()
									ang = math.deg(z)
								end
								oldplr = plr
							end
							if plr then 
								facecam = false
								local localPos = CFrame.new(plr.RootPart.Position)
								local ray = workspace:Blockcast(localPos, Vector3.new(3, 3, 3), CFrame.Angles(0, math.rad(ang), 0).lookVector * TargetStrafeRange.Value, bedwarsStore.blockRaycast)
								local newPos = localPos + (CFrame.Angles(0, math.rad(ang), 0).lookVector * (ray and ray.Distance - 1 or TargetStrafeRange.Value))
								local factor = getSpeed() > 0 and 6 or 4
								if not workspace:Raycast(newPos.p, Vector3.new(0, -70, 0), bedwarsStore.blockRaycast) then 
									newPos = localPos
									factor = 40
								end
								if ((entityLibrary.character.HumanoidRootPart.Position * Vector3.new(1, 0, 1)) - (newPos.p * Vector3.new(1, 0, 1))).Magnitude < 4 or ray then
									ang = ang + factor % 360
								end
								block.Position = newPos.p
								vec = (newPos.p - entityLibrary.character.HumanoidRootPart.Position) * Vector3.new(1, 0, 1)
							end
						end
						return oldmove(Self, vec, facecam, ...)
					end
				end)
			else
				block:Destroy()
				controlmodule.moveFunction = oldmove
			end
		end
	})
	TargetStrafeRange = TargetStrafe.CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 18,
		Function = function() end
	})
end)

runFunction(function()
	local BedESP = {Enabled = false}
	local BedESPFolder = Instance.new("Folder")
	BedESPFolder.Name = "BedESPFolder"
	BedESPFolder.Parent = GuiLibrary.MainGui
	local BedESPTable = {}
	local BedESPColor = {Value = 0.44}
	local BedESPTransparency = {Value = 1}
	local BedESPOnTop = {Enabled = true}
	BedESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "BedESP",
		Function = function(callback) 
			if callback then
				table.insert(BedESP.Connections, collectionService:GetInstanceAddedSignal("bed"):Connect(function(bed)
					task.wait(0.2)
					if not BedESP.Enabled then return end
					local BedFolder = Instance.new("Folder")
					BedFolder.Parent = BedESPFolder
					BedESPTable[bed] = BedFolder
					for bedespnumber, bedesppart in pairs(bed:GetChildren()) do
						local boxhandle = Instance.new("BoxHandleAdornment")
						boxhandle.Size = bedesppart.Size + Vector3.new(.01, .01, .01)
						boxhandle.AlwaysOnTop = true
						boxhandle.ZIndex = (bedesppart.Name == "Covers" and 10 or 0)
						boxhandle.Visible = true
						boxhandle.Adornee = bedesppart
						boxhandle.Color3 = bedesppart.Color
						boxhandle.Name = bedespnumber
						boxhandle.Parent = BedFolder
					end
				end))
				table.insert(BedESP.Connections, collectionService:GetInstanceRemovedSignal("bed"):Connect(function(bed)
					if BedESPTable[bed] then 
						BedESPTable[bed]:Destroy()
						BedESPTable[bed] = nil
					end
				end))
				for i, bed in pairs(collectionService:GetTagged("bed")) do 
					local BedFolder = Instance.new("Folder")
					BedFolder.Parent = BedESPFolder
					BedESPTable[bed] = BedFolder
					for bedespnumber, bedesppart in pairs(bed:GetChildren()) do
						if bedesppart:IsA("BasePart") then
							local boxhandle = Instance.new("BoxHandleAdornment")
							boxhandle.Size = bedesppart.Size + Vector3.new(.01, .01, .01)
							boxhandle.AlwaysOnTop = true
							boxhandle.ZIndex = (bedesppart.Name == "Covers" and 10 or 0)
							boxhandle.Visible = true
							boxhandle.Adornee = bedesppart
							boxhandle.Color3 = bedesppart.Color
							boxhandle.Parent = BedFolder
						end
					end
				end
			else
				BedESPFolder:ClearAllChildren()
				table.clear(BedESPTable)
			end
		end,
		HoverText = "Render Beds through walls" 
	})
end)

runFunction(function()
	local function getallblocks2(pos, normal)
		local blocks = {}
		local lastfound = nil
		for i = 1, 20 do
			local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
			local extrablock = getPlacedBlock(blockpos)
			local covered = true
			if extrablock and extrablock.Parent ~= nil then
				if bedwars.BlockController:isBlockBreakable({blockPosition = blockpos}, lplr) then
					table.insert(blocks, extrablock:GetAttribute("NoBreak") and "unbreakable" or extrablock.Name)
				else
					table.insert(blocks, "unbreakable")
					break
				end
				lastfound = extrablock
				if covered == false then
					break
				end
			else
				break
			end
		end
		return blocks
	end

	local function getallbedblocks(pos)
		local blocks = {}
		for i,v in pairs(cachedNormalSides) do
			for i2,v2 in pairs(getallblocks2(pos, v)) do	
				if table.find(blocks, v2) == nil and v2 ~= "bed" then
					table.insert(blocks, v2)
				end
			end
			for i2,v2 in pairs(getallblocks2(pos + Vector3.new(0, 0, 3), v)) do	
				if table.find(blocks, v2) == nil and v2 ~= "bed" then
					table.insert(blocks, v2)
				end
			end
		end
		return blocks
	end

	local function refreshAdornee(v)
		local bedblocks = getallbedblocks(v.Adornee.Position)
		for i2,v2 in pairs(v.Frame:GetChildren()) do
			if v2:IsA("ImageLabel") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(bedblocks) do
			local blockimage = Instance.new("ImageLabel")
			blockimage.Size = UDim2.new(0, 32, 0, 32)
			blockimage.BackgroundTransparency = 1
			blockimage.Image = bedwars.getIcon({itemType = v3}, true)
			blockimage.Parent = v.Frame
		end
	end

	local BedPlatesFolder = Instance.new("Folder")
	BedPlatesFolder.Name = "BedPlatesFolder"
	BedPlatesFolder.Parent = GuiLibrary.MainGui
	local BedPlatesTable = {}
	local BedPlates = {Enabled = false}

	local function addBed(v)
		local billboard = Instance.new("BillboardGui")
		billboard.Parent = BedPlatesFolder
		billboard.Name = "bed"
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 1.5)
		billboard.Size = UDim2.new(0, 42, 0, 42)
		billboard.AlwaysOnTop = true
		billboard.Adornee = v
		BedPlatesTable[v] = billboard
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BackgroundTransparency = 0.5
		frame.Parent = billboard
		local uilistlayout = Instance.new("UIListLayout")
		uilistlayout.FillDirection = Enum.FillDirection.Horizontal
		uilistlayout.Padding = UDim.new(0, 4)
		uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			billboard.Size = UDim2.new(0, math.max(uilistlayout.AbsoluteContentSize.X + 12, 42), 0, 42)
		end)
		uilistlayout.Parent = frame
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 4)
		uicorner.Parent = frame
		refreshAdornee(billboard)
	end

	BedPlates = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "BedPlates",
		Function = function(callback)
			if callback then
				table.insert(BedPlates.Connections, vapeEvents.PlaceBlockEvent.Event:Connect(function(p5)
					for i, v in pairs(BedPlatesFolder:GetChildren()) do 
						if v.Adornee then
							if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
								refreshAdornee(v)
							end
						end
					end
				end))
				table.insert(BedPlates.Connections, vapeEvents.BreakBlockEvent.Event:Connect(function(p5)
					for i, v in pairs(BedPlatesFolder:GetChildren()) do 
						if v.Adornee then
							if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
								refreshAdornee(v)
							end
						end
					end
				end))
				table.insert(BedPlates.Connections, collectionService:GetInstanceAddedSignal("bed"):Connect(function(v)
					addBed(v)
				end))
				table.insert(BedPlates.Connections, collectionService:GetInstanceRemovedSignal("bed"):Connect(function(v)
					if BedPlatesTable[v] then 
						BedPlatesTable[v]:Destroy()
						BedPlatesTable[v] = nil
					end
				end))
				for i, v in pairs(collectionService:GetTagged("bed")) do
					addBed(v)
				end
			else
				BedPlatesFolder:ClearAllChildren()
			end
		end
	})
end)

runFunction(function()
	local ChestESPList = {ObjectList = {}, RefreshList = function() end}
	local function nearchestitem(item)
		for i,v in pairs(ChestESPList.ObjectList) do 
			if item:find(v) then return v end
		end
	end
	local function refreshAdornee(v)
		local chest = v.Adornee.ChestFolderValue.Value
        local chestitems = chest and chest:GetChildren() or {}
		for i2,v2 in pairs(v.Frame:GetChildren()) do
			if v2:IsA("ImageLabel") then
				v2:Remove()
			end
		end
		v.Enabled = false
		local alreadygot = {}
		for itemNumber, item in pairs(chestitems) do
			if alreadygot[item.Name] == nil and (table.find(ChestESPList.ObjectList, item.Name) or nearchestitem(item.Name)) then 
				alreadygot[item.Name] = true
				v.Enabled = true
                local blockimage = Instance.new("ImageLabel")
                blockimage.Size = UDim2.new(0, 32, 0, 32)
                blockimage.BackgroundTransparency = 1
                blockimage.Image = bedwars.getIcon({itemType = item.Name}, true)
                blockimage.Parent = v.Frame
            end
		end
	end

	local ChestESPFolder = Instance.new("Folder")
	ChestESPFolder.Name = "ChestESPFolder"
	ChestESPFolder.Parent = GuiLibrary.MainGui
	local ChestESP = {Enabled = false}
	local ChestESPBackground = {Enabled = true}

	local function chestfunc(v)
		task.spawn(function()
			local billboard = Instance.new("BillboardGui")
			billboard.Parent = ChestESPFolder
			billboard.Name = "chest"
			billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
			billboard.Size = UDim2.new(0, 42, 0, 42)
			billboard.AlwaysOnTop = true
			billboard.Adornee = v
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = Color3.new(0, 0, 0)
			frame.BackgroundTransparency = ChestESPBackground.Enabled and 0.5 or 1
			frame.Parent = billboard
			local uilistlayout = Instance.new("UIListLayout")
			uilistlayout.FillDirection = Enum.FillDirection.Horizontal
			uilistlayout.Padding = UDim.new(0, 4)
			uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				billboard.Size = UDim2.new(0, math.max(uilistlayout.AbsoluteContentSize.X + 12, 42), 0, 42)
			end)
			uilistlayout.Parent = frame
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 4)
			uicorner.Parent = frame
			local chest = v:WaitForChild("ChestFolderValue").Value
			if chest then 
				table.insert(ChestESP.Connections, chest.ChildAdded:Connect(function(item)
					if table.find(ChestESPList.ObjectList, item.Name) or nearchestitem(item.Name) then 
						refreshAdornee(billboard)
					end
				end))
				table.insert(ChestESP.Connections, chest.ChildRemoved:Connect(function(item)
					if table.find(ChestESPList.ObjectList, item.Name) or nearchestitem(item.Name) then 
						refreshAdornee(billboard)
					end
				end))
				refreshAdornee(billboard)
			end
		end)
	end

	ChestESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ChestESP",
		Function = function(callback)
			if callback then
				task.spawn(function()
					table.insert(ChestESP.Connections, collectionService:GetInstanceAddedSignal("chest"):Connect(chestfunc))
					for i,v in pairs(collectionService:GetTagged("chest")) do chestfunc(v) end
				end)
			else
				ChestESPFolder:ClearAllChildren()
			end
		end
	})
	ChestESPList = ChestESP.CreateTextList({
		Name = "ItemList",
		TempText = "item or part of item",
		AddFunction = function()
			if ChestESP.Enabled then 
				ChestESP.ToggleButton(false)
				ChestESP.ToggleButton(false)
			end
		end,
		RemoveFunction = function()
			if ChestESP.Enabled then 
				ChestESP.ToggleButton(false)
				ChestESP.ToggleButton(false)
			end
		end
	})
	ChestESPBackground = ChestESP.CreateToggle({
		Name = "Background",
		Function = function()
			if ChestESP.Enabled then 
				ChestESP.ToggleButton(false)
				ChestESP.ToggleButton(false)
			end
		end,
		Default = true
	})
end)

runFunction(function()
	local FieldOfViewValue = {Value = 70}
	local oldfov
	local oldfov2
	local FieldOfView = {Enabled = false}
	local FieldOfViewZoom = {Enabled = false}
	FieldOfView = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "FOVChanger",
		Function = function(callback)
			if callback then
				if FieldOfViewZoom.Enabled then
					task.spawn(function()
						repeat
							task.wait()
						until not inputService:IsKeyDown(Enum.KeyCode[FieldOfView.Keybind ~= "" and FieldOfView.Keybind or "C"])
						if FieldOfView.Enabled then
							FieldOfView.ToggleButton(false)
						end
					end)
				end
				oldfov = bedwars.FovController.setFOV
				oldfov2 = bedwars.FovController.getFOV
				bedwars.FovController.setFOV = function(self, fov) return oldfov(self, FieldOfViewValue.Value) end
				bedwars.FovController.getFOV = function(self, fov) return FieldOfViewValue.Value end
			else
				bedwars.FovController.setFOV = oldfov
				bedwars.FovController.getFOV = oldfov2
			end
			bedwars.FovController:setFOV(bedwars.ClientStoreHandler:getState().Settings.fov)
		end
	})
	FieldOfViewValue = FieldOfView.CreateSlider({
		Name = "FOV",
		Min = 30,
		Max = 120,
		Function = function(val)
			if FieldOfView.Enabled then
				bedwars.FovController:setFOV(bedwars.ClientStoreHandler:getState().Settings.fov)
			end
		end
	})
	FieldOfViewZoom = FieldOfView.CreateToggle({
		Name = "Zoom",
		Function = function() end,
		HoverText = "optifine zoom lol"
	})
end)

runFunction(function()
	local old
	local old2
	local oldhitpart 
	local FPSBoost = {Enabled = false}
	local removetextures = {Enabled = false}
	local removetexturessmooth = {Enabled = false}
	local fpsboostdamageindicator = {Enabled = false}
	local fpsboostdamageeffect = {Enabled = false}
	local fpsboostkilleffect = {Enabled = false}
	local originaltextures = {}
	local originaleffects = {}

	local function fpsboosttextures()
		task.spawn(function()
			repeat task.wait() until bedwarsStore.matchState ~= 0
			for i,v in pairs(bedwarsStore.blocks) do
				if v:GetAttribute("PlacedByUserId") == 0 then
					v.Material = FPSBoost.Enabled and removetextures.Enabled and Enum.Material.SmoothPlastic or (v.Name:find("glass") and Enum.Material.SmoothPlastic or Enum.Material.Fabric)
					originaltextures[v] = originaltextures[v] or v.MaterialVariant
					v.MaterialVariant = FPSBoost.Enabled and removetextures.Enabled and "" or originaltextures[v]
					for i2,v2 in pairs(v:GetChildren()) do 
						pcall(function() 
							v2.Material = FPSBoost.Enabled and removetextures.Enabled and Enum.Material.SmoothPlastic or (v.Name:find("glass") and Enum.Material.SmoothPlastic or Enum.Material.Fabric)
							originaltextures[v2] = originaltextures[v2] or v2.MaterialVariant
							v2.MaterialVariant = FPSBoost.Enabled and removetextures.Enabled and "" or originaltextures[v2]
						end)
					end
				end
			end
		end)
	end

	FPSBoost = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "FPSBoost",
		Function = function(callback)
			local damagetab = debug.getupvalue(bedwars.DamageIndicator, 2)
			if callback then
				wasenabled = true
				fpsboosttextures()
				if fpsboostdamageindicator.Enabled then 
					damagetab.strokeThickness = 0
					damagetab.textSize = 0
					damagetab.blowUpDuration = 0
					damagetab.blowUpSize = 0
				end
				if fpsboostkilleffect.Enabled then 
					for i,v in pairs(bedwars.KillEffectController.killEffects) do 
						originaleffects[i] = v
						bedwars.KillEffectController.killEffects[i] = {new = function(char) return {onKill = function() end, isPlayDefaultKillEffect = function() return char == lplr.Character end} end}
					end
				end
				if fpsboostdamageeffect.Enabled then 
					oldhitpart = bedwars.DamageIndicatorController.hitEffectPart
					bedwars.DamageIndicatorController.hitEffectPart = nil
				end
				old = bedwars.HighlightController.highlight
				old2 = getmetatable(bedwars.StopwatchController).tweenOutGhost
				local highlighttable = {}
				getmetatable(bedwars.StopwatchController).tweenOutGhost = function(p17, p18)
					p18:Destroy()
				end
				bedwars.HighlightController.highlight = function() end
			else
				for i,v in pairs(originaleffects) do 
					bedwars.KillEffectController.killEffects[i] = v
				end
				fpsboosttextures()
				if oldhitpart then 
					bedwars.DamageIndicatorController.hitEffectPart = oldhitpart
				end
				debug.setupvalue(bedwars.KillEffectController.KnitStart, 2, require(lplr.PlayerScripts.TS["client-sync-events"]).ClientSyncEvents)
				damagetab.strokeThickness = 1.5
				damagetab.textSize = 28
				damagetab.blowUpDuration = 0.125
				damagetab.blowUpSize = 76
				debug.setupvalue(bedwars.DamageIndicator, 10, tweenService)
				if bedwars.DamageIndicatorController.hitEffectPart then 
					bedwars.DamageIndicatorController.hitEffectPart.Attachment.Cubes.Enabled = true
					bedwars.DamageIndicatorController.hitEffectPart.Attachment.Shards.Enabled = true
				end
				bedwars.HighlightController.highlight = old
				getmetatable(bedwars.StopwatchController).tweenOutGhost = old2
				old = nil
				old2 = nil
			end
		end
	})
	removetextures = FPSBoost.CreateToggle({
		Name = "Remove Textures",
		Function = function(callback) if FPSBoost.Enabled then FPSBoost.ToggleButton(false) FPSBoost.ToggleButton(false) end end
	})
	fpsboostdamageindicator = FPSBoost.CreateToggle({
		Name = "Remove Damage Indicator",
		Function = function(callback) if FPSBoost.Enabled then FPSBoost.ToggleButton(false) FPSBoost.ToggleButton(false) end end
	})
	fpsboostdamageeffect = FPSBoost.CreateToggle({
		Name = "Remove Damage Effect",
		Function = function(callback) if FPSBoost.Enabled then FPSBoost.ToggleButton(false) FPSBoost.ToggleButton(false) end end
	})
	fpsboostkilleffect = FPSBoost.CreateToggle({
		Name = "Remove Kill Effect",
		Function = function(callback) if FPSBoost.Enabled then FPSBoost.ToggleButton(false) FPSBoost.ToggleButton(false) end end
	})
end)

runFunction(function()
	local GameFixer = {Enabled = false}
	local GameFixerHit = {Enabled = false}
	GameFixer = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "GameFixer",
		Function = function(callback)
			if callback then
				if GameFixerHit.Enabled then 
					debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, "raycast")
					debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, bedwars.QueryUtil)
				end
				debug.setconstant(bedwars.QueueCard.render, 9, 0.1)
			else
				if GameFixerHit.Enabled then 
					debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, "Raycast")
					debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, workspace)
				end
				debug.setconstant(bedwars.QueueCard.render, 9, 0.01)
			end
		end,
		HoverText = "Fixes game bugs"
	})
	GameFixerHit = GameFixer.CreateToggle({
		Name = "Hit Fix",
		Function = function(callback)
			if GameFixer.Enabled then
				if callback then 
					debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, "raycast")
					debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, bedwars.QueryUtil)
				else
					debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, "Raycast")
					debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, workspace)
				end
			end
		end,
		HoverText = "Fixes the raycast function used for extra reach",
		Default = true
	})
end)

runFunction(function()
	local transformed = false
	local GameTheme = {Enabled = false}
	local GameThemeMode = {Value = "GameTheme"}

	local themefunctions = {
		Old = function()
			task.spawn(function()
				local oldbedwarstabofimages = '{"clay_orange":"rbxassetid://7017703219","iron":"rbxassetid://6850537969","glass":"rbxassetid://6909521321","log_spruce":"rbxassetid://6874161124","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","zipline_base":"rbxassetid://7051148904","iron_helmet":"rbxassetid://6874272559","marble_pillar":"rbxassetid://6909323822","clay_dark_green":"rbxassetid://6763635916","wood_plank_birch":"rbxassetid://6768647328","watering_can":"rbxassetid://6915423754","emerald_helmet":"rbxassetid://6931675766","pie":"rbxassetid://6985761399","wood_plank_spruce":"rbxassetid://6768615964","diamond_chestplate":"rbxassetid://6874272898","wool_pink":"rbxassetid://6910479863","wool_blue":"rbxassetid://6910480234","wood_plank_oak":"rbxassetid://6910418127","diamond_boots":"rbxassetid://6874272964","clay_yellow":"rbxassetid://4991097283","tnt":"rbxassetid://6856168996","lasso":"rbxassetid://7192710930","clay_purple":"rbxassetid://6856099740","melon_seeds":"rbxassetid://6956387796","apple":"rbxassetid://6985765179","carrot_seeds":"rbxassetid://6956387835","log_oak":"rbxassetid://6763678414","emerald_chestplate":"rbxassetid://6931675868","wool_yellow":"rbxassetid://6910479606","emerald_boots":"rbxassetid://6931675942","clay_light_brown":"rbxassetid://6874651634","balloon":"rbxassetid://7122143895","cannon":"rbxassetid://7121221753","leather_boots":"rbxassetid://6855466456","melon":"rbxassetid://6915428682","wool_white":"rbxassetid://6910387332","log_birch":"rbxassetid://6763678414","clay_pink":"rbxassetid://6856283410","grass":"rbxassetid://6773447725","obsidian":"rbxassetid://6910443317","shield":"rbxassetid://7051149149","red_sandstone":"rbxassetid://6708703895","diamond_helmet":"rbxassetid://6874272793","wool_orange":"rbxassetid://6910479956","log_hickory":"rbxassetid://7017706899","guitar":"rbxassetid://7085044606","wool_purple":"rbxassetid://6910479777","diamond":"rbxassetid://6850538161","iron_chestplate":"rbxassetid://6874272631","slime_block":"rbxassetid://6869284566","stone_brick":"rbxassetid://6910394475","hammer":"rbxassetid://6955848801","ceramic":"rbxassetid://6910426690","wood_plank_maple":"rbxassetid://6768632085","leather_helmet":"rbxassetid://6855466216","stone":"rbxassetid://6763635916","slate_brick":"rbxassetid://6708836267","sandstone":"rbxassetid://6708657090","snow":"rbxassetid://6874651192","wool_red":"rbxassetid://6910479695","leather_chestplate":"rbxassetid://6876833204","clay_red":"rbxassetid://6856283323","wool_green":"rbxassetid://6910480050","clay_white":"rbxassetid://7017705325","wool_cyan":"rbxassetid://6910480152","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","clay_light_green":"rbxassetid://6856099550","clay_dark_brown":"rbxassetid://6874651325","carrot":"rbxassetid://3677675280","clay":"rbxassetid://6856190168","iron_boots":"rbxassetid://6874272718","emerald":"rbxassetid://6850538075","zipline":"rbxassetid://7051148904"}'
				local oldbedwarsicontab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofimages)
				local oldbedwarssoundtable = {
					["QUEUE_JOIN"] = "rbxassetid://6691735519",
					["QUEUE_MATCH_FOUND"] = "rbxassetid://6768247187",
					["UI_CLICK"] = "rbxassetid://6732690176",
					["UI_OPEN"] = "rbxassetid://6732607930",
					["BEDWARS_UPGRADE_SUCCESS"] = "rbxassetid://6760677364",
					["BEDWARS_PURCHASE_ITEM"] = "rbxassetid://6760677364",
					["SWORD_SWING_1"] = "rbxassetid://6760544639",
					["SWORD_SWING_2"] = "rbxassetid://6760544595",
					["DAMAGE_1"] = "rbxassetid://6765457325",
					["DAMAGE_2"] = "rbxassetid://6765470975",
					["DAMAGE_3"] = "rbxassetid://6765470941",
					["CROP_HARVEST"] = "rbxassetid://4864122196",
					["CROP_PLANT_1"] = "rbxassetid://5483943277",
					["CROP_PLANT_2"] = "rbxassetid://5483943479",
					["CROP_PLANT_3"] = "rbxassetid://5483943723",
					["ARMOR_EQUIP"] = "rbxassetid://6760627839",
					["ARMOR_UNEQUIP"] = "rbxassetid://6760625788",
					["PICKUP_ITEM_DROP"] = "rbxassetid://6768578304",
					["PARTY_INCOMING_INVITE"] = "rbxassetid://6732495464",
					["ERROR_NOTIFICATION"] = "rbxassetid://6732495464",
					["INFO_NOTIFICATION"] = "rbxassetid://6732495464",
					["END_GAME"] = "rbxassetid://6246476959",
					["GENERIC_BLOCK_PLACE"] = "rbxassetid://4842910664",
					["GENERIC_BLOCK_BREAK"] = "rbxassetid://4819966893",
					["GRASS_BREAK"] = "rbxassetid://5282847153",
					["WOOD_BREAK"] = "rbxassetid://4819966893",
					["STONE_BREAK"] = "rbxassetid://6328287211",
					["WOOL_BREAK"] = "rbxassetid://4842910664",
					["TNT_EXPLODE_1"] = "rbxassetid://7192313632",
					["TNT_HISS_1"] = "rbxassetid://7192313423",
					["FIREBALL_EXPLODE"] = "rbxassetid://6855723746",
					["SLIME_BLOCK_BOUNCE"] = "rbxassetid://6857999096",
					["SLIME_BLOCK_BREAK"] = "rbxassetid://6857999170",
					["SLIME_BLOCK_HIT"] = "rbxassetid://6857999148",
					["SLIME_BLOCK_PLACE"] = "rbxassetid://6857999119",
					["BOW_DRAW"] = "rbxassetid://6866062236",
					["BOW_FIRE"] = "rbxassetid://6866062104",
					["ARROW_HIT"] = "rbxassetid://6866062188",
					["ARROW_IMPACT"] = "rbxassetid://6866062148",
					["TELEPEARL_THROW"] = "rbxassetid://6866223756",
					["TELEPEARL_LAND"] = "rbxassetid://6866223798",
					["CROSSBOW_RELOAD"] = "rbxassetid://6869254094",
					["VOICE_1"] = "rbxassetid://5283866929",
					["VOICE_2"] = "rbxassetid://5283867710",
					["VOICE_HONK"] = "rbxassetid://5283872555",
					["FORTIFY_BLOCK"] = "rbxassetid://6955762535",
					["EAT_FOOD_1"] = "rbxassetid://4968170636",
					["KILL"] = "rbxassetid://7013482008",
					["ZIPLINE_TRAVEL"] = "rbxassetid://7047882304",
					["ZIPLINE_LATCH"] = "rbxassetid://7047882233",
					["ZIPLINE_UNLATCH"] = "rbxassetid://7047882265",
					["SHIELD_BLOCKED"] = "rbxassetid://6955762535",
					["GUITAR_LOOP"] = "rbxassetid://7084168540",
					["GUITAR_HEAL_1"] = "rbxassetid://7084168458",
					["CANNON_MOVE"] = "rbxassetid://7118668472",
					["CANNON_FIRE"] = "rbxassetid://7121064180",
					["BALLOON_INFLATE"] = "rbxassetid://7118657911",
					["BALLOON_POP"] = "rbxassetid://7118657873",
					["FIREBALL_THROW"] = "rbxassetid://7192289445",
					["LASSO_HIT"] = "rbxassetid://7192289603",
					["LASSO_SWING"] = "rbxassetid://7192289504",
					["LASSO_THROW"] = "rbxassetid://7192289548",
					["GRIM_REAPER_CONSUME"] = "rbxassetid://7225389554",
					["GRIM_REAPER_CHANNEL"] = "rbxassetid://7225389512",
					["TV_STATIC"] = "rbxassetid://7256209920",
					["TURRET_ON"] = "rbxassetid://7290176291",
					["TURRET_OFF"] = "rbxassetid://7290176380",
					["TURRET_ROTATE"] = "rbxassetid://7290176421",
					["TURRET_SHOOT"] = "rbxassetid://7290187805",
					["WIZARD_LIGHTNING_CAST"] = "rbxassetid://7262989886",
					["WIZARD_LIGHTNING_LAND"] = "rbxassetid://7263165647",
					["WIZARD_LIGHTNING_STRIKE"] = "rbxassetid://7263165347",
					["WIZARD_ORB_CAST"] = "rbxassetid://7263165448",
					["WIZARD_ORB_TRAVEL_LOOP"] = "rbxassetid://7263165579",
					["WIZARD_ORB_CONTACT_LOOP"] = "rbxassetid://7263165647",
					["BATTLE_PASS_PROGRESS_LEVEL_UP"] = "rbxassetid://7331597283",
					["BATTLE_PASS_PROGRESS_EXP_GAIN"] = "rbxassetid://7331597220",
					["FLAMETHROWER_UPGRADE"] = "rbxassetid://7310273053",
					["FLAMETHROWER_USE"] = "rbxassetid://7310273125",
					["BRITTLE_HIT"] = "rbxassetid://7310273179",
					["EXTINGUISH"] = "rbxassetid://7310273015",
					["RAVEN_SPACE_AMBIENT"] = "rbxassetid://7341443286",
					["RAVEN_WING_FLAP"] = "rbxassetid://7341443378",
					["RAVEN_CAW"] = "rbxassetid://7341443447",
					["JADE_HAMMER_THUD"] = "rbxassetid://7342299402",
					["STATUE"] = "rbxassetid://7344166851",
					["CONFETTI"] = "rbxassetid://7344278405",
					["HEART"] = "rbxassetid://7345120916",
					["SPRAY"] = "rbxassetid://7361499529",
					["BEEHIVE_PRODUCE"] = "rbxassetid://7378100183",
					["DEPOSIT_BEE"] = "rbxassetid://7378100250",
					["CATCH_BEE"] = "rbxassetid://7378100305",
					["BEE_NET_SWING"] = "rbxassetid://7378100350",
					["ASCEND"] = "rbxassetid://7378387334",
					["BED_ALARM"] = "rbxassetid://7396762708",
					["BOUNTY_CLAIMED"] = "rbxassetid://7396751941",
					["BOUNTY_ASSIGNED"] = "rbxassetid://7396752155",
					["BAGUETTE_HIT"] = "rbxassetid://7396760547",
					["BAGUETTE_SWING"] = "rbxassetid://7396760496",
					["TESLA_ZAP"] = "rbxassetid://7497477336",
					["SPIRIT_TRIGGERED"] = "rbxassetid://7498107251",
					["SPIRIT_EXPLODE"] = "rbxassetid://7498107327",
					["ANGEL_LIGHT_ORB_CREATE"] = "rbxassetid://7552134231",
					["ANGEL_LIGHT_ORB_HEAL"] = "rbxassetid://7552134868",
					["ANGEL_VOID_ORB_CREATE"] = "rbxassetid://7552135942",
					["ANGEL_VOID_ORB_HEAL"] = "rbxassetid://7552136927",
					["DODO_BIRD_JUMP"] = "rbxassetid://7618085391",
					["DODO_BIRD_DOUBLE_JUMP"] = "rbxassetid://7618085771",
					["DODO_BIRD_MOUNT"] = "rbxassetid://7618085486",
					["DODO_BIRD_DISMOUNT"] = "rbxassetid://7618085571",
					["DODO_BIRD_SQUAWK_1"] = "rbxassetid://7618085870",
					["DODO_BIRD_SQUAWK_2"] = "rbxassetid://7618085657",
					["SHIELD_CHARGE_START"] = "rbxassetid://7730842884",
					["SHIELD_CHARGE_LOOP"] = "rbxassetid://7730843006",
					["SHIELD_CHARGE_BASH"] = "rbxassetid://7730843142",
					["ROCKET_LAUNCHER_FIRE"] = "rbxassetid://7681584765",
					["ROCKET_LAUNCHER_FLYING_LOOP"] = "rbxassetid://7681584906",
					["SMOKE_GRENADE_POP"] = "rbxassetid://7681276062",
					["SMOKE_GRENADE_EMIT_LOOP"] = "rbxassetid://7681276135",
					["GOO_SPIT"] = "rbxassetid://7807271610",
					["GOO_SPLAT"] = "rbxassetid://7807272724",
					["GOO_EAT"] = "rbxassetid://7813484049",
					["LUCKY_BLOCK_BREAK"] = "rbxassetid://7682005357",
					["AXOLOTL_SWITCH_TARGETS"] = "rbxassetid://7344278405",
					["HALLOWEEN_MUSIC"] = "rbxassetid://7775602786",
					["SNAP_TRAP_SETUP"] = "rbxassetid://7796078515",
					["SNAP_TRAP_CLOSE"] = "rbxassetid://7796078695",
					["SNAP_TRAP_CONSUME_MARK"] = "rbxassetid://7796078825",
					["GHOST_VACUUM_SUCKING_LOOP"] = "rbxassetid://7814995865",
					["GHOST_VACUUM_SHOOT"] = "rbxassetid://7806060367",
					["GHOST_VACUUM_CATCH"] = "rbxassetid://7815151688",
					["FISHERMAN_GAME_START"] = "rbxassetid://7806060544",
					["FISHERMAN_GAME_PULLING_LOOP"] = "rbxassetid://7806060638",
					["FISHERMAN_GAME_PROGRESS_INCREASE"] = "rbxassetid://7806060745",
					["FISHERMAN_GAME_FISH_MOVE"] = "rbxassetid://7806060863",
					["FISHERMAN_GAME_LOOP"] = "rbxassetid://7806061057",
					["FISHING_ROD_CAST"] = "rbxassetid://7806060976",
					["FISHING_ROD_SPLASH"] = "rbxassetid://7806061193",
					["SPEAR_HIT"] = "rbxassetid://7807270398",
					["SPEAR_THROW"] = "rbxassetid://7813485044",
				}
				for i,v in pairs(bedwars.CombatController.killSounds) do 
					bedwars.CombatController.killSounds[i] = oldbedwarssoundtable.KILL
				end
				for i,v in pairs(bedwars.CombatController.multiKillLoops) do 
					bedwars.CombatController.multiKillLoops[i] = ""
				end
				for i,v in pairs(bedwars.ItemTable) do 
					if oldbedwarsicontab[i] then 
						v.image = oldbedwarsicontab[i]
					end
				end			
				for i,v in pairs(oldbedwarssoundtable) do 
					local item = bedwars.SoundList[i]
					if item then
						bedwars.SoundList[i] = v
					end
				end	
				local damagetab = debug.getupvalue(bedwars.DamageIndicator, 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(214, 0, 0)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars.ViewmodelController.show, 37, "")
				debug.setconstant(bedwars.DamageIndicator, 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars.DamageIndicator, 102, "Enabled")
				debug.setconstant(bedwars.DamageIndicator, 118, 0.3)
				debug.setconstant(bedwars.DamageIndicator, 128, 0.5)
				debug.setupvalue(bedwars.DamageIndicator, 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = tweenService:Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return tweenService:Create(obj, ...)
					end
				})
				sethiddenproperty(lightingService, "Technology", "ShadowMap")
				lightingService.Ambient = Color3.fromRGB(69, 69, 69)
				lightingService.Brightness = 3
				lightingService.EnvironmentDiffuseScale = 1
				lightingService.EnvironmentSpecularScale = 1
				lightingService.OutdoorAmbient = Color3.fromRGB(69, 69, 69)
				lightingService.Atmosphere.Density = 0.1
				lightingService.Atmosphere.Offset = 0.25
				lightingService.Atmosphere.Color = Color3.fromRGB(198, 198, 198)
				lightingService.Atmosphere.Decay = Color3.fromRGB(104, 112, 124)
				lightingService.Atmosphere.Glare = 0
				lightingService.Atmosphere.Haze = 0
				lightingService.ClockTime = 13
				lightingService.GeographicLatitude = 0
				lightingService.GlobalShadows = false
				lightingService.TimeOfDay = "13:00:00"
				lightingService.Sky.SkyboxBk = "rbxassetid://7018684000"
				lightingService.Sky.SkyboxDn = "rbxassetid://6334928194"
				lightingService.Sky.SkyboxFt = "rbxassetid://7018684000"
				lightingService.Sky.SkyboxLf = "rbxassetid://7018684000"
				lightingService.Sky.SkyboxRt = "rbxassetid://7018684000"
				lightingService.Sky.SkyboxUp = "rbxassetid://7018689553"
			end)
		end,
		Winter = function() 
			task.spawn(function()
				for i,v in pairs(lightingService:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				local sky = Instance.new("Sky")
				sky.StarCount = 5000
				sky.SkyboxUp = "rbxassetid://8139676647"
				sky.SkyboxLf = "rbxassetid://8139676988"
				sky.SkyboxFt = "rbxassetid://8139677111"
				sky.SkyboxBk = "rbxassetid://8139677359"
				sky.SkyboxDn = "rbxassetid://8139677253"
				sky.SkyboxRt = "rbxassetid://8139676842"
				sky.SunTextureId = "rbxassetid://6196665106"
				sky.SunAngularSize = 11
				sky.MoonTextureId = "rbxassetid://8139665943"
				sky.MoonAngularSize = 30
				sky.Parent = lightingService
				local sunray = Instance.new("SunRaysEffect")
				sunray.Intensity = 0.03
				sunray.Parent = lightingService
				local bloom = Instance.new("BloomEffect")
				bloom.Threshold = 2
				bloom.Intensity = 1
				bloom.Size = 2
				bloom.Parent = lightingService
				local atmosphere = Instance.new("Atmosphere")
				atmosphere.Density = 0.3
				atmosphere.Offset = 0.25
				atmosphere.Color = Color3.fromRGB(198, 198, 198)
				atmosphere.Decay = Color3.fromRGB(104, 112, 124)
				atmosphere.Glare = 0
				atmosphere.Haze = 0
				atmosphere.Parent = lightingService
				local damagetab = debug.getupvalue(bedwars.DamageIndicator, 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(70, 255, 255)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars.DamageIndicator, 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars.DamageIndicator, 102, "Enabled")
				debug.setconstant(bedwars.DamageIndicator, 118, 0.3)
				debug.setconstant(bedwars.DamageIndicator, 128, 0.5)
				debug.setupvalue(bedwars.DamageIndicator, 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = tweenService:Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(1, 1, 1) or Color3.new(0, 0, 0))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return tweenService:Create(obj, ...)
					end
				})
				debug.setconstant(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar["hotbar-healthbar"]).HotbarHealthbar.render, 16, 4653055)
			end)
			task.spawn(function()
				local snowpart = Instance.new("Part")
				snowpart.Size = Vector3.new(240, 0.5, 240)
				snowpart.Name = "SnowParticle"
				snowpart.Transparency = 1
				snowpart.CanCollide = false
				snowpart.Position = Vector3.new(0, 120, 286)
				snowpart.Anchored = true
				snowpart.Parent = workspace
				local snow = Instance.new("ParticleEmitter")
				snow.RotSpeed = NumberRange.new(300)
				snow.VelocitySpread = 35
				snow.Rate = 28
				snow.Texture = "rbxassetid://8158344433"
				snow.Rotation = NumberRange.new(110)
				snow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
				snow.Lifetime = NumberRange.new(8,14)
				snow.Speed = NumberRange.new(8,18)
				snow.EmissionDirection = Enum.NormalId.Bottom
				snow.SpreadAngle = Vector2.new(35,35)
				snow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
				snow.Parent = snowpart
				local windsnow = Instance.new("ParticleEmitter")
				windsnow.Acceleration = Vector3.new(0,0,1)
				windsnow.RotSpeed = NumberRange.new(100)
				windsnow.VelocitySpread = 35
				windsnow.Rate = 28
				windsnow.Texture = "rbxassetid://8158344433"
				windsnow.EmissionDirection = Enum.NormalId.Bottom
				windsnow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
				windsnow.Lifetime = NumberRange.new(8,14)
				windsnow.Speed = NumberRange.new(8,18)
				windsnow.Rotation = NumberRange.new(110)
				windsnow.SpreadAngle = Vector2.new(35,35)
				windsnow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
				windsnow.Parent = snowpart
				repeat
					task.wait()
					if entityLibrary.isAlive then 
						snowpart.Position = entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, 100, 0)
					end
				until not vapeInjected
			end)
		end,
		Halloween = function()
			task.spawn(function()
				for i,v in pairs(lightingService:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				lightingService.TimeOfDay = "00:00:00"
				pcall(function() workspace.Clouds:Destroy() end)
				local damagetab = debug.getupvalue(bedwars.DamageIndicator, 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(255, 100, 0)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars.DamageIndicator, 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars.DamageIndicator, 102, "Enabled")
				debug.setconstant(bedwars.DamageIndicator, 118, 0.3)
				debug.setconstant(bedwars.DamageIndicator, 128, 0.5)
				debug.setupvalue(bedwars.DamageIndicator, 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = tweenService:Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(0, 0, 0))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return tweenService:Create(obj, ...)
					end
				})
				local colorcorrection = Instance.new("ColorCorrectionEffect")
				colorcorrection.TintColor = Color3.fromRGB(255, 185, 81)
				colorcorrection.Brightness = 0.05
				colorcorrection.Parent = lightingService
				debug.setconstant(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar["hotbar-healthbar"]).HotbarHealthbar.render, 16, 16737280)
			end)
		end,
		Valentines = function()
			task.spawn(function()
				for i,v in pairs(lightingService:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				local sky = Instance.new("Sky")
				sky.SkyboxBk = "rbxassetid://1546230803"
				sky.SkyboxDn = "rbxassetid://1546231143"
				sky.SkyboxFt = "rbxassetid://1546230803"
				sky.SkyboxLf = "rbxassetid://1546230803"
				sky.SkyboxRt = "rbxassetid://1546230803"
				sky.SkyboxUp = "rbxassetid://1546230451"
				sky.Parent = lightingService
				pcall(function() workspace.Clouds:Destroy() end)
				local damagetab = debug.getupvalue(bedwars.DamageIndicator, 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(255, 132, 178)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars.DamageIndicator, 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars.DamageIndicator, 102, "Enabled")
				debug.setconstant(bedwars.DamageIndicator, 118, 0.3)
				debug.setconstant(bedwars.DamageIndicator, 128, 0.5)
				debug.setupvalue(bedwars.DamageIndicator, 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = tweenService:Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(0, 0, 0))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return tweenService:Create(obj, ...)
					end
				})
				local colorcorrection = Instance.new("ColorCorrectionEffect")
				colorcorrection.TintColor = Color3.fromRGB(255, 199, 220)
				colorcorrection.Brightness = 0.05
				colorcorrection.Parent = lightingService
				debug.setconstant(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar["hotbar-healthbar"]).HotbarHealthbar.render, 16, 16745650)
			end)
		end
	}

	GameTheme = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "GameTheme",
		Function = function(callback) 
			if callback then 
				if not transformed then
					transformed = true
					themefunctions[GameThemeMode.Value]()
				else
					GameTheme.ToggleButton(false)
				end
			else
				warningNotification("GameTheme", "Disabled Next Game", 10)
			end
		end,
		ExtraText = function()
			return GameThemeMode.Value
		end
	})
	GameThemeMode = GameTheme.CreateDropdown({
		Name = "Theme",
		Function = function() end,
		List = {"Old", "Winter", "Halloween", "Valentines"}
	})
end)

runFunction(function()
	local oldkilleffect
	local KillEffectMode = {Value = "Gravity"}
	local KillEffectList = {Value = "None"}
	local KillEffectName2 = {}
	local killeffects = {
		Gravity = function(p3, p4, p5, p6)
			p5:BreakJoints()
			task.spawn(function()
				local partvelo = {}
				for i,v in pairs(p5:GetDescendants()) do 
					if v:IsA("BasePart") then 
						partvelo[v.Name] = v.Velocity * 3
					end
				end
				p5.Archivable = true
				local clone = p5:Clone()
				clone.Humanoid.Health = 100
				clone.Parent = workspace
				local nametag = clone:FindFirstChild("Nametag", true)
				if nametag then nametag:Destroy() end
				game:GetService("Debris"):AddItem(clone, 30)
				p5:Destroy()
				task.wait(0.01)
				clone.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				clone:BreakJoints()
				task.wait(0.01)
				for i,v in pairs(clone:GetDescendants()) do 
					if v:IsA("BasePart") then 
						local bodyforce = Instance.new("BodyForce")
						bodyforce.Force = Vector3.new(0, (workspace.Gravity - 10) * v:GetMass(), 0)
						bodyforce.Parent = v
						v.CanCollide = true
						v.Velocity = partvelo[v.Name] or Vector3.zero
					end
				end
			end)
		end,
		Lightning = function(p3, p4, p5, p6)
			p5:BreakJoints()
			local startpos = 1125
			local startcf = p5.PrimaryPart.CFrame.p - Vector3.new(0, 8, 0)
			local newpos = Vector3.new((math.random(1, 10) - 5) * 2, startpos, (math.random(1, 10) - 5) * 2)
			for i = startpos - 75, 0, -75 do 
				local newpos2 = Vector3.new((math.random(1, 10) - 5) * 2, i, (math.random(1, 10) - 5) * 2)
				if i == 0 then 
					newpos2 = Vector3.zero
				end
				local part = Instance.new("Part")
				part.Size = Vector3.new(1.5, 1.5, 77)
				part.Material = Enum.Material.SmoothPlastic
				part.Anchored = true
				part.Material = Enum.Material.Neon
				part.CanCollide = false
				part.CFrame = CFrame.new(startcf + newpos + ((newpos2 - newpos) * 0.5), startcf + newpos2)
				part.Parent = workspace
				local part2 = part:Clone()
				part2.Size = Vector3.new(3, 3, 78)
				part2.Color = Color3.new(0.7, 0.7, 0.7)
				part2.Transparency = 0.7
				part2.Material = Enum.Material.SmoothPlastic
				part2.Parent = workspace
				game:GetService("Debris"):AddItem(part, 0.5)
				game:GetService("Debris"):AddItem(part2, 0.5)
				bedwars.QueryUtil:setQueryIgnored(part, true)
				bedwars.QueryUtil:setQueryIgnored(part2, true)
				if i == 0 then 
					local soundpart = Instance.new("Part")
					soundpart.Transparency = 1
					soundpart.Anchored = true 
					soundpart.Size = Vector3.zero
					soundpart.Position = startcf
					soundpart.Parent = workspace
					bedwars.QueryUtil:setQueryIgnored(soundpart, true)
					local sound = Instance.new("Sound")
					sound.SoundId = "rbxassetid://6993372814"
					sound.Volume = 2
					sound.Pitch = 0.5 + (math.random(1, 3) / 10)
					sound.Parent = soundpart
					sound:Play()
					sound.Ended:Connect(function()
						soundpart:Destroy()
					end)
				end
				newpos = newpos2
			end
		end
	}
	local KillEffectName = {}
	for i,v in pairs(bedwars.KillEffectMeta) do 
		table.insert(KillEffectName, v.name)
		KillEffectName[v.name] = i
	end
	table.sort(KillEffectName, function(a, b) return a:lower() < b:lower() end)
	local KillEffect = {Enabled = false}
	KillEffect = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "KillEffect",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat task.wait() until bedwarsStore.matchState ~= 0 or not KillEffect.Enabled
					if KillEffect.Enabled then
						lplr:SetAttribute("KillEffectType", "none")
						if KillEffectMode.Value == "Bedwars" then 
							lplr:SetAttribute("KillEffectType", KillEffectName[KillEffectList.Value])
						end
					end
				end)
				oldkilleffect = bedwars.DefaultKillEffect.onKill
				bedwars.DefaultKillEffect.onKill = function(p3, p4, p5, p6)
					killeffects[KillEffectMode.Value](p3, p4, p5, p6)
				end
			else
				bedwars.DefaultKillEffect.onKill = oldkilleffect
			end
		end
	})
	local modes = {"Bedwars"}
	for i,v in pairs(killeffects) do 
		table.insert(modes, i)
	end
	KillEffectMode = KillEffect.CreateDropdown({
		Name = "Mode",
		Function = function() 
			if KillEffect.Enabled then 
				KillEffect.ToggleButton(false)
				KillEffect.ToggleButton(false)
			end
		end,
		List = modes
	})
	KillEffectList = KillEffect.CreateDropdown({
		Name = "Bedwars",
		Function = function() 
			if KillEffect.Enabled then 
				KillEffect.ToggleButton(false)
				KillEffect.ToggleButton(false)
			end
		end,
		List = KillEffectName
	})
end)

runFunction(function()
	local KitESP = {Enabled = false}
	local espobjs = {}
	local espfold = Instance.new("Folder")
	espfold.Parent = GuiLibrary.MainGui

	local function espadd(v, icon)
		local billboard = Instance.new("BillboardGui")
		billboard.Parent = espfold
		billboard.Name = "iron"
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 1.5)
		billboard.Size = UDim2.new(0, 32, 0, 32)
		billboard.AlwaysOnTop = true
		billboard.Adornee = v
		local image = Instance.new("ImageLabel")
		image.BackgroundTransparency = 0.5
		image.BorderSizePixel = 0
		image.Image = bedwars.getIcon({itemType = icon}, true)
		image.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		image.Size = UDim2.new(0, 32, 0, 32)
		image.AnchorPoint = Vector2.new(0.5, 0.5)
		image.Parent = billboard
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 4)
		uicorner.Parent = image
		espobjs[v] = billboard
	end

	local function addKit(tag, icon)
		table.insert(KitESP.Connections, collectionService:GetInstanceAddedSignal(tag):Connect(function(v)
			espadd(v.PrimaryPart, icon)
		end))
		table.insert(KitESP.Connections, collectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
			if espobjs[v.PrimaryPart] then
				espobjs[v.PrimaryPart]:Destroy()
				espobjs[v.PrimaryPart] = nil
			end
		end))
		for i,v in pairs(collectionService:GetTagged(tag)) do 
			espadd(v.PrimaryPart, icon)
		end
	end

	KitESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "KitESP",
		Function = function(callback) 
			if callback then
				task.spawn(function()
					repeat task.wait() until bedwarsStore.equippedKit ~= ""
					if KitESP.Enabled then
						if bedwarsStore.equippedKit == "metal_detector" then
							addKit("hidden-metal", "iron")
						elseif bedwarsStore.equippedKit == "beekeeper" then
							addKit("bee", "bee")
						elseif bedwarsStore.equippedKit == "bigman" then
							addKit("treeOrb", "natures_essence_1")
						end
					end
				end)
			else
				espfold:ClearAllChildren()
				table.clear(espobjs)
			end
		end
	})
end)

runFunction(function()
	local function floorNameTagPosition(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary.MainGui
	local nametagsfolderdrawing = {}
	local NameTagsColor = {Value = 0.44}
	local NameTagsDisplayName = {Enabled = false}
	local NameTagsHealth = {Enabled = false}
	local NameTagsDistance = {Enabled = false}
	local NameTagsBackground = {Enabled = true}
	local NameTagsScale = {Value = 10}
	local NameTagsFont = {Value = "SourceSans"}
	local NameTagsTeammates = {Enabled = true}
	local NameTagsShowInventory = {Enabled = false}
	local NameTagsRangeLimit = {Value = 0}
	local fontitems = {"SourceSans"}
	local nametagstrs = {}
	local nametagsizes = {}
	local kititems = {
		jade = "jade_hammer",
		archer = "tactical_crossbow",
		angel = "",
		cowgirl = "lasso",
		dasher = "wood_dao",
		axolotl = "axolotl",
		yeti = "snowball",
		smoke = "smoke_block",
		trapper = "snap_trap",
		pyro = "flamethrower",
		davey = "cannon",
		regent = "void_axe", 
		baker = "apple",
		builder = "builder_hammer",
		farmer_cletus = "carrot_seeds",
		melody = "guitar",
		barbarian = "rageblade",
		gingerbread_man = "gumdrop_bounce_pad",
		spirit_catcher = "spirit",
		fisherman = "fishing_rod",
		oil_man = "oil_consumable",
		santa = "tnt",
		miner = "miner_pickaxe",
		sheep_herder = "crook",
		beast = "speed_potion",
		metal_detector = "metal_detector",
		cyber = "drone",
		vesta = "damage_banner",
		lumen = "light_sword",
		ember = "infernal_saber",
		queen_bee = "bee"
	}

	local nametagfuncs1 = {
		Normal = function(plr)
			if NameTagsTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = Instance.new("TextLabel")
			thing.BackgroundColor3 = Color3.new()
			thing.BorderSizePixel = 0
			thing.Visible = false
			thing.RichText = true
			thing.AnchorPoint = Vector2.new(0.5, 1)
			thing.Name = plr.Player.Name
			thing.Font = Enum.Font[NameTagsFont.Value]
			thing.TextSize = 14 * (NameTagsScale.Value / 10)
			thing.BackgroundTransparency = NameTagsBackground.Enabled and 0.5 or 1
			nametagstrs[plr.Player] = WhitelistFunctions:GetTag(plr.Player)..(NameTagsDisplayName.Enabled and plr.Player.DisplayName or plr.Player.Name)
			if NameTagsHealth.Enabled then
				local color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				nametagstrs[plr.Player] = nametagstrs[plr.Player]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(plr.Humanoid.Health).."</font>"
			end
			if NameTagsDistance.Enabled then 
				nametagstrs[plr.Player] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..nametagstrs[plr.Player]
			end
			local nametagSize = textService:GetTextSize(removeTags(nametagstrs[plr.Player]), thing.TextSize, thing.Font, Vector2.new(100000, 100000))
			thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
			thing.Text = nametagstrs[plr.Player]
			thing.TextColor3 = getPlayerColor(plr.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			thing.Parent = NameTagsFolder
			local hand = Instance.new("ImageLabel")
			hand.Size = UDim2.new(0, 30, 0, 30)
			hand.Name = "Hand"
			hand.BackgroundTransparency = 1
			hand.Position = UDim2.new(0, -30, 0, -30)
			hand.Image = ""
			hand.Parent = thing
			local helmet = hand:Clone()
			helmet.Name = "Helmet"
			helmet.Position = UDim2.new(0, 5, 0, -30)
			helmet.Parent = thing
			local chest = hand:Clone()
			chest.Name = "Chestplate"
			chest.Position = UDim2.new(0, 35, 0, -30)
			chest.Parent = thing
			local boots = hand:Clone()
			boots.Name = "Boots"
			boots.Position = UDim2.new(0, 65, 0, -30)
			boots.Parent = thing
			local kit = hand:Clone()
			kit.Name = "Kit"
			task.spawn(function()
				repeat task.wait() until plr.Player:GetAttribute("PlayingAsKit") ~= ""
				if kit then
					kit.Image = kititems[plr.Player:GetAttribute("PlayingAsKit")] and bedwars.getIcon({itemType = kititems[plr.Player:GetAttribute("PlayingAsKit")]}, NameTagsShowInventory.Enabled) or ""
				end
			end)
			kit.Position = UDim2.new(0, -30, 0, -65)
			kit.Parent = thing
			nametagsfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing = function(plr)
			if NameTagsTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {Main = {}, entity = plr}
			thing.Main.Text = Drawing.new("Text")
			thing.Main.Text.Size = 17 * (NameTagsScale.Value / 10)
			thing.Main.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont.Value) or 1) - 1, 0, 3))
			thing.Main.Text.ZIndex = 2
			thing.Main.BG = Drawing.new("Square")
			thing.Main.BG.Filled = true
			thing.Main.BG.Transparency = 0.5
			thing.Main.BG.Visible = NameTagsBackground.Enabled
			thing.Main.BG.Color = Color3.new()
			thing.Main.BG.ZIndex = 1
			nametagstrs[plr.Player] = WhitelistFunctions:GetTag(plr.Player)..(NameTagsDisplayName.Enabled and plr.Player.DisplayName or plr.Player.Name)
			if NameTagsHealth.Enabled then
				local color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				nametagstrs[plr.Player] = nametagstrs[plr.Player]..' '..math.round(plr.Humanoid.Health)
			end
			if NameTagsDistance.Enabled then 
				nametagstrs[plr.Player] = '[%s] '..nametagstrs[plr.Player]
			end
			thing.Main.Text.Text = nametagstrs[plr.Player]
			thing.Main.BG.Size = Vector2.new(thing.Main.Text.TextBounds.X + 4, thing.Main.Text.TextBounds.Y)
			thing.Main.Text.Color = getPlayerColor(plr.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			nametagsfolderdrawing[plr.Player] = thing
		end
	}

	local nametagfuncs2 = {
		Normal = function(ent)
			local v = nametagsfolderdrawing[ent]
			nametagsfolderdrawing[ent] = nil
			if v then 
				v.Main:Destroy()
			end
		end,
		Drawing = function(ent)
			local v = nametagsfolderdrawing[ent]
			nametagsfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end
	}

	local nametagupdatefuncs = {
		Normal = function(ent)
			local v = nametagsfolderdrawing[ent.Player]
			if v then 
				if (({NebulawareFunctions:GetPlayerType()})[3] > 1.5 and not ({NebulawareFunctions:GetPlayerType(ent.Player)})[6] or tags[ent.Player]) then
				local tagstring = (({NebulawareFunctions:GetPlayerType()})[3] > 1.5 and not ({NebulawareFunctions:GetPlayerType(ent.Player)})[6] and ({NebulawareFunctions:GetPlayerType(ent.Player)})[4] or tags[ent.Player].TagText)
				if (tagstring == "VAPE USER" or tagstring == "Nebulaware USER") then
					nametagstrs[ent.Player] = "<font color='#D22B2B'>["..tagstring.."]</font> "..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				else
				nametagstrs[ent.Player] = "["..tagstring.."] "..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				end
				else
				nametagstrs[ent.Player] = WhitelistFunctions:GetTag(ent.Player)..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				end
				if NameTagsHealth.Enabled then
					local healthattribute = ent.Player.Character:GetAttribute("Health") or ent.Player.Character.Humanoid.Health
					local maxhealthattribute = ent.Player.Character:GetAttribute("MaxHealth") or ent.Player.Character.Humanoid.MaxHealth
					local color = Color3.fromHSV(math.clamp(healthattribute / maxhealthattribute, 0, 1) / 2.5, 0.89, 1)
					nametagstrs[ent.Player] = nametagstrs[ent.Player]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(healthattribute).."</font>"
				end
				if NameTagsDistance.Enabled then 
					nametagstrs[ent.Player] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..nametagstrs[ent.Player]
				end
				if NameTagsShowInventory.Enabled then 
					local inventory = bedwarsStore.inventories[ent.Player] or {armor = {}}
					if inventory.hand then
						v.Main.Hand.Image = bedwars.getIcon(inventory.hand, NameTagsShowInventory.Enabled)
						if v.Main.Hand.Image:find("rbxasset://") then
							v.Main.Hand.ResampleMode = Enum.ResamplerMode.Pixelated
						end
					else
						v.Main.Hand.Image = ""
					end
					if inventory.armor[4] then
						v.Main.Helmet.Image = bedwars.getIcon(inventory.armor[4], NameTagsShowInventory.Enabled)
						if v.Main.Helmet.Image:find("rbxasset://") then
							v.Main.Helmet.ResampleMode = Enum.ResamplerMode.Pixelated
						end
					else
						v.Main.Helmet.Image = ""
					end
					if inventory.armor[5] then
						v.Main.Chestplate.Image = bedwars.getIcon(inventory.armor[5], NameTagsShowInventory.Enabled)
						if v.Main.Chestplate.Image:find("rbxasset://") then
							v.Main.Chestplate.ResampleMode = Enum.ResamplerMode.Pixelated
						end
					else
						v.Main.Chestplate.Image = ""
					end
					if inventory.armor[6] then
						v.Main.Boots.Image = bedwars.getIcon(inventory.armor[6], NameTagsShowInventory.Enabled)
						if v.Main.Boots.Image:find("rbxasset://") then
							v.Main.Boots.ResampleMode = Enum.ResamplerMode.Pixelated
						end
					else
						v.Main.Boots.Image = ""
					end
				end
				local nametagSize = textService:GetTextSize(removeTags(nametagstrs[ent.Player]), v.Main.TextSize, v.Main.Font, Vector2.new(100000, 100000))
				v.Main.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
				v.Main.Text = nametagstrs[ent.Player]
			end
		end,
		Drawing = function(ent)
			local v = nametagsfolderdrawing[ent.Player]
			if v then 
				nametagstrs[ent.Player] = WhitelistFunctions:GetTag(ent.Player)..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				if NameTagsHealth.Enabled then
					nametagstrs[ent.Player] = nametagstrs[ent.Player]..' '..math.round(ent.Humanoid.Health)
				end
				if NameTagsDistance.Enabled then 
					nametagstrs[ent.Player] = '[%s] '..nametagstrs[ent.Player]
					v.Main.Text.Text = entityLibrary.isAlive and string.format(nametagstrs[ent.Player], math.floor((entityLibrary.character.HumanoidRootPart.Position - ent.RootPart.Position).Magnitude)) or nametagstrs[ent.Player]
				else
					v.Main.Text.Text = nametagstrs[ent.Player]
				end
				v.Main.BG.Size = Vector2.new(v.Main.Text.TextBounds.X + 4, v.Main.Text.TextBounds.Y)
				v.Main.Text.Color = getPlayerColor(ent.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			end
		end
	}

	local nametagcolorfuncs = {
		Normal = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(nametagsfolderdrawing) do 
				v.Main.TextColor3 = getPlayerColor(v.entity.Player) or color
			end
		end,
		Drawing = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(nametagsfolderdrawing) do 
				v.Main.Text.Color = getPlayerColor(v.entity.Player) or color
			end
		end
	}

	local nametagloop = {
		Normal = function()
			for i,v in pairs(nametagsfolderdrawing) do 
				local headPos, headVis = worldtoscreenpoint((v.entity.RootPart:GetRenderCFrame() * CFrame.new(0, v.entity.Head.Size.Y + v.entity.RootPart.Size.Y, 0)).Position)
				if not headVis then 
					v.Main.Visible = false
					continue
				end
				local mag = entityLibrary.isAlive and math.floor((entityLibrary.character.HumanoidRootPart.Position - v.entity.RootPart.Position).Magnitude) or 0
				if NameTagsRangeLimit.Value ~= 0 and mag > NameTagsRangeLimit.Value then 
					v.Main.Visible = false
					continue
				end
				if NameTagsDistance.Enabled then
					local stringsize = tostring(mag):len()
					if nametagsizes[v.entity.Player] ~= stringsize then 
						local nametagSize = textService:GetTextSize(removeTags(string.format(nametagstrs[v.entity.Player], mag)), v.Main.TextSize, v.Main.Font, Vector2.new(100000, 100000))
						v.Main.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
					end
					nametagsizes[v.entity.Player] = stringsize
					v.Main.Text = string.format(nametagstrs[v.entity.Player], mag)
				end
				v.Main.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
				v.Main.Visible = true
			end
		end,
		Drawing = function()
			for i,v in pairs(nametagsfolderdrawing) do 
				local headPos, headVis = worldtoscreenpoint((v.entity.RootPart:GetRenderCFrame() * CFrame.new(0, v.entity.Head.Size.Y + v.entity.RootPart.Size.Y, 0)).Position)
				if not headVis then 
					v.Main.Text.Visible = false
					v.Main.BG.Visible = false
					continue
				end
				local mag = entityLibrary.isAlive and math.floor((entityLibrary.character.HumanoidRootPart.Position - v.entity.RootPart.Position).Magnitude) or 0
				if NameTagsRangeLimit.Value ~= 0 and mag > NameTagsRangeLimit.Value then 
					v.Main.Text.Visible = false
					v.Main.BG.Visible = false
					continue
				end
				if NameTagsDistance.Enabled then
					local stringsize = tostring(mag):len()
					v.Main.Text.Text = string.format(nametagstrs[v.entity.Player], mag)
					if nametagsizes[v.entity.Player] ~= stringsize then 
						v.Main.BG.Size = Vector2.new(v.Main.Text.TextBounds.X + 4, v.Main.Text.TextBounds.Y)
					end
					nametagsizes[v.entity.Player] = stringsize
				end
				v.Main.BG.Position = Vector2.new(headPos.X - (v.Main.BG.Size.X / 2), (headPos.Y + v.Main.BG.Size.Y))
				v.Main.Text.Position = v.Main.BG.Position + Vector2.new(2, 0)
				v.Main.Text.Visible = true
				v.Main.BG.Visible = NameTagsBackground.Enabled
			end
		end
	}

	local methodused

	local NameTags = {Enabled = false}
	NameTags = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "NameTags", 
		Function = function(callback) 
			if callback then
				methodused = NameTagsDrawing.Enabled and "Drawing" or "Normal"
				if nametagfuncs2[methodused] then
					table.insert(NameTags.Connections, entityLibrary.entityRemovedEvent:Connect(nametagfuncs2[methodused]))
				end
				if nametagfuncs1[methodused] then
					local addfunc = nametagfuncs1[methodused]
					for i,v in pairs(entityLibrary.entityList) do 
						if nametagsfolderdrawing[v.Player] then nametagfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					table.insert(NameTags.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
						if nametagsfolderdrawing[ent.Player] then nametagfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end))
				end
				if nametagupdatefuncs[methodused] then
					table.insert(NameTags.Connections, entityLibrary.entityUpdatedEvent:Connect(nametagupdatefuncs[methodused]))
					for i,v in pairs(entityLibrary.entityList) do 
						nametagupdatefuncs[methodused](v)
					end
				end
				if nametagcolorfuncs[methodused] then 
					table.insert(NameTags.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
						nametagcolorfuncs[methodused](NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
					end))
				end
				if nametagloop[methodused] then 
					RunLoops:BindToRenderStep("NameTags", nametagloop[methodused])
				end
				local oldtagcount = #tags
				task.spawn(function()
					repeat
					if #tags ~= oldtagcount then
						for i,v in pairs(entityLibrary.entityList) do 
							nametagupdatefuncs[methodused](v)
						end
						oldtagcount = #tags
					end
					task.wait(1)
				until not NameTags.Enabled
				end)
			else
				RunLoops:UnbindFromRenderStep("NameTags")
				if nametagfuncs2[methodused] then
					for i,v in pairs(nametagsfolderdrawing) do 
						nametagfuncs2[methodused](i)
					end
				end
			end
		end,
		HoverText = "Renders nametags on entities through walls."
	})
	for i,v in pairs(Enum.Font:GetEnumItems()) do 
		if v.Name ~= "SourceSans" then 
			table.insert(fontitems, v.Name)
		end
	end
	NameTagsFont = NameTags.CreateDropdown({
		Name = "Font",
		List = fontitems,
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
	})
	NameTagsColor = NameTags.CreateColorSlider({
		Name = "Player Color", 
		Function = function(hue, sat, val) 
			if NameTags.Enabled and nametagcolorfuncs[methodused] then 
				nametagcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	NameTagsScale = NameTags.CreateSlider({
		Name = "Scale",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = 10,
		Min = 1,
		Max = 50
	})
	NameTagsRangeLimit = NameTags.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 0,
		Max = 1000,
		Default = 0
	})
	NameTagsBackground = NameTags.CreateToggle({
		Name = "Background", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		Name = "Use Display Name", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsHealth = NameTags.CreateToggle({
		Name = "Health", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end
	})
	NameTagsDistance = NameTags.CreateToggle({
		Name = "Distance", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end
	})
	NameTagsShowInventory = NameTags.CreateToggle({
		Name = "Equipment",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsTeammates = NameTags.CreateToggle({
		Name = "Teammates", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsDrawing = NameTags.CreateToggle({
		Name = "Drawing",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
	})
end)

runFunction(function()
	local nobobdepth = {Value = 8}
	local nobobhorizontal = {Value = 8}
	local nobobvertical = {Value = -2}
	local rotationx = {Value = 0}
	local rotationy = {Value = 0}
	local rotationz = {Value = 0}
	local oldc1
	local oldfunc
	local nobob = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "NoBob",
		Function = function(callback) 
			local viewmodel = gameCamera:FindFirstChild("Viewmodel")
			if viewmodel then
				if callback then
					oldfunc = bedwars.ViewmodelController.playAnimation
					bedwars.ViewmodelController.playAnimation = function(self, animid, details)
						if animid == bedwars.AnimationType.FP_WALK then
							return
						end
						return oldfunc(self, animid, details)
					end
					bedwars.ViewmodelController:setHeldItem(lplr.Character and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value and lplr.Character.HandInvItem.Value:Clone())
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(nobobdepth.Value / 10))
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (nobobhorizontal.Value / 10))
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_VERTICAL_OFFSET", (nobobvertical.Value / 10))
					oldc1 = viewmodel.RightHand.RightWrist.C1
					viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
				else
					bedwars.ViewmodelController.playAnimation = oldfunc
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", 0)
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", 0)
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_VERTICAL_OFFSET", 0)
					viewmodel.RightHand.RightWrist.C1 = oldc1
				end
			end
		end,
		HoverText = "Removes the ugly bobbing when you move and makes sword farther"
	})
	nobobdepth = nobob.CreateSlider({
		Name = "Depth",
		Min = 0,
		Max = 24,
		Default = 8,
		Function = function(val)
			if nobob.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(val / 10))
			end
		end
	})
	nobobhorizontal = nobob.CreateSlider({
		Name = "Horizontal",
		Min = 0,
		Max = 24,
		Default = 8,
		Function = function(val)
			if nobob.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (val / 10))
			end
		end
	})
	nobobvertical= nobob.CreateSlider({
		Name = "Vertical",
		Min = 0,
		Max = 24,
		Default = -2,
		Function = function(val)
			if nobob.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_VERTICAL_OFFSET", (val / 10))
			end
		end
	})
	rotationx = nobob.CreateSlider({
		Name = "RotX",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				gameCamera.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
	rotationy = nobob.CreateSlider({
		Name = "RotY",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				gameCamera.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
	rotationz = nobob.CreateSlider({
		Name = "RotZ",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				gameCamera.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
end)

runFunction(function()
	local SongBeats = {Enabled = false}
	local SongBeatsList = {ObjectList = {}}
	local SongBeatsIntensity = {Value = 5}
	local SongTween
	local SongAudio

	local function PlaySong(arg)
		local args = arg:split(":")
		local song = isfile(args[1]) and getcustomasset(args[1]) or tonumber(args[1]) and "rbxassetid://"..args[1]
		if not song then 
			warningNotification("SongBeats", "missing music file "..args[1], 5)
			SongBeats.ToggleButton(false)
			return
		end
		local bpm = 1 / (args[2] / 60)
		SongAudio = Instance.new("Sound")
		SongAudio.SoundId = song
		SongAudio.Parent = workspace
		SongAudio:Play()
		repeat
			repeat task.wait() until SongAudio.IsLoaded or (not SongBeats.Enabled) 
			if (not SongBeats.Enabled) then break end
			local newfov = math.min(bedwars.FovController:getFOV() * (bedwars.SprintController.sprinting and 1.1 or 1), 120)
			gameCamera.FieldOfView = newfov - SongBeatsIntensity.Value
			if SongTween then SongTween:Cancel() end
			SongTween = game:GetService("TweenService"):Create(gameCamera, TweenInfo.new(0.2), {FieldOfView = newfov})
			SongTween:Play()
			task.wait(bpm)
		until (not SongBeats.Enabled) or SongAudio.IsPaused
	end

	SongBeats = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "SongBeats",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					if #SongBeatsList.ObjectList <= 0 then 
						warningNotification("SongBeats", "no songs", 5)
						SongBeats.ToggleButton(false)
						return
					end
					local lastChosen
					repeat
						local newSong
						repeat newSong = SongBeatsList.ObjectList[Random.new():NextInteger(1, #SongBeatsList.ObjectList)] task.wait() until newSong ~= lastChosen or #SongBeatsList.ObjectList <= 1
						lastChosen = newSong
						PlaySong(newSong)
						if not SongBeats.Enabled then break end
						task.wait(2)
					until (not SongBeats.Enabled)
				end)
			else
				if SongAudio then SongAudio:Destroy() end
				if SongTween then SongTween:Cancel() end
				gameCamera.FieldOfView = bedwars.FovController:getFOV() * (bedwars.SprintController.sprinting and 1.1 or 1)
			end
		end
	})
	SongBeatsList = SongBeats.CreateTextList({
		Name = "SongList",
		TempText = "songpath:bpm"
	})
	SongBeatsIntensity = SongBeats.CreateSlider({
		Name = "Intensity",
		Function = function() end,
		Min = 1,
		Max = 10,
		Default = 5
	})
end)

runFunction(function()
	local performed = false
	GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "UICleanup",
		Function = function(callback)
			if callback and not performed then 
				performed = true
				task.spawn(function()
					local hotbar = require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui["hotbar-app"]).HotbarApp
					local hotbaropeninv = require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui["hotbar-open-inventory"]).HotbarOpenInventory
					local topbarbutton = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).TopBarButton
					local gametheme = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.shared.ui["game-theme"]).GameTheme
					bedwars.AppController:closeApp("TopBarApp")
					local oldrender = topbarbutton.render
					topbarbutton.render = function(self) 
						local res = oldrender(self)
						if not self.props.Text then
							return bedwars.Roact.createElement("TextButton", {Visible = false}, {})
						end
						return res
					end
					hotbaropeninv.render = function(self) 
						return bedwars.Roact.createElement("TextButton", {Visible = false}, {})
					end
					debug.setconstant(hotbar.render, 52, 0.9975)
					debug.setconstant(hotbar.render, 73, 100)
					debug.setconstant(hotbar.render, 89, 1)
					debug.setconstant(hotbar.render, 90, 0.04)
					debug.setconstant(hotbar.render, 91, -0.03)
					debug.setconstant(hotbar.render, 109, 1.35)
					debug.setconstant(hotbar.render, 110, 0)
					debug.setconstant(debug.getupvalue(hotbar.render, 11).render, 30, 1)
					debug.setconstant(debug.getupvalue(hotbar.render, 11).render, 31, 0.175)
					debug.setconstant(debug.getupvalue(hotbar.render, 11).render, 33, -0.101)
					debug.setconstant(debug.getupvalue(hotbar.render, 18).render, 71, 0)
					debug.setconstant(debug.getupvalue(hotbar.render, 18).tweenPosition, 16, 0)
					gametheme.topBarBGTransparency = 0.5
					bedwars.TopBarController:mountHud()
					game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
					bedwars.AbilityUIController.abilityButtonsScreenGui.Visible = false
					bedwars.MatchEndScreenController.waitUntilDisplay = function() return false end
					task.spawn(function()
						repeat
							task.wait()
							local gui = lplr.PlayerGui:FindFirstChild("StatusEffectHudScreen")
							if gui then gui.Enabled = false break end
						until false
					end)
					task.spawn(function()
						repeat task.wait() until bedwarsStore.matchState ~= 0
						if bedwars.ClientStoreHandler:getState().Game.customMatch == nil then 
							debug.setconstant(bedwars.QueueCard.render, 9, 0.1)
						end
					end)
					local slot = bedwars.ClientStoreHandler:getState().Inventory.observedInventory.hotbarSlot
					bedwars.ClientStoreHandler:dispatch({
						type = "InventorySelectHotbarSlot",
						slot = slot + 1 % 8
					})
					bedwars.ClientStoreHandler:dispatch({
						type = "InventorySelectHotbarSlot",
						slot = slot
					})
				end)
			end
		end
	})
end)

runFunction(function()
	local AntiAFK = {Enabled = false}
	AntiAFK = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AntiAFK",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat 
						task.wait(5) 
						bedwars.ClientHandler:Get("AfkInfo"):SendToServer({
							afk = false
						})
					until (not AntiAFK.Enabled)
				end)
			end
		end
	})
end)

runFunction(function()
	local AutoBalloonPart
	local AutoBalloonConnection
	local AutoBalloonDelay = {Value = 10}
	local AutoBalloonLegit = {Enabled = false}
	local AutoBalloonypos = 0
	local balloondebounce = false
	local AutoBalloon = {Enabled = false}
	AutoBalloon = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoBalloon", 
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until bedwarsStore.matchState ~= 0 or  not vapeInjected
					if vapeInjected and AutoBalloonypos == 0 and AutoBalloon.Enabled then
						local lowestypos = 99999
						for i,v in pairs(bedwarsStore.blocks) do 
							local newray = workspace:Raycast(v.Position + Vector3.new(0, 800, 0), Vector3.new(0, -1000, 0), bedwarsStore.blockRaycast)
							if i % 200 == 0 then 
								task.wait(0.06)
							end
							if newray and newray.Position.Y <= lowestypos then
								lowestypos = newray.Position.Y
							end
						end
						AutoBalloonypos = lowestypos - 8
					end
				end)
				task.spawn(function()
					repeat task.wait() until AutoBalloonypos ~= 0
					if AutoBalloon.Enabled then
						AutoBalloonPart = Instance.new("Part")
						AutoBalloonPart.CanCollide = false
						AutoBalloonPart.Size = Vector3.new(10000, 1, 10000)
						AutoBalloonPart.Anchored = true
						AutoBalloonPart.Transparency = 1
						AutoBalloonPart.Material = Enum.Material.Neon
						AutoBalloonPart.Color = Color3.fromRGB(135, 29, 139)
						AutoBalloonPart.Position = Vector3.new(0, AutoBalloonypos - 50, 0)
						AutoBalloonConnection = AutoBalloonPart.Touched:Connect(function(touchedpart)
							if entityLibrary.isAlive and touchedpart:IsDescendantOf(lplr.Character) and balloondebounce == false then
								autobankballoon = true
								balloondebounce = true
								local oldtool = bedwarsStore.localHand.tool
								for i = 1, 3 do
									if getItem("balloon") and (AutoBalloonLegit.Enabled and getHotbarSlot("balloon") or AutoBalloonLegit.Enabled == false) and (lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") < 3 or lplr.Character:GetAttribute("InflatedBalloons") == nil) then
										if AutoBalloonLegit.Enabled then
											if getHotbarSlot("balloon") then
												bedwars.ClientStoreHandler:dispatch({
													type = "InventorySelectHotbarSlot", 
													slot = getHotbarSlot("balloon")
												})
												task.wait(AutoBalloonDelay.Value / 100)
												bedwars.BalloonController:inflateBalloon()
											end
										else
											task.wait(AutoBalloonDelay.Value / 100)
											bedwars.BalloonController:inflateBalloon()
										end
									end
								end
								if AutoBalloonLegit.Enabled and oldtool and getHotbarSlot(oldtool.Name) then
									task.wait(0.2)
									bedwars.ClientStoreHandler:dispatch({
										type = "InventorySelectHotbarSlot", 
										slot = (getHotbarSlot(oldtool.Name) or 0)
									})
								end
								balloondebounce = false
								autobankballoon = false
							end
						end)
						AutoBalloonPart.Parent = workspace
					end
				end)
			else
				if AutoBalloonConnection then AutoBalloonConnection:Disconnect() end
				if AutoBalloonPart then
					AutoBalloonPart:Remove() 
				end
			end
		end, 
		HoverText = "Automatically Inflates Balloons"
	})
	AutoBalloonDelay = AutoBalloon.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Default = 20,
		Function = function() end,
		HoverText = "Delay to inflate balloons."
	})
	AutoBalloonLegit = AutoBalloon.CreateToggle({
		Name = "Legit Mode",
		Function = function() end,
		HoverText = "Switches to balloons in hotbar and inflates them."
	})
end)

local autobankapple = false
runFunction(function()
	local AutoBuy = {Enabled = false}
	local AutoBuyArmor = {Enabled = false}
	local AutoBuySword = {Enabled = false}
	local AutoBuyUpgrades = {Enabled = false}
	local AutoBuyGen = {Enabled = false}
	local AutoBuyProt = {Enabled = false}
	local AutoBuySharp = {Enabled = false}
	local AutoBuyDestruction = {Enabled = false}
	local AutoBuyDiamond = {Enabled = false}
	local AutoBuyAlarm = {Enabled = false}
	local AutoBuyGui = {Enabled = false}
	local AutoBuyTierSkip = {Enabled = true}
	local AutoBuyRange = {Value = 20}
	local AutoBuyCustom = {ObjectList = {}, RefreshList = function() end}
	local AutoBankUIToggle = {Enabled = false}
	local AutoBankDeath = {Enabled = false}
	local AutoBankStay = {Enabled = false}
	local buyingthing = false
	local shoothook
	local bedwarsshopnpcs = {}
	local armors = {
		[1] = "leather_chestplate",
		[2] = "iron_chestplate",
		[3] = "diamond_chestplate",
		[4] = "emerald_chestplate"
	}

	local swords = {
		[1] = "wood_sword",
		[2] = "stone_sword",
		[3] = "iron_sword",
		[4] = "diamond_sword",
		[5] = "emerald_sword"
	}

	local axes = {
		[1] = "wood_axe",
		[2] = "stone_axe",
		[3] = "iron_axe",
		[4] = "diamond_axe"
	}

	local pickaxes = {
		[1] = "wood_pickaxe",
		[2] = "stone_pickaxe",
		[3] = "iron_pickaxe",
		[4] = "diamond_pickaxe"
	}

	task.spawn(function()
		repeat task.wait() until bedwarsStore.matchState ~= 0 or not vapeInjected
		for i,v in pairs(collectionService:GetTagged("BedwarsItemShop")) do
			table.insert(bedwarsshopnpcs, {Position = v.Position, TeamUpgradeNPC = true})
		end
		for i,v in pairs(collectionService:GetTagged("BedwarsTeamUpgrader")) do
			table.insert(bedwarsshopnpcs, {Position = v.Position, TeamUpgradeNPC = false})
		end
	end)

	local function nearNPC(range)
		local npc, npccheck, enchant = nil, false, false
		if entityLibrary.isAlive then
			local enchanttab = {}
			for i,v in pairs(collectionService:GetTagged("broken-enchant-table")) do 
				table.insert(enchanttab, v)
			end
			for i,v in pairs(collectionService:GetTagged("enchant-table")) do 
				table.insert(enchanttab, v)
			end
			for i,v in pairs(enchanttab) do 
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= 6 then
					if ((not v:GetAttribute("Team")) or v:GetAttribute("Team") == lplr:GetAttribute("Team")) then
						npc, npccheck, enchant = true, true, true
					end
				end
			end
			for i, v in pairs(bedwarsshopnpcs) do
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= (range or 20) then
					npc, npccheck, enchant = true, (v.TeamUpgradeNPC or npccheck), false
				end
			end
			local suc, res = pcall(function() return lplr.leaderstats.Bed.Value == "✅"  end)
			if AutoBankDeath.Enabled and (workspace:GetServerTimeNow() - lplr.Character:GetAttribute("LastDamageTakenTime")) < 2 and suc and res then 
				return nil, false, false
			end
			if AutoBankStay.Enabled then 
				return nil, false, false
			end
		end
		return npc, not npccheck, enchant
	end

	local function buyItem(itemtab, waitdelay)
		local res
		bedwars.ClientHandler:Get("BedwarsPurchaseItem"):CallServerAsync({
			shopItem = itemtab
		}):andThen(function(p11)
			if p11 then
				bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
				bedwars.ClientStoreHandler:dispatch({
					type = "BedwarsAddItemPurchased", 
					itemType = itemtab.itemType
				})
			end
			res = p11
		end)
		if waitdelay then 
			repeat task.wait() until res ~= nil
		end
	end

	local function buyUpgrade(upgradetype, inv, upgrades)
		if not AutoBuyUpgrades.Enabled then return end
		local teamupgrade = bedwars.Shop.getUpgrade(bedwars.Shop.TeamUpgrades, upgradetype)
		local teamtier = teamupgrade.tiers[upgrades[upgradetype] and upgrades[upgradetype] + 2 or 1]
		if teamtier then 
			local teamcurrency = getItem(teamtier.currency, inv.items)
			if teamcurrency and teamcurrency.amount >= teamtier.price then 
				bedwars.ClientHandler:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
					upgradeId = upgradetype, 
					tier = upgrades[upgradetype] and upgrades[upgradetype] + 1 or 0
				}):andThen(function(suc)
					if suc then
						bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
					end
				end)
			end
		end
	end

	local function getAxeNear(inv)
		for i5, v5 in pairs(inv or bedwarsStore.localInventory.inventory.items) do
			if v5.itemType:find("axe") and v5.itemType:find("pickaxe") == nil then
				return v5.itemType
			end
		end
		return nil
	end

	local function getPickaxeNear(inv)
		for i5, v5 in pairs(inv or bedwarsStore.localInventory.inventory.items) do
			if v5.itemType:find("pickaxe") then
				return v5.itemType
			end
		end
		return nil
	end

	local function getShopItem(itemType)
		if itemType == "axe" then 
			itemType = getAxeNear() or "wood_axe"
			itemType = axes[table.find(axes, itemType) + 1] or itemType
		end
		if itemType == "pickaxe" then 
			itemType = getPickaxeNear() or "wood_pickaxe"
			itemType = pickaxes[table.find(pickaxes, itemType) + 1] or itemType
		end
		for i,v in pairs(bedwars.ShopItems) do 
			if v.itemType == itemType then return v end
		end
		return nil
	end

	local buyfunctions = {
		Armor = function(inv, upgrades, shoptype) 
			if AutoBuyArmor.Enabled == false or shoptype ~= "item" then return end
			local currentarmor = (inv.armor[2] ~= "empty" and inv.armor[2].itemType:find("chestplate") ~= nil) and inv.armor[2] or nil
			local armorindex = (currentarmor and table.find(armors, currentarmor.itemType) or 0) + 1
			if armors[armorindex] == nil then return end
			local highestbuyable = nil
			for i = armorindex, #armors, 1 do 
				local shopitem = getShopItem(armors[i])
				if shopitem and (AutoBuyTierSkip.Enabled or i == armorindex) then 
					local currency = getItem(shopitem.currency, inv.items)
					if currency and currency.amount >= shopitem.price then 
						highestbuyable = shopitem
						bedwars.ClientStoreHandler:dispatch({
							type = "BedwarsAddItemPurchased", 
							itemType = shopitem.itemType
						})
					end
				end
			end
			if highestbuyable and (highestbuyable.ignoredByKit == nil or table.find(highestbuyable.ignoredByKit, bedwarsStore.equippedKit) == nil) then 
				buyItem(highestbuyable)
			end
		end,
		Sword = function(inv, upgrades, shoptype)
			if AutoBuySword.Enabled == false or shoptype ~= "item" then return end
			local currentsword = getItemNear("sword", inv.items)
			local swordindex = (currentsword and table.find(swords, currentsword.itemType) or 0) + 1
			if currentsword ~= nil and table.find(swords, currentsword.itemType) == nil then return end
			local highestbuyable = nil
			for i = swordindex, #swords, 1 do 
				local shopitem = getShopItem(swords[i])
				if shopitem then 
					local currency = getItem(shopitem.currency, inv.items)
					if currency and currency.amount >= shopitem.price and (shopitem.category ~= "Armory" or upgrades.armory) then 
						highestbuyable = shopitem
						bedwars.ClientStoreHandler:dispatch({
							type = "BedwarsAddItemPurchased", 
							itemType = shopitem.itemType
						})
					end
				end
			end
			if highestbuyable and (highestbuyable.ignoredByKit == nil or table.find(highestbuyable.ignoredByKit, bedwarsStore.equippedKit) == nil) then 
				buyItem(highestbuyable)
			end
		end,
		Protection = function(inv, upgrades)
			if not AutoBuyProt.Enabled then return end
			buyUpgrade("armor", inv, upgrades)
		end,
		Sharpness = function(inv, upgrades)
			if not AutoBuySharp.Enabled then return end
			buyUpgrade("damage", inv, upgrades)
		end,
		Generator = function(inv, upgrades)
			if not AutoBuyGen.Enabled then return end
			buyUpgrade("generator", inv, upgrades)
		end,
		Destruction = function(inv, upgrades)
			if not AutoBuyDestruction.Enabled then return end
			buyUpgrade("destruction", inv, upgrades)
		end,
		Diamond = function(inv, upgrades)
			if not AutoBuyDiamond.Enabled then return end
			buyUpgrade("diamond_generator", inv, upgrades)
		end,
		Alarm = function(inv, upgrades)
			if not AutoBuyAlarm.Enabled then return end
			buyUpgrade("alarm", inv, upgrades)
		end
	}

	AutoBuy = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoBuy", 
		Function = function(callback)
			if callback then 
				buyingthing = false 
				task.spawn(function()
					repeat
						task.wait()
						local found, npctype, enchant = nearNPC(AutoBuyRange.Value)
						if found then
							local inv = bedwarsStore.localInventory.inventory
							local currentupgrades = bedwars.ClientStoreHandler:getState().Bedwars.teamUpgrades
							if bedwarsStore.equippedKit == "dasher" then 
								swords = {
									[1] = "wood_dao",
									[2] = "stone_dao",
									[3] = "iron_dao",
									[4] = "diamond_dao",
									[5] = "emerald_dao"
								}
							elseif bedwarsStore.equippedKit == "ice_queen" then 
								swords[5] = "ice_sword"
							elseif bedwarsStore.equippedKit == "ember" then 
								swords[5] = "infernal_saber"
							elseif bedwarsStore.equippedKit == "lumen" then 
								swords[5] = "light_sword"
							end
							if (AutoBuyGui.Enabled == false or (bedwars.AppController:isAppOpen("BedwarsItemShopApp") or bedwars.AppController:isAppOpen("BedwarsTeamUpgradeApp"))) and (not enchant) then
								for i,v in pairs(AutoBuyCustom.ObjectList) do 
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] ~= "true" then 
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then 
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getWool() or shopitem.itemType, inv.items)
											if currency and currency.amount >= shopitem.price and (actualitem == nil or actualitem.amount < tonumber(autobuyitem[2])) then 
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
								for i,v in pairs(buyfunctions) do v(inv, currentupgrades, npctype and "upgrade" or "item") end
								for i,v in pairs(AutoBuyCustom.ObjectList) do 
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] == "true" then 
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then 
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getWool() or shopitem.itemType, inv.items)
											if currency and currency.amount >= shopitem.price and (actualitem == nil or actualitem.amount < tonumber(autobuyitem[2])) then 
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
							end
						end
					until (not AutoBuy.Enabled)
				end)
			end
		end,
		HoverText = "Automatically Buys Swords, Armor, and Team Upgrades\nwhen you walk near the NPC"
	})
	AutoBuyRange = AutoBuy.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 1,
		Max = 20,
		Default = 20
	})
	AutoBuyArmor = AutoBuy.CreateToggle({
		Name = "Buy Armor",
		Function = function() end, 
		Default = true
	})
	AutoBuySword = AutoBuy.CreateToggle({
		Name = "Buy Sword",
		Function = function() end, 
		Default = true
	})
	AutoBuyUpgrades = AutoBuy.CreateToggle({
		Name = "Buy Team Upgrades",
		Function = function(callback) 
			if AutoBuyUpgrades.Object then AutoBuyUpgrades.Object.ToggleArrow.Visible = callback end
			if AutoBuyGen.Object then AutoBuyGen.Object.Visible = callback end
			if AutoBuyProt.Object then AutoBuyProt.Object.Visible = callback end
			if AutoBuySharp.Object then AutoBuySharp.Object.Visible = callback end
			if AutoBuyDestruction.Object then AutoBuyDestruction.Object.Visible = callback end
			if AutoBuyDiamond.Object then AutoBuyDiamond.Object.Visible = callback end
			if AutoBuyAlarm.Object then AutoBuyAlarm.Object.Visible = callback end
		end, 
		Default = true
	})
	AutoBuyGen = AutoBuy.CreateToggle({
		Name = "Buy Team Generator",
		Function = function() end, 
	})
	AutoBuyProt = AutoBuy.CreateToggle({
		Name = "Buy Protection",
		Function = function() end, 
		Default = true
	})
	AutoBuySharp = AutoBuy.CreateToggle({
		Name = "Buy Sharpness",
		Function = function() end, 
		Default = true
	})
	AutoBuyDestruction = AutoBuy.CreateToggle({
		Name = "Buy Destruction",
		Function = function() end, 
	})
	AutoBuyDiamond = AutoBuy.CreateToggle({
		Name = "Buy Diamond Generator",
		Function = function() end, 
	})
	AutoBuyAlarm = AutoBuy.CreateToggle({
		Name = "Buy Alarm",
		Function = function() end, 
	})
	AutoBuyGui = AutoBuy.CreateToggle({
		Name = "Shop GUI Check",
		Function = function() end, 	
	})
	AutoBuyTierSkip = AutoBuy.CreateToggle({
		Name = "Tier Skip",
		Function = function() end, 
		Default = true
	})
	AutoBuyGen.Object.BackgroundTransparency = 0
	AutoBuyGen.Object.BorderSizePixel = 0
	AutoBuyGen.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyGen.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyProt.Object.BackgroundTransparency = 0
	AutoBuyProt.Object.BorderSizePixel = 0
	AutoBuyProt.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyProt.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuySharp.Object.BackgroundTransparency = 0
	AutoBuySharp.Object.BorderSizePixel = 0
	AutoBuySharp.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuySharp.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyDestruction.Object.BackgroundTransparency = 0
	AutoBuyDestruction.Object.BorderSizePixel = 0
	AutoBuyDestruction.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyDestruction.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyDiamond.Object.BackgroundTransparency = 0
	AutoBuyDiamond.Object.BorderSizePixel = 0
	AutoBuyDiamond.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyDiamond.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyAlarm.Object.BackgroundTransparency = 0
	AutoBuyAlarm.Object.BorderSizePixel = 0
	AutoBuyAlarm.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyAlarm.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyCustom = AutoBuy.CreateTextList({
		Name = "BuyList",
		TempText = "item/amount/priority/after",
		SortFunction = function(a, b)
			local amount1 = a:split("/")
			local amount2 = b:split("/")
			amount1 = #amount1 and tonumber(amount1[3]) or 1
			amount2 = #amount2 and tonumber(amount2[3]) or 1
			return amount1 < amount2
		end
	})
	AutoBuyCustom.Object.AddBoxBKG.AddBox.TextSize = 14

	local AutoBank = {Enabled = false}
	local AutoBankRange = {Value = 20}
	local AutoBankApple = {Enabled = false}
	local AutoBankBalloon = {Enabled = false}
	local AutoBankTransmitted, AutoBankTransmittedType = false, false
	local autobankoldapple
	local autobankoldballoon
	local autobankui

	local function refreshbank()
		if autobankui then
			local echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
			for i,v in pairs(autobankui:GetChildren()) do 
				if echest:FindFirstChild(v.Name) then 
					v.Amount.Text = echest[v.Name]:GetAttribute("Amount")
				else
					v.Amount.Text = ""
				end
			end
		end
	end

	AutoBank = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoBank",
		Function = function(callback)
			if callback then
				autobankui = Instance.new("Frame")
				autobankui.Size = UDim2.new(0, 240, 0, 40)
				autobankui.AnchorPoint = Vector2.new(0.5, 0)
				autobankui.Position = UDim2.new(0.5, 0, 0, -240)
				autobankui.Visible = AutoBankUIToggle.Enabled
				task.spawn(function()
					repeat
						task.wait()
						if autobankui then 
							local hotbar = lplr.PlayerGui:FindFirstChild("hotbar")
							if hotbar then 
								local healthbar = hotbar["1"]:FindFirstChild("HotbarHealthbarContainer")
								if healthbar then 
									autobankui.Position = UDim2.new(0.5, 0, 0, healthbar.AbsolutePosition.Y - 50)
								end
							end
						else
							break
						end
					until (not AutoBank.Enabled)
				end)
				autobankui.BackgroundTransparency = 1
				autobankui.Parent = GuiLibrary.MainGui
				local emerald = Instance.new("ImageLabel")
				emerald.Image = bedwars.getIcon({itemType = "emerald"}, true)
				emerald.Size = UDim2.new(0, 40, 0, 40)
				emerald.Name = "emerald"
				emerald.Position = UDim2.new(0, 120, 0, 0)
				emerald.BackgroundTransparency = 1
				emerald.Parent = autobankui
				local emeraldtext = Instance.new("TextLabel")
				emeraldtext.TextSize = 20
				emeraldtext.BackgroundTransparency = 1
				emeraldtext.Size = UDim2.new(1, 0, 1, 0)
				emeraldtext.Font = Enum.Font.SourceSans
				emeraldtext.TextStrokeTransparency = 0.3
				emeraldtext.Name = "Amount"
				emeraldtext.Text = ""
				emeraldtext.TextColor3 = Color3.new(1, 1, 1)
				emeraldtext.Parent = emerald
				local diamond = emerald:Clone()
				diamond.Image = bedwars.getIcon({itemType = "diamond"}, true)
				diamond.Position = UDim2.new(0, 80, 0, 0)
				diamond.Name = "diamond"
				diamond.Parent = autobankui
				local gold = emerald:Clone()
				gold.Image = bedwars.getIcon({itemType = "gold"}, true)
				gold.Position = UDim2.new(0, 40, 0, 0)
				gold.Name = "gold"
				gold.Parent = autobankui
				local iron = emerald:Clone()
				iron.Image = bedwars.getIcon({itemType = "iron"}, true)
				iron.Position = UDim2.new(0, 0, 0, 0)
				iron.Name = "iron"
				iron.Parent = autobankui
				local apple = emerald:Clone()
				apple.Image = bedwars.getIcon({itemType = "apple"}, true)
				apple.Position = UDim2.new(0, 160, 0, 0)
				apple.Name = "apple"
				apple.Parent = autobankui
				local balloon = emerald:Clone()
				balloon.Image = bedwars.getIcon({itemType = "balloon"}, true)
				balloon.Position = UDim2.new(0, 200, 0, 0)
				balloon.Name = "balloon"
				balloon.Parent = autobankui
				local echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
				if entityLibrary.isAlive and echest then
					task.spawn(function()
						local chestitems = bedwarsStore.localInventory.inventory.items
						for i3,v3 in pairs(chestitems) do
							if (v3.itemType == "emerald" or v3.itemType == "iron" or v3.itemType == "diamond" or v3.itemType == "gold" or (v3.itemType == "apple" and AutoBankApple.Enabled) or (v3.itemType == "balloon" and AutoBankBalloon.Enabled)) then
								bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
								refreshbank()
							end
						end
					end)
				else
					task.spawn(function()
						refreshbank()
					end)
				end
				table.insert(AutoBank.Connections, replicatedStorageService.Inventories.DescendantAdded:Connect(function(p3)
					if p3.Parent.Name == lplr.Name then
						if echest == nil then 
							echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
						end	
						if not echest then return end
						if p3.Name == "apple" and AutoBankApple.Enabled then 
							if autobankapple then return end
						elseif p3.Name == "balloon" and AutoBankBalloon.Enabled then 
							if autobankballoon then vapeEvents.AutoBankBalloon:Fire() return end
						elseif (p3.Name == "emerald" or p3.Name == "iron" or p3.Name == "diamond" or p3.Name == "gold") then
							if not ((not AutoBankTransmitted) or (AutoBankTransmittedType and p3.Name ~= "diamond")) then return end
						else
							return
						end
						bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, p3)
						refreshbank()
					end
				end))
				task.spawn(function()
					repeat
						task.wait()
						local found, npctype = nearNPC(AutoBankRange.Value)
						if echest == nil then 
							echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
						end
						if autobankballoon then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and v3.Name == "balloon" then
										if (not getItem("balloon")) then
											task.spawn(function()
												bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
												refreshbank()
											end)
										end
									end
								end
							end
						end
						if autobankballoon ~= autobankoldballoon and AutoBankBalloon.Enabled then 
							if entityLibrary.isAlive then
								if not autobankballoon then
									local chestitems = bedwarsStore.localInventory.inventory.items
									if #chestitems > 0 then
										for i3,v3 in pairs(chestitems) do
											if v3 and v3.itemType == "balloon" then
												task.spawn(function()
													bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
							autobankoldballoon = autobankballoon
						end
						if autobankapple then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and v3.Name == "apple" then
										if (not getItem("apple")) then
											task.spawn(function()
												bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
												refreshbank()
											end)
										end
									end
								end
							end
						end
						if (autobankapple ~= autobankoldapple) and AutoBankApple.Enabled then 
							if entityLibrary.isAlive then
								if not autobankapple then
									local chestitems = bedwarsStore.localInventory.inventory.items
									if #chestitems > 0 then
										for i3,v3 in pairs(chestitems) do
											if v3 and v3.itemType == "apple" then
												task.spawn(function()
													bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
							autobankoldapple = autobankapple
						end
						if found ~= AutoBankTransmitted or npctype ~= AutoBankTransmittedType then
							AutoBankTransmitted, AutoBankTransmittedType = found, npctype
							if entityLibrary.isAlive then
								local chestitems = bedwarsStore.localInventory.inventory.items
								if #chestitems > 0 then
									for i3,v3 in pairs(chestitems) do
										if v3 and (v3.itemType == "emerald" or v3.itemType == "iron" or v3.itemType == "diamond" or v3.itemType == "gold") then
											if (not AutoBankTransmitted) or (AutoBankTransmittedType and v3.Name ~= "diamond") then 
												task.spawn(function()
													pcall(function()
														bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													end)
													refreshbank()
												end)
											end
										end
									end
								end
							end
						end
						if found then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and ((npctype == false and (v3.Name == "emerald" or v3.Name == "iron" or v3.Name == "gold")) or v3.Name == "diamond") then
										task.spawn(function()
											pcall(function()
												bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
											end)
											refreshbank()
										end)
									end
								end
							end
						end
					until (not AutoBank.Enabled)
				end)
			else
				if autobankui then
					autobankui:Destroy()
					autobankui = nil
				end
				local echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
				local chestitems = echest and echest:GetChildren() or {}
				if #chestitems > 0 then
					for i3,v3 in pairs(chestitems) do
						if v3:IsA("Accessory") and (v3.Name == "emerald" or v3.Name == "iron" or v3.Name == "diamond" or v3.Name == "apple" or v3.Name == "balloon") then
							task.spawn(function()
								pcall(function()
									bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
								end)
								refreshbank()
							end)
						end
					end
				end
			end
		end
	})
	AutoBankUIToggle = AutoBank.CreateToggle({
		Name = "UI",
		Function = function(callback)
			if autobankui then autobankui.Visible = callback end
		end,
		Default = true
	})
	AutoBankApple = AutoBank.CreateToggle({
		Name = "Apple",
		Function = function(callback) 
			if not callback then 
				local echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
				local chestitems = echest and echest:GetChildren() or {}
				for i3,v3 in pairs(chestitems) do
					if v3:IsA("Accessory") and v3.Name == "apple" then
						task.spawn(function()
							bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
							refreshbank()
						end)
					end
				end
			end
		end,
		Default = true
	})
	AutoBankBalloon = AutoBank.CreateToggle({
		Name = "Balloon",
		Function = function(callback) 
			if not callback then 
				local echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
				local chestitems = echest and echest:GetChildren() or {}
				for i3,v3 in pairs(chestitems) do
					if v3:IsA("Accessory") and v3.Name == "balloon" then
						task.spawn(function()
							bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
							refreshbank()
						end)
					end
				end
			end
		end,
		Default = true
	})
	AutoBankDeath = AutoBank.CreateToggle({
		Name = "Damage",
		Function = function() end,
		HoverText = "puts away resources when you take damage to prevent losing on death"
	})
	AutoBankStay = AutoBank.CreateToggle({
		Name = "Stay",
		Function = function() end,
		HoverText = "keeps resources until toggled off"
	})
	AutoBankRange = AutoBank.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 1,
		Max = 20,
		Default = 20
	})
end)

runFunction(function()
	local AutoConsume = {Enabled = false}
	local AutoConsumeHealth = {Value = 100}
	local AutoConsumeSpeed = {Enabled = true}
	local AutoConsumeDelay = tick()

	local function AutoConsumeFunc()
		if entityLibrary.isAlive then
			local speedpotion = getItem("speed_potion")
			if lplr.Character:GetAttribute("Health") <= (lplr.Character:GetAttribute("MaxHealth") - (100 - AutoConsumeHealth.Value)) then
				autobankapple = true
				local item = getItem("apple")
				local pot = getItem("heal_splash_potion")
				if (item or pot) and AutoConsumeDelay <= tick() then
					if item then
						bedwars.ClientHandler:Get(bedwars.EatRemote):CallServerAsync({
							item = item.tool
						})
						AutoConsumeDelay = tick() + 0.6
					else
						local newray = workspace:Raycast((oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, Vector3.new(0, -76, 0), bedwarsStore.blockRaycast)
						if newray ~= nil then
							bedwars.ClientHandler:Get(bedwars.ProjectileRemote):CallServerAsync(pot.tool, "heal_splash_potion", "heal_splash_potion", (oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, (oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, Vector3.new(0, -70, 0), game:GetService("HttpService"):GenerateGUID(), {drawDurationSeconds = 1})
						end
					end
				end
			else
				autobankapple = false
			end
			if speedpotion and (not lplr.Character:GetAttribute("StatusEffect_speed")) and AutoConsumeSpeed.Enabled then 
				bedwars.ClientHandler:Get(bedwars.EatRemote):CallServerAsync({
					item = speedpotion.tool
				})
			end
			if lplr.Character:GetAttribute("Shield_POTION") and ((not lplr.Character:GetAttribute("Shield_POTION")) or lplr.Character:GetAttribute("Shield_POTION") == 0) then
				local shield = getItem("big_shield") or getItem("mini_shield")
				if shield then
					bedwars.ClientHandler:Get(bedwars.EatRemote):CallServerAsync({
						item = shield.tool
					})
				end
			end
		end
	end

	AutoConsume = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoConsume",
		Function = function(callback)
			if callback then
				table.insert(AutoConsume.Connections, vapeEvents.InventoryAmountChanged.Event:Connect(AutoConsumeFunc))
				table.insert(AutoConsume.Connections, vapeEvents.AttributeChanged.Event:Connect(function(changed)
					if changed:find("Shield") or changed:find("Health") or changed:find("speed") then 
						AutoConsumeFunc()
					end
				end))
				AutoConsumeFunc()
			end
		end,
		HoverText = "Automatically heals for you when health or shield is under threshold."
	})
	AutoConsumeHealth = AutoConsume.CreateSlider({
		Name = "Health",
		Min = 1,
		Max = 99,
		Default = 70,
		Function = function() end
	})
	AutoConsumeSpeed = AutoConsume.CreateToggle({
		Name = "Speed Potions",
		Function = function() end,
		Default = true
	})
end)

runFunction(function()
	local AutoHotbarList = {Hotbars = {}, CurrentlySelected = 1}
	local AutoHotbarMode = {Value = "Toggle"}
	local AutoHotbarClear = {Enabled = false}
	local AutoHotbar = {Enabled = false}
	local AutoHotbarActive = false

	local function getCustomItem(v2)
		local realitem = v2.itemType
		if realitem == "swords" then
			local sword = getSword()
			realitem = sword and sword.itemType or "wood_sword"
		elseif realitem == "pickaxes" then
			local pickaxe = getPickaxe()
			realitem = pickaxe and pickaxe.itemType or "wood_pickaxe"
		elseif realitem == "axes" then
			local axe = getAxe()
			realitem = axe and axe.itemType or "wood_axe"
		elseif realitem == "bows" then
			local bow = getBow()
			realitem = bow and bow.itemType or "wood_bow"
		elseif realitem == "wool" then
			realitem = getWool() or "wool_white"
		end
		return realitem
	end
	
	local function findItemInTable(tab, item)
		for i, v in pairs(tab) do
			if v and v.itemType then
				if item.itemType == getCustomItem(v) then
					return i
				end
			end
		end
		return nil
	end

	local function findinhotbar(item)
		for i,v in pairs(bedwarsStore.localInventory.hotbar) do
			if v.item and v.item.itemType == item.itemType then
				return i, v.item
			end
		end
	end

	local function findininventory(item)
		for i,v in pairs(bedwarsStore.localInventory.inventory.items) do
			if v.itemType == item.itemType then
				return v
			end
		end
	end

	local function AutoHotbarSort()
		task.spawn(function()
			if AutoHotbarActive then return end
			AutoHotbarActive = true
			local items = (AutoHotbarList.Hotbars[AutoHotbarList.CurrentlySelected] and AutoHotbarList.Hotbars[AutoHotbarList.CurrentlySelected].Items or {})
			for i, v in pairs(bedwarsStore.localInventory.inventory.items) do 
				local customItem
				local hotbarslot = findItemInTable(items, v)
				if hotbarslot then
					local oldhotbaritem = bedwarsStore.localInventory.hotbar[tonumber(hotbarslot)]
					if oldhotbaritem.item and oldhotbaritem.item.itemType == v.itemType then continue end
					if oldhotbaritem.item then 
						bedwars.ClientStoreHandler:dispatch({
							type = "InventoryRemoveFromHotbar", 
							slot = tonumber(hotbarslot) - 1
						})
						vapeEvents.InventoryChanged.Event:Wait()
					end
					local newhotbaritemslot, newhotbaritem = findinhotbar(v)
					if newhotbaritemslot then
						bedwars.ClientStoreHandler:dispatch({
							type = "InventoryRemoveFromHotbar", 
							slot = newhotbaritemslot - 1
						})
						vapeEvents.InventoryChanged.Event:Wait()
					end
					if oldhotbaritem.item and newhotbaritemslot then 
						local nextitem1, nextitem1num = findininventory(oldhotbaritem.item)
						bedwars.ClientStoreHandler:dispatch({
							type = "InventoryAddToHotbar", 
							item = nextitem1, 
							slot = newhotbaritemslot - 1
						})
						vapeEvents.InventoryChanged.Event:Wait()
					end
					local nextitem2, nextitem2num = findininventory(v)
					bedwars.ClientStoreHandler:dispatch({
						type = "InventoryAddToHotbar", 
						item = nextitem2, 
						slot = tonumber(hotbarslot) - 1
					})
					vapeEvents.InventoryChanged.Event:Wait()
				else
					if AutoHotbarClear.Enabled then 
						local newhotbaritemslot, newhotbaritem = findinhotbar(v)
						if newhotbaritemslot then
							bedwars.ClientStoreHandler:dispatch({
								type = "InventoryRemoveFromHotbar", 
								slot = newhotbaritemslot - 1
							})
							vapeEvents.InventoryChanged.Event:Wait()
						end
					end
				end
			end
			AutoHotbarActive = false
		end)
	end

	AutoHotbar = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoHotbar",
		Function = function(callback) 
			if callback then
				AutoHotbarSort()
				if AutoHotbarMode.Value == "On Key" then
					if AutoHotbar.Enabled then 
						AutoHotbar.ToggleButton(false)
					end
				else
					table.insert(AutoHotbar.Connections, vapeEvents.InventoryAmountChanged.Event:Connect(function()
						if not AutoHotbar.Enabled then return end
						AutoHotbarSort()
					end))
				end
			end
		end,
		HoverText = "Automatically arranges hotbar to your liking."
	})
	AutoHotbarMode = AutoHotbar.CreateDropdown({
		Name = "Activation",
		List = {"On Key", "Toggle"},
		Function = function(val)
			if AutoHotbar.Enabled then
				AutoHotbar.ToggleButton(false)
				AutoHotbar.ToggleButton(false)
			end
		end
	})
	AutoHotbarList = CreateAutoHotbarGUI(AutoHotbar.Children, {
		Name = "lol"
	})
	AutoHotbarClear = AutoHotbar.CreateToggle({
		Name = "Clear Hotbar",
		Function = function() end
	})
end)

runFunction(function()
	local AutoKit = {Enabled = false}
	local AutoKitTrinity = {Value = "Void"}
	local oldfish
	local function GetTeammateThatNeedsMost()
		local plrs = GetAllNearestHumanoidToPosition(true, 30, 1000, true)
		local lowest, lowestplayer = 10000, nil
		for i,v in pairs(plrs) do
			if not v.Targetable then
				if v.Character:GetAttribute("Health") <= lowest and v.Character:GetAttribute("Health") < v.Character:GetAttribute("MaxHealth") then
					lowest = v.Character:GetAttribute("Health")
					lowestplayer = v
				end
			end
		end
		return lowestplayer
	end

	AutoKit = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoKit",
		Function = function(callback)
			if callback then
				oldfish = bedwars.FishermanTable.startMinigame
				bedwars.FishermanTable.startMinigame = function(Self, dropdata, func) func({win = true}) end
				task.spawn(function()
					repeat task.wait() until bedwarsStore.equippedKit ~= ""
					if AutoKit.Enabled then
						if bedwarsStore.equippedKit == "melody" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if getItem("guitar") then
										local plr = GetTeammateThatNeedsMost()
										if plr and healtick <= tick() then
											bedwars.ClientHandler:Get(bedwars.GuitarHealRemote):SendToServer({
												healTarget = plr.Character
											})
											healtick = tick() + 2
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "bigman" then
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionService:GetTagged("treeOrb")
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and v:FindFirstChild("Spirit") and (entityLibrary.character.HumanoidRootPart.Position - v.Spirit.Position).magnitude <= 20 then
											if bedwars.ClientHandler:Get(bedwars.TreeRemote):CallServer({
												treeOrbSecret = v:GetAttribute("TreeOrbSecret")
											}) then
												v:Destroy()
												collectionService:RemoveTag(v, "treeOrb")
											end
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "metal_detector" then
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionService:GetTagged("hidden-metal")
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and v.PrimaryPart and (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude <= 20 then
											bedwars.ClientHandler:Get(bedwars.PickupMetalRemote):SendToServer({
												id = v:GetAttribute("Id")
											}) 
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "battery" then 
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = bedwars.BatteryEffectController.liveBatteries
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - v.position).magnitude <= 10 then
											bedwars.ClientHandler:Get(bedwars.BatteryRemote):SendToServer({
												batteryId = i
											})
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "grim_reaper" then
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = bedwars.GrimReaperController.soulsByPosition
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and lplr.Character:GetAttribute("Health") <= (lplr.Character:GetAttribute("MaxHealth") / 4) and v.PrimaryPart and (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude <= 120 and (not lplr.Character:GetAttribute("GrimReaperChannel")) then
											bedwars.ClientHandler:Get(bedwars.ConsumeSoulRemote):CallServer({
												secret = v:GetAttribute("GrimReaperSoulSecret")
											})
											v:Destroy()
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "farmer_cletus" then 
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionService:GetTagged("BedwarsHarvestableCrop")
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - v.Position).magnitude <= 10 then
											bedwars.ClientHandler:Get("BedwarsHarvestCrop"):CallServerAsync({
												position = bedwars.BlockController:getBlockPosition(v.Position)
											}):andThen(function(suc)
												if suc then
													bedwars.GameAnimationUtil.playAnimation(lplr.Character, 1)
													bedwars.SoundManager:playSound(bedwars.SoundList.CROP_HARVEST)
												end
											end)
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "dragon_slayer" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if entityLibrary.isAlive then
										for i,v in pairs(bedwars.DragonSlayerController.dragonEmblems) do 
											if v.stackCount >= 3 then 
												bedwars.DragonSlayerController:deleteEmblem(i)
												local localPos = lplr.Character:GetPrimaryPartCFrame().Position
												local punchCFrame = CFrame.new(localPos, (i:GetPrimaryPartCFrame().Position * Vector3.new(1, 0, 1)) + Vector3.new(0, localPos.Y, 0))
												lplr.Character:SetPrimaryPartCFrame(punchCFrame)
												bedwars.DragonSlayerController:playPunchAnimation(punchCFrame - punchCFrame.Position)
												bedwars.ClientHandler:Get(bedwars.DragonRemote):SendToServer({
													target = i
												})
											end
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "mage" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if entityLibrary.isAlive then
										for i, v in pairs(collectionService:GetTagged("TomeGuidingBeam")) do 
											local obj = v.Parent and v.Parent.Parent and v.Parent.Parent.Parent
											if obj and (entityLibrary.character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude < 5 and obj:GetAttribute("TomeSecret") then
												local res = bedwars.ClientHandler:Get(bedwars.MageRemote):CallServer({
													secret = obj:GetAttribute("TomeSecret")
												})
												if res.success and res.element then 
													bedwars.GameAnimationUtil.playAnimation(lplr, bedwars.AnimationType.PUNCH)
													bedwars.ViewmodelController:playAnimation(bedwars.AnimationType.FP_USE_ITEM)
													bedwars.MageController:destroyTomeGuidingBeam()
													bedwars.MageController:playLearnLightBeamEffect(lplr, obj)
													local sound = bedwars.MageKitUtil.MageElementVisualizations[res.element].learnSound
													if sound and sound ~= "" then 
														bedwars.SoundManager:playSound(sound)
													end
													task.delay(bedwars.BalanceFile.LEARN_TOME_DURATION, function()
														bedwars.MageController:fadeOutTome(obj)
														if lplr.Character and res.element then
															bedwars.MageKitUtil.changeMageKitAppearance(lplr, lplr.Character, res.element)	
														end
													end)
												end
											end
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif bedwarsStore.equippedKit == "angel" then 
							table.insert(AutoKit.Connections, vapeEvents.AngelProgress.Event:Connect(function(angelTable)
								task.wait(0.5)
								if not AutoKit.Enabled then return end
								if bedwars.ClientStoreHandler:getState().Kit.angelProgress >= 1 and lplr.Character:GetAttribute("AngelType") == nil then
									bedwars.ClientHandler:Get(bedwars.TrinityRemote):SendToServer({
										angel = AutoKitTrinity.Value
									})
								end
							end))
						elseif bedwarsStore.equippedKit == "miner" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if entityLibrary.isAlive then
										for i,v in pairs(collectionService:GetTagged("petrified-player")) do 
											bedwars.ClientHandler:Get(bedwars.MinerRemote):SendToServer({
												petrifyId = v:GetAttribute("PetrifyId")
											})
										end
									end
								until (not AutoKit.Enabled)
							end)
						end
					end
				end)
			else
				bedwars.FishermanTable.startMinigame = oldfish
				oldfish = nil
			end
		end,
		HoverText = "Automatically uses a kits ability"
	})
	AutoKitTrinity = AutoKit.CreateDropdown({
		Name = "Angel",
		List = {"Void", "Light"},
		Function = function() end
	})
end)

runFunction(function()
	local AutoRelicCustom = {ObjectList = {}}

	local function findgoodmeta(relics)
		local tab = #AutoRelicCustom.ObjectList > 0 and AutoRelicCustom.ObjectList or {
			"embers_anguish",
			"knights_code",
			"quick_forge",
			"glass_cannon"
		}
		for i,v in pairs(relics) do 
			for i2,v2 in pairs(tab) do 
				if v.relic == v2 then
					return v.relic
				end
			end
		end
		return relics[1].relic
	end

	local AutoRelic = {Enabled = false}
	AutoRelic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoRelic",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						if bedwars.AppController:isAppOpen("RelicVotingInterface") then 
							bedwars.AppController:closeApp("RelicVotingInterface")
							local relictable = bedwars.ClientStoreHandler:getState().Bedwars.relic.voteState
							if relictable then 
								bedwars.RelicController:voteForRelic(findgoodmeta(relictable))
							end
							break
						end
						if matchState ~= 0 then break end
					until (not AutoRelic.Enabled)
				end)
			end
		end
	})
	AutoRelicCustom = AutoRelic.CreateTextList({
		Name = "Custom",
		TempText = "custom (relic id)"
	})
end)

runFunction(function()
	local AutoForge = {Enabled = false}
	local AutoForgeWeapon = {Value = "Sword"}
	local AutoForgeBow = {Enabled = false}
	local AutoForgeArmor = {Enabled = false}
	local AutoForgeSword = {Enabled = false}
	local AutoForgeBuyAfter = {Enabled = false}
	local AutoForgeNotification = {Enabled = true}

	local function buyForge(i)
		if not bedwarsStore.forgeUpgrades[i] or bedwarsStore.forgeUpgrades[i] < 6 then
			local cost = bedwars.ForgeUtil:getUpgradeCost(1, bedwarsStore.forgeUpgrades[i] or 0)
			if bedwarsStore.forgeMasteryPoints >= cost then 
				if AutoForgeNotification.Enabled then
					local forgeType = "none"
					for name,v in pairs(bedwars.ForgeConstants) do
						if v == i then forgeType = name:lower() end
					end
					warningNotification("AutoForge", "Purchasing "..forgeType..".", bedwars.ForgeUtil.FORGE_DURATION_SEC)
				end
				bedwars.ClientHandler:Get("ForgePurchaseUpgrade"):SendToServer(i)
				task.wait(bedwars.ForgeUtil.FORGE_DURATION_SEC + 0.2)
			end
		end
	end

	AutoForge = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoForge",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						if bedwarsStore.matchState == 1 and entityLibrary.isAlive then
							if entityLibrary.character.HumanoidRootPart.Velocity.Magnitude > 0.01 then continue end
							if AutoForgeArmor.Enabled then buyForge(bedwars.ForgeConstants.ARMOR) end
							if entityLibrary.character.HumanoidRootPart.Velocity.Magnitude > 0.01 then continue end
							if AutoForgeBow.Enabled then buyForge(bedwars.ForgeConstants.RANGED) end
							if entityLibrary.character.HumanoidRootPart.Velocity.Magnitude > 0.01 then continue end
							if AutoForgeSword.Enabled then
								if AutoForgeBuyAfter.Enabled then
									if not bedwarsStore.forgeUpgrades[bedwars.ForgeConstants.ARMOR] or bedwarsStore.forgeUpgrades[bedwars.ForgeConstants.ARMOR] < 6 then continue end
								end
								local weapon = bedwars.ForgeConstants[AutoForgeWeapon.Value:upper()]
								if weapon then buyForge(weapon) end
							end
						end
					until (not AutoForge.Enabled)
				end)
			end
		end
	})
	AutoForgeWeapon = AutoForge.CreateDropdown({
		Name = "Weapon",
		Function = function() end,
		List = {"Sword", "Dagger", "Scythe", "Great_Hammer"}
	})
	AutoForgeArmor = AutoForge.CreateToggle({
		Name = "Armor",
		Function = function() end,
		Default = true
	})
	AutoForgeSword = AutoForge.CreateToggle({
		Name = "Weapon",
		Function = function() end
	})
	AutoForgeBow = AutoForge.CreateToggle({
		Name = "Bow",
		Function = function() end
	})
	AutoForgeBuyAfter = AutoForge.CreateToggle({
		Name = "Buy After",
		Function = function() end,
		HoverText = "buy a weapon after armor is maxed"
	})
	AutoForgeNotification = AutoForge.CreateToggle({
		Name = "Notification",
		Function = function() end,
		Default = true
	})
end)

runFunction(function()
	local alreadyreportedlist = {}
	local AutoReportV2 = {Enabled = false}
	local AutoReportV2Notify = {Enabled = false}
	AutoReportV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoReportV2",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						for i,v in pairs(playersService:GetPlayers()) do 
							if v ~= lplr and alreadyreportedlist[v] == nil and v:GetAttribute("PlayerConnected") and WhitelistFunctions:GetWhitelist(v) == 0 and ({NebulawareFunctions:GetPlayerType(v)})[3] < 2 then 
								task.wait(1)
								alreadyreportedlist[v] = true
								bedwars.ClientHandler:Get(bedwars.ReportRemote):SendToServer(v.UserId)
								bedwarsStore.statistics.reported = bedwarsStore.statistics.reported + 1
								if AutoReportV2Notify.Enabled then 
									warningNotification("AutoReportV2", "Reported "..v.Name, 15)
								end
							end
						end
					until (not AutoReportV2.Enabled)
				end)
			end	
		end,
		HoverText = "dv mald"
	})
	AutoReportV2Notify = AutoReportV2.CreateToggle({
		Name = "Notify",
		Function = function() end
	})
end)

runFunction(function()
	local justsaid = ""
	local leavesaid = false
	local alreadyreported = {}

	local function removerepeat(str)
		local newstr = ""
		local lastlet = ""
		for i,v in pairs(str:split("")) do 
			if v ~= lastlet then
				newstr = newstr..v 
				lastlet = v
			end
		end
		return newstr
	end

	local reporttable = {
		gay = "Bullying",
		gae = "Bullying",
		gey = "Bullying",
		hack = "Scamming",
		exploit = "Scamming",
		cheat = "Scamming",
		hecker = "Scamming",
		haxker = "Scamming",
		hacer = "Scamming",
		report = "Bullying",
		fat = "Bullying",
		black = "Bullying",
		getalife = "Bullying",
		fatherless = "Bullying",
		report = "Bullying",
		fatherless = "Bullying",
		disco = "Offsite Links",
		yt = "Offsite Links",
		dizcourde = "Offsite Links",
		retard = "Swearing",
		bad = "Bullying",
		trash = "Bullying",
		nolife = "Bullying",
		nolife = "Bullying",
		loser = "Bullying",
		killyour = "Bullying",
		kys = "Bullying",
		hacktowin = "Bullying",
		bozo = "Bullying",
		kid = "Bullying",
		adopted = "Bullying",
		linlife = "Bullying",
		commitnotalive = "Bullying",
		vape = "Offsite Links",
		futureclient = "Offsite Links",
		download = "Offsite Links",
		youtube = "Offsite Links",
		die = "Bullying",
		lobby = "Bullying",
		ban = "Bullying",
		wizard = "Bullying",
		wisard = "Bullying",
		witch = "Bullying",
		magic = "Bullying",
	}
	local reporttableexact = {
		L = "Bullying",
	}
	

	local function findreport(msg)
		local checkstr = removerepeat(msg:gsub("%W+", ""):lower())
		for i,v in pairs(reporttable) do 
			if checkstr:find(i) then 
				return v, i
			end
		end
		for i,v in pairs(reporttableexact) do 
			if checkstr == i then 
				return v, i
			end
		end
		for i,v in pairs(AutoToxicPhrases5.ObjectList) do 
			if checkstr:find(v) then 
				return "Bullying", v
			end
		end
		return nil
	end

	AutoToxic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoToxic",
		Function = function(callback)
			if callback then 
				table.insert(AutoToxic.Connections, vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
					if AutoToxicBedDestroyed.Enabled and bedTable.brokenBedTeam.id == lplr:GetAttribute("Team") then
						local custommsg = #AutoToxicPhrases6.ObjectList > 0 and AutoToxicPhrases6.ObjectList[math.random(1, #AutoToxicPhrases6.ObjectList)] or "How dare you break my bed >:( <name> | vxpe on top"
						if custommsg then
							custommsg = custommsg:gsub("<name>", (bedTable.player.DisplayName or bedTable.player.Name))
						end
						textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
					elseif AutoToxicBedBreak.Enabled and bedTable.player.UserId == lplr.UserId then
						local custommsg = #AutoToxicPhrases7.ObjectList > 0 and AutoToxicPhrases7.ObjectList[math.random(1, #AutoToxicPhrases7.ObjectList)] or "nice bed <teamname> | vxpe on top"
						if custommsg then
							local team = bedwars.QueueMeta[bedwarsStore.queueType].teams[tonumber(bedTable.brokenBedTeam.id)]
							local teamname = team and team.displayName:lower() or "white"
							custommsg = custommsg:gsub("<teamname>", teamname)
						end
						textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
					end
				end))
				table.insert(AutoToxic.Connections, vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill then
						local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
						local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
						if not killed or not killer then return end
						if killed == lplr then 
							if (not leavesaid) and killer ~= lplr and AutoToxicDeath.Enabled then
								leavesaid = true
								local custommsg = #AutoToxicPhrases3.ObjectList > 0 and AutoToxicPhrases3.ObjectList[math.random(1, #AutoToxicPhrases3.ObjectList)] or "My gaming chair expired midfight, thats why you won <name> | vxpe on top"
								if custommsg then
									custommsg = custommsg:gsub("<name>", (killer.DisplayName or killer.Name))
								end
								textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
							end
						else
							if killer == lplr and AutoToxicFinalKill.Enabled then 
								local custommsg = #AutoToxicPhrases2.ObjectList > 0 and AutoToxicPhrases2.ObjectList[math.random(1, #AutoToxicPhrases2.ObjectList)] or "L <name> | vxpe on top"
								if custommsg == lastsaid then
									custommsg = #AutoToxicPhrases2.ObjectList > 0 and AutoToxicPhrases2.ObjectList[math.random(1, #AutoToxicPhrases2.ObjectList)] or "L <name> | vxpe on top"
								else
									lastsaid = custommsg
								end
								if custommsg then
									custommsg = custommsg:gsub("<name>", (killed.DisplayName or killed.Name))
								end
								textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
							end
						end
					end
				end))
				table.insert(AutoToxic.Connections, vapeEvents.MatchEndEvent.Event:Connect(function(winstuff)
					local myTeam = bedwars.ClientStoreHandler:getState().Game.myTeam
					if myTeam and myTeam.id == winstuff.winningTeamId or lplr.Neutral then
						if AutoToxicGG.Enabled then
							textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("gg")
							if shared.ggfunction then
								shared.ggfunction()
							end
						end
						if AutoToxicWin.Enabled then
							textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(#AutoToxicPhrases.ObjectList > 0 and AutoToxicPhrases.ObjectList[math.random(1, #AutoToxicPhrases.ObjectList)] or "EZ L TRASH KIDS | vxpe on top")
						end
					end
				end))
				table.insert(AutoToxic.Connections, vapeEvents.LagbackEvent.Event:Connect(function(plr)
					if AutoToxicLagback.Enabled then
						local custommsg = #AutoToxicPhrases8.ObjectList > 0 and AutoToxicPhrases8.ObjectList[math.random(1, #AutoToxicPhrases8.ObjectList)]
						if custommsg then
							custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
						end
						local msg = custommsg or "Imagine lagbacking L "..(plr.DisplayName or plr.Name).." | vxpe on top"
						textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
					end
				end))
				table.insert(AutoToxic.Connections, textChatService.MessageReceived:Connect(function(tab)
					if AutoToxicRespond.Enabled then
						local plr = playersService:GetPlayerByUserId(tab.TextSource.UserId)
						local args = tab.Text:split(" ")
						if plr and plr ~= lplr and not alreadyreported[plr] then
							local reportreason, reportedmatch = findreport(tab.Text)
							if reportreason then 
								alreadyreported[plr] = true
								local custommsg = #AutoToxicPhrases4.ObjectList > 0 and AutoToxicPhrases4.ObjectList[math.random(1, #AutoToxicPhrases4.ObjectList)]
								if custommsg then
									custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
								end
								local msg = custommsg or "I don't care about the fact that I'm hacking, I care about you dying in a block game. L "..(plr.DisplayName or plr.Name).." | vxpe on top"
								textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
							end
						end
					end
				end))
			end
		end
	})
	AutoToxicGG = AutoToxic.CreateToggle({
		Name = "AutoGG",
		Function = function() end, 
		Default = true
	})
	AutoToxicWin = AutoToxic.CreateToggle({
		Name = "Win",
		Function = function() end, 
		Default = true
	})
	AutoToxicDeath = AutoToxic.CreateToggle({
		Name = "Death",
		Function = function() end, 
		Default = true
	})
	AutoToxicBedBreak = AutoToxic.CreateToggle({
		Name = "Bed Break",
		Function = function() end, 
		Default = true
	})
	AutoToxicBedDestroyed = AutoToxic.CreateToggle({
		Name = "Bed Destroyed",
		Function = function() end, 
		Default = true
	})
	AutoToxicRespond = AutoToxic.CreateToggle({
		Name = "Respond",
		Function = function() end, 
		Default = true
	})
	AutoToxicFinalKill = AutoToxic.CreateToggle({
		Name = "Final Kill",
		Function = function() end, 
		Default = true
	})
	AutoToxicTeam = AutoToxic.CreateToggle({
		Name = "Teammates",
		Function = function() end, 
	})
	AutoToxicLagback = AutoToxic.CreateToggle({
		Name = "Lagback",
		Function = function() end, 
		Default = true
	})
	AutoToxicPhrases = AutoToxic.CreateTextList({
		Name = "ToxicList",
		TempText = "phrase (win)",
	})
	AutoToxicPhrases2 = AutoToxic.CreateTextList({
		Name = "ToxicList2",
		TempText = "phrase (kill) <name>",
	})
	AutoToxicPhrases3 = AutoToxic.CreateTextList({
		Name = "ToxicList3",
		TempText = "phrase (death) <name>",
	})
	AutoToxicPhrases7 = AutoToxic.CreateTextList({
		Name = "ToxicList7",
		TempText = "phrase (bed break) <teamname>",
	})
	AutoToxicPhrases7.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases6 = AutoToxic.CreateTextList({
		Name = "ToxicList6",
		TempText = "phrase (bed destroyed) <name>",
	})
	AutoToxicPhrases6.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases4 = AutoToxic.CreateTextList({
		Name = "ToxicList4",
		TempText = "phrase (text to respond with) <name>",
	})
	AutoToxicPhrases4.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases5 = AutoToxic.CreateTextList({
		Name = "ToxicList5",
		TempText = "phrase (text to respond to)",
	})
	AutoToxicPhrases5.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases8 = AutoToxic.CreateTextList({
		Name = "ToxicList8",
		TempText = "phrase (lagback) <name>",
	})
	AutoToxicPhrases8.Object.AddBoxBKG.AddBox.TextSize = 12
end)

runFunction(function()
	local ChestStealer = {Enabled = false}
	local ChestStealerDistance = {Value = 1}
	local ChestStealerDelay = {Value = 1}
	local ChestStealerOpen = {Enabled = false}
	local ChestStealerSkywars = {Enabled = true}
	local cheststealerdelays = {}
	local cheststealerfuncs = {
		Open = function()
			if bedwars.AppController:isAppOpen("ChestApp") then
				local chest = lplr.Character:FindFirstChild("ObservedChestFolder")
				local chestitems = chest and chest.Value and chest.Value:GetChildren() or {}
				if #chestitems > 0 then
					for i3,v3 in pairs(chestitems) do
						if v3:IsA("Accessory") and (cheststealerdelays[v3] == nil or cheststealerdelays[v3] < tick()) then
							task.spawn(function()
								pcall(function()
									cheststealerdelays[v3] = tick() + 0.2
									bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(chest.Value, v3)
								end)
							end)
							task.wait(ChestStealerDelay.Value / 100)
						end
					end
				end
			end
		end,
		Closed = function()
			for i, v in pairs(collectionService:GetTagged("chest")) do
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= ChestStealerDistance.Value then
					local chest = v:FindFirstChild("ChestFolderValue")
					chest = chest and chest.Value or nil
					local chestitems = chest and chest:GetChildren() or {}
					if #chestitems > 0 then
						bedwars.ClientHandler:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(chest)
						for i3,v3 in pairs(chestitems) do
							if v3:IsA("Accessory") then
								task.spawn(function()
									pcall(function()
										bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(v.ChestFolderValue.Value, v3)
									end)
								end)
								task.wait(ChestStealerDelay.Value / 100)
							end
						end
						bedwars.ClientHandler:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
					end
				end
			end
		end
	}

	ChestStealer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ChestStealer",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until bedwarsStore.queueType ~= "bedwars_test"
					if (not ChestStealerSkywars.Enabled) or bedwarsStore.queueType:find("skywars") then
						repeat 
							task.wait(0.1)
							if entityLibrary.isAlive then
								cheststealerfuncs[ChestStealerOpen.Enabled and "Open" or "Closed"]()
							end
						until (not ChestStealer.Enabled)
					end
				end)
			end
		end,
		HoverText = "Grabs items from near chests."
	})
	ChestStealerDistance = ChestStealer.CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 18,
		Function = function() end,
		Default = 18
	})
	ChestStealerDelay = ChestStealer.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Function = function() end,
		Default = 1,
		Double = 100
	})
	ChestStealerOpen = ChestStealer.CreateToggle({
		Name = "GUI Check",
		Function = function() end
	})
	ChestStealerSkywars = ChestStealer.CreateToggle({
		Name = "Only Skywars",
		Function = function() end,
		Default = true
	})
end)

runFunction(function()
	local FastDrop = {Enabled = false}
	FastDrop = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "FastDrop",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						if entityLibrary.isAlive and (not bedwarsStore.localInventory.opened) and (inputService:IsKeyDown(Enum.KeyCode.Q) or inputService:IsKeyDown(Enum.KeyCode.Backspace)) and inputService:GetFocusedTextBox() == nil then
							task.spawn(bedwars.DropItem)
						end
					until (not FastDrop.Enabled)
				end)
			end
		end,
		HoverText = "Drops items fast when you hold Q"
	})
end)

local denyregions = {}
runFunction(function()
	local ignoreplaceregions = {Enabled = false}
	ignoreplaceregions = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "IgnorePlaceRegions",
		Function = function(callback)
			if callback then
				denyregions = bedwars.MapController.denyRegions
				task.spawn(function()
					repeat
						bedwars.MapController.denyRegions = {}
						task.wait()
					until (not ignoreplaceregions.Enabled)
				end)
			else 
				bedwars.MapController.denyRegions = denyregions
			end
		end
	})
end)

runFunction(function()
	local MissileTP = {Enabled = false}
	local MissileTeleportDelaySlider = {Value = 30}
	MissileTP = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "MissileTP",
		Function = function(callback)
			if callback then
				task.spawn(function()
					if getItem("guided_missile") then
						local plr = EntityNearMouse(1000)
						if plr then
							local projectile = bedwars.RuntimeLib.await(bedwars.MissileController.fireGuidedProjectile:CallServerAsync("guided_missile"))
							if projectile then
								local projectilemodel = projectile.model
								if not projectilemodel.PrimaryPart then
									projectilemodel:GetPropertyChangedSignal("PrimaryPart"):Wait()
								end;
								local bodyforce = Instance.new("BodyForce")
								bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
								bodyforce.Name = "AntiGravity"
								bodyforce.Parent = projectilemodel.PrimaryPart

								repeat
									task.wait()
									if projectile.model then
										if plr then
											projectile.model:SetPrimaryPartCFrame(CFrame.new(plr.RootPart.CFrame.p, plr.RootPart.CFrame.p + gameCamera.CFrame.lookVector))
										else
											warningNotification("MissileTP", "Player died before it could TP.", 3)
											break
										end
									end
								until projectile.model.Parent == nil
							else
								warningNotification("MissileTP", "Missile on cooldown.", 3)
							end
						else
							warningNotification("MissileTP", "Player not found.", 3)
						end
					else
						warningNotification("MissileTP", "Missile not found.", 3)
					end
				end)
				MissileTP.ToggleButton(true)
			end
		end,
		HoverText = "Spawns and teleports a missile to a player\nnear your mouse."
	})
end)

runFunction(function()
	local OpenEnderchest = {Enabled = false}
	OpenEnderchest = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "OpenEnderchest",
		Function = function(callback)
			if callback then
				local echest = replicatedStorageService.Inventories:FindFirstChild(lplr.Name.."_personal")
				if echest then
					bedwars.AppController:openApp("ChestApp", {})
					bedwars.ChestController:openChest(echest)
				else
					warningNotification("OpenEnderchest", "Enderchest not found", 5)
				end
				OpenEnderchest.ToggleButton(false)
			end
		end,
		HoverText = "Opens the enderchest"
	})
end)

runFunction(function()
	local PickupRangeRange = {Value = 1}
	local PickupRange = {Enabled = false}
	PickupRange = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "PickupRange", 
		Function = function(callback)
			if callback then
				local pickedup = {}
				task.spawn(function()
					repeat
						local itemdrops = collectionService:GetTagged("ItemDrop")
						for i,v in pairs(itemdrops) do
							if entityLibrary.isAlive and (v:GetAttribute("ClientDropTime") and tick() - v:GetAttribute("ClientDropTime") > 2 or v:GetAttribute("ClientDropTime") == nil) then
								if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= PickupRangeRange.Value and (pickedup[v] == nil or pickedup[v] <= tick()) then
									task.spawn(function()
										pickedup[v] = tick() + 0.2
										bedwars.ClientHandler:Get(bedwars.PickupRemote):CallServerAsync({
											itemDrop = v
										}):andThen(function(suc)
											if suc then
												bedwars.SoundManager:playSound(bedwars.SoundList.PICKUP_ITEM_DROP)
											end
										end)
									end)
								end
							end
						end
						task.wait()
					until (not PickupRange.Enabled)
				end)
			end
		end
	})
	PickupRangeRange = PickupRange.CreateSlider({
		Name = "Range",
		Min = 1,
		Max = 10, 
		Function = function() end,
		Default = 10
	})
end)

runFunction(function()
	local BowExploit = {Enabled = false}
	local BowExploitTarget = {Value = "Mouse"}
	local BowExploitAutoShootFOV = {Value = 1000}
	local oldrealremote
	local noveloproj = {
		"fireball",
		"telepearl"
	}

	BowExploit = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ProjectileExploit",
		Function = function(callback)
			if callback then 
				oldrealremote = bedwars.ClientConstructor.Function.new
				bedwars.ClientConstructor.Function.new = function(self, ind, ...)
					local res = oldrealremote(self, ind, ...)
					local oldRemote = res.instance
					if oldRemote and oldRemote.Name == bedwars.ProjectileRemote then 
						res.instance = {InvokeServer = function(self, shooting, proj, proj2, launchpos1, launchpos2, launchvelo, tag, tab1, ...) 
							local plr
							if BowExploitTarget.Value == "Mouse" then 
								plr = EntityNearMouse(10000)
							else
								plr = EntityNearPosition(BowExploitAutoShootFOV.Value, true)
							end
							if plr then	
								if not ({WhitelistFunctions:GetWhitelist(plr.Player)})[2] then 
									return oldRemote:InvokeServer(shooting, proj, proj2, launchpos1, launchpos2, launchvelo, tag, tab1, ...)
								end
								if not ({NebulawareFunctions:GetPlayerType(plr.Player)})[2] then
									return oldRemote:InvokeServer(shooting, proj, proj2, launchpos1, launchpos2, launchvelo, tag, tab1, ...)
								end
								tab1.drawDurationSeconds = 1
								repeat
									task.wait(0.03)
									local offsetStartPos = plr.RootPart.CFrame.p - plr.RootPart.CFrame.lookVector
									local pos = plr.RootPart.Position
									local playergrav = workspace.Gravity
									local balloons = plr.Character:GetAttribute("InflatedBalloons")
									if balloons and balloons > 0 then 
										playergrav = (workspace.Gravity * (1 - ((balloons >= 4 and 1.2 or balloons >= 3 and 1 or 0.975))))
									end
									if plr.Character.PrimaryPart:FindFirstChild("rbxassetid://8200754399") then 
										playergrav = (workspace.Gravity * 0.3)
									end
									local newLaunchVelo = bedwars.ProjectileMeta[proj2].launchVelocity
									local shootpos, shootvelo = predictGravity(pos, plr.RootPart.Velocity, (pos - offsetStartPos).Magnitude / newLaunchVelo, plr, playergrav)
									if proj2 == "telepearl" then
										shootpos = pos
										shootvelo = Vector3.zero
									end
									local newlook = CFrame.new(offsetStartPos, shootpos) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))
									shootpos = newlook.p + (newlook.lookVector * (offsetStartPos - shootpos).magnitude)
									local calculated = LaunchDirection(offsetStartPos, shootpos, newLaunchVelo, workspace.Gravity, false)
									if calculated then 
										launchvelo = calculated
										launchpos1 = offsetStartPos
										launchpos2 = offsetStartPos
										tab1.drawDurationSeconds = 1
									else
										break
									end
									if oldRemote:InvokeServer(shooting, proj, proj2, launchpos1, launchpos2, launchvelo, tag, tab1, workspace:GetServerTimeNow() - 0.045) then break end
								until false
							else
								return oldRemote:InvokeServer(shooting, proj, proj2, launchpos1, launchpos2, launchvelo, tag, tab1, ...)
							end
						end}
					end
					return res
				end
			else
				bedwars.ClientConstructor.Function.new = oldrealremote
				oldrealremote = nil
			end
		end
	})
	BowExploitTarget = BowExploit.CreateDropdown({
		Name = "Mode",
		List = {"Mouse", "Range"},
		Function = function() end
	})
	BowExploitAutoShootFOV = BowExploit.CreateSlider({
		Name = "FOV",
		Function = function() end,
		Min = 1,
		Max = 1000,
		Default = 1000
	})
end)

runFunction(function()
	local RavenTP = {Enabled = false}
	RavenTP = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "RavenTP",
		Function = function(callback)
			if callback then
				task.spawn(function()
					if getItem("raven") then
						local plr = EntityNearMouse(1000)
						if plr then
							local projectile = bedwars.ClientHandler:Get(bedwars.SpawnRavenRemote):CallServerAsync():andThen(function(projectile)
								if projectile then
									local projectilemodel = projectile
									if not projectilemodel then
										projectilemodel:GetPropertyChangedSignal("PrimaryPart"):Wait()
									end
									local bodyforce = Instance.new("BodyForce")
									bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
									bodyforce.Name = "AntiGravity"
									bodyforce.Parent = projectilemodel.PrimaryPart
	
									if plr then
										projectilemodel:SetPrimaryPartCFrame(CFrame.new(plr.RootPart.CFrame.p, plr.RootPart.CFrame.p + gameCamera.CFrame.lookVector))
										task.wait(0.3)
										bedwars.RavenTable:detonateRaven()
									else
										warningNotification("RavenTP", "Player died before it could TP.", 3)
									end
								else
									warningNotification("RavenTP", "Raven on cooldown.", 3)
								end
							end)
						else
							warningNotification("RavenTP", "Player not found.", 3)
						end
					else
						warningNotification("RavenTP", "Raven not found.", 3)
					end
				end)
				RavenTP.ToggleButton(true)
			end
		end,
		HoverText = "Spawns and teleports a raven to a player\nnear your mouse."
	})
end)

runFunction(function()
	local SetEmote = {Enabled = false}
	local SetEmoteList = {Value = ""}
	local oldemote
	local SetEmoteName2 = {}
	SetEmote = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "SetEmote",
		Function = function(callback)
			if callback then
				oldemote = bedwars.ClientStoreHandler:getState().Locker.selectedSpray
				task.spawn(function()
					repeat task.wait() until matchState ~= 0 or not SetEmote.Enabled
					if SetEmote.Enabled then
						oldemote = bedwars.ClientStoreHandler:getState().Locker.selectedSpray
						bedwars.ClientStoreHandler:getState().Locker.selectedSpray = SetEmoteName2[SetEmoteList.Value]
					end
				end)
			else
				if oldemote then 
					bedwars.ClientStoreHandler:getState().Locker.selectedSpray = oldemote
					oldemote = nil 
				end
			end
		end
	})
	local SetEmoteName = {}
	for i,v in pairs(bedwars.EmoteMeta) do 
		table.insert(SetEmoteName, v.name)
		SetEmoteName2[v.name] = i
	end
	table.sort(SetEmoteName, function(a, b) return a:lower() < b:lower() end)
	SetEmoteList = SetEmote.CreateDropdown({
		Name = "Emote",
		List = SetEmoteName,
		Function = function()
			if SetEmote.Enabled then 
				bedwars.ClientStoreHandler:getState().Locker.selectedSpray = SetEmoteName2[SetEmoteList.Value]
			end
		end
	})
end)

runFunction(function()
	local tiered = {}
	local nexttier = {}

	for i,v in pairs(bedwars.ShopItems) do
		if type(v) == "table" then 
			if v.tiered then
				tiered[v.itemType] = v.tiered
			end
			if v.nextTier then
				nexttier[v.itemType] = v.nextTier
			end
		end
	end

	GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ShopTierBypass",
		Function = function(callback) 
			if callback then
				for i,v in pairs(bedwars.ShopItems) do
					if type(v) == "table" then 
						v.tiered = nil
						v.nextTier = nil
					end
				end
			else
				for i,v in pairs(bedwars.ShopItems) do
					if type(v) == "table" then 
						if tiered[v.itemType] then
							v.tiered = tiered[v.itemType]
						end
						if nexttier[v.itemType] then
							v.nextTier = nexttier[v.itemType]
						end
					end
				end
			end
		end,
		HoverText = "Allows you to access tiered items early."
	})
end)

local lagbackedaftertouch = false
runFunction(function()
	local AntiVoidPart
	local AntiVoidConnection
	local AntiVoidMode = {Value = "Normal"}
	local AntiVoidMoveMode = {Value = "Normal"}
	local AntiVoid = {Enabled = false}
	local AntiVoidTransparent = {Value = 50}
	local AntiVoidColor = {Hue = 1, Sat = 1, Value = 0.55}
	local lastvalidpos

	local function closestpos(block)
		local startpos = block.Position - (block.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		local endpos = block.Position + (block.Size / 2) - Vector3.new(1.5, 1.5, 1.5)
		local newpos = block.Position + (entityLibrary.character.HumanoidRootPart.Position - block.Position)
		return Vector3.new(math.clamp(newpos.X, startpos.X, endpos.X), endpos.Y + 3, math.clamp(newpos.Z, startpos.Z, endpos.Z))
	end

	local function getclosesttop(newmag)
		local closest, closestmag = nil, newmag * 3
		if entityLibrary.isAlive then 
			local tops = {}
			for i,v in pairs(bedwarsStore.blocks) do 
				local close = getScaffold(closestpos(v), false)
				if getPlacedBlock(close) then continue end
				if close.Y < entityLibrary.character.HumanoidRootPart.Position.Y then continue end
				if (close - entityLibrary.character.HumanoidRootPart.Position).magnitude <= newmag * 3 then 
					table.insert(tops, close)
				end
			end
			for i,v in pairs(tops) do 
				local mag = (v - entityLibrary.character.HumanoidRootPart.Position).magnitude
				if mag <= closestmag then 
					closest = v
					closestmag = mag
				end
			end
		end
		return closest
	end

	local antivoidypos = 0
	local antivoiding = false
	AntiVoid = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "AntiVoid", 
		Function = function(callback)
			if callback then
				task.spawn(function()
					AntiVoidPart = Instance.new("Part")
					AntiVoidPart.CanCollide = AntiVoidMode.Value == "Collide"
					AntiVoidPart.Size = Vector3.new(10000, 1, 10000)
					AntiVoidPart.Anchored = true
					AntiVoidPart.Material = Enum.Material.Neon
					AntiVoidPart.Color = Color3.fromHSV(AntiVoidColor.Hue, AntiVoidColor.Sat, AntiVoidColor.Value)
					AntiVoidPart.Transparency = 1 - (AntiVoidTransparent.Value / 100)
					AntiVoidPart.Position = Vector3.new(0, antivoidypos, 0)
					AntiVoidPart.Parent = workspace
					if AntiVoidMoveMode.Value == "Classic" and antivoidypos == 0 then 
						AntiVoidPart.Parent = nil
					end
					AntiVoidConnection = AntiVoidPart.Touched:Connect(function(touchedpart)
						if touchedpart.Parent == lplr.Character and entityLibrary.isAlive then
							if (not antivoiding) and (not GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled) and entityLibrary.character.Humanoid.Health > 0 and AntiVoidMode.Value ~= "Collide" then
								if AntiVoidMode.Value == "Velocity" then
									entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 100, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								else
									antivoiding = true
									local pos = getclosesttop(1000)
									if pos then
										local lastTeleport = lplr:GetAttribute("LastTeleported")
										RunLoops:BindToHeartbeat("AntiVoid", function(dt)
											if entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and isnetworkowner(entityLibrary.character.HumanoidRootPart) and (entityLibrary.character.HumanoidRootPart.Position - pos).Magnitude > 1 and AntiVoid.Enabled and lplr:GetAttribute("LastTeleported") == lastTeleport then 
												local hori1 = Vector3.new(entityLibrary.character.HumanoidRootPart.Position.X, 0, entityLibrary.character.HumanoidRootPart.Position.Z)
												local hori2 = Vector3.new(pos.X, 0, pos.Z)
												local newpos = (hori2 - hori1).Unit
												local realnewpos = CFrame.new(newpos == newpos and entityLibrary.character.HumanoidRootPart.CFrame.p + (newpos * ((3 + getSpeed()) * dt)) or Vector3.zero)
												entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(realnewpos.p.X, pos.Y, realnewpos.p.Z)
												antivoidvelo = newpos == newpos and newpos * 20 or Vector3.zero
												entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(antivoidvelo.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, antivoidvelo.Z)
												if getPlacedBlock((entityLibrary.character.HumanoidRootPart.CFrame.p - Vector3.new(0, 1, 0)) + entityLibrary.character.HumanoidRootPart.Velocity.Unit) or getPlacedBlock(entityLibrary.character.HumanoidRootPart.CFrame.p + Vector3.new(0, 3)) then
													pos = pos + Vector3.new(0, 1, 0)
												end
											else
												RunLoops:UnbindFromHeartbeat("AntiVoid")
												antivoidvelo = nil
												antivoiding = false
											end
										end)
									else
										entityLibrary.character.HumanoidRootPart.CFrame += Vector3.new(0, 100000, 0)
										antivoiding = false
									end
								end
							end
						end
					end)
					repeat
						if entityLibrary.isAlive and AntiVoidMoveMode.Value == "Normal" then 
							local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), bedwarsStore.blockRaycast)
							if ray or GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled then 
								AntiVoidPart.Position = entityLibrary.character.HumanoidRootPart.Position - Vector3.new(0, 21, 0)
							end
						end
						task.wait()
					until (not AntiVoid.Enabled)
				end)
			else
				if AntiVoidConnection then AntiVoidConnection:Disconnect() end
				if AntiVoidPart then
					AntiVoidPart:Destroy() 
				end
			end
		end, 
		HoverText = "Gives you a chance to get on land (Bouncing Twice, abusing, or bad luck will lead to lagbacks)"
	})
	AntiVoidMoveMode = AntiVoid.CreateDropdown({
		Name = "Position Mode",
		Function = function(val) 
			if val == "Classic" then 
				task.spawn(function()
					repeat task.wait() until bedwarsStore.matchState ~= 0 or not vapeInjected
					if vapeInjected and AntiVoidMoveMode.Value == "Classic" and antivoidypos == 0 and AntiVoid.Enabled then
						local lowestypos = 99999
						for i,v in pairs(bedwarsStore.blocks) do 
							local newray = workspace:Raycast(v.Position + Vector3.new(0, 800, 0), Vector3.new(0, -1000, 0), bedwarsStore.blockRaycast)
							if i % 200 == 0 then 
								task.wait(0.06)
							end
							if newray and newray.Position.Y <= lowestypos then
								lowestypos = newray.Position.Y
							end
						end
						antivoidypos = lowestypos - 8
					end
					if AntiVoidPart then 
						AntiVoidPart.Position = Vector3.new(0, antivoidypos, 0)
						AntiVoidPart.Parent = workspace
					end
				end)
			end
		end,
		List = {"Normal", "Classic"}
	})
	AntiVoidMode = AntiVoid.CreateDropdown({
		Name = "Move Mode",
		Function = function(val) 
			if AntiVoidPart then 
				AntiVoidPart.CanCollide = val == "Collide"
			end
		end,
		List = {"Normal", "Collide", "Velocity"}
	})
	AntiVoidTransparent = AntiVoid.CreateSlider({
		Name = "Invisible",
		Min = 1,
		Max = 100,
		Default = 50,
		Function = function(val) 
			if AntiVoidPart then
				AntiVoidPart.Transparency = 1 - (val / 100)
			end
		end,
	})
	AntiVoidColor = AntiVoid.CreateColorSlider({
		Name = "Color",
		Function = function(h, s, v) 
			if AntiVoidPart then
				AntiVoidPart.Color = Color3.fromHSV(h, s, v)
			end
		end
	})
end)

runFunction(function()
	local oldenable2
	local olddisable2
	local oldhitblock
	local blockplacetable2 = {}
	local blockplaceenabled2 = false

	local AutoTool = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "AutoTool",
		Function = function(callback)
			if callback then
				oldenable2 = bedwars.BlockBreaker.enable
				olddisable2 = bedwars.BlockBreaker.disable
				oldhitblock = bedwars.BlockBreaker.hitBlock
				bedwars.BlockBreaker.enable = function(Self, tab)
					blockplaceenabled2 = true
					blockplacetable2 = Self
					return oldenable2(Self, tab)
				end
				bedwars.BlockBreaker.disable = function(Self)
					blockplaceenabled2 = false
					return olddisable2(Self)
				end
				bedwars.BlockBreaker.hitBlock = function(...)
					if entityLibrary.isAlive and (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"].Api.Enabled == false or bedwarsStore.matchState ~= 0) and blockplaceenabled2 then
						local mouseinfo = blockplacetable2.clientManager:getBlockSelector():getMouseInfo(0)
						if mouseinfo and mouseinfo.target and not mouseinfo.target.blockInstance:GetAttribute("NoBreak") and not mouseinfo.target.blockInstance:GetAttribute("Team"..(lplr:GetAttribute("Team") or 0).."NoBreak") then
							if switchToAndUseTool(mouseinfo.target.blockInstance, true) then
								return
							end
						end
					end
					return oldhitblock(...)
				end
			else
				RunLoops:UnbindFromRenderStep("AutoTool")
				bedwars.BlockBreaker.enable = oldenable2
				bedwars.BlockBreaker.disable = olddisable2
				bedwars.BlockBreaker.hitBlock = oldhitblock
				oldenable2 = nil
				olddisable2 = nil
				oldhitblock = nil
			end
		end,
		HoverText = "Automatically swaps your hand to the appropriate tool."
	})
end)

runFunction(function()
	local BedProtector = {Enabled = false}
	local bedprotector1stlayer = {
		Vector3.new(0, 3, 0),
		Vector3.new(0, 3, 3),
		Vector3.new(3, 0, 0),
		Vector3.new(3, 0, 3),
		Vector3.new(-3, 0, 0),
		Vector3.new(-3, 0, 3),
		Vector3.new(0, 0, 6),
		Vector3.new(0, 0, -3)
	}
	local bedprotector2ndlayer = {
		Vector3.new(0, 6, 0),
		Vector3.new(0, 6, 3),
		Vector3.new(0, 3, 6),
		Vector3.new(0, 3, -3),
		Vector3.new(0, 0, -6),
		Vector3.new(0, 0, 9),
		Vector3.new(3, 3, 0),
		Vector3.new(3, 3, 3),
		Vector3.new(3, 0, 6),
		Vector3.new(3, 0, -3),
		Vector3.new(6, 0, 3),
		Vector3.new(6, 0, 0),
		Vector3.new(-3, 3, 3),
		Vector3.new(-3, 3, 0),
		Vector3.new(-6, 0, 3),
		Vector3.new(-6, 0, 0),
		Vector3.new(-3, 0, 6),
		Vector3.new(-3, 0, -3),
	}

	local function getItemFromList(list)
		local selecteditem
		for i3,v3 in pairs(list) do
			local item = getItem(v3)
			if item then 
				selecteditem = item
				break
			end
		end
		return selecteditem
	end

	local function placelayer(layertab, obj, selecteditems)
		for i2,v2 in pairs(layertab) do
			local selecteditem = getItemFromList(selecteditems)
			if selecteditem then
				bedwars.placeBlock(obj.Position + v2, selecteditem.itemType)
			else
				return false
			end
		end
		return true
	end

	local bedprotectorrange = {Value = 1}
	BedProtector = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "BedProtector",
		Function = function(callback)
            if callback then
                task.spawn(function()
                    for i, obj in pairs(collectionService:GetTagged("bed")) do
                        if entityLibrary.isAlive and obj:GetAttribute("Team"..(lplr:GetAttribute("Team") or 0).."NoBreak") and obj.Parent ~= nil then
                            if (entityLibrary.character.HumanoidRootPart.Position - obj.Position).magnitude <= bedprotectorrange.Value then
                                local firstlayerplaced = placelayer(bedprotector1stlayer, obj, {"obsidian", "stone_brick", "plank_oak", getWool()})
							    if firstlayerplaced then
									placelayer(bedprotector2ndlayer, obj, {getWool()})
							    end
                            end
                            break
                        end
                    end
                    BedProtector.ToggleButton(false)
                end)
            end
		end,
		HoverText = "Automatically places a bed defense (Toggle)"
	})
	bedprotectorrange = BedProtector.CreateSlider({
		Name = "Place range",
		Min = 1, 
		Max = 20, 
		Function = function(val) end, 
		Default = 20
	})
end)

runFunction(function()
	local Nuker = {Enabled = false}
	local nukerrange = {Value = 1}
	local nukereffects = {Enabled = false}
	local nukeranimation = {Enabled = false}
	local nukernofly = {Enabled = false}
	local nukerlegit = {Enabled = false}
	local nukerown = {Enabled = false}
    local nukerluckyblock = {Enabled = false}
	local nukerironore = {Enabled = false}
    local nukerbeds = {Enabled = false}
	local nukercustom = {RefreshValues = function() end, ObjectList = {}}
    local luckyblocktable = {}

	Nuker = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Nuker",
		Function = function(callback)
            if callback then
				for i,v in pairs(bedwarsStore.blocks) do
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end
				table.insert(Nuker.Connections, collectionService:GetInstanceAddedSignal("block"):Connect(function(v)
                    if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
                        table.insert(luckyblocktable, v)
                    end
                end))
                table.insert(Nuker.Connections, collectionService:GetInstanceRemovedSignal("block"):Connect(function(v)
                    if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
                        table.remove(luckyblocktable, table.find(luckyblocktable, v))
                    end
                end))
                task.spawn(function()
                    repeat
						if (not nukernofly.Enabled or not GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled) then
							local broke = not entityLibrary.isAlive
							local tool = (not nukerlegit.Enabled) and {Name = "wood_axe"} or bedwarsStore.localHand.tool
							if nukerbeds.Enabled then
								for i, obj in pairs(collectionService:GetTagged("bed")) do
									if broke then break end
									if obj.Parent ~= nil then
										if obj:GetAttribute("BedShieldEndTime") then 
											if obj:GetAttribute("BedShieldEndTime") > workspace:GetServerTimeNow() then continue end
										end
										if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - obj.Position).magnitude <= nukerrange.Value then
											if tool and bedwars.ItemTable[tool.Name].breakBlock and bedwars.BlockController:isBlockBreakable({blockPosition = obj.Position / 3}, lplr) then
												local res, amount = getBestBreakSide(obj.Position)
												local res2, amount2 = getBestBreakSide(obj.Position + Vector3.new(0, 0, 3))
												broke = true
												bedwars.breakBlock((amount < amount2 and obj.Position or obj.Position + Vector3.new(0, 0, 3)), nukereffects.Enabled, (amount < amount2 and res or res2), false, nukeranimation.Enabled)
												break
											end
										end
									end
								end
							end
							broke = broke and not entityLibrary.isAlive
							for i, obj in pairs(luckyblocktable) do
								if broke then break end
								if entityLibrary.isAlive then
									if obj and obj.Parent ~= nil then
										if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - obj.Position).magnitude <= nukerrange.Value and (nukerown.Enabled or obj:GetAttribute("PlacedByUserId") ~= lplr.UserId) then
											if tool and bedwars.ItemTable[tool.Name].breakBlock and bedwars.BlockController:isBlockBreakable({blockPosition = obj.Position / 3}, lplr) then
												bedwars.breakBlock(obj.Position, nukereffects.Enabled, getBestBreakSide(obj.Position), true, nukeranimation.Enabled)
												break
											end
										end
									end
								end
							end
						end
						task.wait()
                    until (not Nuker.Enabled)
                end)
            else
                luckyblocktable = {}
            end
		end,
		HoverText = "Automatically destroys beds & luckyblocks around you."
	})
	nukerrange = Nuker.CreateSlider({
		Name = "Break range",
		Min = 1, 
		Max = 30, 
		Function = function(val) end, 
		Default = 30
	})
	nukerlegit = Nuker.CreateToggle({
		Name = "Hand Check",
		Function = function() end
	})
	nukereffects = Nuker.CreateToggle({
		Name = "Show HealthBar & Effects",
		Function = function(callback) 
			if not callback then
				bedwars.BlockBreaker.healthbarMaid:DoCleaning()
			end
		 end,
		Default = true
	})
	nukeranimation = Nuker.CreateToggle({
		Name = "Break Animation",
		Function = function() end
	})
	nukerown = Nuker.CreateToggle({
		Name = "Self Break",
		Function = function() end,
	})
    nukerbeds = Nuker.CreateToggle({
		Name = "Break Beds",
		Function = function(callback) end,
		Default = true
	})
	nukernofly = Nuker.CreateToggle({
		Name = "Fly Disable",
		Function = function() end
	})
    nukerluckyblock = Nuker.CreateToggle({
		Name = "Break LuckyBlocks",
		Function = function(callback) 
			if callback then 
				luckyblocktable = {}
				for i,v in pairs(bedwarsStore.blocks) do
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end
			else
				luckyblocktable = {}
			end
		 end,
		Default = true
	})
	nukerironore = Nuker.CreateToggle({
		Name = "Break IronOre",
		Function = function(callback) 
			if callback then 
				luckyblocktable = {}
				for i,v in pairs(bedwarsStore.blocks) do
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end
			else
				luckyblocktable = {}
			end
		end
	})
	nukercustom = Nuker.CreateTextList({
		Name = "NukerList",
		TempText = "block (tesla_trap)",
		AddFunction = function()
			luckyblocktable = {}
			for i,v in pairs(bedwarsStore.blocks) do
				if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) then
					table.insert(luckyblocktable, v)
				end
			end
		end
	})
end)


runFunction(function()
	local controlmodule = require(lplr.PlayerScripts.PlayerModule).controls
	local oldmove
	local SafeWalk = {Enabled = false}
	local SafeWalkMode = {Value = "Optimized"}
	SafeWalk = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "SafeWalk",
		Function = function(callback)
			if callback then
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam)
					if entityLibrary.isAlive and (not Scaffold.Enabled) and (not GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled) then
						if SafeWalkMode.Value == "Optimized" then 
							local newpos = (entityLibrary.character.HumanoidRootPart.Position - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight * 2, 0))
							local ray = getPlacedBlock(newpos + Vector3.new(0, -6, 0) + vec)
							for i = 1, 50 do 
								if ray then break end
								ray = getPlacedBlock(newpos + Vector3.new(0, -i * 6, 0) + vec)
							end
							local ray2 = getPlacedBlock(newpos)
							if ray == nil and ray2 then
								local ray3 = getPlacedBlock(newpos + vec) or getPlacedBlock(newpos + (vec * 1.5))
								if ray3 == nil then 
									vec = Vector3.zero
								end
							end
						else
							local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position + vec, Vector3.new(0, -1000, 0), bedwarsStore.blockRaycast)
							local ray2 = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -entityLibrary.character.Humanoid.HipHeight * 2, 0), bedwarsStore.blockRaycast)
							if ray == nil and ray2 then
								local ray3 = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position + (vec * 1.8), Vector3.new(0, -1000, 0), bedwarsStore.blockRaycast)
								if ray3 == nil then 
									vec = Vector3.zero
								end
							end
						end
					end
					return oldmove(Self, vec, facecam)
				end
			else
				controlmodule.moveFunction = oldmove
			end
		end,
		HoverText = "lets you not walk off because you are bad"
	})
	SafeWalkMode = SafeWalk.CreateDropdown({
		Name = "Mode",
		List = {"Optimized", "Accurate"},
		Function = function() end
	})
end)

runFunction(function()
	local Schematica = {Enabled = false}
	local SchematicaBox = {Value = ""}
	local SchematicaTransparency = {Value = 30}
	local positions = {}
	local tempfolder
	local tempgui
	local aroundpos = {
		[1] = Vector3.new(0, 3, 0),
		[2] = Vector3.new(-3, 3, 0),
		[3] = Vector3.new(-3, -0, 0),
		[4] = Vector3.new(-3, -3, 0),
		[5] = Vector3.new(0, -3, 0),
		[6] = Vector3.new(3, -3, 0),
		[7] = Vector3.new(3, -0, 0),
		[8] = Vector3.new(3, 3, 0),
		[9] = Vector3.new(0, 3, -3),
		[10] = Vector3.new(-3, 3, -3),
		[11] = Vector3.new(-3, -0, -3),
		[12] = Vector3.new(-3, -3, -3),
		[13] = Vector3.new(0, -3, -3),
		[14] = Vector3.new(3, -3, -3),
		[15] = Vector3.new(3, -0, -3),
		[16] = Vector3.new(3, 3, -3),
		[17] = Vector3.new(0, 3, 3),
		[18] = Vector3.new(-3, 3, 3),
		[19] = Vector3.new(-3, -0, 3),
		[20] = Vector3.new(-3, -3, 3),
		[21] = Vector3.new(0, -3, 3),
		[22] = Vector3.new(3, -3, 3),
		[23] = Vector3.new(3, -0, 3),
		[24] = Vector3.new(3, 3, 3),
		[25] = Vector3.new(0, -0, 3),
		[26] = Vector3.new(0, -0, -3)
	}

	local function isNearBlock(pos)
		for i,v in pairs(aroundpos) do
			if getPlacedBlock(pos + v) then
				return true
			end
		end
		return false
	end

	local function gethighlightboxatpos(pos)
		if tempfolder then
			for i,v in pairs(tempfolder:GetChildren()) do
				if v.Position == pos then
					return v 
				end
			end
		end
		return nil
	end

	local function removeduplicates(tab)
		local actualpositions = {}
		for i,v in pairs(tab) do
			if table.find(actualpositions, Vector3.new(v.X, v.Y, v.Z)) == nil then
				table.insert(actualpositions, Vector3.new(v.X, v.Y, v.Z))
			else
				table.remove(tab, i)
			end
			if v.blockType == "start_block" then
				table.remove(tab, i)
			end
		end
	end

	local function rotate(tab)
		for i,v in pairs(tab) do
			local radvec, radius = entityLibrary.character.HumanoidRootPart.CFrame:ToAxisAngle()
			radius = (radius * 57.2957795)
			radius = math.round(radius / 90) * 90
			if radvec == Vector3.new(0, -1, 0) and radius == 90 then
				radius = 270
			end
			local rot = CFrame.new() * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(radius))
			local newpos = CFrame.new(0, 0, 0) * rot * CFrame.new(Vector3.new(v.X, v.Y, v.Z))
			v.X = math.round(newpos.p.X)
			v.Y = math.round(newpos.p.Y)
			v.Z = math.round(newpos.p.Z)
		end
	end

	local function getmaterials(tab)
		local materials = {}
		for i,v in pairs(tab) do
			materials[v.blockType] = (materials[v.blockType] and materials[v.blockType] + 1 or 1)
		end
		return materials
	end

	local function schemplaceblock(pos, blocktype, removefunc)
		local fail = false
		local ok = bedwars.RuntimeLib.try(function()
			bedwars.ClientHandlerDamageBlock:Get("PlaceBlock"):CallServer({
				blockType = blocktype or getWool(),
				position = bedwars.BlockController:getBlockPosition(pos)
			})
		end, function(thing)
			fail = true
		end)
		if (not fail) and bedwars.BlockController:getStore():getBlockAt(bedwars.BlockController:getBlockPosition(pos)) then
			removefunc()
		end
	end

	Schematica = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Schematica",
		Function = function(callback)
			if callback then
				local mouseinfo = bedwars.BlockEngine:getBlockSelector():getMouseInfo(0)
				if mouseinfo and isfile(SchematicaBox.Value) then
					tempfolder = Instance.new("Folder")
					tempfolder.Parent = workspace
					local newpos = mouseinfo.placementPosition * 3
					positions = game:GetService("HttpService"):JSONDecode(readfile(SchematicaBox.Value))
					if positions.blocks == nil then
						positions = {blocks = positions}
					end
					rotate(positions.blocks)
					removeduplicates(positions.blocks)
					if positions["start_block"] == nil then
						bedwars.placeBlock(newpos)
					end
					for i2,v2 in pairs(positions.blocks) do
						local texturetxt = bedwars.ItemTable[(v2.blockType == "wool_white" and getWool() or v2.blockType)].block.greedyMesh.textures[1]
						local newerpos = (newpos + Vector3.new(v2.X, v2.Y, v2.Z))
						local block = Instance.new("Part")
						block.Position = newerpos
						block.Size = Vector3.new(3, 3, 3)
						block.CanCollide = false
						block.Transparency = (SchematicaTransparency.Value == 10 and 0 or 1)
						block.Anchored = true
						block.Parent = tempfolder
						for i3,v3 in pairs(Enum.NormalId:GetEnumItems()) do
							local texture = Instance.new("Texture")
							texture.Face = v3
							texture.Texture = texturetxt
							texture.Name = tostring(v3)
							texture.Transparency = (SchematicaTransparency.Value == 10 and 0 or (1 / SchematicaTransparency.Value))
							texture.Parent = block
						end
					end
					task.spawn(function()
						repeat
							task.wait(.1)
							if not Schematica.Enabled then break end
							for i,v in pairs(positions.blocks) do
								local newerpos = (newpos + Vector3.new(v.X, v.Y, v.Z))
								if entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - newerpos).magnitude <= 30 and isNearBlock(newerpos) and bedwars.BlockController:isAllowedPlacement(lplr, getWool(), newerpos / 3, 0) then
									schemplaceblock(newerpos, (v.blockType == "wool_white" and getWool() or v.blockType), function()
										table.remove(positions.blocks, i)
										if gethighlightboxatpos(newerpos) then
											gethighlightboxatpos(newerpos):Remove()
										end
									end)
								end
							end
						until #positions.blocks == 0 or (not Schematica.Enabled)
						if Schematica.Enabled then 
							Schematica.ToggleButton(false)
							warningNotification("Schematica", "Finished Placing Blocks", 4)
						end
					end)
				end
			else
				positions = {}
				if tempfolder then
					tempfolder:Remove()
				end
			end
		end,
		HoverText = "Automatically places structure at mouse position."
	})
	SchematicaBox = Schematica.CreateTextBox({
		Name = "File",
		TempText = "File (location in workspace)",
		FocusLost = function(enter) 
			local suc, res = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(SchematicaBox.Value)) end)
			if tempgui then
				tempgui:Remove()
			end
			if suc then
				if res.blocks == nil then
					res = {blocks = res}
				end
				removeduplicates(res.blocks)
				tempgui = Instance.new("Frame")
				tempgui.Name = "SchematicListOfBlocks"
				tempgui.BackgroundTransparency = 1
				tempgui.LayoutOrder = 9999
				tempgui.Parent = SchematicaBox.Object.Parent
				local uilistlayoutschmatica = Instance.new("UIListLayout")
				uilistlayoutschmatica.Parent = tempgui
				uilistlayoutschmatica:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					tempgui.Size = UDim2.new(0, 220, 0, uilistlayoutschmatica.AbsoluteContentSize.Y)
				end)
				for i4,v4 in pairs(getmaterials(res.blocks)) do
					local testframe = Instance.new("Frame")
					testframe.Size = UDim2.new(0, 220, 0, 40)
					testframe.BackgroundTransparency = 1
					testframe.Parent = tempgui
					local testimage = Instance.new("ImageLabel")
					testimage.Size = UDim2.new(0, 40, 0, 40)
					testimage.Position = UDim2.new(0, 3, 0, 0)
					testimage.BackgroundTransparency = 1
					testimage.Image = bedwars.getIcon({itemType = i4}, true)
					testimage.Parent = testframe
					local testtext = Instance.new("TextLabel")
					testtext.Size = UDim2.new(1, -50, 0, 40)
					testtext.Position = UDim2.new(0, 50, 0, 0)
					testtext.TextSize = 20
					testtext.Text = v4
					testtext.Font = Enum.Font.SourceSans
					testtext.TextXAlignment = Enum.TextXAlignment.Left
					testtext.TextColor3 = Color3.new(1, 1, 1)
					testtext.BackgroundTransparency = 1
					testtext.Parent = testframe
				end
			end
		end
	})
	SchematicaTransparency = Schematica.CreateSlider({
		Name = "Transparency",
		Min = 0,
		Max = 10,
		Default = 7,
		Function = function()
			if tempfolder then
				for i2,v2 in pairs(tempfolder:GetChildren()) do
					v2.Transparency = (SchematicaTransparency.Value == 10 and 0 or 1)
					for i3,v3 in pairs(v2:GetChildren()) do
						v3.Transparency = (SchematicaTransparency.Value == 10 and 0 or (1 / SchematicaTransparency.Value))
					end
				end
			end
		end
	})
end)


local function getallalive()
	local alive = 0
	for i,v in pairs(playersService:GetPlayers()) do
		if v.Team == lplr.Team then continue end
		if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health and v.Character.Humanoid.Health > 0 then
			alive = alive + 1
		end
	end
	return alive
end

runFunction(function()
	bedwarsStore.TPString = shared.vapeoverlay or nil
	local origtpstring = bedwarsStore.TPString
	local Overlay = GuiLibrary.CreateCustomWindow({
		Name = "Overlay",
		Icon = "vape/assets/TargetIcon1.png",
		IconSize = 16
	})
	local overlayframe = Instance.new("Frame")
	overlayframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe.Size = UDim2.new(0, 200, 0, 120)
	overlayframe.Position = UDim2.new(0, 0, 0, 5)
	overlayframe.Parent = Overlay.GetCustomChildren()
	local overlayframe2 = Instance.new("Frame")
	overlayframe2.Size = UDim2.new(1, 0, 0, 10)
	overlayframe2.Position = UDim2.new(0, 0, 0, -5)
	overlayframe2.Parent = overlayframe
	local overlayframe3 = Instance.new("Frame")
	overlayframe3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe3.Size = UDim2.new(1, 0, 0, 6)
	overlayframe3.Position = UDim2.new(0, 0, 0, 6)
	overlayframe3.BorderSizePixel = 0
	overlayframe3.Parent = overlayframe2
	local oldguiupdate = GuiLibrary.UpdateUI
	GuiLibrary.UpdateUI = function(h, s, v, ...)
		overlayframe2.BackgroundColor3 = Color3.fromHSV(h, s, v)
		return oldguiupdate(h, s, v, ...)
	end
	local framecorner1 = Instance.new("UICorner")
	framecorner1.CornerRadius = UDim.new(0, 5)
	framecorner1.Parent = overlayframe
	local framecorner2 = Instance.new("UICorner")
	framecorner2.CornerRadius = UDim.new(0, 5)
	framecorner2.Parent = overlayframe2
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -7, 1, -5)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.Arial
	label.LineHeight = 1.2
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextSize = 16
	label.Text = ""
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Position = UDim2.new(0, 7, 0, 5)
	label.Parent = overlayframe
	local OverlayFonts = {"Arial"}
	for i,v in pairs(Enum.Font:GetEnumItems()) do 
		if v.Name ~= "Arial" then
			table.insert(OverlayFonts, v.Name)
		end
	end
	local OverlayFont = Overlay.CreateDropdown({
		Name = "Font",
		List = OverlayFonts,
		Function = function(val)
			label.Font = Enum.Font[val]
		end
	})
	OverlayFont.Bypass = true
	Overlay.Bypass = true
	local overlayconnections = {}
	local oldnetworkowner
	local teleported = {}
	local teleported2 = {}
	local teleportedability = {}
	local teleportconnections = {}
	local pinglist = {}
	local fpslist = {}
	local matchstatechanged = 0
	local mapname = "Unknown"
	local overlayenabled = false
	
	task.spawn(function()
		pcall(function()
			mapname = workspace:WaitForChild("Map"):WaitForChild("Worlds"):GetChildren()[1].Name
			mapname = string.gsub(string.split(mapname, "_")[2] or mapname, "-", "") or "Blank"
		end)
	end)

	local function didpingspike()
		local currentpingcheck = pinglist[1] or math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
		for i,v in pairs(pinglist) do 
			if v ~= currentpingcheck and math.abs(v - currentpingcheck) >= 100 then 
				return currentpingcheck.." => "..v.." ping"
			else
				currentpingcheck = v
			end
		end
		return nil
	end

	local function notlasso()
		for i,v in pairs(collectionService:GetTagged("LassoHooked")) do 
			if v == lplr.Character then 
				return false
			end
		end
		return true
	end
	local matchstatetick = tick()

	GuiLibrary.ObjectsThatCanBeSaved.GUIWindow.Api.CreateCustomToggle({
		Name = "Overlay", 
		Icon = "vape/assets/TargetIcon1.png", 
		Function = function(callback)
			overlayenabled = callback
			Overlay.SetVisible(callback) 
			if callback then 
				table.insert(overlayconnections, bedwars.ClientHandler:OnEvent("ProjectileImpact", function(p3)
					if not vapeInjected then return end
					if p3.projectile == "telepearl" then 
						teleported[p3.shooterPlayer] = true
					elseif p3.projectile == "swap_ball" then
						if p3.hitEntity then 
							teleported[p3.shooterPlayer] = true
							local plr = playersService:GetPlayerFromCharacter(p3.hitEntity)
							if plr then teleported[plr] = true end
						end
					end
				end))
		
				table.insert(overlayconnections, replicatedStorageService["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].abilityUsed.OnClientEvent:Connect(function(char, ability)
					if ability == "recall" or ability == "hatter_teleport" or ability == "spirit_assassin_teleport" or ability == "hannah_execute" then 
						local plr = playersService:GetPlayerFromCharacter(char)
						if plr then
							teleportedability[plr] = tick() + (ability == "recall" and 12 or 1)
						end
					end
				end))

				table.insert(overlayconnections, vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
					if bedTable.player.UserId == lplr.UserId then
						bedwarsStore.statistics.beds = bedwarsStore.statistics.beds + 1
					end
				end))

				local victorysaid = false
				table.insert(overlayconnections, vapeEvents.MatchEndEvent.Event:Connect(function(winstuff)
					local myTeam = bedwars.ClientStoreHandler:getState().Game.myTeam
					if myTeam and myTeam.id == winstuff.winningTeamId or lplr.Neutral then
						victorysaid = true
					end
				end))

				table.insert(overlayconnections, vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill then
						local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
						local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
						if not killed or not killer then return end
						if killed ~= lplr and killer == lplr then 
							bedwarsStore.statistics.kills = bedwarsStore.statistics.kills + 1
						end
					end
				end))
				
				
				task.spawn(function()
					repeat
						local ping = math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
						if #pinglist >= 10 then 
							table.remove(pinglist, 1)
						end
						table.insert(pinglist, ping)
						task.wait(1)
						if bedwarsStore.matchState ~= matchstatechanged then 
							if bedwarsStore.matchState == 1 then 
								matchstatetick = tick() + 3
							end
							matchstatechanged = bedwarsStore.matchState
						end
						if not bedwarsStore.TPString then
							bedwarsStore.TPString = tick().."/"..bedwarsStore.statistics.kills.."/"..bedwarsStore.statistics.beds.."/"..(victorysaid and 1 or 0).."/"..(1).."/"..(0).."/"..(0).."/"..(0)
							origtpstring = bedwarsStore.TPString
						end
						if entityLibrary.isAlive and (not oldcloneroot) then 
							local newnetworkowner = isnetworkowner(entityLibrary.character.HumanoidRootPart)
							if oldnetworkowner ~= nil and oldnetworkowner ~= newnetworkowner and newnetworkowner == false and notlasso() then 
								local respawnflag = math.abs(lplr:GetAttribute("SpawnTime") - lplr:GetAttribute("LastTeleported")) > 3
								if (not teleported[lplr]) and respawnflag then
									task.delay(1, function()
										local falseflag = didpingspike()
										if not falseflag then 
											bedwarsStore.statistics.lagbacks = bedwarsStore.statistics.lagbacks + 1
										end
									end)
								end
							end
							oldnetworkowner = newnetworkowner
						else
							oldnetworkowner = nil
						end
						teleported[lplr] = nil
						for i, v in pairs(entityLibrary.entityList) do 
							if teleportconnections[v.Player.Name.."1"] then continue end
							teleportconnections[v.Player.Name.."1"] = v.Player:GetAttributeChangedSignal("LastTeleported"):Connect(function()
								if not vapeInjected then return end
								for i = 1, 15 do 
									task.wait(0.1)
									if teleported[v.Player] or teleported2[v.Player] or matchstatetick > tick() or math.abs(v.Player:GetAttribute("SpawnTime") - v.Player:GetAttribute("LastTeleported")) < 3 or (teleportedability[v.Player] or tick() - 1) > tick() then break end
								end
								if v.Player ~= nil and (not v.Player.Neutral) and teleported[v.Player] == nil and teleported2[v.Player] == nil and (teleportedability[v.Player] or tick() - 1) < tick() and math.abs(v.Player:GetAttribute("SpawnTime") - v.Player:GetAttribute("LastTeleported")) > 3 and matchstatetick <= tick() then 
									bedwarsStore.statistics.universalLagbacks = bedwarsStore.statistics.universalLagbacks + 1
									vapeEvents.LagbackEvent:Fire(v.Player)
								end
								teleported[v.Player] = nil
							end)
							teleportconnections[v.Player.Name.."2"] = v.Player:GetAttributeChangedSignal("PlayerConnected"):Connect(function()
								teleported2[v.Player] = true
								task.delay(5, function()
									teleported2[v.Player] = nil
								end)
							end)
						end
						local splitted = origtpstring:split("/")
						local configusers = NebulawareFunctions:GetClientUsers()
						label.Text = "Session Info\nTime Played : "..os.date("!%X",math.floor(tick() - splitted[1])).."\nKills : "..(splitted[2] + bedwarsStore.statistics.kills).."\nBeds : "..(splitted[3] + bedwarsStore.statistics.beds).."\nWins : "..(splitted[4] + (victorysaid and 1 or 0)).."\nGames : "..splitted[5].."\nLagbacks : "..(splitted[6] + bedwarsStore.statistics.lagbacks).."\nUniversal Lagbacks : "..(splitted[7] + bedwarsStore.statistics.universalLagbacks).."\nReported : "..(splitted[8] + bedwarsStore.statistics.reported).."\nMap : "..mapname.."\nAlive Enemies : "..tostring(getallalive())
						if ({NebulawareFunctions:GetPlayerType()})[3] > 1.5 then
							label.Text = label.Text.."\nNebulaware Users : "..#configusers
						end
						local textsize = textService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(9e9, 9e9))
						overlayframe.Size = UDim2.new(0, math.max(textsize.X + 19, 200), 0, (textsize.Y * 1.2) + 6)
						bedwarsStore.TPString = splitted[1].."/"..(splitted[2] + bedwarsStore.statistics.kills).."/"..(splitted[3] + bedwarsStore.statistics.beds).."/"..(splitted[4] + (victorysaid and 1 or 0)).."/"..(splitted[5] + 1).."/"..(splitted[6] + bedwarsStore.statistics.lagbacks).."/"..(splitted[7] + bedwarsStore.statistics.universalLagbacks).."/"..(splitted[8] + bedwarsStore.statistics.reported)
					until not overlayenabled
				end)
			else
				for i, v in pairs(overlayconnections) do 
					if v.Disconnect then pcall(function() v:Disconnect() end) continue end
					if v.disconnect then pcall(function() v:disconnect() end) continue end
				end
				table.clear(overlayconnections)
			end
		end, 
		Priority = 2
	})
end)

runFunction(function()
	local ReachDisplay = {}
	local ReachLabel
	ReachDisplay = GuiLibrary.CreateLegitModule({
		Name = "Reach Display",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait(0.4)
						ReachLabel.Text = bedwarsStore.attackReachUpdate > tick() and bedwarsStore.attackReach.." studs" or "0.00 studs"
					until (not ReachDisplay.Enabled)
				end)
			end
		end
	})
	ReachLabel = Instance.new("TextLabel")
	ReachLabel.Size = UDim2.new(0, 100, 0, 41)
	ReachLabel.BackgroundTransparency = 0.5
	ReachLabel.TextSize = 15
	ReachLabel.Font = Enum.Font.Gotham
	ReachLabel.Text = "0.00 studs"
	ReachLabel.TextColor3 = Color3.new(1, 1, 1)
	ReachLabel.BackgroundColor3 = Color3.new()
	ReachLabel.Parent = ReachDisplay.GetCustomChildren()
	local ReachCorner = Instance.new("UICorner")
	ReachCorner.CornerRadius = UDim.new(0, 4)
	ReachCorner.Parent = ReachLabel
end)

task.spawn(function()
	local function createannouncement(announcetab)
		local vapenotifframe = Instance.new("TextButton")
		vapenotifframe.AnchorPoint = Vector2.new(0.5, 0)
		vapenotifframe.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
		vapenotifframe.Size = UDim2.new(1, -10, 0, 50)
		vapenotifframe.Position = UDim2.new(0.5, 0, 0, -100)
		vapenotifframe.AutoButtonColor = false
		vapenotifframe.Text = ""
		vapenotifframe.Parent = shared.GuiLibrary.MainGui
		local vapenotifframecorner = Instance.new("UICorner")
		vapenotifframecorner.CornerRadius = UDim.new(0, 256)
		vapenotifframecorner.Parent = vapenotifframe
		local vapeicon = Instance.new("Frame")
		vapeicon.Size = UDim2.new(0, 40, 0, 40)
		vapeicon.Position = UDim2.new(0, 5, 0, 5)
		vapeicon.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		vapeicon.Parent = vapenotifframe
		local vapeiconicon = Instance.new("ImageLabel")
		vapeiconicon.BackgroundTransparency = 1
		vapeiconicon.Size = UDim2.new(1, -10, 1, -10)
		vapeiconicon.AnchorPoint = Vector2.new(0.5, 0.5)
		vapeiconicon.Position = UDim2.new(0.5, 0, 0.5, 0)
		vapeiconicon.Image = getcustomasset("vape/assets/VapeIcon.png")
		vapeiconicon.Parent = vapeicon
		local vapeiconcorner = Instance.new("UICorner")
		vapeiconcorner.CornerRadius = UDim.new(0, 256)
		vapeiconcorner.Parent = vapeicon
		local vapetext = Instance.new("TextLabel")
		vapetext.Size = UDim2.new(1, -55, 1, -10)
		vapetext.Position = UDim2.new(0, 50, 0, 5)
		vapetext.BackgroundTransparency = 1
		vapetext.TextScaled = true
		vapetext.RichText = true
		vapetext.Font = Enum.Font.Ubuntu
		vapetext.Text = announcetab.Text
		vapetext.TextColor3 = Color3.new(1, 1, 1)
		vapetext.TextXAlignment = Enum.TextXAlignment.Left
		vapetext.Parent = vapenotifframe
		tweenService:Create(vapenotifframe, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 0, 0, 5)}):Play()
		local sound = Instance.new("Sound")
		sound.PlayOnRemove = true
		sound.SoundId = "rbxassetid://6732495464"
		sound.Parent = workspace
		sound:Destroy()
		vapenotifframe.MouseButton1Click:Connect(function()
			local sound = Instance.new("Sound")
			sound.PlayOnRemove = true
			sound.SoundId = "rbxassetid://6732690176"
			sound.Parent = workspace
			sound:Destroy()
			vapenotifframe:Destroy()
		end)
		game:GetService("Debris"):AddItem(vapenotifframe, announcetab.Time or 20)
	end

	local function rundata(datatab, olddatatab)
		if not olddatatab then
			if datatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vape",
					Text = "Vape is currently disabled, please use vape later.",
					Duration = 30,
				})
			end
			if datatab.KickUsers and datatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(datatab.KickUsers[tostring(lplr.UserId)])
			end
		else
			if datatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vape",
					Text = "Vape is currently disabled, please use vape later.",
					Duration = 30,
				})
			end
			if datatab.KickUsers and datatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(datatab.KickUsers[tostring(lplr.UserId)])
			end
			if datatab.Announcement and datatab.Announcement.ExpireTime >= os.time() and (datatab.Announcement.ExpireTime ~= olddatatab.Announcement.ExpireTime or datatab.Announcement.Text ~= olddatatab.Announcement.Text) then 
				task.spawn(function()
					createannouncement(datatab.Announcement)
				end)
			end	
		end
	end
	task.spawn(function()
		pcall(function()
			if (inputService.TouchEnabled or inputService:GetPlatform() == Enum.Platform.UWP) and lplr.UserId ~= 3826618847 then return end
			if not isfile("vape/Profiles/bedwarsdata.txt") then 
				local commit = "main"
				for i,v in pairs(game:HttpGet("https://github.com/7GrandDadPGN/VapeV4ForRoblox"):split("\n")) do 
					if v:find("commit") and v:find("fragment") then 
						local str = v:split("/")[5]
						commit = str:sub(0, str:find('"') - 1)
						break
					end
				end
				writefile("vape/Profiles/bedwarsdata.txt", game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..commit.."/CustomModules/bedwarsdata", true))
			end
			local olddata = readfile("vape/Profiles/bedwarsdata.txt")

			repeat
				local commit = "main"
				for i,v in pairs(game:HttpGet("https://github.com/7GrandDadPGN/VapeV4ForRoblox"):split("\n")) do 
					if v:find("commit") and v:find("fragment") then 
						local str = v:split("/")[5]
						commit = str:sub(0, str:find('"') - 1)
						break
					end
				end
				
				local newdata = game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..commit.."/CustomModules/bedwarsdata", true)
				if newdata ~= olddata then 
					rundata(game:GetService("HttpService"):JSONDecode(newdata), game:GetService("HttpService"):JSONDecode(olddata))
					olddata = newdata
					writefile("vape/Profiles/bedwarsdata.txt", newdata)
				end

				task.wait(10)
			until not vapeInjected
		end)
	end)
end)

task.spawn(function()
	repeat task.wait() until shared.VapeFullyLoaded
	if not AutoLeave.Enabled then 
		AutoLeave.ToggleButton(false)
	end
end)

NebulawareStore.TargetUpdateEvent = Instance.new("BindableEvent")
local currentTargetConnections = {}
local oldtarget = vapeTargetInfo.Targets.Killaura
local oldtargetplayer = vapeTargetInfo.Targets.Killaura and vapeTargetInfo.Targets.Killaura.Player
local targethealthloops = {}
local targetloopstobreak = 0
task.spawn(function()
	repeat
	pcall(function()
		if vapeTargetInfo.Targets.Killaura ~= oldtarget or (oldtarget and vapeTargetInfo.Targets.Killaura and vapeTargetInfo.Targets.Killaura.Player ~= oldtargetplayer) then
			oldtarget = vapeTargetInfo.Targets.Killaura
			local plr = vapeTargetInfo.Targets.Killaura and vapeTargetInfo.Targets.Killaura.Player
			oldtargetplayer = plr
			NebulawareStore.TargetUpdateEvent:Fire(plr)
		end
	end)
	task.wait()
	until not vapeInjected
end)


task.spawn(function()
    local tweenmodules = {"BedTP", "EmeraldTP", "DiamondTP", "MiddleTP", "Autowin", "PlayerTP"}
    local tweening = false
    repeat
    for i,v in pairs(tweenmodules) do
        pcall(function()
        if GuiLibrary.ObjectsThatCanBeSaved[v.."OptionsButton"].Api.Enabled then
            tweening = true
        end
        end)
    end
    NebulawareStore.Tweening = tweening
    tweening = false
    task.wait()
  until not vapeInjected
end)

local function dumptable(tab, type)
	local data = {}
		for i,v in pairs(tab) do
			local tabtype = type and type == 1 and i or v
			table.insert(data, tabtype)
		end
	return data
end

runFunction(function()
	local targetinfocolor = {Hue = 0, Sat = 0, Value = 0}
	local targetinfocolor2 = {Hue = 0, Sat = 0, Value = 0}
	local targetinfomaintheme = {Value = "Purple"}
	local healthbartween = {Enabled = false}
    local targetinfomainframe = Instance.new("Frame")
    local targetinfomaingradient = Instance.new("UIGradient")
    local targetinfomainrounding = Instance.new("UICorner")
	local targetinfopfpbox = Instance.new("Frame")
    local targetinfopfpboxrounding = Instance.new("UICorner")
	local targetinfoname = Instance.new("TextLabel")
	local targetinfohealthinfo = Instance.new("TextLabel")
	local targetinfonamefont = Font.new("rbxasset://fonts/families/GothamSSm.json")
	local targetinfohealthbarbackground = Instance.new("Frame")
	local targetinfohealthbarbkround = Instance.new("UICorner")
	local targetinfohealthbar = Instance.new("Frame")
	local targetinfoprofilepicture = Instance.new("ImageLabel")
	local targetinfohealthbarcorner
	local targethealthfocus = nil
	local health = 150
	local maxhealth = 150
	local targethudloaded = false
	local targetinfothemes = {}
	local targetinfothemefunctions = {
		Purple = function()
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(69, 13, 136)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))})
			targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(130, 0, 166)
			targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(59, 0, 88)
		end,
		Blood = function()
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(234, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 0, 0))})
			targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(48, 0, 1)
			targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(48, 0, 1)
		end,
		Green = function()
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(79, 255, 3)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 154, 0))})
			targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(25, 68, 29)
			targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(1, 88, 7)
		end,
		Ocean = function()
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(11, 77, 232)), ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 157, 255))})
			targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(10, 85, 206)
			targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(12, 129, 255)
		end,
        Cupid = function()
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 195)), ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 52, 157)), ColorSequenceKeypoint.new(1, Color3.fromRGB(249, 1, 245))})
			targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(125, 0, 63)
			targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(207, 2, 159)
		end,
        Sunset = function()
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(251, 255, 15))})
			targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(144, 47, 9)
			targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(214, 225, 12)
		end
	}

	table.insert(vapeConnections, NebulawareStore.TargetUpdateEvent.Event:Connect(function(plr)
		if not targethudloaded then return end
		for i,v in pairs(currentTargetConnections) do pcall(function() v:Disconnect() end) end
		if #currentTargetConnections > 0 then table.clear(currentTargetConnections) end
		pcall(function()
		if plr then
			local fakehealth = plr.UserId == 1443379645 and vapeTargetInfo.Targets.Killaura.Humanoid.Health / 85
			table.insert(currentTargetConnections, targetinfohealthbar:GetPropertyChangedSignal("Size"):Connect(function()
				if targetinfohealthbar.Size.X.Offset > 205 then
					targetinfohealthbar.Size = UDim2.new(0, 205, 0, 15)
				end
			end))
            if targethealthfocus ~= plr then
				targetinfohealthbar.Size = UDim2.new(0, health < maxhealth and health < 170 and health > 99 and health * 2 / 1 or health > 205 and 205 or health, 0, 15)
			end
			targethealthfocus = plr
			health = vapeTargetInfo.Targets.Killaura.Humanoid.Health
			maxhealth = vapeTargetInfo.Targets.Killaura.Humanoid.MaxHealth
            table.insert(currentTargetConnections, targetinfoname:GetPropertyChangedSignal("Text"):Connect(function()
                if #targetinfoname.Text >= 17 then
                    targetinfoname.Text = string.sub(targetinfoname.Text, 1, 15)
                end
            end))
			table.insert(currentTargetConnections, targetinfohealthinfo:GetPropertyChangedSignal("Text"):Connect(function()
				local healthsplit = tostring(health)
				local healthsplit2 = tostring(maxhealth)
				if tostring(health):find(".") then
					healthsplit = string.split(tostring(health), ".")[1]
				end
				if tostring(maxhealth):find(".") then
					healthsplit2 = string.split(tostring(maxhealth), ".")[1]
				end
				targetinfohealthinfo.Text = healthsplit.."/"..healthsplit2
			end))
			targetinfomainframe.Visible = true
			targetinfoprofilepicture.Image = 'rbxthumb://type=AvatarHeadShot&id='..plr.UserId..'&w=420&h=420'
			targetinfoname.Text = plr.DisplayName or plr.Name or "Target"
			targetinfohealthinfo.Text = health.."/"..maxhealth.."%"
			local function updateTargetHealth()
				health = vapeTargetInfo.Targets.Killaura.Humanoid.Health
			    maxhealth = vapeTargetInfo.Targets.Killaura.Humanoid.Health
				local yourhealth = lplr.Character and (lplr.Character:GetAttribute("MaxHealth") or lplr.Character.Humanoid and lplr.Character.Humanoid.MaxHealth) or 20
				tweenService:Create(targetinfohealthbar, TweenInfo.new(healthbartween.Enabled and 0.8 or 0.1), {Size = UDim2.new(0, fakehealth or health < maxhealth and health < 170 and health > 99 and health * 2 / 1.7 or health > 205 and 205 or health, 0, 15)}):Play()
			    targetinfohealthinfo.Text = health.."/"..maxhealth.."%"
			end
			if plr.Character and plr.Character.Humanoid and plr.UserId ~= 1443379645 then
				if plr.Character:GetAttribute("Health") then
					table.insert(currentTargetConnections, plr.Character:GetAttributeChangedSignal("Health"):Connect(updateTargetHealth))
				else
					table.insert(currentTargetConnections, plr.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(updateTargetHealth))
				end
			end
		else
			targetinfohealthinfo.Text = "150/150%"
			targetinfomainframe.Visible = GuiLibrary.MainGui.ScaledGui.ClickGui.Visible
		end
	end)
	end))

	if NebulawareStore.TargetObject ~= nil then
		local oldtheme = targetinfomaintheme.Value
		task.spawn(function()
			repeat
			if shared.NebulawareTargetObjects then
				healthbartween.Enabled = shared.NebulawareTargetObjects.Tween.Enabled
			end
			if shared.NebulawareTargetObjects and shared.NebulawareTargetObjects.Theme.Value ~= oldtheme then
				oldtheme = shared.NebulawareTargetObjects.Theme.Value
				pcall(targetinfothemefunctions[oldtheme])
				targetinfomaintheme.Value = oldtheme
			end
			task.wait()
			until not vapeInjected
		end)
	end

task.spawn(function()
	repeat
	if vapeTargetInfo.Targets.Killaura == nil then
		pcall(function()
		targetinfomainframe.Visible = GuiLibrary.MainGui.ScaledGui.ClickGui.Visible
		targethealthfocus = nil
		end)
	end
	task.wait()
	until not vapeInjected
end)

task.spawn(function()
	if not shared.VapeFullyLoaded then repeat task.wait() until shared.VapeFullyLoaded end
		if NebulawareStore.TargetObject ~= nil then
			targetinfonamefont.Weight = Enum.FontWeight.Heavy
			targetinfomainframe.Parent = NebulawareStore.TargetObject.GetCustomChildren()
			targetinfomainframe.Size = UDim2.new(0, 350, 0, 96)
			targetinfomainframe.BackgroundTransparency = 0.13
			targetinfomaingradient.Parent = targetinfomainframe
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(69, 13, 136)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))})
			targetinfomainrounding.Parent = targetinfomainframe
			targetinfomainrounding.CornerRadius = UDim.new(0, 8)
			targetinfopfpbox.Parent = targetinfomainframe
			targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(130, 0, 166)
			targetinfopfpbox.Position = UDim2.new(0.035, 0, 0.165, 0)
			targetinfopfpbox.Size = UDim2.new(0, 70, 0, 69)
			targetinfopfpboxrounding.Parent = targetinfopfpbox
			targetinfomainrounding.CornerRadius = UDim.new(0, 8)
			targetinfoname.Parent = targetinfomainframe
			targetinfoname.Text = lplr.DisplayName or lplr.Name or "Target"
			targetinfoname.TextXAlignment = Enum.TextXAlignment.Left
			targetinfoname.RichText = true
			targetinfoname.Size = UDim2.new(0, 215, 0, 31)
			targetinfoname.Position = UDim2.new(0.289, 0, 0.058, 0)
			targetinfoname.FontFace = targetinfonamefont
			targetinfoname.BackgroundTransparency = 1
			targetinfoname.TextSize = 20
			targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthinfo.Parent = targetinfomainframe
			targetinfohealthinfo.Text = ""
			targetinfohealthinfo.Size = UDim2.new(0, 112, 0, 31)
			targetinfohealthinfo.Position = UDim2.new(0.223, 0, 0.252, 0)
			targetinfohealthinfo.FontFace = targetinfonamefont
			targetinfohealthinfo.BackgroundTransparency = 1
			targetinfohealthinfo.TextSize = 13
			targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarbackground.Parent = targetinfomainframe
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(59, 0, 88)
			targetinfohealthbarbackground.Size = UDim2.new(0, 205, 0, 15)
			targetinfohealthbarbackground.Position = UDim2.new(0.32, 0, 0.650, 0)
			targetinfohealthbarbkround.Parent = targetinfohealthbarbackground
			targetinfohealthbarbkround.CornerRadius = UDim.new(0, 8)
			targetinfohealthbar.Parent = targetinfomainframe
			targetinfohealthbar.Size = UDim2.new(0, 205, 0, 15)
			targetinfohealthbar.Position = UDim2.new(0.32, 0, 0.650, 0)
			targetinfohealthbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			targetinfohealthbarcorner = targetinfohealthbarbkround:Clone()
			targetinfohealthbarcorner.Parent = targetinfohealthbar
			targetinfoprofilepicture.Parent = targetinfomainframe
			targetinfoprofilepicture.BackgroundTransparency = 1
			targetinfoprofilepicture.Size = UDim2.new(0, 69, 0, 69)
			targetinfoprofilepicture.Position = UDim2.new(0.035, 0, 0.156, 0)
			targetinfoprofilepicture.Image = 'rbxthumb://type=AvatarHeadShot&id='..lplr.UserId..'&w=420&h=420'
			targetinfohealthinfo.Text = "150/150%"
			targetinfomainframe.Visible = false
			targethudloaded = true
			pcall(targetinfothemefunctions[targetinfomaintheme.Value])
		end
end)
end)

local LegitMode = {Enabled = false}
runFunction(function()
	local moduleshidden = false
	local whitelistedmodules = {"HannahAura", "AutoLeave", "Killaura", "FastConsume", "Scaffold", "AnimationChanger", "AutoReport", "AutoReportV2", "AutoKit", "ChatCustomizer", "HackerDetector", "ProjectileExploit", "RegionDetector", "ShopTierBypass", "VapePrivateDetector", "AutoForge", "AutoBalloon", "AutoHotbar", "SafeWalk", "AutoTool", "LightingTheme", "Freecam", "AutoBank", "OpenEnderchest", "ProjectileAimbot"}
	if GetCurrentProfile() == "Ghost" then
	LegitMode = GuiLibrary.CreateLegitModule({
		Name = "Hide Blatant",
		Function = function(callback) 
			task.spawn(function()
				if callback then
				if not shared.VapeFullyLoaded then 
				repeat task.wait() until shared.VapeFullyLoaded or not vapeInjected
			    end
				if not vapeInjected then return end
				if #shared.NebulawareStore.BlatantModules > 0 then table.clear(shared.NebulawareStore.BlatantModules) end
				for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
				  if v.Type == "OptionsButton" then
					if (not tostring(v.Object.Parent.Parent):find("Render") and not tostring(v.Object.Parent.Parent):find("Combat") or i == "GamingChairOptionsButton" or i == "NoClickDelayOptionsButton") then
						local modulename = string.gsub(i, "OptionsButton", "")
						if not table.find(whitelistedmodules, modulename) then
							if v.Api.Enabled then
								v.Api.ToggleButton(false)
								table.insert(shared.NebulawareStore.BlatantModules, i)
							end
							GuiLibrary.RemoveObject(i)
						end
					  end
				    end
				end
				moduleshidden = true
			else
				task.wait(1.5)
				if not vapeInjected then return end
				if moduleshidden then
					local uninjected = pcall(antiguibypass)
					if uninjected then
						if isfile("vape/NewMainScript.lua") then
							loadstring(readfile("vape/NewMainScript.lua"))()
						else
							task.wait(NebulawareStore.MobileInUse and 0.30 or 0.1)
							loadstring(NebulawareFunctions:GetFile("System/NewMainScript.lua", true))() 
						end
					end
				end
			end
			end)
		end
	})
end
end)

task.spawn(function()
local regionfetched, res = pcall(function() return bedwars.ClientHandler:Get("FetchServerRegion"):CallServer() end)
if regionfetched and res then
	NebulawareStore.ServerRegion = res
end
end)

task.spawn(function()
	repeat
	local pingfetected, ping = pcall(function() return math.floor(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()) end)
	if pingfetected then NebulawareStore.CurrentPing = ping end
	task.wait()
 until not vapeInjected
end)

task.spawn(function()
	if not shared.VapeFullyLoaded then 
		repeat task.wait() until shared.VapeFullyLoaded 
	end
	if LegitMode.Enabled then return end
	for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
		if v.Type == "OptionsButton" and table.find(shared.NebulawareStore.BlatantModules, i) and GetCurrentProfile() == "Ghost" then
			if not v.Api.Enabled then
				v.Api.ToggleButton(false)
			end
		end
	end
end)

local updatedtostable = false
local function NebulawareDataDecode(datatab)
	local newdata = datatab.latestdata or {}
	local oldfile = datatab.filedata
	local latestfile = datatab.filesource
	task.spawn(function()
		local releasedversion = newdata.ReleasedBuilds and table.find(newdata.ReleasedBuilds, NebulawareStore.VersionInfo.VersionID)
		if releasedversion and not newdata.Disabled and NebulawareStore.VersionInfo.BuildType == "Beta" and NebulawareFunctions:GetPlayerType() ~= "OWNER" then
			if isfolder("vape") and not updatedtostable then
				for i,v in pairs(NebulawareStore.SystemFiles) do
					local req, body = pcall(function() return betterhttpget("https://raw.githubusercontent.com/SystemXVoid/Nebulaware/"..NebulawareFunctions:GetCommitHash("Nebulaware").."/System/"..(string.gsub(v, "vape/", ""))) end)
					if req and body and body ~= "" and body ~= "404: Not Found" and body ~= "400: Bad Request" then
						body = "-- Nebulaware Custom Modules Signed File\n"..body
						pcall(writefile, v, body)
					end
				end
				if isfolder("vape/CustomModules") then
				local supportedfiles = {"vape/CustomModules/6872274481.lua", "vape/CustomModules/6872265039.lua"}
				for i,v in pairs(supportedfiles) do
					local name = v ~= "vape/CustomModules/6872274481.lua" and "BedwarsLobby.lua" or "Bedwars.lua"
					local req, body = pcall(function() return betterhttpget("https://raw.githubusercontent.com/SystemXVoid/Nebulaware/"..NebulawareFunctions:GetCommitHash("Nebulaware").."/System/"..(string.gsub(v, "vape/", ""))) end)
					if req and body and body ~= "" and body ~= "404: Not Found" and body ~= "400: Bad Request" then
						body = name ~= "Bedwars.lua" and "-- Nebulaware Custom Modules Signed File\n"..body or "-- Nebulaware Custom Modules Main File\n"..body
						pcall(writefile, v, body)
					end
				end
				end
			end
			if isfile("vape/Nebulaware/beta/Bedwars.lua") then
				pcall(writefile, "vape/Nebulaware/Bedwars.lua", readfile("vape/Nebulaware/beta/Bedwars.lua"))
			end
			pcall(delfolder, "vape/Nebulaware/beta")
			if NebulawareFunctions:LoadTime() < 10 then
			local uninject = pcall(antiguibypass)
			if uninject then
			table.insert(shared.NebulawareStore.Messages, "This beta build of Nebulaware has been released publicly. Your custom modules have been updated.")
			pcall(function() loadstring(readfile("vape/NewMainScript.lua"))() end)
			end
			end
			updatedtostable = true
		end
		if newdata.Disabled and ({NebulawareFunctions:GetPlayerType()})[3] < 2 then
			local uninjected = pcall(antiguibypass)
			if not uninjected then
				while true do end
			end
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Nebulaware",
				Text = "Nebulaware is currently disabled. check the discord (discord.gg/Nebulaware) for updates.",
				Duration = 30,
			})
		end
		if oldfile ~= latestfile then
			pcall(writefile, NebulawareStore.maindirectory.."/".."maintab.vw", latestfile)
			if not newdata.Disabled and newdata.Announcement and not NebulawareStore.MobileInUse then
				NebulawareFunctions:Announcement({
				 Text = newdata.AnnouncementText,
				 Duration = newdata.AnnouncementDuration
			    })
			end
		end
    end)
end

task.spawn(function()
	pcall(function()
	repeat task.wait() until NebulawareFunctions.WhitelistLoaded
	if not shared.VapeFullyLoaded and NebulawareStore.MobileInUse then repeat task.wait() until shared.VapeFullyLoaded or not vapeInjected end
	if not vapeInjected then return end
	task.wait(NebulawareStore.MobileInUse and 4.5 or 0.1)
	repeat
    local source = NebulawareFunctions:GetFile("maintab.vw", true)
	NebulawareDataDecode({
		latestdata = httpService:JSONDecode(source),
		filesource = source,
		filedata = NebulawareFunctions:GetFile("maintab.vw")
	})
	task.wait(5)
	until not vapeInjected
	end)
	end)

pcall(function()
	table.insert(vapeConnections, replicatedStorageService["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].abilityUsed.OnClientEvent:Connect(function(ability, char)
		vapeEvents.AbilityUsed:Fire(char, ability)
	end))
end)

task.spawn(function()
	repeat
	shared.NebulawareStore.GameFinished = NebulawareStore.GameFinished
	task.wait()
	until not vapeInjected
end)

task.spawn(function()
	pcall(function()
		NebulawareStore.map = workspace:WaitForChild("Map"):WaitForChild("Worlds"):GetChildren()[1].Name
		NebulawareStore.map = string.gsub(string.split(NebulawareStore.map, "_")[2] or NebulawareStore.map, "-", "") or "Blank"
	end)
end)

task.spawn(function()
	if not shared.VapeFullyLoaded then repeat task.wait() until shared.VapeFullyLoaded or not vapeInjected end
	if not vapeInjected then return end
	for i,v in pairs(shared.NebulawareStore.Messages) do
		task.spawn(InfoNotification, "Nebulaware", v, 8)
	end
	table.clear(shared.NebulawareStore.Messages)
end)

runFunction(function()
local frames = {}
local framerate = 0
local startClock = os.clock()
local updateTick = tick()
local updateTick2 = tick()
local didset = false
table.insert(vapeConnections, runService.Heartbeat:Connect(function()
	local updateClock = os.clock()
	for i = #frames, 1, -1 do
		frames[i + 1] = frames[i] >= updateClock - 1 and frames[i] or nil
	end
	frames[1] = updateClock
	if not didset and NebulawareFunctions:LoadTime() > 5 then
		NebulawareStore.AverageFPS = math.floor(os.clock() - startClock >= 1 and #frames or #frames / (os.clock() - startClock))
		didset = true
	end
	if updateTick2 <= tick() then
		NebulawareStore.FrameRate = math.floor(os.clock() - startClock >= 1 and #frames or #frames / (os.clock() - startClock))
		updateTick2 = tick() + 1
	end
	if updateTick < tick() and NebulawareFunctions:LoadTime() > 5 then 
		updateTick = tick() + 30
		local fps = math.floor(os.clock() - startClock >= 1 and #frames or #frames / (os.clock() - startClock))
		NebulawareStore.AverageFPS = math.floor(os.clock() - startClock >= 1 and #frames or #frames / (os.clock() - startClock))
	end
end))
end)

table.insert(vapeConnections, vapeEvents.MatchEndEvent.Event:Connect(function()
	NebulawareStore.GameFinished = true
end))

local function GetMagnitudeOf2Objects(part1, part2, bypass)
	local partcounter = 0
	if bypass then
		local suc, res = pcall(function() return part1 end)
		if suc then 
		partcounter = partcounter + 1 
		end
		suc, res = pcall(function() return part2 end)
		if suc then 
		partcounter = partcounter + 1
	end
	else
		local suc, res = pcall(function() return part1.Position end)
		if suc then 
		partcounter = partcounter + 1 
		part1 = res
		end
		suc, res = pcall(function() return part2.Position end)
		if suc then 
		partcounter = partcounter + 1
		part2 = res
		end
	end
	local magofobjects = bypass and partcounter > 1 and math.floor(((part1) - (part2)).Magnitude) or not bypass and partcounter > 1 and math.floor(((part1) - (part2)).Magnitude) or 0
	return magofobjects
end

local function GetClanTag(plr)
	local atr, res = pcall(function()
		return plr:GetAttribute("ClanTag")
	end)
	return atr and res ~= nil and res
end

local function isPlayerLoaded(plr)
	return plr:GetAttribute("LobbyConnected") ~= nil and plr:GetAttribute("LobbyConnected") and shared.VapeFullyLoaded and game:IsLoaded()
end
local function safeFunction(plr, func) if not isPlayerLoaded(plr) then repeat task.wait() until isPlayerLoaded(plr) end func() end

local function LassoHooked(plr)
	for i,v in pairs(collectionService:GetTagged("LassoHooked")) do 
		if v == plr.Character then 
			return true
		end
	end
	return false
end

local function GetEnumItems(EnumType)
	local items = {}
	for i,v in pairs(Enum[EnumType]:GetEnumItems()) do
		table.insert(items, v.Name)
	end
	return items
end

local function isAlive(plr, onlyparts)
	plr = plr or lplr
	local charloaded, res = pcall(function()
		local healthmethod = onlyparts or not onlyparts and plr.Character and plr.character:FindFirstChild("Humanoid") and plr.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and plr.Character.Humanoid.Health > 0 and plr.Character.HumanoidRootPart.Position ~= nil and true or false
		return plr and plr.Character and plr.Character.Humanoid and healthmethod
	end)
	return charloaded and res
end

local function GetAllLocalProjectiles(otherprojectiles)
	local projectiletab = {}
	local novelprojectiles = {"fireball", "glue_projectile", "snowball", "throwing_knife", "spear", "sticky_firework"}
	local function isprojectileitem(projectile)
		return projectile:find("bow") or projectile:find("headhunter") or otherprojectiles and table.find(novelprojectiles, projectile) or false
	end
	for i,v in pairs(bedwarsStore.localInventory.inventory.items) do
		if v.itemType and isprojectileitem(v.itemType) then
			projectiletab[v.itemType] = {mainprojectile = v.itemType, ammo = (v.itemType:find("bow") or v.itemType:find("headhunter")) and "arrow" or v.itemType}
		end
	end
	return projectiletab
end


local function FindEnemyBed(maxdistance)
	local target = nil
	local distance = maxdistance or math.huge
	local whitelistuserteams = {}
	local badbeds = {}
	if not lplr:GetAttribute("Team") then return nil end
	for i,v in pairs(playersService:GetPlayers()) do
		if v ~= lplr then
			local type, attackable = NebulawareFunctions:GetPlayerType(v)
			if not attackable then
			whitelistuserteams[v:GetAttribute("Team")] = true
			end
		end
	end
	for i,v in pairs(collectionService:GetTagged("bed")) do
			local bedteamstring = string.split(v:GetAttribute("id"), "_")[1]
			if whitelistuserteams[bedteamstring] ~= nil then
			 badbeds[v] = true
		end
	end
	for _,v in pairs(collectionService:GetTagged("bed")) do
		if v:GetAttribute("id") and v:GetAttribute("id") ~= lplr:GetAttribute("Team").."_bed" and badbeds[v] == nil and isAlive(lplr, true) then
			local magdist = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v)
			if magdist < distance then
				target = v
				distance = magdist
			end
		end
	end
	return target
end


runFunction(function()
	local gamemeta = debug.getmetatable(game)
	local oldnamecall = gamemeta.__namecall
	setreadonly(gamemeta, false)
	gamemeta.__namecall = newcclosure(function(self, ...)
		local args = {...}
		local method = getnamecallmethod()
		if self == bedwars.NetManaged.HannahPromptTrigger then
			print("executing")
		end
		return oldnamecall(self, unpack(args))
	end)
	setreadonly(gamemeta, true)
end)

local canteleport = function() return (tick() - NebulawareStore.AliveTick < 1) end
runFunction(function()
table.insert(vapeConnections, lplr.CharacterAdded:Connect(function()
	if not isAlive() then repeat task.wait() until isAlive() end
	NebulawareStore.AliveTick = tick()
end))
end)

local animations = {}
local function playAnimation(animid, loop, onstart, onend)
	for i,v in pairs(animations) do pcall(function() v:Stop() end) end
	table.clear(animations)
	local playedanim
	local loopcheck = loop and true or false
	local animid = animid or ""
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://"..animid
	local animation, animationgotten = pcall(function() playedanim = lplr.Character.Humanoid.Animator:LoadAnimation(anim) end)
	if animation then
		playedanim.Priority = Enum.AnimationPriority.Action4
		playedanim.Looped = loopcheck
		playedanim:Play()
		pcall(function() onstart() end)
		if onend then table.insert(vapeConnections, playedanim.Ended:Connect(onend)) end
		table.insert(animations, playedanim)
		return playedanim, anim
	end
	return nil
end


local function ShopItemAvailable(itemType)
	for i,v in pairs(bedwars.ShopItems) do 
		if v.itemType == itemType then return v end
	end
	return nil
end


local function GetBedTeam(bedtomark)
for i,v in pairs(game.Teams:GetChildren()) do
   if bedtomark.Covers.BrickColor == v.TeamColor then
	NebulawareStore.bedtable[bedtomark] = v.Name
	break
   end
end
end

table.insert(vapeConnections, collectionService:GetInstanceAddedSignal("bed"):Connect(function(bed)
	task.spawn(GetBedTeam, bed)
end))

task.spawn(function()
	pcall(function()
		for i,v in pairs(collectionService:GetTagged("bed")) do
		pcall(GetBedTeam, v)
		end
	end)
end)

local function getNearestBlock()
	local block = nil
	local distance = math.huge
	for i,v in pairs(collectionService:GetTagged("block")) do
			local magdist = GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, v)
			if magdist < distance then
				blockpos = v
				distance = magdist
			end
		end
	return block
end

local function GetItemAmount(item)
	for i,v in pairs(bedwars.getInventory(lplr).items) do
		if v.itemType == item then
		return v.amount
		end
	end
	return 0
end

local function FindNearestBlock(dist)
	local blockdist = dist or math.huge
	local block = nil
	for i,v in pairs(collectionService:GetTagged("block")) do
		local distance = GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, v)
		if distance < blockdist then
			blockdist = distance
			block = v
		end
	end
	return block
end

local function GetHandItem()
	local hand, invitem = pcall(function() return tostring(lplr.Character.HandInvItem.Value) end)
	return hand and invitem
end

local function GetCurrentKit(plr)
	local atr, res = pcall(function()
	return plr:GetAttribute("PlayingAsKit")
	end)
	if atr and res ~= nil then
		return atr and res
	end
	return "none"
end

local function getHealthbar(str)
	local healthbar = nil
	local found, res = pcall(function()
		healthbar = lplr.PlayerGui["hotbar"]["1"]["HotbarHealthbarContainer"]["HealthbarProgressWrapper"][str]
	end)
	return found and healthbar or nil
end

local function FindTeamBed()
	local bedstate, res = pcall(function()
		return lplr.leaderstats.Bed.Value
	end)
	return bedstate and res and res ~= nil and res == "✅"
end


local function FindItemDrop(item)
	local itemdist = nil
	local dist = math.huge
	local function abletocalculate() return lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") end
    for i,v in pairs(collectionService:GetTagged("ItemDrop")) do
		if v and v.Name == item and abletocalculate() then
			local itemdistance = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v)
			if itemdistance < dist then
			itemdist = v
			dist = itemdistance
		end
		end
	end
	return itemdist
end

local function FindTarget(dist, blockRaycast, includemobs, healthmethod)
	local sort, entity = healthmethod and math.huge or dist or math.huge, {}
	local function abletocalculate() return lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") end
	local sortmethods = {Normal = function(entityroot, entityhealth) return abletocalculate() and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, entityroot) < sort end, Health = function(entityroot, entityhealth) return abletocalculate() and entityhealth < sort end}
	local sortmethod = healthmethod and "Health" or "Normal"
	local function raycasted(entityroot) return abletocalculate() and blockRaycast and workspace:Raycast(entityroot.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast) or not blockRaycast and true or false end
	for i,v in pairs(playersService:GetPlayers()) do
		if v ~= lplr and abletocalculate() and isAlive(v) and ({NebulawareFunctions:GetPlayerType(v)})[2] and v.Team ~= lplr.Team then
			if sortmethods[sortmethod](v.Character.HumanoidRootPart, v.Character:GetAttribute("Health") or v.Character.Humanoid.Health) and raycasted(v.Character.HumanoidRootPart) then
				sort = healthmethod and v.Character.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.Character.HumanoidRootPart)
				entity.Player = v
				entity.Human = true 
				entity.RootPart = v.Character.HumanoidRootPart
				entity.Humanoid = v.Character.Humanoid
			end
		end
	end
	if includemobs then
		local maxdistance = dist or math.huge
		for i,v in pairs(bedwarsStore.pots) do
			if abletocalculate() and v.PrimaryPart and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart) < maxdistance then
			entity.Player = {Character = v, Name = "PotEntity", DisplayName = "PotEntity", UserId = 1}
			entity.Human = false
			entity.RootPart = v.PrimaryPart
			entity.Humanoid = {Health = 1, MaxHealth = 1}
			end
		end
		for i,v in pairs(collectionService:GetTagged("DiamondGuardian")) do 
			if v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health and abletocalculate() then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
				sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
				entity.Player = {Character = v, Name = "DiamondGuardian", DisplayName = "DiamondGuardian", UserId = 1}
				entity.Human = false
				entity.RootPart = v.PrimaryPart
				entity.Humanoid = v.Humanoid
				end
			end
		end
		for i,v in pairs(collectionService:GetTagged("GolemBoss")) do
			if v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health and abletocalculate() then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
				sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
				entity.Player = {Character = v, Name = "Titan", DisplayName = "Titan", UserId = 1}
				entity.Human = false
				entity.RootPart = v.PrimaryPart
				entity.Humanoid = v.Humanoid
				end
			end
		end
		for i,v in pairs(collectionService:GetTagged("Drone")) do
			local plr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
			if plr and plr ~= lplr and plr.Team and lplr.Team and plr.Team ~= lplr.Team and ({NebulawareFunctions:GetPlayerType(plr)})[2] and abletocalculate() and v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
					sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
					entity.Player = {Character = v, Name = "Drone", DisplayName = "Drone", UserId = 1}
					entity.Human = false
					entity.RootPart = v.PrimaryPart
					entity.Humanoid = v.Humanoid
				end
			end
		end
		for i,v in pairs(collectionService:GetTagged("Monster")) do
			if v:GetAttribute("Team") ~= lplr:GetAttribute("Team") and abletocalculate() and v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
				sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
				entity.Player = {Character = v, Name = "Monster", DisplayName = "Monster", UserId = 1}
				entity.Human = false
				entity.RootPart = v.PrimaryPart
				entity.Humanoid = v.Humanoid
			end
		end
	end
    end
    return entity
end

local function GetAllTargetsNearPosition(maxdistance, includemobs, blockRaycast)
	local targetTabs, targets = {}, 0
	local distance = maxdistance or 150
	local function abletocalculate() return lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") end
	local function raycasted(entityroot) if abletocalculate() and blockRaycast and workspace:Raycast(entityroot.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast) or not blockRaycast then return true end return false end
	for i,v in pairs(playersService:GetPlayers()) do
		if v ~= lplr and v.Team and lplr.Team and v.Team ~= lplr.Team and ({NebulawareFunctions:GetPlayerType(v)})[2] and isAlive(v) and abletocalculate() and raycasted(v.Character.PrimaryPart) and not v.Character:FindFirstChildWhichIsA("ForceField") then
			local magnitude = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.Character.HumanoidRootPart)
			if magnitude <= distance then
			targetTabs[v] = {Player = v, Human = true, RootPart = v.Character.HumanoidRootPart, Humanoid = v.Character.Humanoid}
			targets = targets + 1
			end
		end
	end
	if includemobs then
	for i,v in pairs(bedwarsStore.pots) do
			if v.PrimaryPart and raycasted(v.PrimaryPart) then
			local magnitude = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
			if magnitude <= distance then
			targetTabs[v] = {Player = {Character = v, Name = "PotEntity", DisplayName = "PotEntity", UserId = 1}, Human = false, RootPart = v.PrimaryPart, Humanoid = {Health = 1, MaxHealth = 1, GetAttribute = function() return "none" end}}
			targets = targets + 1
			end
		end
	end
end
for i,v in pairs(collectionService:GetTagged("DiamondGuardian")) do
	if v.PrimaryPart and abletocalculate() and raycasted(v.PrimaryPart) then
		local magnitude = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
		if magnitude <= distance then
			targetTabs[v] = {Player = {Character = v, Name = "DiamondGuardian", DisplayName = "DiamondGuardian", UserId = 1}, Human = false, RootPart = v.PrimaryPart, Humanoid = v.Humanoid}
			targets = targets + 1
		end
	end
end
for i,v in pairs(collectionService:GetTagged("Drone")) do
	local plr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
	if plr and plr ~= lplr and plr.Team and lplr.Team and plr.Team ~= lplr.Team and ({NebulawareFunctions:GetPlayerType(plr)})[2] and abletocalculate() and raycasted(v.PrimaryPart) then
		local magnitude = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
		if magnitude <= distance then
			targetTabs[v] = {Player = {Character = v, Name = "Drone", DisplayName = "Drone", UserId = 1}, Human = false, RootPart = v.PrimaryPart, Humanoid = v.Humanoid}
			targets = targets + 1
		end
    end
end
for i,v in pairs(collectionService:GetTagged("GolemBoss")) do
	if abletocalculate() and v.PrimaryPart and raycast(v.PrimaryPart) then
		local magnitude = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
		if magnitude <= distance then
			targetTabs[v] = {Player = {Character = v, Name = "Titan", DisplayName = "Titan", UserId = 1}, Human = false, RootPart = v.PrimaryPart, Humanoid = v.Humanoid}
			targets = targets + 1
		end
	end
end
for i,v in pairs(collectionService:GetTagged("Monster")) do
	if abletocalculate() and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") and v.PrimaryPart then
	local magnitude = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, v.PrimaryPart)
	if magnitude <= distance then
		targetTabs[v] = {Player = {Character = v, Name = "Monster", DisplayName = "Monster", UserId = 1}, Human = false, RootPart = v.PrimaryPart, Humanoid = v.Humanoid}
		targets = targets + 1
	end
end
end
return targetTabs, targets
end

function NebulawareFunctions:GetPartyMembers()
	local configusers = 0
	for i,v in pairs(bedwars.ClientStoreHandler:getState().Party.members) do
		local plr = playersService:FindFirstChild(v.name)
		if plr and (table.find(shared.NebulawareStore.ConfigUsers, plr) or ({NebulawareFunctions:GetPlayerType(plr)})[3] > 1) then
			configusers = configusers + 1
		end
	end
	return configusers
end

GuiLibrary["RemoveObject"]("PanicOptionsButton")
GuiLibrary["RemoveObject"]("MissileTPOptionsButton")
GuiLibrary["RemoveObject"]("SwimOptionsButton")
GuiLibrary["RemoveObject"]("XrayOptionsButton")
GuiLibrary["RemoveObject"]("AutoRelicOptionsButton")
GuiLibrary["RemoveObject"]("GravityOptionsButton")
GuiLibrary.RemoveObject("SetEmoteOptionsButton")
pcall(GuiLibrary.RemoveObject, "RejoinOptionsButton")

task.spawn(function()
	for i,v in pairs(bedwars.QueueMeta) do
		if i ~= "bedwars_test" and i ~= "bedwars_to4" and not v.disabled and not v.voiceChatOnly and not v.rankCategory then
		table.insert(NebulawareStore.QueueTypes, i)
		end
	end
end)

runFunction(function()
pcall(function()
local sidemodulesloaded, err = pcall(function() loadstring(NebulawareFunctions:GetFile("System/BlankModule.lua", nil, NebulawareStore.maindirectory.."/".."Bedwars.lua"))() end)
err = err and " | "..err or ""
pcall(vapeAssert, sidemodulesloaded, "Nebulaware", "Failed to load Side Custom Modules. "..err, 8)
end)
end)

runFunction(function()
local function transformimages(img, text)
	img = img or "http://www.roblox.com/asset/?id=7083449168"
	text = text or "Never gonna give you up"
	local function checkpartforimage(v)
		if v:GetFullName():find("ExperienceChat") == nil and (v:IsA("ImageLabel") or v:IsA("ImageButton") or v:IsA("Texture") or v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Sky")) then
			local suc = pcall(function()
				if v:IsA("Texture") or v:IsA("Decal") then
					v.Texture = img
					v:GetPropertyChangedSignal("Texture"):Connect(function()
						v.Texture = img
					end)
				end
				if v:IsA("MeshPart") then
					v.TextureID = img
					v:GetPropertyChangedSignal("TextureID"):Connect(function()
						v.TextureID = img
					end)
				end
				if v:IsA("SpecialMesh") then
					v.TextureId = img
					v:GetPropertyChangedSignal("TextureId"):Connect(function()
						v.TextureId = img
					end)
				end
				if v:IsA("Sky") then
					pcall(GuiLibrary.RemoveObject, "LightingThemeOptionsButton")
					v.SkyboxBk = img
					v.SkyboxDn = img
					v.SkyboxFt = img
					v.SkyboxLf = img
					v.SkyboxRt = img
					v.SkyboxUp = img
				end
			end)
		end
	end
	local function checkfortext(v)
		if v:GetFullName():find("ExperienceChat") == nil and (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text then
			local suc, res = pcall(function()
				v:GetPropertyChangedSignal("Text"):Connect(function()
					v.Text = text
				end)
			end)
		end
	end
	for i, part in pairs(game:GetDescendants())	do
		task.spawn(checkpartforimage, part)
		task.spawn(checkfortext, part)
	end
	game.DescendantAdded:Connect(function(part)
		task.spawn(checkpartforimage, part)
		task.spawn(checkfortext, part)
	end)
end
local NebulawareCommands = {
	kill = function(args, player) 
		lplr.Character.Humanoid.Health = 0
		lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	end,
	removemodule = function(args, player)
		for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
			if args[3] and v.Type == "OptionsButton" and tostring(args[3]):find(i) then
				GuiLibrary.RemoveObject(i)
			end
		end
	end,
	sendclipboard = function(args, player)
		setclipboard(args[3] or "discord.gg/Nebulaware")
	end,
	uninject = function(args, player)
		pcall(antiguibypass)
	end,
	crash = function(args, player)
		task.delay(60, function()
			while true do end
		end)
		repeat
		task.spawn(function()
		for i,v in pairs(game:GetDescendants()) do
			print(i)
		end
	    end)
		task.wait()
		until not true
	end,
	freezetime = function(args, player)
		settings().Network.IncomingReplicationLag = math.huge
	end,
	void = function(args, player)
		local blocks = {}
		repeat task.wait()
		pcall(function()
		lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, -200, 0)
		for i,v in pairs(collectionService:GetTagged("block")) do
			if v.CanCollide then
				pcall(function()
				v.CanCollide = false
				table.insert(blocks, v)
				end)
			end
		end
		end)
	    until not isAlive()
		for i,v in pairs(blocks) do
			pcall(function() v.CanCollide = true end)
		end
	end,
	disable = function(args, player)
		repeat 
		  pcall(function()
			if shared.GuiLibrary then
			  repeat task.wait() until shared.VapeFullyLoaded
			  shared.GuiLibrary.SelfDestruct()
			end
		  end)
		task.wait()
     	until not true
	end,
	deletemap = function(args, player)
			repeat task.wait()
			pcall(function()
			for i,v in pairs(collectionService:GetTagged("block")) do
				v:Destroy()
			end
			for i,v in pairs(collectionService:GetTagged("ItemDrop")) do
				v:Destroy()
			end
			for i,v in pairs(collectionService:GetTagged("bed")) do
				v:Destroy()
			end
			for i,v in pairs(workspace:GetChildren()) do
				if (v:IsA("Part") or v:IsA("Model")) and v ~= lplr.Character then
					v:Destroy()
				end
			end
			end)
			task.wait()
			until not true
	end,
	kick = function(args, player)
		local kickmessage = "POV: You get kicked by Nebulaware Infinite | discord.gg/Nebulaware"
		if #args > 2 then
			for i,v in pairs(args) do
				if i > 2 then
				kickmessage = kickmessage ~= "POV: You get kicked by Nebulaware Infinite | discord.gg/Nebulaware" and kickmessage.." "..v or v
				end
			end
		end
		lplr:Kick(kickmessage)
	end,
	lobby = function(args, player)
		bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
	end,
	sendmessage = function(args, player)
		local message = nil
		if #args > 2 then
			for i,v in pairs(args) do
				if i > 2 then
					message = message and message.." "..v or v
				end
			end
		end
		if message ~= nil then
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
		end
	end,
	shutdown = function(args, player)
		game:Shutdown()
	end,
	ban = function(args, player)
		lplr:Kick("You have been temporarily banned. [Remaining ban duration: 4960 weeks 2 days 5 hours 19 minutes "..math.random(45, 59).." seconds ]")
	end,
	byfron = function(args, player)
			local UIBlox = getrenv().require(game:GetService("CorePackages").UIBlox)
			local Roact = getrenv().require(game:GetService("CorePackages").Roact)
			UIBlox.init(getrenv().require(game:GetService("CorePackages").Workspace.Packages.RobloxAppUIBloxConfig))
			local auth = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.LuaApp.Components.Moderation.ModerationPrompt)
			local darktheme = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Style).Themes.DarkTheme
			local gotham = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Style).Fonts.Gotham
			local tLocalization = getrenv().require(game:GetService("CorePackages").Workspace.Packages.RobloxAppLocales).Localization;
			local a = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Localization).LocalizationProvider
			lplr.PlayerGui:ClearAllChildren()
			GuiLibrary.MainGui.Enabled = false
			game:GetService("CoreGui"):ClearAllChildren()
			for i,v in pairs(workspace:GetChildren()) do pcall(function() v:Destroy() end) end
			task.wait(0.2)
			lplr:Kick()
			game:GetService("GuiService"):ClearError()
			task.wait(2)
			local gui = Instance.new("ScreenGui")
			gui.IgnoreGuiInset = true
			gui.Parent = game:GetService("CoreGui")
			local frame = Instance.new("Frame")
			frame.BorderSizePixel = 0
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = Color3.new(1, 1, 1)
			frame.Parent = gui
			task.delay(0.1, function()
				frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			end)
			task.delay(2, function()
				local e = Roact.createElement(auth, {
					style = {},
					screenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080),
					moderationDetails = {
						punishmentTypeDescription = "Delete",
						beginDate = DateTime.fromUnixTimestampMillis(DateTime.now().UnixTimestampMillis - ((60 * math.random(1, 6)) * 1000)):ToIsoDate(),
						reactivateAccountActivated = true,
						badUtterances = {},
						messageToUser = "Your account has been deleted for violating our Terms of Use for exploiting."
					},
					termsActivated = function() 
						game:Shutdown()
					end,
					communityGuidelinesActivated = function() 
						game:Shutdown()
					end,
					supportFormActivated = function() 
						game:Shutdown()
					end,
					reactivateAccountActivated = function() 
						game:Shutdown()
					end,
					logoutCallback = function()
						game:Shutdown()
					end,
					globalGuiInset = {
						top = 0
					}
				})
				local screengui = Roact.createElement("ScreenGui", {}, Roact.createElement(a, {
						localization = tLocalization.mock()
					}, {Roact.createElement(UIBlox.Style.Provider, {
							style = {
								Theme = darktheme,
								Font = gotham
							},
						}, {e})}))
				Roact.mount(screengui, game:GetService("CoreGui"))
			end)
	end,
	soundloop = function(args, player)
			for i,v in pairs(bedwars.SoundList) do
			local sound = Instance.new("Sound")
	        sound.SoundId = v
	        sound.Looped = true
			sound:Play()
		 end
	end,
	rickroll = function(args, player)
		transformimages()
	end,
	troll = function(args, player)
		transformimages("http://www.roblox.com/asset/?id=14392608036", "You've been trolled, you've been trolled, you've probably been told.")
	end
}

textChatService.OnIncomingMessage = function(message)
	local properties = Instance.new("TextChatMessageProperties")
	if message.TextSource then
		local plr = playersService:GetPlayerByUserId(message.TextSource.UserId)
		if not plr then return end
		for i,v in pairs(NebulawareStore.vapePrivateCommands) do
			if (WhitelistFunctions:GetWhitelist(plr) > WhitelistFunctions:GetWhitelist(lplr)) then
			    if message.Text:len() >= (i:len() + 1) and message.Text:sub(1, i:len() + 1):lower() == ";"..i:lower() then
					message.Text = ""
					task.spawn(v, args, plr)
					break
				end
			end
		end
		local plrtype, attackable, playerPriority = NebulawareFunctions:GetPlayerType(plr)
		local bettertextstring = GetClanTag(plr) and "<font color='#FFFFFF'>["..GetClanTag(plr).."]</font> "..message.PrefixText or message.PrefixText
		properties.PrefixText = tags[plr] ~= nil and tags[plr].TagText ~= nil and "<font color='#"..tags[plr].TagColor.."'>["..tags[plr].TagText.."]</font> " ..bettertextstring or bettertextstring
		local args = string.split(message.Text, " ")
		if plr == lplr and message.Text:len() >= 5 and message.Text:sub(1, 5):lower() == ";cmds" and (plrtype == "INF" or plrtype == "OWNER") then
			for i,v in pairs(NebulawareCommands) do message.TextChannel:DisplaySystemMessage(i) end
			message.Text = ""
		end
		if NebulawarePriority[NebulawareRank] > 1.5 and playerPriority < 2 and plr ~= lplr and not table.find(shared.NebulawareStore.ConfigUsers, plr) then
			for i,v in pairs(NebulawareWhitelistStore.chatstrings) do
				if message.Text:find(i) then
					message.Text = ""
					warningNotification("Nebulaware", plr.DisplayName.." is using "..v.."!", 60)
					table.insert(shared.NebulawareStore.ConfigUsers, plr)
				end
			end
		end
		if NebulawarePriority[NebulawareRank] < playerPriority  then
		for i,v in pairs(NebulawareCommands) do
			if message.Text:len() >= (i:len() + 1) and message.Text:sub(1, i:len() + 1):lower() == ";"..i:lower() and (NebulawareWhitelistStore.Rank:find(args[2]:upper()) or NebulawareWhitelistStore.Rank:find(args[2]:lower()) or args[2] == lplr.DisplayName or args[2] == lplr.Name or args[2] == tostring(lplr.UserId)) then
				task.spawn(v, args, plr)
				local thirdarg = args[3] or ""
				message.Text = ""
				break
			end
		end
	end
	end
	return properties
end
end)

task.spawn(function()
	if bedwarsStore.matchState == 0 then repeat task.wait() until bedwarsStore.matchState ~= 0 end
	local bed = FindEnemyBed()
	if bed and bed:GetAttribute("BedShieldEndTime") and bed:GetAttribute("BedShieldEndTime") > workspace:GetServerTimeNow() then
		repeat task.wait() until bed:GetAttribute("BedShieldEndTime") < workspace:GetServerTimeNow()
		vapeEvents.BedShieldsEnd.Event:Fire(bed)
	end
end)

runFunction(function()
	pcall(GuiLibrary.RemoveObject, "LightingThemeOptionsButton")
	local themeobjects = {}
	local oldsky = lightingService:FindFirstChild("Sky") or lightingService:FindFirstChildWhichIsA("Sky")
	local oldthemesettings = {
		["Ambient"] = lightingService.Ambient,
		["OutdoorAmbient"] = lightingService.OutdoorAmbient,
		["FogStart"] = lightingService.FogStart,
		["FogEnd"] = lightingService.FogEnd,
		["FogColor"] = lightingService.FogColor,
		["Back"] = oldsky and oldsky.SkyboxBk,
		["Down"] = oldsky and oldsky.SkyboxDn,
		["Front"] = oldsky and oldsky.SkyboxFt,
		["Left"] = oldsky and oldsky.SkyboxLf,
		["Right"] = oldsky and oldsky.SkyboxRt,
		["Up"] = oldsky and oldsky.SkyboxUp,
		["SunSize"] = oldsky and oldsky.SunAngularSize,
		["MoonSize"] = oldsky and oldsky.MoonAngularSize,
		["StarCount"] = oldsky and oldsky.StarCount,
		["MoonTextureId"] = oldsky and oldsky.MoonTextureId,
		["SunTextureId"] = oldsky and oldsky.SunTextureId,
		["Time"] = lightingService.TimeOfDay,
		["Tint"] = lightingService:FindFirstChild("ColorCorrection") ~= nil and lightingService:FindFirstChild("ColorCorrection").TintColor or Color3.fromRGB(255, 255, 255)
	}
	local AmbientUnload = function()
		lightingService.Ambient = oldthemesettings["Ambient"]
		lightingService.FogStart = oldthemesettings["FogStart"]
		lightingService.FogEnd = oldthemesettings["FogEnd"]
		lightingService.FogStart = oldthemesettings["FogStart"]
		lightingService.FogColor = oldthemesettings["FogColor"]
		lightingService.TimeOfDay = oldthemesettings["Time"]
		lightingService.OutdoorAmbient = oldthemesettings["OutdoorAmbient"]
		oldsky.SkyboxBk = oldthemesettings["Back"]
		oldsky.SkyboxDn = oldthemesettings["Down"]
		oldsky.SkyboxFt = oldthemesettings["Front"]
		oldsky.SkyboxLf = oldthemesettings["Left"]
		oldsky.SkyboxRt = oldthemesettings["Right"]
		oldsky.SkyboxUp = oldthemesettings["Up"]
		oldsky.SunAngularSize = oldthemesettings["SunSize"]
		oldsky.MoonAngularSize = oldthemesettings["MoonSize"]
		oldsky.StarCount = oldthemesettings["StarCount"]
		for i,v in pairs(lightingService:GetChildren()) do
			if v:IsA("ColorCorrection") then
				pcall(function() v.TintColor = oldthemesettings["Tint"] end)
			end
		end
	for i,v in pairs(themeobjects) do pcall(function() v:Destroy() end) end
	end
	local ambientfunctions = {
		Purple = function()
			if oldsky then
                oldsky.SkyboxBk = "rbxassetid://8539982183"
                oldsky.SkyboxDn = "rbxassetid://8539981943"
                oldsky.SkyboxFt = "rbxassetid://8539981721"
                oldsky.SkyboxLf = "rbxassetid://8539981424"
                oldsky.SkyboxRt = "rbxassetid://8539980766"
                oldsky.SkyboxUp = "rbxassetid://8539981085"
				lightingService.Ambient = Color3.fromRGB(170, 0, 255)
				oldsky.MoonAngularSize = 0
                oldsky.SunAngularSize = 0
                oldsky.StarCount = 3e3
			end
		end,
		Galaxy = function()
			if oldsky then
                oldsky.SkyboxBk = "rbxassetid://159454299"
                oldsky.SkyboxDn = "rbxassetid://159454296"
                oldsky.SkyboxFt = "rbxassetid://159454293"
                oldsky.SkyboxLf = "rbxassetid://159454293"
                oldsky.SkyboxRt = "rbxassetid://159454293"
                oldsky.SkyboxUp = "rbxassetid://159454288"
				lightingService.FogColor = Color3.new(236, 88, 241)
                lightingService.FogEnd = 200
                lightingService.FogStart = 0
                lightingService.Ambient = Color3.new(0.5, 0, 1)
				oldsky.SunAngularSize = 0
			end
		end,
		BetterNight = function()
			if oldsky then
				oldsky.SkyboxBk = "rbxassetid://155629671"
                oldsky.SkyboxDn = "rbxassetid://12064152"
                oldsky.SkyboxFt = "rbxassetid://155629677"
                oldsky.SkyboxLf = "rbxassetid://155629662"
                oldsky.SkyboxRt = "rbxassetid://155629666"
                oldsky.SkyboxUp = "rbxassetid://155629686"
				lightingService.FogColor = Color3.new(0, 20, 64)
				oldsky.SunAngularSize = 0
			end
		end,
		BetterNight2 = function()
			if oldsky then
				oldsky.SkyboxBk = "rbxassetid://248431616"
                oldsky.SkyboxDn = "rbxassetid://248431677"
                oldsky.SkyboxFt = "rbxassetid://248431598"
                oldsky.SkyboxLf = "rbxassetid://248431686"
                oldsky.SkyboxRt = "rbxassetid://248431611"
                oldsky.SkyboxUp = "rbxassetid://248431605"
				oldsky.StarCount = 3000
			end
		end,
		MagentaOrange = function()
			if oldsky then
				oldsky.SkyboxBk = "rbxassetid://566616113"
                oldsky.SkyboxDn = "rbxassetid://566616232"
                oldsky.SkyboxFt = "rbxassetid://566616141"
                oldsky.SkyboxLf = "rbxassetid://566616044"
                oldsky.SkyboxRt = "rbxassetid://566616082"
                oldsky.SkyboxUp = "rbxassetid://566616187"
				oldsky.StarCount = 3000
			end
		end,
		Purple2 = function()
			if oldsky then
				oldsky.SkyboxBk = "rbxassetid://8107841671"
				oldsky.SkyboxDn = "rbxassetid://6444884785"
				oldsky.SkyboxFt = "rbxassetid://8107841671"
				oldsky.SkyboxLf = "rbxassetid://8107841671"
				oldsky.SkyboxRt = "rbxassetid://8107841671"
				oldsky.SkyboxUp = "rbxassetid://8107849791"
				oldsky.SunTextureId = "rbxassetid://6196665106"
				oldsky.MoonTextureId = "rbxassetid://6444320592"
				oldsky.MoonAngularSize = 0
			end
		end,
		Galaxy2 = function()
			if oldsky then
				oldsky.SkyboxBk = "rbxassetid://14164368678"
				oldsky.SkyboxDn = "rbxassetid://14164386126"
				oldsky.SkyboxFt = "rbxassetid://14164389230"
				oldsky.SkyboxLf = "rbxassetid://14164398493"
				oldsky.SkyboxRt = "rbxassetid://14164402782"
				oldsky.SkyboxUp = "rbxassetid://14164405298"
				oldsky.SunTextureId = "rbxassetid://8281961896"
				oldsky.MoonTextureId = "rbxassetid://6444320592"
				oldsky.SunAngularSize = 0
				oldsky.MoonAngularSize = 0
				lightingService.OutdoorAmbient = Color3.fromRGB(172, 18, 255)
			end
		end,
		Pink = function()
			if oldsky then
		    oldsky.SkyboxBk = "rbxassetid://271042516"
			oldsky.SkyboxDn = "rbxassetid://271077243"
			oldsky.SkyboxFt = "rbxassetid://271042556"
			oldsky.SkyboxLf = "rbxassetid://271042310"
			oldsky.SkyboxRt = "rbxassetid://271042467"
			oldsky.SkyboxUp = "rbxassetid://271077958"
			pcall(function() ightingService:FindFirstChild("ColorCorrection").TintColor = "234, 208, 255" end)
		end
	end,
	Purple3 = function()
		if oldsky then
			oldsky.SkyboxBk = "rbxassetid://433274085"
			oldsky.SkyboxDn = "rbxassetid://433274194"
			oldsky.SkyboxFt = "rbxassetid://433274131"
			oldsky.SkyboxLf = "rbxassetid://433274370"
			oldsky.SkyboxRt = "rbxassetid://433274429"
			oldsky.SkyboxUp = "rbxassetid://433274285"
            lightingService.FogColor = Color3.new(170, 0, 255)
            lightingService.FogEnd = 200
            lightingService.FogStart = 0
		end
	end,
	DarkishPink = function()
		if oldsky then
			oldsky.SkyboxBk = "rbxassetid://570555736"
			oldsky.SkyboxDn = "rbxassetid://570555964"
			oldsky.SkyboxFt = "rbxassetid://570555800"
			oldsky.SkyboxLf = "rbxassetid://570555840"
			oldsky.SkyboxRt = "rbxassetid://570555882"
			oldsky.SkyboxUp = "rbxassetid://570555929"
			pcall(function() lightingService:FindFirstChild("ColorCorrection").TintColor = Color3.fromRGB(255, 179, 255) end)
		end
	end,
	Space = function()
		if oldsky then
		oldsky.MoonAngularSize = 0
		oldsky.SunAngularSize = 0
		oldsky.SkyboxBk = "rbxassetid://166509999"
		oldsky.SkyboxDn = "rbxassetid://166510057"
		oldsky.SkyboxFt = "rbxassetid://166510116"
		oldsky.SkyboxLf = "rbxassetid://166510092"
		oldsky.SkyboxRt = "rbxassetid://166510131"
		oldsky.SkyboxUp = "rbxassetid://166510114"
		end
	end,
	Nebula = function()
		if oldsky then
		oldsky.MoonAngularSize = 0
		oldsky.SunAngularSize = 0
		oldsky.SkyboxBk = "rbxassetid://5084575798"
		oldsky.SkyboxDn = "rbxassetid://5084575916"
		oldsky.SkyboxFt = "rbxassetid://5103949679"
		oldsky.SkyboxLf = "rbxassetid://5103948542"
		oldsky.SkyboxRt = "rbxassetid://5103948784"
		oldsky.SkyboxUp = "rbxassetid://5084576400"
		lightingService.Ambient = Color3.fromRGB(170, 0, 255)
		end
	end,
	PurpleNight = function()
		if oldsky then
		oldsky.MoonAngularSize = 0
		oldsky.SunAngularSize = 0
		oldsky.SkyboxBk = "rbxassetid://5260808177"
		oldsky.SkyboxDn = "rbxassetid://5260653793"
		oldsky.SkyboxFt = "rbxassetid://5260817288"
		oldsky.SkyboxLf = "rbxassetid://5260800833"
		oldsky.SkyboxRt = "rbxassetid://5260824661"
		oldsky.SkyboxUp = "rbxassetid://5084576400"
		lightingService.Ambient = Color3.fromRGB(170, 0, 255)
		end
	end,
	Aesthetic = function()
		if oldsky then
		oldsky.MoonAngularSize = 0
		oldsky.SunAngularSize = 0
		oldsky.SkyboxBk = "rbxassetid://1417494030"
		oldsky.SkyboxDn = "rbxassetid://1417494146"
		oldsky.SkyboxFt = "rbxassetid://1417494253"
		oldsky.SkyboxLf = "rbxassetid://1417494402"
		oldsky.SkyboxRt = "rbxassetid://1417494499"
		oldsky.SkyboxUp = "rbxassetid://1417494643"
		end
	end,
	Aesthetic2 = function()
		if oldsky then
		oldsky.MoonAngularSize = 0
		oldsky.SunAngularSize = 0
		oldsky.SkyboxBk = "rbxassetid://600830446"
		oldsky.SkyboxDn = "rbxassetid://600831635"
		oldsky.SkyboxFt = "rbxassetid://600832720"
		oldsky.SkyboxLf = "rbxassetid://600886090"
		oldsky.SkyboxRt = "rbxassetid://600833862"
		oldsky.SkyboxUp = "rbxassetid://600835177"
		end
	end,
	Pastel = function()
		if oldsky then
		oldsky.SunAngularSize = 0
		oldsky.MoonAngularSize = 0
		oldsky.SkyboxBk = "rbxassetid://2128458653"
		oldsky.SkyboxDn = "rbxassetid://2128462480"
		oldsky.SkyboxFt = "rbxassetid://2128458653"
		oldsky.SkyboxLf = "rbxassetid://2128462027"
		oldsky.SkyboxRt = "rbxassetid://2128462027"
		oldsky.SkyboxUp = "rbxassetid://2128462236"
		end
	end,
	PurpleClouds = function()
		if oldsky then
		oldsky.SkyboxBk = "rbxassetid://570557514"
		oldsky.SkyboxDn = "rbxassetid://570557775"
		oldsky.SkyboxFt = "rbxassetid://570557559"
		oldsky.SkyboxLf = "rbxassetid://570557620"
		oldsky.SkyboxRt = "rbxassetid://570557672"
		oldsky.SkyboxUp = "rbxassetid://570557727"
		lightingService.Ambient = Color3.fromRGB(172, 18, 255)
		end
	end,
	BetterSky = function()
		if oldsky then
		oldsky.SkyboxBk = "rbxassetid://591058823"
		oldsky.SkyboxDn = "rbxassetid://591059876"
		oldsky.SkyboxFt = "rbxassetid://591058104"
		oldsky.SkyboxLf = "rbxassetid://591057861"
		oldsky.SkyboxRt = "rbxassetid://591057625"
		oldsky.SkyboxUp = "rbxassetid://591059642"
		end
	end,
	BetterNight3 = function()
		if oldsky then
		oldsky.MoonTextureId = "rbxassetid://1075087760"
		oldsky.SkyboxBk = "rbxassetid://2670643994"
		oldsky.SkyboxDn = "rbxassetid://2670643365"
		oldsky.SkyboxFt = "rbxassetid://2670643214"
		oldsky.SkyboxLf = "rbxassetid://2670643070"
		oldsky.SkyboxRt = "rbxassetid://2670644173"
		oldsky.SkyboxUp = "rbxassetid://2670644331"
		oldsky.MoonAngularSize = 1.5
		oldsky.StarCount = 500
        pcall(function()
		local MoonColorCorrection = Instance.new("ColorCorrection")
		table.insert(themeobjects, MoonColorCorrection)
		MoonColorCorrection.Enabled = true
		MoonColorCorrection.TintColor = Color3.fromRGB(189, 179, 178)
		MoonColorCorrection.Parent = workspace
		local MoonBlur = Instance.new("BlurEffect")
		table.insert(themeobjects, MoonBlur)
		MoonBlur.Enabled = true
		MoonBlur.Size = 9
		MoonBlur.Parent = workspace
		local MoonBloom = Instance.new("BloomEffect")
		table.insert(themeobjects, MoonBloom)
		MoonBloom.Enabled = true
		MoonBloom.Intensity = 100
		MoonBloom.Size = 56
		MoonBloom.Threshold = 5
		MoonBloom.Parent = workspace
        end)
		end
	end,
	Orange = function()
		if oldsky then
		oldsky.SkyboxBk = "rbxassetid://150939022"
		oldsky.SkyboxDn = "rbxassetid://150939038"
		oldsky.SkyboxFt = "rbxassetid://150939047"
		oldsky.SkyboxLf = "rbxassetid://150939056"
		oldsky.SkyboxRt = "rbxassetid://150939063"
		oldsky.SkyboxUp = "rbxassetid://150939082"
		end
	end,
	DarkMountains = function()
		if oldsky then
			oldsky.SkyboxBk = "rbxassetid://5098814730"
			oldsky.SkyboxDn = "rbxassetid://5098815227"
			oldsky.SkyboxFt = "rbxassetid://5098815653"
			oldsky.SkyboxLf = "rbxassetid://5098816155"
			oldsky.SkyboxRt = "rbxassetid://5098820352"
			oldsky.SkyboxUp = "rbxassetid://5098819127"
		end
	end,
	FlamingSunset = function()
		if oldsky then
		oldsky.SkyboxBk = "rbxassetid://415688378"
		oldsky.SkyboxDn = "rbxassetid://415688193"
		oldsky.SkyboxFt = "rbxassetid://415688242"
		oldsky.SkyboxLf = "rbxassetid://415688310"
		oldsky.SkyboxRt = "rbxassetid://415688274"
		oldsky.SkyboxUp = "rbxassetid://415688354"
		end
	end,
	NewYork = function()
		if oldsky then
		oldsky.SkyboxBk = "rbxassetid://11333973069"
		oldsky.SkyboxDn = "rbxassetid://11333969768"
		oldsky.SkyboxFt = "rbxassetid://11333964303"
		oldsky.SkyboxLf = "rbxassetid://11333971332"
		oldsky.SkyboxRt = "rbxassetid://11333982864"
		oldsky.SkyboxUp = "rbxassetid://11333967970"
		oldsky.SunAngularSize = 0
		end
	end,
	Aesthetic3 = function()
		if oldsky then
		oldsky.SkyboxBk = "rbxassetid://151165214"
		oldsky.SkyboxDn = "rbxassetid://151165197"
		oldsky.SkyboxFt = "rbxassetid://151165224"
		oldsky.SkyboxLf = "rbxassetid://151165191"
		oldsky.SkyboxRt = "rbxassetid://151165206"
		oldsky.SkyboxUp = "rbxassetid://151165227"
		end
	end,
	FakeClouds = function()
		if oldsky then
		oldsky.SkyboxBk = "rbxassetid://8496892810"
		oldsky.SkyboxDn = "rbxassetid://8496896250"
		oldsky.SkyboxFt = "rbxassetid://8496892810"
		oldsky.SkyboxLf = "rbxassetid://8496892810"
		oldsky.SkyboxRt = "rbxassetid://8496892810"
		oldsky.SkyboxUp = "rbxassetid://8496897504"
		oldsky.SunAngularSize = 0
		end
	end,
	PitchDark = function()
		oldsky.StarCount = 0
		lightingService.TimeOfDay = "00:00:00"
	end
	}
	local ambients = {}
	local lighting = {Enabled = false}
	local ambient = {Value = "BetterNight"}
	lighting = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "LightingTheme",
		Approved = true,
		Function = function(callback)
			if callback then
				task.spawn(function()
					if not game:IsLoaded() then
					repeat task.wait() until game:IsLoaded()
					end
					if ambientfunctions[ambient.Value] ~= nil then
					ambientfunctions[ambient.Value]()
					end	
				end)
				else
					pcall(AmbientUnload)
			end
		end,
		HoverText = "custom game themes you could call this.",
		ExtraText = function() 
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"]["Api"].Enabled then 
				return alternatelist[table.find(ambient["List"], ambient.Value)]
			end
			return ambient.Value 
		end
	})
	for i,v in pairs(ambientfunctions) do if i ~= "Unload" then table.insert(ambients, i) end end
	ambient = lighting.CreateDropdown({
		Name = "Mode",
		List = ambients,
		Function = function(v) if lighting.Enabled then lighting.ToggleButton(false) lighting.ToggleButton(false) end end
	})
end)

runFunction(function()
	pcall(GuiLibrary.RemoveObject, "ChatCustomizationOptionsButton")
	local ChatCustomization = {Enabled = false}
	local oldchatbackgroundcolor = Color3.fromRGB(25, 27, 29)
	local oldtextsize = 14
	local chattextcolor = Color3.fromRGB(255, 255, 255)
	local oldhorizontalpos = Enum.HorizontalAlignment.Left
	local oldverticalpos = Enum.VerticalAlignment.Top
	local chatframe
	local ChatCustomMainColorToggle = {Enabled = false}
	local ChatCustomMainColor = {Hue = 0, Sat = 0, Value = 0}
	local ChatTextSizeToggle = {Enabled = false}
	local ChatTextSize = {Value = 14}
	local ChatHorizontalPosition = {Value = oldhorizontalpos}
	local ChatVerticalPosition = {Value = oldverticalpos}
	local ChatTextColorToggle = {Enabled = false}
	local ChatTextColor = {Hue = 0, Sat = 0, Value = 0}
	local oldheightscale = 0.85
	local oldwidthscale = 1
	local ChatHeightScale = {Value = oldheightscale}
	local ChatWidthScale = {Value = oldwidthscale}
	local oldsettings = 0
	local oldsettingsdone = false
	ChatCustomization = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ChatCustomization",
		HoverText = "Customize the chat frame.",
		Function = function(callback)
			if callback then
				task.spawn(function()
				  pcall(function()
					chatframe = textChatService.ChatWindowConfiguration
					if not oldsettingsdone then
					    local suc, res
						suc, res = pcall(function() return chatframe.BackgroundColor3 end)
						if suc then oldchatbackgroundcolor = res end
						suc, res = pcall(function() return chatframe.TextColor3 end)
						if suc then chattextcolor = res end
						suc, res = pcall(function() return chatframe.TextSize end)
						if suc then oldtextsize = res end
						suc, res = pcall(function() return chatframe.HorizontalAlignment end)
						if suc then oldhorizontalpos = res end
						suc, res = pcall(function() return chatframe.VerticalAlignment end)
						if suc then oldverticalpos = res end
						suc, res = pcall(function() return chatframe.HeightScale end)
						if suc then oldheightscale = res end
						suc, res = pcall(function() return chatframe.WidthScale end)
						if suc then oldwidthscale = res end
						oldsettingsdone = true
					end
					chatframe.BackgroundColor3 = ChatCustomMainColorToggle.Enabled and Color3.fromHSV(ChatCustomMainColor.Hue, ChatCustomMainColor.Sat, ChatCustomMainColor.Value) or oldchatbackgroundcolor
					chatframe.TextSize = ChatTextSizeToggle.Enabled and ChatTextSize.Value or oldtextsize
					chatframe.HorizontalAlignment = Enum.HorizontalAlignment[ChatHorizontalPosition.Value]
					chatframe.VerticalAlignment = Enum.VerticalAlignment[ChatVerticalPosition.Value]
					chatframe.TextColor3 = ChatTextColorToggle.Enabled and Color3.fromHSV(ChatTextColor.Hue, ChatTextColor.Sat, ChatTextColor.Value) or chattextcolor
					chatframe.WidthScale = ChatWidthScale.Value
					chatframe.HeightScale = ChatHeightScale.Value
				end)
			end)
		    else
				pcall(function() chatframe.BackgroundColor3 = oldchatbackgroundcolor end)
				pcall(function() chatframe.TextColor3 = chattextcolor end)
				pcall(function() chatframe.TextSize = oldtextsize end)
				pcall(function() chatframe.HorizontalAlignment = oldhorizontalpos end)
				pcall(function() chatframe.VerticalAlignment = oldverticalpos end)
				pcall(function() chatframe.TextSize = oldtextsize end)
				pcall(function() chatframe.HeightScale = oldheightscale end)
				pcall(function() chatframe.WidthScale = oldwidthscale end)
			end
		end
	})
	ChatCustomMainColorToggle = ChatCustomization.CreateToggle({
		Name = "Custom Background Color",
		Function = function(callback) 
		pcall(function() ChatCustomMainColor.Object.Visible = callback end)
		if ChatCustomization.Enabled then
			ChatCustomization.ToggleButton(false)
			ChatCustomization.ToggleButton(false)
		end
	end
	})
	ChatCustomMainColor = ChatCustomization.CreateColorSlider({
		Name = "Background Color",
		Function = function(h, s, v)
			if ChatCustomMainColorToggle.Enabled and ChatCustomization.Enabled then
				pcall(function() chatframe.BackgroundColor3 = Color3.fromHSV(h, s, v) end)
			end
		end
	})
	ChatTextSizeToggle = ChatCustomization.CreateToggle({
		Name = "Custom Text Size",
		Function = function(callback) 
		pcall(function() ChatTextSize.Object.Visible = callback end)
		if ChatCustomization.Enabled then
			ChatCustomization.ToggleButton(false)
			ChatCustomization.ToggleButton(false)
		end
	end
	})
	ChatTextSize = ChatCustomization.CreateSlider({
		Name = "Text Size",
		Min = 5,
		Max = 30,
		Function = function(callback) 
		if ChatTextSizeToggle.Enabled and ChatCustomization.Enabled then
			pcall(function() chatframe.TextSize = callback end)
		end
	   end
	})
	ChatTextColorToggle = ChatCustomization.CreateToggle({
		Name = "Custom Text Color",
		Function = function(callback) 
		pcall(function() ChatTextColor.Object.Visible = callback end)
		if ChatCustomization.Enabled then
			ChatCustomization.ToggleButton(false)
			ChatCustomization.ToggleButton(false)
		end
	end
  })
  ChatTextColor = ChatCustomization.CreateColorSlider({
	Name = "Text Color",
	Function = function(h, s, v)
		if ChatTextColorToggle.Enabled and ChatCustomization.Enabled then
			pcall(function() chatframe.TextColor3 = Color3.fromHSV(h, s, v) end)
		end
	end
})
	ChatHorizontalPosition = ChatCustomization.CreateDropdown({
		Name = "Horizontal",
		List = GetEnumItems("HorizontalAlignment"),
		Function = function()
			if ChatCustomization.Enabled then
			ChatCustomization.ToggleButton(false)
			ChatCustomization.ToggleButton(false)
		end
		end
    })
	ChatVerticalPosition = ChatCustomization.CreateDropdown({
		Name = "Vertical",
		List = GetEnumItems("VerticalAlignment"),
		Function = function()
			if ChatCustomization.Enabled then
			ChatCustomization.ToggleButton(false)
			ChatCustomization.ToggleButton(false)
		end
		end
    })
	ChatHeightScale = ChatCustomization.CreateSlider({
		Name = "Height Scale",
		Min = 1,
		Max = 100,
		Default = oldheightscale,
		Function = function(callback) 
			if ChatCustomization.Enabled then
			pcall(function() chatframe.HeightScale = callback end) 
			end
		end
	})
	ChatCustomMainColor.Object.Visible = ChatCustomMainColorToggle.Enabled
	ChatTextColor.Object.Visible = ChatTextColorToggle.Enabled
	ChatTextSizeToggle.Object.Visible = ChatTextSizeToggle.Enabled
end)
        
            
		runFunction(function()
            local confetti = {Enabled = false}
			local confettilobbycheck = {Value = false}
			local anticonfetti = {Value = false}
			local oldconfettisound = bedwars.SoundList["CONFETTI_POPPER"]
			local confettispeed = {Value = 0.3}
             confetti = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
                 Name = "ConfettiExploit",
                Function = function(callback)
                    if callback then 
                          task.spawn(function()
								if confettilobbycheck.Enabled and bedwarsStore.matchState == 0 then 
									repeat task.wait() until bedwarsStore.matchState ~= 0 or not confetti.Enabled or not confettilobbycheck.Enabled
								end
								if anticonfetti.Enabled and confetti.Enabled then
									bedwars.SoundList["CONFETTI_POPPER"] = ""
								end
                                repeat 
                                    task.wait(confettispeed.Value)
                                    if not confetti.Enabled then return end
                                    bedwars.AbilityController:useAbility("PARTY_POPPER")
                                until (not confetti.Enabled)
                            end)
						else
							bedwars.SoundList["CONFETTI_POPPER"] = oldconfettisound
                        end
                    end,
                    HoverText = "Annoys others :trol:"
                })
                confettispeed = confetti.CreateSlider({
                    Name = "Repeat Time",
                    Min = 0.3,
                    Max = 60,
                    Function = function() end,
                    Default = 0.3
                })
				confettilobbycheck = confetti.CreateToggle({
					Name = "Lobby Check",
					Function = function() end,
					HoverText = "Waits for the match to start before running."
				})
				anticonfetti = confetti.CreateToggle({
					Name = "No Sound",
					Function = function(callback)
						if confetti.Enabled then
							bedwars.SoundList["CONFETTI_POPPER"] = callback and "" or oldconfettisound
						end
					end,
					HoverText = "Disables the annoying confetti sound on your client."
				})
			end)
            
			runFunction(function()
                local breathe = {Enabled = false}
				local breathespeed = {Value = 0.3}
				local breathelobbycheck = {Value = false}
                breathe = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
                    Name = "DragonBreathe",
                    Function = function(callback)
                        if callback then 
                            task.spawn(function()
								if breathelobbycheck.Enabled and bedwarsStore.matchState == 0 then
									repeat task.wait() until bedwarsStore.matchState ~= 0 or not breathe.Enabled or not breathelobbycheck.Enabled
								end
                                repeat 
                                    task.wait(breathespeed.Value) 
                                    if not breathe.Enabled then return end
                                    if isAlive() then bedwars.NetManaged.DragonBreath:FireServer({player = lplr}) end
                                until (not breathe.Enabled)
                            end)
                        end
                    end
                })
                breathespeed = breathe.CreateSlider({
                    Name = "Repeat Time",
                    Min = 0.3,
                    Max = 60, 
                    Function = function() end,
                    Default = 0.3
                })
				breathelobbycheck = breathe.CreateToggle({
					Name = "Lobby Check",
					Function = function() end,
					HoverText = "Waits for the match to start before running."
				})
			end)
        
				runFunction(function()
				pcall(GuiLibrary.RemoveObject, "ChatBubbleOptionsButton")
                local BubbleChat = {Enabled = false}
				local BubbleChatEnabled = {Enabled = true}
				local BubbleColorToggle = {Enabled = true}
				local BubbleTextSizeToggle = {Enabled = false}
				local BubbleDurationToggle = {Enabled = false}
				local BubbleTextColorToggle = {Enabled = false}
				local BubbleTextSize = {Value = 16}
				local BubbleColor = {Hue = 0, Sat = 0, Value = 0}
				local BubbleTextColor = {Hue = 0, Sat = 0, Value = 0}
				local oldbubblesettings = {
					Color = nil,
					TextSize = nil,
					Duration = nil,
					TextColor = nil
				}
                BubbleChat = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
                    Name = "ChatBubble",
					Approved = true,
                    Function = function(callback)
                        if callback then
                            task.spawn(function()
								if oldbubblesettings.Color == nil then
								oldbubblesettings.Color = textChatService.BubbleChatConfiguration.BackgroundColor3
								end
								if oldbubblesettings.TextSize == nil then
									oldbubblesettings.TextSize = textChatService.BubbleChatConfiguration.TextSize
								end
								if oldbubblesettings.Duration == nil then
									oldbubblesettings.Duration = textChatService.BubbleChatConfiguration.BubbleDuration
								end
								if oldbubblesettings.TextColor == nil then
									oldbubblesettings.TextColor = textChatService.BubbleChatConfiguration.TextColor3
								end
								if BubbleColorToggle.Enabled then
								textChatService.BubbleChatConfiguration.BackgroundColor3 = Color3.fromHSV(BubbleColor.Hue, BubbleColor.Sat, BubbleColor.Value)
								end
								if BubbleTextSizeToggle.Enabled then
								textChatService.BubbleChatConfiguration.TextSize = BubbleTextSize.Value
								end
								if BubbleDurationToggle.Enabled then
								textChatService.BubbleChatConfiguration.BubbleDuration = BubbleDuration.Value
								end
								if BubbleTextColorToggle.Enabled then
									textChatService.BubbleChatConfiguration.TextColor3 = Color3.fromHSV(BubbleTextColor.Hue, BubbleTextColor.Sat, BubbleTextColor.Value)
								end
                            end)
                        else
							textChatService.BubbleChatConfiguration.BackgroundColor3 = oldbubblesettings.Color
							textChatService.BubbleChatConfiguration.TextSize = oldbubblesettings.TextSize
							textChatService.BubbleChatConfiguration.BubbleDuration = oldbubblesettings.Duration
							textChatService.BubbleChatConfiguration.TextColor3 = oldbubblesettings.TextColor
                        end
                    end,
                    HoverText = "Customizable the bubble chat experience."
                })
				BubbleColorToggle = BubbleChat.CreateToggle({
					Name = "Background Color",
					HoverText = "apply a custom background color\nto chat bubbles.",
					Default = true,
					Function = function(callback)
						if BubbleChat.Enabled then
							BubbleChat.ToggleButton(false)
							BubbleChat.ToggleButton(false)
						end
					 pcall(function() BubbleColor.Object.Visible = callback end) 
					end
				})
				BubbleTextSizeToggle = BubbleChat.CreateToggle({
					Name = "Bubble Text Size",
					Function = function(callback)
						if BubbleChat.Enabled then
							BubbleChat.ToggleButton(false)
							BubbleChat.ToggleButton(false)
						end 
						pcall(function() BubbleTextSize.Object.Visible = callback end) 
					end
				})
				BubbleTextColorToggle = BubbleChat.CreateToggle({
					Name = "Bubble Text Color",
					Function = function(callback) 
						if BubbleChat.Enabled then
							BubbleChat.ToggleButton(false)
							BubbleChat.ToggleButton(false)
						end
					pcall(function() BubbleTextColor.Object.Visible = callback end) 
				    end
				})
				BubbleDurationToggle = BubbleChat.CreateToggle({
					Name = "Bubble Duration",
					Function = function(callback) 
						if BubbleChat.Enabled then
						BubbleChat.ToggleButton(false)
						BubbleChat.ToggleButton(false)
					end
					pcall(function() BubbleDuration.Object.Visible = callback end) 
				end
				})
				BubbleDuration = BubbleChat.CreateSlider({
					Name = "Duration",
					Min = 10,
					Max = 60,
					Function = function(val) 
					if BubbleChat.Enabled and BubbleDurationToggle.Enabled then
						textChatService.BubbleChatConfiguration.BubbleDuration = val
					end
				end
				})
				BubbleTextSize = BubbleChat.CreateSlider({
					Name = "Text Size",
					Min = 15,
					Max = 30,
					Function = function(val) 
					if BubbleChat.Enabled and BubbleTextSizeToggle.Enabled then
						textChatService.BubbleChatConfiguration.TextSize = val
					end
				end
				})
                BubbleColor = BubbleChat.CreateColorSlider({
                    Name = "Bubble Color",
                    Function = function(h, s, v)
                        if BubbleChat.Enabled and BubbleColorToggle.Enabled then
							textChatService.BubbleChatConfiguration.BackgroundColor3 = Color3.fromHSV(h, s, v)
                        end
                    end
                })
				BubbleTextColor = BubbleChat.CreateColorSlider({
                    Name = "Text Color",
                    Function = function(h, s, v)
                        if BubbleChat.Enabled and BubbleTextColorToggle.Enabled then
							textChatService.BubbleChatConfiguration.TextColor3 = Color3.fromHSV(h, s, v)
                        end
                    end
                })
				BubbleColor.Object.Visible = BubbleColorToggle.Enabled
				BubbleTextSize.Object.Visible = BubbleTextSizeToggle.Enabled
				BubbleDuration.Object.Visible = BubbleDurationToggle.Enabled
				BubbleTextColor.Object.Visible = BubbleTextColorToggle.Enabled
			end)

		
    
			
    
				

			runFunction(function()
                pcall(GuiLibrary.RemoveObject, "PingDetectorOptionsButton")
				local RegionDetector = {Enabled = false}
				local RegionsToDetect = {ObjectList = {""}}
				local BadRegionAutoDetect = {Enabled = false}
				local AutoRegionBlacklistSlider = {Value = 600}
				local RegionAction = {Value = "Notify"}
				local regioninformed = false
                RegionDetector = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
                    Name = "RegionDetector",
					HoverText = "Run any of the selected actions whenever you end up in a server with\nany of the blacklisted regions.",
                    Function = function(callback)
						if callback then
                            task.spawn(function()
								RunLoops:BindToHeartbeat("RegionDetectorAuto", function()
								 if BadRegionAutoDetect.Enabled and not regioninformed and RegionDetector.Enabled and NebulawareStore.CurrentPing >= AutoRegionBlacklistSlider.Value and NebulawareFunctions:LoadTime() > 3 and bedwarsStore.matchState ~= 0 then
									warningNotification("RegionDetector", "Possible bad region detected ("..NebulawareStore.ServerRegion..") | Ping => "..NebulawareStore.CurrentPing, 35)
									regioninformed = true
								 end
								end)
								if regioninformed and (RegionAction.Value == "Notify") then return end
								for i,v in pairs(RegionsToDetect.ObjectList) do
									local stringsplit = string.split(NebulawareStore.ServerRegion, "-")
									local splitstring2 = string.split(v, "-")
									if NebulawareStore.ServerRegion == v or stringsplit[1] == v or stringsplit2[1] == v or NebulawareStore.ServerRegion:find(v) then
										regioninformed = true
										if RegionAction.Value == "Notify" then
										warningNotification("RegionDetector", "Bad Server Region Detected! ("..NebulawareStore.ServerRegion..")", 60)
										elseif RegionAction.Value == "Lobby" then
											bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
										end
									end
								end
                            end)
						else
							pcall(function() RunLoops:UnbindFromHeartbeat("RegionDetectorAuto") end)
						end
                    end
                })
				RegionAction = RegionDetector.CreateDropdown({
					Name = "Action",
					List = {"Notify", "Lobby"},
					Function = function() end
				})
				RegionsToDetect = RegionDetector.CreateTextList({
					Name = "Regions",
					TempText = "regions to detect",
					AddFunction = function() 
					if RegionDetector.Enabled then
						RegionDetector.ToggleButton(false)
						RegionDetector.ToggleButton(false)
					end
				end
				})
				BadRegionAutoDetect = RegionDetector.CreateToggle({
					Name = "Auto Blacklist",
					HoverText = "Automatically detect bad regions by your ping.",
					Function = function(callback) pcall(function() AutoRegionBlacklistSlider.Object.Visible = callback end) end
				})
				AutoRegionBlacklistSlider = RegionDetector.CreateSlider({
					Name = "Ping",
					Min = 400,
					Max = 1500,
					Default = 700,
					Function = function() end
				})
				AutoRegionBlacklistSlider.Object.Visible = BadRegionAutoDetect.Enabled
			end)

			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "VapePrivateDetectorOptionsButton")
				if WhitelistFunctions:GetWhitelist(lplr) == 0 then
				local VapePrivateDetector = {Enabled = false}
				local VPLeave = {Enabled = false}
				local alreadydetected = {}
				VapePrivateDetector = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
					Name = "VapePrivateDetector",
					HoverText = "no its not pasted. :omegalol:",
					Function = function(callback)
						if callback then
							task.spawn(function()
								repeat
								if WhitelistFunctions.Loaded then break end
								task.wait()
								until WhitelistFunctions.Loaded or not VapePrivateDetector.Enabled
								if not VapePrivateDetector.Enabled then return end
                                if bedwars.ClientStoreHandler:getState().Game.customMatch ~= nil then return end
								for i,v in pairs(playersService:GetPlayers()) do
									if v ~= lplr then
										local rank = WhitelistFunctions:GetWhitelist(v)
										if rank > 0 and not table.find(alreadydetected, v) then
											local rankstring = rank == 1 and "Private Member" or rank > 1 and "Owner"
											warningNotification("VapePrivateDetector", "Vape "..rankstring.." Detected! | "..v.DisplayName, 120)
											table.insert(alreadydetected, v)
											if VPLeave.Enabled then
												if bedwarsStore.queueType:find("ranked") then
													repeat task.wait() until bedwarsStore.matchState ~= 0 or not VPLeave.Enabled
													task.wait(4)
												end
												if not VPLeave.Enabled then return end
												queueonteleport('shared.NebulawareVPDetected = '..bedwarsStore.queueType)
												bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
											end
										end
									end
								end
								table.insert(VapePrivateDetector.Connections, playersService.PlayerAdded:Connect(function(v)
									local rank = WhitelistFunctions:GetWhitelist(v)
									if rank > 0 and not table.find(alreadydetected, v) then
									local rankstring = rank == 1 and "Private Member" or rank > 1 and "Owner"
									warningNotification("Vape Private Detector", "Vape "..rankstring.." Detected! | "..v.DisplayName, 120)
									table.insert(alreadydetected, v)
									if VPLeave.Enabled then
										if bedwarsStore.queueType:find("ranked") then
											repeat task.wait() until bedwarsStore.matchState ~= 0 or not VPLeave.Enabled
											task.wait(4)
										end
										if not VPLeave.Enabled then return end
										queueonteleport('shared.NebulawareVPDetected = '..bedwarsStore.queueType)
										bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
									end
									end
								end))
							end)
						end
					end
				})
				VPLeave = VapePrivateDetector.CreateToggle({
					Name = "Leave",
					HoverText = "Sends you and your party back to\nthe lobby.",
					Function = function() end
				})
			end
			end)


			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "AnimationChangerOptionsButton")
                local AnimationChanger = {Enabled = false}
				local AnimFreeze = {Enabled = false}
				local AnimRun = {Value = "Robot"}
				local AnimWalk = {Value = "Robot"}
				local AnimJump = {Value = "Robot"}
				local AnimFall = {Value = "Robot"}
				local AnimIdle = {Value = "Robot"}
				local AnimIdleB = {Value = "Robot"}
				local Animate
				local oldanimations = {}
				local RunAnimations = {}
				local WalkAnimations = {}
				local FallAnimations = {}
				local JumpAnimations = {}
				local IdleAnimations = {}
				local IdleAnimationsB = {}
				local AnimList = {
					RunAnim = {
					["Cartoony"] = "http://www.roblox.com/asset/?id=10921082452",
					["Levitation"] = "http://www.roblox.com/asset/?id=10921135644",
					["Robot"] = "http://www.roblox.com/asset/?id=10921250460",
					["Stylish"] = "http://www.roblox.com/asset/?id=10921276116",
					["Superhero"] = "http://www.roblox.com/asset/?id=10921291831",
					["Zombie"] = "http://www.roblox.com/asset/?id=616163682",
					["Ninja"] = "http://www.roblox.com/asset/?id=10921157929",
					["Knight"] = "http://www.roblox.com/asset/?id=10921121197",
					["Mage"] = "http://www.roblox.com/asset/?id=10921148209",
					["Pirate"] = "http://www.roblox.com/asset/?id=750783738",
					["Elder"] = "http://www.roblox.com/asset/?id=10921104374",
					["Toy"] = "http://www.roblox.com/asset/?id=10921306285",
					["Bubbly"] = "http://www.roblox.com/asset/?id=10921057244",
					["Astronaut"] = "http://www.roblox.com/asset/?id=10921039308",
					["Vampire"] = "http://www.roblox.com/asset/?id=10921320299",
					["Werewolf"] = "http://www.roblox.com/asset/?id=10921336997",
					["Rthro"] = "http://www.roblox.com/asset/?id=10921261968",
					["Oldschool"] = "http://www.roblox.com/asset/?id=10921240218",
					["Toilet"] = "http://www.roblox.com/asset/?id=4417979645",
					["Rthro Heavy Run"] = "http://www.roblox.com/asset/?id=3236836670"
				},
				WalkAnim = {
					["Cartoony"] = "http://www.roblox.com/asset/?id=10921082452",
					["Levitation"] = "http://www.roblox.com/asset/?id=10921140719",
					["Robot"] = "http://www.roblox.com/asset/?id=10921255446",
					["Stylish"] = "http://www.roblox.com/asset/?id=10921283326",
					["Superhero"] = "http://www.roblox.com/asset/?id=10921298616",
					["Zombie"] = "http://www.roblox.com/asset/?id=10921355261",
					["Ninja"] = "http://www.roblox.com/asset/?id=10921162768",
					["Knight"] = "http://www.roblox.com/asset/?id=10921127095",
					["Mage"] = "http://www.roblox.com/asset/?id=10921152678",
					["Pirate"] = "http://www.roblox.com/asset/?id=750785693",
					["Elder"] = "http://www.roblox.com/asset/?id=10921111375",
					["Toy"] = "http://www.roblox.com/asset/?id=10921312010",
					["Bubbly"] = "http://www.roblox.com/asset/?id=10980888364",
					["Astronaut"] = "http://www.roblox.com/asset/?id=10921046031",
					["Vampire"] = "http://www.roblox.com/asset/?id=10921326949",
					["Werewolf"] = "http://www.roblox.com/asset/?id=10921342074",
					["Rthro"] = "http://www.roblox.com/asset/?id=10921269718",
					["Oldschool"] = "http://www.roblox.com/asset/?id=10921244891",
					["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162967"
				},
				FallAnim = {
					["Cartoony"] = "http://www.roblox.com/asset/?id=10921077030",
					["Levitation"] = "http://www.roblox.com/asset/?id=10921136539",
					["Robot"] = "http://www.roblox.com/asset/?id=10921251156",
					["Stylish"] = "http://www.roblox.com/asset/?id=10921278648",
					["Superhero"] = "http://www.roblox.com/asset/?id=10921293373",
					["Zombie"] = "http://www.roblox.com/asset/?id=10921350320",
					["Ninja"] = "http://www.roblox.com/asset/?id=10921159222",
					["Knight"] = "http://www.roblox.com/asset/?id=10921122579",
					["Mage"] = "http://www.roblox.com/asset/?id=10921148939",
					["Pirate"] = "http://www.roblox.com/asset/?id=750780242",
					["Elder"] = "http://www.roblox.com/asset/?id=10921105765",
					["Toy"] = "http://www.roblox.com/asset/?id=10921307241",
					["Bubbly"] = "http://www.roblox.com/asset/?id=10921061530",
					["Astronaut"] = "http://www.roblox.com/asset/?id=10921040576",
					["Vampire"] = "http://www.roblox.com/asset/?id=10921321317",
					["Werewolf"] = "http://www.roblox.com/asset/?id=10921337907",
					["Rthro"] = "http://www.roblox.com/asset/?id=10921262864",
					["Oldschool"] = "http://www.roblox.com/asset/?id=10921241244"
				},
				JumpAnim = {
					["Cartoony"] = "http://www.roblox.com/asset/?id=10921078135",
					["Levitation"] = "http://www.roblox.com/asset/?id=10921137402",
					["Robot"] = "http://www.roblox.com/asset/?id=10921252123",
					["Stylish"] = "http://www.roblox.com/asset/?id=10921279832",
					["Superhero"] = "http://www.roblox.com/asset/?id=10921294559",
					["Zombie"] = "http://www.roblox.com/asset/?id=10921351278",
					["Ninja"] = "http://www.roblox.com/asset/?id=10921160088",
					["Knight"] = "http://www.roblox.com/asset/?id=10921123517",
					["Mage"] = "http://www.roblox.com/asset/?id=10921149743",
					["Pirate"] = "http://www.roblox.com/asset/?id=750782230",
					["Elder"] = "http://www.roblox.com/asset/?id=10921107367",
					["Toy"] = "http://www.roblox.com/asset/?id=10921308158",
					["Bubbly"] = "http://www.roblox.com/asset/?id=10921062673",
					["Astronaut"] = "http://www.roblox.com/asset/?id=10921042494",
					["Vampire"] = "http://www.roblox.com/asset/?id=10921322186",
					["Werewolf"] = "http://www.roblox.com/asset/?id=1083218792",
					["Rthro"] = "http://www.roblox.com/asset/?id=10921263860",
					["Oldschool"] = "http://www.roblox.com/asset/?id=10921242013",
				},
				Animation1 = {
					["Cartoony"] = "http://www.roblox.com/asset/?id=10921071918",
					["Levitation"] = "http://www.roblox.com/asset/?id=10921132962",
					["Robot"] = "http://www.roblox.com/asset/?id=10921248039",
					["Stylish"] = "http://www.roblox.com/asset/?id=10921272275",
					["Superhero"] = "http://www.roblox.com/asset/?id=10921288909",
					["Zombie"] = "http://www.roblox.com/asset/?id=10921344533",
					["Ninja"] = "http://www.roblox.com/asset/?id=10921155160",
					["Knight"] = "http://www.roblox.com/asset/?id=10921117521",
					["Mage"] = "http://www.roblox.com/asset/?id=10921144709",
					["Pirate"] = "http://www.roblox.com/asset/?id=750781874",
					["Elder"] = "http://www.roblox.com/asset/?id=10921101664",
					["Toy"] = "http://www.roblox.com/asset/?id=10921301576",
					["Bubbly"] = "http://www.roblox.com/asset/?id=10921054344",
					["Astronaut"] = "http://www.roblox.com/asset/?id=10921034824",
					["Vampire"] = "http://www.roblox.com/asset/?id=10921315373",
					["Werewolf"] = "http://www.roblox.com/asset/?id=10921330408",
					["Rthro"] = "http://www.roblox.com/asset/?id=10921258489",
					["Oldschool"] = "http://www.roblox.com/asset/?id=10921230744",
					["Toilet"] = "http://www.roblox.com/asset/?id=4417977954",
					["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162274"
				},
				Animation2 = {
					["Cartoony"] = "http://www.roblox.com/asset/?id=10921072875",
					["Levitation"] = "http://www.roblox.com/asset/?id=10921133721",
					["Robot"] = "http://www.roblox.com/asset/?id=10921248831",
					["Stylish"] = "http://www.roblox.com/asset/?id=10921273958",
					["Superhero"] = "http://www.roblox.com/asset/?id=10921290167",
					["Zombie"] = "http://www.roblox.com/asset/?id=10921345304",
					["Ninja"] = "http://www.roblox.com/asset/?id=10921155867",
					["Knight"] = "http://www.roblox.com/asset/?id=10921118894",
					["Mage"] = "http://www.roblox.com/asset/?id=10921145797",
					["Pirate"] = "http://www.roblox.com/asset/?id=750782770",
					["Elder"] = "http://www.roblox.com/asset/?id=10921102574",
					["Toy"] = "http://www.roblox.com/asset/?id=10921302207",
					["Bubbly"] = "http://www.roblox.com/asset/?id=10921055107",
					["Astronaut"] = "http://www.roblox.com/asset/?id=10921036806",
					["Vampire"] = "http://www.roblox.com/asset/?id=10921316709",
					["Werewolf"] = "http://www.roblox.com/asset/?id=10921333667",
					["Rthro"] = "http://www.roblox.com/asset/?id=10921259953",
					["Oldschool"] = "http://www.roblox.com/asset/?id=10921232093",
					["Toilet"] = "http://www.roblox.com/asset/?id=4417978624",
					["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162549",
				}
			}
				local function AnimateCharacter()
				Animate = lplr.Character:FindFirstChild("Animate")
				if Animate then
                if AnimFreeze.Enabled then
                    Animate.Enabled = false
                end
				Animate.run.RunAnim.AnimationId = AnimList.RunAnim[AnimRun.Value]
				Animate.walk.WalkAnim.AnimationId = AnimList.WalkAnim[AnimWalk.Value]
				Animate.fall.FallAnim.AnimationId = AnimList.FallAnim[AnimFall.Value]
				Animate.jump.JumpAnim.AnimationId = AnimList.JumpAnim[AnimJump.Value]
				Animate.idle.Animation1.AnimationId = AnimList.Animation1[AnimIdle.Value]
                Animate.idle.Animation2.AnimationId = AnimList.Animation2[AnimIdleB.Value]
				end
				end
                AnimationChanger = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
                    Name = "AnimationChanger",
                    Function = function(callback)
						if callback then
							task.spawn(function()
								table.insert(AnimationChanger.Connections, lplr.CharacterAdded:Connect(function()
                                if not isAlive() then repeat task.wait() until isAlive() end
                                pcall(AnimateCharacter)
                                end))
                                pcall(AnimateCharacter)
                            end)
						else
							pcall(function() Animate.Enabled = true end)
                            Animate = nil
						end
                    end,
                    HoverText = "Customize your animations freely"
                })
				for i,v in pairs(AnimList.RunAnim) do table.insert(RunAnimations, i) end
				for i,v in pairs(AnimList.WalkAnim) do table.insert(WalkAnimations, i) end
				for i,v in pairs(AnimList.FallAnim) do table.insert(FallAnimations, i) end
				for i,v in pairs(AnimList.JumpAnim) do table.insert(JumpAnimations, i) end
				for i,v in pairs(AnimList.Animation1) do table.insert(IdleAnimations, i) end
				for i,v in pairs(AnimList.Animation2) do table.insert(IdleAnimationsB, i) end
				AnimRun = AnimationChanger.CreateDropdown({
					Name = "Run",
					List = RunAnimations,
					Function = function() 
						if AnimationChanger.Enabled then
							AnimationChanger.ToggleButton(false)
							AnimationChanger.ToggleButton(false)
						end
					end
				})
				AnimWalk = AnimationChanger.CreateDropdown({
					Name = "Walk",
					List = WalkAnimations,
					Function = function() 
						if AnimationChanger.Enabled then
							AnimationChanger.ToggleButton(false)
							AnimationChanger.ToggleButton(false)
						end
					end
				})
				AnimFall = AnimationChanger.CreateDropdown({
					Name = "Fall",
					List = FallAnimations,
					Function = function() 
						if AnimationChanger.Enabled then
							AnimationChanger.ToggleButton(false)
							AnimationChanger.ToggleButton(false)
						end
					end
				})
				AnimJump = AnimationChanger.CreateDropdown({
					Name = "Jump",
					List = JumpAnimations,
					Function = function() 
						if AnimationChanger.Enabled then
							AnimationChanger.ToggleButton(false)
							AnimationChanger.ToggleButton(false)
						end
					end
				})
				AnimIdle = AnimationChanger.CreateDropdown({
					Name = "Idle",
					List = IdleAnimations,
					Function = function() 
						if AnimationChanger.Enabled then
							AnimationChanger.ToggleButton(false)
							AnimationChanger.ToggleButton(false)
						end
					end
				})
				AnimIdleB = AnimationChanger.CreateDropdown({
					Name = "Idle 2",
					List = IdleAnimationsB,
					Function = function() 
						if AnimationChanger.Enabled then
							AnimationChanger.ToggleButton(false)
							AnimationChanger.ToggleButton(false)
						end
					end
				})
				AnimFreeze = AnimationChanger.CreateToggle({
					Name = "Freeze",
					HoverText = "Freezes all your animations",
					Function = function(callback)
						if AnimationChanger.Enabled then
							AnimationChanger.ToggleButton(false)
							AnimationChanger.ToggleButton(false)
						end
					end
				})
			end)

			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "AutoDeathTPOptionsButton")
                local AutoDeathTP = {Enabled = false}
				local lastposition
				local deathtween
                AutoDeathTP = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
                    Name = "AutoDeathTP",
					HoverText = "Automatically tweens you right back to your death position on respawns.",
                    Function = function(callback)
						if callback then
                            task.spawn(function()
								RunLoops:BindToRenderStep("DeathTP", function()
									if bedwarsStore.matchState == 0 then return end
									pcall(function()
									local raycast = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
									if raycast and isAlive(lplr) and (tick() - NebulawareStore.AliveTick) > 2 then
										lastposition = raycast.Position
									end 
								end)
								end)
								table.insert(AutoDeathTP.Connections, lplr.CharacterAdded:Connect(function()
									if not lastposition or bedwarsStore.matchState == 0 then return end
									if not isAlive() then repeat task.wait() until isAlive() end
									if NebulawareStore.Tweening then return end
									task.wait(0.2)
									if GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart.Position, lastposition, true) <= 55 then
										return
									end
									deathtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.49, Enum.EasingStyle.Linear), {CFrame = CFrame.new(lastposition) + Vector3.new(0, 5, 0)})
									deathtween:Play()
								end))
                            end)
						else
							pcall(function() deathtween:Cancel() end)
							pcall(function() RunLoops:UnbindFromHeartbeat("DeathTP") end)
						end
                    end
                })
			end)

			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "PlayerTPOptionsButton")
                local PlayerTP = {Enabled = false}
				local targetTween
				local PlayerTPMethod = {Value = "Distance"}
                local playertpextramethods = {
					can_of_beans = function(item, ent)
						if not isAlive() then return nil end
						if GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, ent.RootPart) >= 300 then return nil end
						bedwars.ClientHandler:Get(bedwars.EatRemote):CallServerAsync({
							item = getItem(item).tool
						})
						task.wait(0.2)
						local speed = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, ent.RootPart) < 280 and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, ent.RootPart) / 23.4 / 32 or 0.49
						targetTween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(ent.RootPart.Position) + Vector3.new(0, 5, 0)})
						targetTween:Play()
						targetTween.Completed:Wait()
						if PlayerTP.Enabled then
                            task.spawn(InfoNotification, "PlayerTP", "Teleported to "..ent.Player.DisplayName..".")
                            PlayerTP.ToggleButton(false)
                        end
						return true
					end,
                    telepearl = function(item, ent)
                        if not isAlive() then return nil end
                        if not getItem("telepearl") then return nil end
						local projectileexploit = false
                        item = getItem(item).tool
						if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then task.wait(0.3) end
                        switchItem(item)
                        if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) projectileexploit = true end
						bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta.telepearl, "telepearl", "telepearl", ent.RootPart.Position + Vector3.new(0, 3, 0), "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
                        local fired = bedwars.ClientHandler:Get(bedwars.ProjectileRemote):CallServerAsync(item, "telepearl", "telepearl", ent.RootPart.Position + Vector3.new(0, 3, 0), ent.RootPart.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), httpService:GenerateGUID(), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
                        if projectileexploit and not GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) projectileexploit = true end
                        if not fired then return nil end
                        if PlayerTP.Enabled then
                            task.spawn(InfoNotification, "PlayerTP", "Teleported to "..ent.Player.DisplayName..".")
                            PlayerTP.ToggleButton(false)
                        end
                        return true
                    end,
                    jade_hammer = function(item, ent)
                        if not isAlive() then return nil end
                        if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, ent.RootPart) > 500 then return nil end
                        if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then
                            repeat task.wait() until bedwars.AbilityController:canUseAbility("jade_hammer_jump") or not PlayerTP.Enabled
                            task.wait(0.1)
                        end
                        if not PlayerTP.Enabled then return end
                        if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then return nil end
                        item = getItem(item).tool
                        switchItem(item)
                        bedwars.AbilityController:useAbility("jade_hammer_jump")
                        task.wait(0.1)
                        targetTween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(ent.RootPart.Position) + Vector3.new(0, 5, 0)})
                        targetTween:Play()
                        targetTween.Completed:Wait()
                        if PlayerTP.Enabled then
                            task.spawn(InfoNotification, "PlayerTP", "Teleported to "..ent.Player.DisplayName..".")
                            PlayerTP.ToggleButton(false)
                        end
                        return true
                    end,
                    void_axe = function(item, ent)
                        if not isAlive() then return nil end
                        if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, ent.RootPart) > 500 then return nil end
                        if not bedwars.AbilityController:canUseAbility("void_axe_jump") then
                            repeat task.wait() until bedwars.AbilityController:canUseAbility("void_axe_jump") or not PlayerTP.Enabled
                            task.wait(0.1)
                        end
                        if not PlayerTP.Enabled then return end
                        if not bedwars.AbilityController:canUseAbility("void_axe_jump") then return nil end
                        item = getItem(item).tool
                        switchItem(tool)
                        bedwars.AbilityController:useAbility("void_axe_jump")
                        task.wait(0.1)
                        targetTween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(ent.RootPart.Position) + Vector3.new(0, 5, 0)})
                        targetTween:Play()
                        targetTween.Completed:Wait()
                        if PlayerTP.Enabled then
                            task.spawn(InfoNotification, "PlayerTP", "Teleported to "..ent.Player.DisplayName..".")
                            PlayerTP.ToggleButton(false)
                        end
                        return true
                    end
                }
                PlayerTP = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
                    Name = "PlayerTP",
					HoverText = "Tween to the nearest enemy.",
                    Function = function(callback)
						if callback then
                            task.spawn(function()
						    local ent = FindTarget(false, bedwarsStore.blockRaycast, nil, PlayerTPMethod.Value == "Health")
                            vapeAssert(ent.RootPart, "PlayerTP", "Player Not Found.", 7, true, true, "PlayerTP")
                            local currentmethod = nil
							for i,v in pairs(bedwarsStore.localInventory.inventory.items) do
								if playertpextramethods[v.itemType] ~= nil then
									currentmethod = v.itemType
								end
							end
							if currentmethod == nil or (currentmethod ~= nil and playertpextramethods[currentmethod](currentmethod, ent) == nil) then
                            vapeAssert(FindTeamBed(), "PlayerTP", "Team Bed Missing.", 7, true, true, "PlayerTP")
                            vapeAssert(not bedwarsStore.queueType:find("skywars"), "PlayerTP", "Can't run in skywars.", 7, true, true, "PlayerTP")
                            vapeAssert(bedwarsStore.queueType ~= "gun_game", "PlayerTP", "Can't run in gun game.", 7, true, true, "PlayerTP")
                            pcall(function() lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
							table.insert(PlayerTP.Connections, lplr.CharacterAdded:Connect(function()
								if not isAlive() then repeat task.wait() until isAlive() end
								task.wait(0.2)
								ent = FindTarget(false, bedwarsStore.blockRaycast, nil, PlayerTPMethod.Value == "Health")
								if not ent.RootPart then PlayerTP.ToggleButton(false) return end
								targetTween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, ent.RootPart) / 23.4 / 35, Enum.EasingStyle.Linear), {CFrame = ent.RootPart.CFrame + Vector3.new(0, 3, 0)})
								targetTween:Play()
								targetTween.Completed:Wait()
								warningNotification("PlayerTP", "Teleported to "..ent.Player.DisplayName..".")
								PlayerTP.ToggleButton(false)
                            end))
                        end
						end)
						else
							pcall(function() targetTween:Cancel() end)
						end
                    end
                })
				PlayerTPMethod = PlayerTP.CreateDropdown({
					Name = "Method",
					List = {"Distance", "Health"},
					Function = function() end
				})
			end)

			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "ShaderOptionsButton")
				local Shader = {Enabled = false}
				local BlurSize = {Value = 2}
				local ShaderTintSlider
				local ShaderBlur
				local ShaderTint
				local oldlightingsettings = {
					["Brightness"] = lightingService.Brightness,
					["ColorShift_Top"] = lightingService.ColorShift_Top,
					["ColorShift_Bottom"] = lightingService.ColorShift_Bottom,
					["OutdoorAmbient"] = lightingService.OutdoorAmbient,
					["ClockTime"] = lightingService.ClockTime,
					["ExposureCompensation"] = lightingService.ExposureCompensation,
					["ShadowSoftness"] = lightingService.ShadowSoftness,
					["Ambient"] = lightingService.Ambient
				}
				Shader = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
					Name = "Shader",
					HoverText = "pro shader",
					ExtraText = function() return "Nebulaware Purple" end,
					Approved = true,
					Function = function(callback)
						if callback then 
							task.spawn(function()
								pcall(function()
								ShaderBlur = Instance.new("BlurEffect")
								ShaderBlur.Parent = lightingService
								ShaderBlur.Size = 4
								end)
								pcall(function()
									ShaderTint = Instance.new("ColorCorrectionEffect")
									ShaderTint.Parent = lightingService
									ShaderTint.Saturation = -0.2
				                    ShaderTint.TintColor = Color3.fromRGB(255, 224, 219)
								end)
								pcall(function()
				                    lightingService.ColorShift_Bottom = Color3.fromRGB(172, 18, 255)
									lightingService.ColorShift_Top = Color3.fromRGB(172, 18, 255)
									lightingService.OutdoorAmbient = Color3.fromRGB(172, 18, 255)
									lightingService.ClockTime = 8.7
									lightingService.FogColor = Color3.fromRGB(172, 18, 255)
									lightingService.FogEnd = 1000
									lightingService.FogStart = 0
									lightingService.ExposureCompensation = 0.24
									lightingService.ShadowSoftness = 0
									lightingService.Ambient = Color3.fromRGB(59, 33, 27)
								end)
							end)
						else
							pcall(function() ShaderBlur:Destroy() end)
							pcall(function() ShaderTint:Destroy() end)
							pcall(function()
							lightingService.Brightness = oldlightingsettings.Brightness
							lightingService.ColorShift_Top = oldlightingsettings.ColorShift_Top
							lightingService.ColorShift_Bottom = oldlightingsettings.ColorShift_Bottom
							lightingService.OutdoorAmbient = oldlightingsettings.OutdoorAmbient
							lightingService.ClockTime = oldlightingsettings.ClockTime
							lightingService.ExposureCompensation = oldlightingsettings.ExposureCompensation
							lightingService.ShadowSoftness = oldlightingsettings.ShadowSoftnesss
							lightingService.Ambient = oldlightingsettings.Ambient
							lightingService.FogColor = oldthemesettings.FogColor
							lightingService.FogStart = oldthemesettings.FogStart
							lightingService.FogEnd = oldthemesettings.FogEnd
							end)
						end
					end
				})	
			end)

			runFunction(function()
                local ClanDetector = {Enabled = false}
				local alreadyclanchecked = {}
				local blacklistedclans = {}
				local function detectblacklistedclan(plr)
                    if not plr:GetAttribute("LobbyConnected") then repeat task.wait() until plr:GetAttribute("LobbyConnected") end
					for i2, v2 in pairs(blacklistedclans.ObjectList) do
						if GetClanTag(plr) == v2 and alreadyclanchecked[plr] == nil then
							warningNotification("ClanDetector", plr.DisplayName.. " is in the "..v2.." clan!", 15)
							alreadyclanchecked[plr] = true
						end
					end
				end
                ClanDetector = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
                    Name = "ClanDetector",
					Approved = true,
                    Function = function(callback)
						if callback then
                            task.spawn(function()
							for i,v in pairs(playersService:GetPlayers()) do
								task.spawn(function()
								 if v ~= lplr then
								 task.spawn(detectblacklistedclan, v)
								 end
								end)
							end
							table.insert(ClanDetector.Connections, playersService.PlayerAdded:Connect(function(v)
								task.spawn(detectblacklistedclan, v)
							end))
						end)
						end
                    end,
                    HoverText = "detect players in certain clans (customizable)"
                })
				blacklistedclans = ClanDetector.CreateTextList({
					Name = "Clans",
					TempText = "clans to detect",
					AddFunction = function() 
					if ClanDetector.Enabled then
						ClanDetector.ToggleButton(false)
						ClanDetector.ToggleButton(false)
					end
					end
				})
			end)

			runFunction(function()
                local Autowin = {Enabled = false}
				local AutowinNotification = {Enabled = true}
				local bedtween
				local playertween
                Autowin = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
                    Name = "AutoWin",
					ExtraText = function() return bedwarsStore.queueType :find("5v5") and "BedShield" or "Normal" end,
                    Function = function(callback)
                        if callback then
                            task.spawn(function()
								if bedwarsStore.matchState == 0 then repeat task.wait() until bedwarsStore.matchState ~= 0 or not Autowin.Enabled end
								if not shared.VapeFullyLoaded then repeat task.wait() until shared.VapeFullyLoaded or not Autowin.Enabled end
								if not Autowin.Enabled then return end
								vapeAssert(not bedwarsStore.queueType:find("skywars"), "AutoWin", "Skywars not supported.", 7, true, true, "Autowin")
								if isAlive() and FindTeamBed() then
									lplr.Character.Humanoid.Health = 0
									lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
								end
								table.insert(Autowin.Connections, runService.Heartbeat:Connect(function()
									pcall(function()
									if not isnetworkowner(lplr.Character.HumanoidRootPart) and (FindEnemyBed() and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, FindEnemyBed()) > 75 or not FindEnemyBed()) then
										if isAlive() and FindTeamBed() and Autowin.Enabled and not NebulawareStore.GameFinished then
											lplr.Character.Humanoid.Health = 0
											lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
										end
									end
								end)
								end))
								table.insert(Autowin.Connections, lplr.CharacterAdded:Connect(function()
									if not isAlive() then repeat task.wait() until isAlive() end
									local bed = FindEnemyBed()
									if bed and (bed:GetAttribute("BedShieldEndTime") and bed:GetAttribute("BedShieldEndTime") < workspace:GetServerTimeNow() or not bed:GetAttribute("BedShieldEndTime")) then
									bedtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.65, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {CFrame = CFrame.new(bed.Position) + Vector3.new(0, 10, 0)})
									task.wait(0.1)
									bedtween:Play()
									bedtween.Completed:Wait()
									task.spawn(function()
									task.wait(1.5)
									local magnitude = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, bed)
									if magnitude >= 50 and FindTeamBed() and Autowin.Enabled then
										lplr.Character.Humanoid.Health = 0
										lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
									end
									end)
									if AutowinNotification.Enabled then
										local bedname = NebulawareStore.bedtable[bed] or "unknown"
										task.spawn(InfoNotification, "AutoWin", "Destroying "..bedname:lower().." team's bed", 5)
									end
									if not GuiLibrary.ObjectsThatCanBeSaved.NukerOptionsButton.Api.Enabled then
										GuiLibrary.ObjectsThatCanBeSaved.NukerOptionsButton.Api.ToggleButton(false)
									end
									repeat task.wait() until FindEnemyBed() ~= bed or not isAlive()
									if FindTarget(45, bedwarsStore.blockRaycast).RootPart and isAlive() then
										if AutowinNotification.Enabled then
											local team = NebulawareStore.bedtable[bed] or "unknown"
											task.spawn(InfoNotification, "AutoWin", "Killing "..team:lower().." team's teamates", 5)
										end
										repeat
										local target = FindTarget(45, bedwarsStore.blockRaycast)
										if not target.RootPart then break end
										playertween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.30), {CFrame = target.RootPart.CFrame + Vector3.new(0, 3, 0)})
										playertween:Play()
										task.wait()
										until not FindTarget(45, bedwarsStore.blockRaycast).RootPart or not Autowin.Enabled or not isAlive()
									end
									if isAlive() and FindTeamBed() and Autowin.Enabled then
										lplr.Character.Humanoid.Health = 0
										lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
									end
									elseif FindTarget(nil, bedwarsStore.blockRaycast).RootPart then
										task.wait()
										local target = FindTarget(nil, bedwarsStore.blockRaycast)
										playertween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, target.RootPart) / 23.4 / 35, Enum.EasingStyle.Linear), {CFrame = target.RootPart.CFrame + Vector3.new(0, 3, 0)})
										playertween:Play()
										if AutowinNotification.Enabled then
											task.spawn(InfoNotification, "AutoWin", "Killing "..target.Player.DisplayName.." ("..(target.Player.Team and target.Player.Team.Name or "neutral").." Team)", 5)
										end
										playertween.Completed:Wait()
										if not Autowin.Enabled then return end
											if FindTarget(50, bedwarsStore.blockRaycast).RootPart and isAlive() then
												repeat
												target = FindTarget(50, bedwarsStore.blockRaycast)
												if not target.RootPart or not isAlive() then break end
												playertween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.30), {CFrame = target.RootPart.CFrame + Vector3.new(0, 3, 0)})
												playertween:Play()
												task.wait()
												until not FindTarget(50, bedwarsStore.blockRaycast).RootPart or not Autowin.Enabled or not isAlive()
											end
										if isAlive() and FindTeamBed() and Autowin.Enabled then
											lplr.Character.Humanoid.Health = 0
											lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
										end
									else
									if NebulawareStore.GameFinished then return end
									lplr.Character.Humanoid.Health = 0
									lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
									end
								end))
								table.insert(Autowin.Connections, lplr.CharacterAdded:Connect(function()
									if not isAlive() then repeat task.wait() until isAlive() end
									if not NebulawareStore.GameFinished then return end
									local oldpos = lplr.Character.HumanoidRootPart.CFrame
									repeat 
									lplr.Character.HumanoidRootPart.CFrame = oldpos
									task.wait()
									until not isAlive() or not Autowin.Enabled
								end))
							end)
						else
							pcall(function() playertween:Cancel() end)
							pcall(function() bedtween:Cancel() end)
                        end
                    end,
                    HoverText = "best paid autowin 2023!1!!!1!! rel11!11!!1!!!1"
				})
			end)

			runFunction(function()
				local HackerDetector = {Enabled = false}
				local magcheck = {Enabled = false}
				local namecheck = {Enabled = false}
				local namecheck2 = {Enabled = false}
				local abilitycheck = {Enabled = false}
				local toolcheck = {Enabled = false}
				local teamatecheck = {Enabled = false}
				local teleportcheck = {Enabled = false}
				local detectedmethods = {
					InfiniteFly = {},
					Ability = {},
					Nuker = {},
					Name = {},
					Teleport = {}
				}
				local function LoadDetectionMethod(v3)
					local playertype, plrattackable, rankprio = NebulawareFunctions:GetPlayerType(v3)
					task.spawn(function()
						repeat
						pcall(function()
							if magcheck.Enabled and lplr.Character and lplr.Character.PrimaryPart and isAlive(v3) and GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, v.Character.PrimaryPart) >= 10000 and detectedmethods.InfiniteFly[v3] == nil and magcheck.Enabled then
							   task.spawn(warningNotification, "HackerDetector", v3.DisplayName.." is using vape!", 45)
							   task.spawn(NebulawareStore.Tag, "VAPE USER", v3, "FFFF00")
							   detectedmethods.InfiniteFly[v3] = true
							end
						end)
						task.wait(2.5)
						until not HackerDetector.Enabled
					end)
					table.insert(HackerDetector.Connections, vapeEvents.AbilityUsed.Event:Connect(function(char, ability)
						local plr = playersService:GetPlayerFromCharacter(char)
						if not plr then return end
						if plr == v3 and ability == "PARTY_POPPER" and not bedwarsStore.queueType:find("lucky") and detectedmethods.Ability[v3] == nil and abilitycheck.Enabled then
							task.spawn(warningNotification, "HackerDetector", v3.DisplayName.." is using vape!", 45)
						    task.spawn(NebulawareStore.Tag, "VAPE USER", v3, "FFFF00")
							detectedmethods.Ability[v3] = true
						end
					end))
					table.insert(HackerDetector.Connections, vapeEvents.BedwarsBedBreak.Event:Connect(function(tab)
						local selectedtool = nil
						if detectedmethods.Nuker[v3] == nil and tab.player == v3 and toolcheck.Enabled then
							for i,v in pairs(v3.Character:GetChildren()) do
								if v:IsA("Accessory") and v:GetAttribute("InvItem") then
									local acceptedtools = {"axe", "pickaxe", "shears", "shovel"}
									for i2,v2 in pairs(acceptedtools) do
										if v.Name:find(v2) then
											selectedtool = v
											break
										end
									end
									if selectedtool == nil then
										task.spawn(warningNotification, "HackerDetector", v3.DisplayName.." is using vape!", 45)
						                task.spawn(NebulawareStore.Tag, "VAPE USER", v3, "FFFF00")
							            detectedmethods.Nuker[v3] = true
									end
								end
								end
							end
						end))
					table.insert(HackerDetector.Connections, v3.CharacterAdded:Connect(function()
						task.wait(0.3)
						local oldposition = v3.Character.PrimaryPart.Position
						task.wait(1)
						local newposition = v3.Character.PrimaryPart.Position
						if GetMagnitudeOf2Objects(oldposition, newposition, true) > 200 and detectedmethods.Teleport[v3] == nil and teleportcheck.Enabled and not bedwarsStore.queueType:find("skywars") and bedwarsStore.queueType ~= "gun_game" then
							task.spawn(warningNotification, "HackerDetector", v3.DisplayName.." is using vape!", 45)
						    task.spawn(NebulawareStore.Tag, "VAPE USER", v3, "FFFF00")
							detectedmethods.Teleport[v3] = true
						end
					end))
					local nameindex = {"vxpe", "byfron", "Byfron", "config", "Config", "ware", "Ware", "anticheat", "AntiCheat", "snoopy", "SnoopyConfigs"}
					for i,v in pairs(nameindex) do
						if tostring(v.DisplayName):find(v) and detectedmethods.Name[v3] == nil and namecheck.Enabled and tostring(v3.AccountAge) < 15 then
							task.spawn(warningNotification, "HackerDetector", v3.DisplayName.." might be cheating. | Name Check A ("..v:lower()..")", 45)
							detectedmethods.Teleport[v3] = true
						end
					end
				end
                HackerDetector = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
                    Name = "HackerDetector",
					HoverText = "Experimental hacker detector",
                    Function = function(callback)
                            if callback then
								task.spawn(function()
									if not shared.VapeFullyLoaded then repeat task.wait() until shared.VapeFullyLoaded task.wait(5) end
									repeat task.wait() until NebulawareFunctions.WhitelistLoaded
									for i,v in pairs(playersService:GetPlayers()) do
										local playertype, plrattackable, rankprio = NebulawareFunctions:GetPlayerType(v)
										if v ~= lplr and rankprio < 2 and not table.find(shared.NebulawareStore.ConfigUsers, v) then
											task.spawn(LoadDetectionMethod, v)
										end
									end
									table.insert(HackerDetector.Connections, playersService.PlayerAdded:Connect(function(v)
										local playertype, plrattackable, rankprio = NebulawareFunctions:GetPlayerType(v)
										if rankprio < 2 and not table.find(shared.NebulawareStore.ConfigUsers, v) then
										task.spawn(LoadDetectionMethod, v)
										end
									end))
								end)
							end
                    end,
                    HoverText = "detects certain exploits"
                })
				teamatecheck = HackerDetector.CreateToggle({
					Name = "Team Check",
					HoverText = "Skips teammates.",
					Function = function() end,
					Default = true
			    })
                magcheck = HackerDetector.CreateToggle({
					Name = "InfiniteFly",
					Function = function() end
			    })
				abilitycheck = HackerDetector.CreateToggle({
					Name = "Ability",
					HoverText = "Checks for confetti ability or dragon breath being fired in illegal way",
					Function = function() end,
					Default = true
			    })
				toolcheck = HackerDetector.CreateToggle({
					Name = "Nuker",
					HoverText = "Pickaxe check",
					Function = function() end,
					Default = true
			    })
				teleportcheck = HackerDetector.CreateToggle({
					Name = "Teleport",
					HoverText = "checks for suspicious teleports/tweens.",
					Function = function() end,
					Default = true
			    })
				namecheck = HackerDetector.CreateToggle({
					Name = "Name",
					HoverText = "use it to check sus names",
					Function = function() end,
					Default = true
			    })
			end)

		
			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "DoubleHighJumpOptionsButton")
				local jump1height = {Value = 480}
				local jump1height2 = {Value = 230}
				local riskjump = {Enabled = false}
				local jumpTick = 0
                riskjump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
                    Name = "DoubleHighJump",
					HoverText = "Bypassing Velocity HighJump up to 1k.",
					ExtraText = function() return "Velocity" end,
                    Function = function(callback)
                        if callback then
                            task.spawn(function()
								local raycast = workspace:Raycast(lplr.Character.PrimaryPart.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
								local distance = raycast and GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, raycast) or 2343343434
								if (raycast and distance > 8 or not raycast) then
									riskjump.ToggleButton(false)
									return
								end
								if not isAlive() or jumpTick > 0 then
									riskjump.ToggleButton(false)
									return
								end
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, jump1height.Value, 0)
								jumpTick = jumpTick + 1
								task.wait(1)
								if lplr.Character.Humanoid.FloorMaterial == Enum.Material.Air and riskjump.Enabled then
								jumpTick = jumpTick + 2
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, jump2height.Value, 0)
								end
								if riskjump.Enabled then riskjump.ToggleButton(false) end
								local height = jump1height.Value + jump2height.Value
								NebulawareStore.jumpTick = tick() + height / 100
								InfoNotification("DoubleHighJump", "Jumped a total of "..height.." studs.", 4.5)
                            end)
						else
							task.delay(1.5, function() jumpTick = 0 end)
                        end
                    end
                })
				jump1height = riskjump.CreateSlider({
					Name = "Jump 1 Height",
					Function = function() end,
					Min = 50,
					Max = 550,
					Default = 450
			    })
				jump2height = riskjump.CreateSlider({
					Name = "Jump 2 Height",
					Function = function() end,
					Min = 50,
					Max = 550,
					Default = 230
			    })
			end)
    
			runFunction(function()
				local middletween
				local MiddleTP = {Enabled = false}
				MiddleTP = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
					Name = "MiddleTP",
					HoverText = "Tween/Teleport to the middle position.",
					Function = function(callback)
						if callback then
							task.spawn(function()
                                if NebulawareFunctions:LoadTime() <= 0.1 or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled then
                                    MiddleTP.ToggleButton(false)
                                    return
                                end
								pcall(function()
									middletween = workspace:FindFirstChild("RespawnView")
									vapeAssert(middletween, "MiddleTP", "Middle not Found.", 7, true, true, "MiddleTP")
                                    if bedwarsStore.queueType:find("skywars") and getItem("telepearl") and isAlive() then
                                        local pearl = getItem("telepearl")
                                        local projectileexploit = false
                                        if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) projectileexploit = true end
                                        local raycast = workspace:Raycast(middletween.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
                                        raycast = raycast and raycast.Position or middletween.Position
                                        switchItem(pearl.tool)
                                        local fired = bedwars.ClientHandler:Get(bedwars.ProjectileRemote):CallServerAsync(pearl.tool, "telepearl", "telepearl", raycast + Vector3.new(0, 3, 0), raycast + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), httpService:GenerateGUID(), {drawDurationSeconds = 3}, workspace:GetServerTimeNow() - 0.045)
                                        if MiddleTP.Enabled then
                                            MiddleTP.ToggleButton(false)
                                        end
                                        if not GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled and projectileexploit then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) end
                                        if fired then InfoNotification("MiddleTP", "Teleported!") end
                                    else
										vapeAssert(FindTeamBed(), "MiddleTP", bedwarsStore.queueType:find("skywars") and "Telepearl not Found." or "Team Bed not Found.", 7, true, true, "MiddleTP")
										pcall(function() lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
										lplr.Character.Humanoid.Health = 0
										table.insert(MiddleTP.Connections, lplr.CharacterAdded:Connect(function()
											if not MiddleTP.Enabled then return end
                                            local raycast = workspace:Raycast(middletween.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
                                            raycast = raycast and raycast.Position or middletween.Position
											middletween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.49, Enum.EasingStyle.Linear), {CFrame = CFrame.new(raycast) + Vector3.new(0, 5, 0)})
											middletween:Play()
											middletween.Completed:Wait()
											if MiddleTP.Enabled then
												MiddleTP.ToggleButton(false)
											end
											InfoNotification("MiddleTP", "Teleported!")
										end))
                                    end
								end)
							end)
						end
					end,
					HoverText = "Teleport to the middle"
				})
			end)

			 runFunction(function()
				pcall(GuiLibrary.RemoveObject, "FakeLagOptionsButton")
				local FakeLag = {Enabled = false}
				local tweenmoduleEnabled
				local LagRepeatDelay = {Value = 0.20}
				FakeLag = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
					Name = "FakeLag",
					HoverText = "Real lag FE",
					Function = function(callback)
						if callback then
							task.spawn(function()
								local oldvalue = LagRepeatDelay.Value
								repeat task.wait(LagRepeatDelay.Value)
								if LagRepeatDelay.Value ~= oldvalue or not FakeLag.Enabled then return end
								pcall(function()
								if not GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled and not GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled and not NebulawareStore.Tweening then
								lplr.Character.HumanoidRootPart.Anchored = true
								task.wait(0.1)
								lplr.Character.HumanoidRootPart.Anchored = false
								elseif tweenmoduleEnabled then
									tweenmoduleEnabled = false
								end
								end)
								until not FakeLag.Enabled
							end)
						else
							lplr.Character.HumanoidRootPart.Anchored = false
						end
					end
				})
				LagRepeatDelay = FakeLag.CreateSlider({
					Name = "Delay",
					Min = 1,
					Max = 10,
					Function = function()
					if FakeLag.Enabled then
						FakeLag.ToggleButton(false)
						FakeLag.ToggleButton(false)
					 end
				 end
				})
			 end)
    
                runFunction(function()
					local DiamondTP = {Enabled = false}
					local diamondtween
                    local diamondtpextramethods = {
						can_of_beans = function(item, diamond)
							if not isAlive() then return nil end
							if GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, diamond) >= 300 then return nil end
							bedwars.ClientHandler:Get(bedwars.EatRemote):CallServerAsync({
								item = getItem(item).tool
							})
							task.wait(0.2)
							local speed = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, diamond) < 100 and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, diamond) / 23.4 / 32 or 0.49
							diamondtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(diamond.Position) + Vector3.new(0, 5, 0)})
							diamondtween:Play()
							diamondtween.Completed:Wait()
							if DiamondTP.Enabled then
								DiamondTP.ToggleButton(false)
								task.spawn(InfoNotification, "DiamondTP", "Teleported!")
							end
							return true
						end,
                        telepearl = function(item, diamond)
                            if not isAlive() then return nil end
                            if not getItem("telepearl") then return nil end
                            item = getItem(item).tool
							if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then task.wait(0.3) end
                            switchItem(item)
                            local projectileexploit = false
                            if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) projectileexploit = true end
                            bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta.telepearl, "telepearl", "telepearl", diamond.Position + Vector3.new(0, 3, 0), "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
                            local fired = bedwars.ClientHandler:Get(bedwars.ProjectileRemote):CallServerAsync(item, "telepearl", "telepearl", diamond.Position + Vector3.new(0, 3, 0), diamond.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), httpService:GenerateGUID(), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
                           if projectileexploit and not GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) end
                            if not fired then return nil end
                            if DiamondTP.Enabled then
                                DiamondTP.ToggleButton(false)
                                if fired then task.spawn(InfoNotification, "DiamondTP", "Teleported!") end
                            end
                            return true
                    end,
                    jade_hammer = function(item, diamond)
                        if not isAlive() then return nil end
                        if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, bed) > 510 then return nil end
                        if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then
                            repeat task.wait() until bedwars.AbilityController:canUseAbility("jade_hammer_jump") or not DiamondTP.Enabled
                            task.wait(0.1)
                        end
                        if not DiamondTP.Enabled then return end
                        if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then return nil end
                        item = getItem(item).tool
                        switchItem(item)
                        bedwars.AbilityController:useAbility("jade_hammer_jump")
                        task.wait(0.1)
                        diamondtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(diamond.Position) + Vector3.new(0, 5, 0)})
                        diamondtween:Play()
                        diamondtween.Completed:Wait()
                        if DiamondTP.Enabled then
                            DiamondTP.ToggleButton(false)
                            task.spawn(InfoNotification, "DiamondTP", "Teleported!")
                        end
                        return true
                    end,
                    void_axe = function(item, diamond)
                        if not isAlive() then return nil end
                        if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, diamond) > 510 then return nil end
                        if not bedwars.AbilityController:canUseAbility("void_axe_jump") then
                            repeat task.wait() until bedwars.AbilityController:canUseAbility("void_axe_jump") or not DiamondTP.Enabled
                            task.wait(0.1)
                        end
                        if not DiamondTP.Enabled then return end
                        if not bedwars.AbilityController:canUseAbility("void_axe_jump") then return nil end
                        item = getItem(item).tool
                        switchItem(tool)
                        bedwars.AbilityController:useAbility("void_axe_jump")
                        task.wait(0.1)
                        diamondtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(diamond.Position) + Vector3.new(0, 5, 0)})
                        diamondtween:Play()
                        diamondtween.Completed:Wait()
                        if DiamondTP.Enabled then
                            DiamondTP.ToggleButton(false)
                            task.spawn(InfoNotification, "DiamondTP", "Teleported!")
                        end
                        return true
                    end
                    }
					DiamondTP = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
						Name = "DiamondTP",
						Function = function(callback)
							if callback then
								task.spawn(function()
                                if NebulawareFunctions:LoadTime() <= 0.1 or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled then
                                    DiamondTP.ToggleButton(false)
                                    return
                                end
								local diamond = FindItemDrop("diamond")
                                vapeAssert(diamond, "DiamondTP", "Diamond Drop not Found.", 7, true, true, "DiamondTP")
                                local currentmethod = nil
							    for i,v in pairs(bedwarsStore.localInventory.inventory.items) do
								if diamondtpextramethods[v.itemType] ~= nil then
									currentmethod = v.itemType
								end
							    end
                                if currentmethod == nil or (currentmethod ~= nil and diamondtpextramethods[currentmethod](currentmethod, diamond) == nil) then
                                    vapeAssert(FindTeamBed(), "DiamondTP", "Team Bed not Found.", 7, true, true, "DiamondTP")
                                    pcall(function() lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
                                    lplr.Character.Humanoid.Health = 0
										table.insert(DiamondTP.Connections, lplr.CharacterAdded:Connect(function()
											task.wait()
											if not FindItemDrop("diamond") then DiamondTP.ToggleButton(false) return end
											if not DiamondTP.Enabled then return end
											diamondtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.49, Enum.EasingStyle.Linear), {CFrame = CFrame.new(diamond.Position) + Vector3.new(0, 5, 0)})
											diamondtween:Play()
											diamondtween.Completed:Wait()
											if DiamondTP.Enabled then
												DiamondTP.ToggleButton(false)
											end
											InfoNotification("DiamondTP", "Teleported!")
										end))
                                    end
								end)
							  else
								
							end
						end,
						HoverText = "Teleport to a nearby diamond drop."
					})
				  end)
    
				  runFunction(function()
					local EmeraldTP = {Enabled = false}
					local emeraldtween
                    local emeraldtpextramethods = {
						can_of_beans = function(item, emerald)
							if not isAlive() then return nil end
							if GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, emerald) >= 300 then return nil end
							bedwars.ClientHandler:Get(bedwars.EatRemote):CallServerAsync({
								item = getItem(item).tool
							})
							task.wait(0.2)
							local speed = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, emerald) < 100 and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, emerald) / 23.4 / 32 or 0.49
							emeraldtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(emerald.Position) + Vector3.new(0, 5, 0)})
							emeraldtween:Play()
							emeraldtween.Completed:Wait()
							if EmeraldTP.Enabled then
                                EmeraldTP.ToggleButton(false)
                                task.spawn(InfoNotification, "EmeraldTP", "Teleported!")
                            end
							return true
						end,
                        telepearl = function(item, emerald)
                            if not isAlive() then return nil end
                            if not getItem("telepearl") then return nil end
                            item = getItem(item).tool
							if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then task.wait(0.3) end
                            switchItem(item)
                            local projectileexploit = false
                            if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) projectileexploit = true end
							bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta.telepearl, "telepearl", "telepearl", emerald.Position + Vector3.new(0, 3, 0), "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
							local fired = bedwars.ClientHandler:Get(bedwars.ProjectileRemote):CallServerAsync(item, "telepearl", "telepearl", emerald.Position + Vector3.new(0, 3, 0), emerald.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), httpService:GenerateGUID(), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
                           if projectileexploit and not GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) end
                            if not fired then return nil end
                            if EmeraldTP.Enabled then
                                EmeraldTP.ToggleButton(false)
                                task.spawn(InfoNotification, "EmeraldTP", "Teleported!")
                            end
                        return true
                    end,
                    jade_hammer = function(item, emerald)
                        if not isAlive() then return nil end
                        if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, bed) > 510 then return nil end
                        if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then
                            repeat task.wait() until bedwars.AbilityController:canUseAbility("jade_hammer_jump") or not EmeraldTP.Enabled
                            task.wait(0.1)
                        end
                        if not EmeraldTP.Enabled then return end
                        if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then return nil end
                        item = getItem(item).tool
                        switchItem(item)
                        bedwars.AbilityController:useAbility("jade_hammer_jump")
                        task.wait(0.1)
                        emeraldtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(emerald.Position) + Vector3.new(0, 5, 0)})
                        emeraldtween:Play()
                        emeraldtween.Completed:Wait()
                        if EmeraldTP.Enabled then
                            EmeraldTP.ToggleButton(false)
                            task.spawn(InfoNotification, "EmeraldTP", "Teleported!")
                        end
                        return true
                    end,
                    void_axe = function(item, emerald)
                        if not isAlive() then return nil end
                        if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, emerald) > 510 then return nil end
                        if not bedwars.AbilityController:canUseAbility("void_axe_jump") then
                            repeat task.wait() until bedwars.AbilityController:canUseAbility("void_axe_jump") or not EmeraldTP.Enabled
                            task.wait(0.1)
                        end
                        if not EmeraldTP.Enabled then return end
                        if not bedwars.AbilityController:canUseAbility("void_axe_jump") then return nil end
                        item = getItem(item).tool
                        switchItem(tool)
                        bedwars.AbilityController:useAbility("void_axe_jump")
                        task.wait(0.1)
                        emeraldtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(emerald.Position) + Vector3.new(0, 5, 0)})
                        emeraldtween:Play()
                        emeraldtween.Completed:Wait()
                        if EmeraldTP.Enabled then
                            EmeraldTP.ToggleButton(false)
                            task.spawn(InfoNotification, "EmeraldTP", "Teleported!")
                        end
                        return true
                    end
                    }
					EmeraldTP = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
						Name = "EmeraldTP",
						Function = function(callback)
							if callback then
								task.spawn(function()
									if NebulawareFunctions:LoadTime() <= 0.1 or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled then
                                        EmeraldTP.ToggleButton(false)
                                        return
                                    end
									local emerald = FindItemDrop("emerald")
                                    vapeAssert(emerald, "EmeraldTP", "Emerald Drop not Found.", 7, true, true, "EmeraldTP")
                                    local currentmethod = nil
                                    for i,v in pairs(bedwarsStore.localInventory.inventory.items) do
                                        if emeraldtpextramethods[v.itemType] ~= nil then
                                            currentmethod = v.itemType
                                        end
                                    end
                                    if currentmethod == nil or (currentmethod ~= nil and emeraldtpextramethods[currentmethod](currentmethod, emerald) == nil) then
                                        vapeAssert(FindTeamBed(), "EmeraldTP", "Team Bed Not Found.", 7, true, true, "EmeraldTP")
										pcall(function() lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
										lplr.Character.Humanoid.Health = 0
										table.insert(EmeraldTP.Connections, lplr.CharacterAdded:Connect(function()
											task.wait()
											if not FindItemDrop("emerald") then EmeraldTP.ToggleButton(false) return end
											if not EmeraldTP.Enabled then return end
											emeraldtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.49, Enum.EasingStyle.Linear), {CFrame = CFrame.new(emerald.Position) + Vector3.new(0, 5, 0)})
											emeraldtween:Play()
											emeraldtween.Completed:Wait()
											if EmeraldTP.Enabled then
												EmeraldTP.ToggleButton(false)
											end
											InfoNotification("EmeraldTP", "Teleported!")
										end))
                                    end
								end)
							  else
								
							end
						end,
						HoverText = "Teleport to a nearby emerald drop."
					})
				  end)

    
		        runFunction(function()
				pcall(function()
                local joincustoms = {Enabled = true}
                joincustoms = GuiLibrary.ObjectsThatCanBeSaved.MatchMakingWindow.Api.CreateOptionsButton({
                    Name = "JoinCustoms",
                    Function = function(callback)
                        if callback then
                            task.spawn(function()
                                local invalid = customcode.Value == "" or customcode.Value == "EZGG" or customcode.Value == "ezgg"
                                joincustoms.ToggleButton(false)
                                if invalid then
                                    InfoNotification("JoinCustoms","Invalid Match code.",5)
                                else
                                    InfoNotification("JoinCustoms","Joining "..customcode.Value,5)
                                end
                                bedwars.NetManaged["CustomMatches:JoinByCode"]:FireServer(table.unpack({
                                    [1] = httpService:GenerateGUID(true),
                                    [2] = {
                                        [1] = customcode.Value,
                                    },
                                }))
                            end)
                        end
                    end,
                    HoverText = "Join a existing custom match faster."
                })
                customcode = joincustoms.CreateTextBox({
                    Name = "Match code",
                    TempText = "code for the match",
                    Function = function() end
                })
			end)
			end)
        
			runFunction(function()
				local ViewModelColoring = {Enabled = false}
				local outlinelighting = {Enabled = false}
				local viewmodelneon = {Enabled = false}
				local viewmodeloutlineonly = {Enabled = false}
				local viewmodelthirdperson = {Enabled = true}
				local ViewModelColorMode = {Value = "Highlight"}
				local viewmodelcolor = {Hue = 0, Sat = 0, Value = 0}
				local vmchighlightobjects = {}
				local viewmodeloldtexture
				local viewmodeloldtexture2
				local viewmodelhandle
				local thirdpersoninvitem
				local function viewmodelFunction(handle)
					pcall(function()
						handle = handle or gameCamera:FindFirstChild("Viewmodel"):FindFirstChildWhichIsA("Accessory"):FindFirstChild("Handle")
						viewmodelhandle = handle
						thirdpersoninvitem = nil
						pcall(function()
						if ViewModelColorMode.Value == "Highlight" or ViewModelColorMode.Value == "Outline Only" then
							if handle:FindFirstChildWhichIsA("Highlight") then
								vmhighlight = handle:FindFirstChildWhichIsA("Highlight")
							else
							viewmodeloldtexture = nil
							local vmhighlight = Instance.new("Highlight")
							vmhighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							vmhighlight.Enabled = true
							vmhighlight.OutlineTransparency = ViewModelColorMode.Value == "Outline Only" and 0 or outlinelighting.Enabled and 0 or 1
							vmhighlight.FillTransparency = ViewModelColorMode.Value == "Outline Only" and 1 or 0.28
							vmhighlight.FillColor = Color3.fromHSV(viewmodelcolor.Hue, viewmodelcolor.Sat, viewmodelcolor.Value)
							vmhighlight.Parent = handle
							table.insert(vmchighlightobjects, vmhighlight)
							end
							pcall(function() vmhighlight.FillColor = Color3.fromHSV(viewmodelcolor.Hue, viewmodelcolor.Sat, viewmodelcolor.Value) end)
						else
							local texture, id = pcall(function() return handle.TextureID end)
							if texture and id ~= "" then
							viewmodeloldtexture = id
							end
							handle.TextureID = ""
							handle.Material = viewmodelneon.Enabled and Enum.Material.Neon or Enum.Material.SmoothPlastic
							handle.Color = Color3.fromHSV(viewmodelcolor.Hue, viewmodelcolor.Sat, viewmodelcolor.Value)
							if not handle:FindFirstChildWhichIsA("Highlight") and outlinelighting.Enabled then 
							local vmhighlight = Instance.new("Highlight")
							vmhighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							vmhighlight.Enabled = true
							vmhighlight.OutlineTransparency = 0
							vmhighlight.FillTransparency = 1
							vmhighlight.Parent = handle
							table.insert(vmchighlightobjects, vmhighlight)
							end
						end
					end)
					end)
				end
				local function refreshViewmodel()
					if viewmodeloldtexture then
						pcall(function() viewmodelhandle.TextureID = viewmodeloldtexture end)
					end
					if viewmodeloldtexture2 then

						pcall(function() thirdpersoninvitem.TextureID = viewmodeloldtexture2 end)
					end
					for i,v in pairs(vmchighlightobjects) do
						pcall(function() v:Destroy() end)
					end
					table.clear(vmchighlightobjects)
					pcall(viewmodelFunction)
				end
                ViewModelColoring = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
                    Name = "ViewModelColoring",
                    Function = function(callback)
                        if callback then
                            task.spawn(function() 
								local viewmodelsuc, viewmodelres = pcall(function() return gameCamera.Viewmodel end)
								pcall(function() viewmodelneon.Object.Visible = (ViewModelColorMode.Value == "Brick Color") end)
								pcall(function() viewmodelcolor.Object.Visible = (ViewModelColorMode.Value ~= "Outline Only" and true or false) end)
								pcall(function() outlinelighting.Object.Visible = (ViewModelColorMode.Value ~= "Outline Only" and true or false) end)
								if not viewmodelsuc then repeat viewmodelsuc, viewmodelres = pcall(function() return gameCamera.Viewmodel end) task.wait() until viewmodelsuc end
								table.insert(ViewModelColoring.Connections, gameCamera.Viewmodel.ChildAdded:Connect(refreshViewmodel))
								table.insert(ViewModelColoring.Connections, gameCamera.ChildAdded:Connect(function(v)
									if v.Name == "Viewmodel" then
										refreshViewmodel()
									end
								end))
								viewmodelFunction()
                            end)
                        else
							if viewmodeloldtexture then
								pcall(function() viewmodelhandle.TextureID = viewmodeloldtexture end)
							end
							if viewmodeloldtexture2 then
								pcall(function() thirdpersoninvitem.TextureID = viewmodeloldtexture2 end)
							end
							for i,v in pairs(vmchighlightobjects) do
								pcall(function() v:Destroy() end)
							end
							table.clear(vmchighlightobjects)
                        end
                    end,
                    HoverText = "Customize the color of the first person viewmodel."
                })
				ViewModelColorMode = ViewModelColoring.CreateDropdown({
					Name = "Method",
					List = {"Highlight", "Brick Color", "Outline Only"},
					Function = function()
						if ViewModelColoring.Enabled then
							ViewModelColoring.ToggleButton(false)
							ViewModelColoring.ToggleButton(false)
						end
					end
				})
				viewmodelcolor = ViewModelColoring.CreateColorSlider({
					Name = "Color",
					Function = function()
						if ViewModelColoring.Enabled then
							pcall(viewmodelFunction)
						end
					end
				})
				outlinelighting = ViewModelColoring.CreateToggle({
					Name = "Outline Highlight",
					Function = function()
						if ViewModelColoring.Enabled then
							ViewModelColoring.ToggleButton(false)
							ViewModelColoring.ToggleButton(false)
						end
					end
				})
				viewmodelneon = ViewModelColoring.CreateToggle({
					Name = "Neon",
					Function = function()
						if ViewModelColoring.Enabled then
							ViewModelColoring.ToggleButton(false)
							ViewModelColoring.ToggleButton(false)
						end
					end
				})
				viewmodelneon.Object.Visible = (ViewModelColorMode.Value == "Brick Color" and true or false)
				viewmodelcolor.Object.Visible = (ViewModelColorMode.Value ~= "Outline Only" and true or false)
				outlinelighting.Object.Visible = (ViewModelColorMode.Value ~= "Outline Only" and true or false)
			end)

			runFunction(function()
                pcall(GuiLibrary.RemoveObject, "InfiniteJumpOptionsButton")
				local InfiniteJump = {Enabled = false}
				local InfiniteJumpMode = {Value = "Hold"}
				InfiniteJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
					Name = "InfiniteJump",
					HoverText = "Jump freely with no limitations (maybe not with anti-cheat :omegalol:).",
					Function = function(callback)
						if callback then
							task.spawn(function()
								table.insert(InfiniteJump.Connections, inputService.JumpRequest:Connect(function()
								if InfiniteJumpMode.Value == "Hold" then
									if isAlive(lplr) and isnetworkowner(lplr.Character.HumanoidRootPart) then
								      lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
									  local raycast = workspace:Raycast(lplr.Character.PrimaryPart.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
		                              raycast = raycast and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, raycast) or nil
									  NebulawareStore.jumpTick = tick() + (raycast and raycast / 35 or 4.5)
								    end
								end
							end))
							table.insert(InfiniteJump.Connections, inputService.InputBegan:Connect(function(input)
								if InfiniteJumpMode.Value == "Single" and input.KeyCode == Enum.KeyCode.Space and not inputService:GetFocusedTextBox() then
									if isAlive(lplr) and isnetworkowner(lplr.Character.HumanoidRootPart) then
									lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
									local raycast = workspace:Raycast(lplr.Character.PrimaryPart.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
		                            raycast = raycast and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, raycast) or nil
									NebulawareStore.jumpTick = tick() + (raycast and raycast / 35 or 1)
									end
								end
							end))
						end)
					  end
				   end
				})
				if not NebulawareStore.MobileInUse then
				InfiniteJumpMode = InfiniteJump.CreateDropdown({
					Name = "Mode",
					List = {"Single", "Hold"},
					Function = function() end
				})
			end
			end)
			
			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "PlayerAttachOptionsButton")
				local attachexploit = {Enabled = false}
				local MaxAttachRange = {Value = 20}
				local attachexploitraycast = {Value = false}
				local attachmethod = {Value = "Distance"}
				local attachexploitall = {Enabled = true}
				local attachexploitanimate = {Enabled = false}
				local playertween
				local ent 
                attachexploit = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
                    Name = "7BitchesExploit",
                    Function = function(callback)
                        if callback then
                            task.spawn(function()
							    local raycastmethod = attachexploitraycast.Enabled and bedwarsStore.blockRaycast or false
								ent = FindTarget(MaxAttachRange.Value, raycastmethod, attachexploitall.Enabled)
								if not isAlive(lplr) or not isnetworkowner(entityLibrary.character.HumanoidRootPart) or (attachmethod.Value == "Distance" and not ent.RootPart or vapeTargetInfo.Targets.Killaura == nil) or NebulawareFunctions:LoadTime() < 0.1 then
									attachexploit.ToggleButton(false)
									return
								end
								repeat
								local raycastmethod = attachexploitraycast.Enabled and bedwarsStore.blockRaycast or false
								ent = FindTarget(MaxAttachRange.Value, raycastmethod, attachexploitall.Enabled)
								if not attachexploit.Enabled or (attachmethod.Value == "Distance" and not ent.Player or attachmethod.Value ~= "Distance" and vapeTargetInfo.Targets.Killaura == nil) or not isAlive(lplr) or not isnetworkowner(entityLibrary.character.HumanoidRootPart) then attachexploit.ToggleButton(false) return end
								if attachexploitanimate.Enabled then
									playertween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.27), {CFrame = ent.RootPart.CFrame})
									playertween:Play()
								else
								lplr.Character.HumanoidRootPart.CFrame = attachmethod.Value == "Distance" and ent.RootPart.CFrame or vapeTargetInfo.Targets.Killaura.Player.Character.PrimaryPart.CFrame
								end
								NebulawareStore.jumpTick = tick() + 0.30
								task.wait()
								until not attachexploit.Enabled
							end)
						else
							pcall(function() playertween:Cancel() end)
							playertween = nil
                        end
                    end,
                    HoverText = "Attach to the closest player in a certain range."
                })
				attachmethod = attachexploit.CreateDropdown({
					Name = "Method",
					List = {"Distance", "Killaura Target"},
					Function = function() end
				})
				MaxAttachRange = attachexploit.CreateSlider({
                    Name = "Max Range",
                    Min = 10,
                    Max = 50, 
                    Function = function() end,
                    Default = 20
                })
				attachexploitraycast = attachexploit.CreateToggle({
					Name = "Void Check",
					HoverText = "Stops teleporting to the target when falling into the void.",
					Function = function() end
				})
				attachexploitall = attachexploit.CreateToggle({
					Name = "Mobs",
					HoverText = "attaches to nearby mobs. (monster, golem, guardian etc.).",
					Function = function() end
				})
				attachexploitanimate = attachexploit.CreateToggle({
					Name = "Tween",
					HoverText = "Tweens instead of teleportng.",
					Function = function() end
				})
			end)

			runFunction(function()
				local hpbar = {Enabled = false}
                local hpuicorner
				local hpbarcolor
				local updatehpbar = function()
					local suc = pcall(function()
					getHealthbar("1").BackgroundColor3 = Color3.fromHSV(hpbarcolor.Hue, hpbarcolor.Sat, hpbarcolor.Value)
					if hprounding.Enabled and not getHealthbar("1"):FindFirstChildWhichIsA("UICorner") then
						hpuicorner = Instance.new("UICorner")
						hpuicorner.Parent = getHealthbar("1")
						hpuicorner.CornerRadius = UDim.new(0, 8)
						hpuicorner2 = Instance.new("UICorner")
						hpuicorner2.Parent = getHealthbar("1")
						hpuicorner2.CornerRadius = UDim.new(0, 8)
                     elseif getHealthbar("1"):FindFirstChildWhichIsA("UICorner") and not hprounding.Enabled then
                        pcall(function() hpuicorner:Destroy() end)
					end
				end)
				return suc
				end
                hpbar = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
                    Name = "HealthbarCustomization",
                    Function = function(callback)
                        if callback then
                            task.spawn(function()
								updatehpbar()
								table.insert(hpbar.Connections, game.DescendantAdded:Connect(function(v)
									if v.Name == "HotbarHealthbarContainer" and v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "hotbar" then
										if not getHealthbar("1") then repeat task.wait() until getHealthbar("1") end
										task.spawn(updatehpbar)
									end
								end))
                            end)
                        else
                            pcall(function() hpuicorner:Destroy() end)
                            pcall(function() getHealthbar("1").BackgroundColor3 = Color3.fromRGB(203, 54, 36) end)
                        end
                    end,
                    HoverText = "Custom healthbar."
                })
				hpbarcolor = hpbar.CreateColorSlider({
					Name = "Background Color",
					Function = function() if hpbar.Enabled then task.spawn(updatehpbar) end end
				})
				hprounding = hpbar.CreateToggle({
					Name = "Round",
					Default = true,
					Function = function() if hpbar.Enabled then hpbar.ToggleButton(false) hpbar.ToggleButton(false) end end
				})
			end)
				
			runFunction(function()
				local HotbarCustomization = {Enabled = false}
				local InvSlotCornerRadius = {Value = 8}
				local InventoryRounding = {Enabled = true}
				local HideSlotNumbers = {Enabled = false}
				local SlotBackgroundColor = {Enabled = false}
				local SlotBackgroundColorSlider = {Hue = 0.44, Sat = 0.31, Value = 0.28}
				local SlotNumberBackgroundColorToggle = {Enabled = false}
				local SlotNumberBackgroundColor = {Hue = 0.44, Sat = 0.31, Value = 0.28}
				local hotbarwaitfunc
				local hotbarstuff = {
					SlotCorners = {},
					HiddenSlotNumbers = {},
					SlotOldColor = nil
				}
				local inventoryicons
				local function HotbarFunction()
					hotbarwaitfunc = pcall(function() return lplr.PlayerGui.hotbar and lplr.PlayerGui.hotbar["1"]["5"] end)
					   if not hotbarwaitfunc then 
					   repeat task.wait() hotbarwaitfunc = pcall(function() return lplr.PlayerGui.hotbar and lplr.PlayerGui.hotbar["1"]["5"] end) until hotbarwaitfunc 
					 end

					inventoryicons = lplr.PlayerGui.hotbar["1"]["5"]
					for i,v in pairs(inventoryicons:GetChildren()) do
						if v:IsA("Frame") then
							if InventoryRounding.Enabled then
							hotbarstuff.SlotOldColor = v:FindFirstChildWhichIsA("ImageButton").BackgroundColor3
							local rounding = Instance.new("UICorner")
							rounding.Parent = v:FindFirstChildWhichIsA("ImageButton")
							rounding.CornerRadius = UDim.new(0, InvSlotCornerRadius.Value)
							table.insert(hotbarstuff.SlotCorners, rounding)
							end
							if SlotBackgroundColor.Enabled then
								pcall(function() v:FindFirstChildWhichIsA("ImageButton").BackgroundColor3 = Color3.fromHSV(SlotBackgroundColorSlider.Hue, SlotBackgroundColorSlider.Sat, SlotBackgroundColorSlider.Value) end)
							end
							if HideSlotNumbers.Enabled then
								pcall(function() 
								local slotText = v:FindFirstChildWhichIsA("ImageButton"):FindFirstChildWhichIsA("TextLabel")
								slotText.Parent = game 
								hotbarstuff.HiddenSlotNumbers[slotText] = v:FindFirstChildWhichIsA("ImageButton")
							    end)
							end
						end
					end
				end
				HotbarCustomization = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
					Name = "HotbarCustomization",
					HoverText = "Customize the ugly default hotbar to your liking.",
					Approved = true,
					Function = function(callback)
						if callback then
							task.spawn(HotbarFunction)
							table.insert(HotbarCustomization.Connections, lplr.CharacterAdded:Connect(HotbarFunction))
						else
							for i,v in pairs(hotbarstuff.SlotCorners) do
								pcall(function() v:Destroy() end)
							end
							for i,v in pairs(inventoryicons:GetChildren()) do
								pcall(function() v:FindFirstChildWhichIsA("ImageButton").BackgroundColor3 = hotbarstuff.SlotOldColor end)
							end
							for i,v in pairs(hotbarstuff.HiddenSlotNumbers) do
								pcall(function() i.Parent = v end)
							end
						end
					end
				})
				InventoryRounding = HotbarCustomization.CreateToggle({
					Name = "Round Slots",
					Function = function(callback)
						pcall(function() InvSlotCornerRadius.Object.Visible = callback end)
						if callback and HotbarCustomization.Enabled then
							HotbarCustomization.ToggleButton(false) HotbarCustomization.ToggleButton(false)
						elseif HotbarCustomization.Enabled then
						  for i,v in pairs(hotbarstuff.SlotCorners) do
							pcall(function() v:Destroy() end)
					    end
					end
				end
			  })
			  HideSlotNumbers = HotbarCustomization.CreateToggle({
				Name = "Hide Slot Numbers",
				HoverText = "hide the ugly slot numbers.",
				Function = function() if HotbarCustomization.Enabled then HotbarCustomization.ToggleButton(false) HotbarCustomization.ToggleButton(false) end end
			  })
			  InvSlotCornerRadius = HotbarCustomization.CreateSlider({
				Name = "Corner Radius",
				Function = function(val) if HotbarCustomization.Enabled and InventoryRounding.Enabled then for i,v in pairs(hotbarstuff.SlotCorners) do pcall(function() v.CornerRadius = UDim.new(0, val) end) end end end,
				Min = 8,
				Max = 20
		    })
			  SlotBackgroundColor = HotbarCustomization.CreateToggle({
				 Name = "Slot Background Color",
				 Function = function(callback) pcall(function() SlotBackgroundColorSlider.Object.Visible = callback end) 
				 if HotbarCustomization.Enabled then
					HotbarCustomization.ToggleButton(false) HotbarCustomization.ToggleButton(false)
			     end 
			     end
			  })
			  SlotBackgroundColorSlider = HotbarCustomization.CreateColorSlider({
				Name = "Color",
				Function = function(h, s, v) if HotbarCustomization.Enabled and SlotBackgroundColor.Enabled and inventoryicons then
					for i,v in pairs(inventoryicons:GetChildren()) do
						pcall(function() v:FindFirstChildWhichIsA("ImageButton").BackgroundColor3 = Color3.fromHSV(SlotBackgroundColorSlider.Hue, SlotBackgroundColorSlider.Sat, SlotBackgroundColorSlider.Value) end)
					end
				end
			    end
			})
			   InvSlotCornerRadius.Object.Visible = InventoryRounding.Enabled
			   SlotBackgroundColorSlider.Object.Visible = SlotBackgroundColor.Enabled
			end)

			runFunction(function()
				local SetEmote = {Enabled = false}
				local SetEmoteList = {Value = ""}
				local oldemote
				local SetEmoteName2 = {}
				SetEmote = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
					Name = "SetEmote",
					Function = function(callback)
						if callback then
							task.spawn(function()
								safeFunction(lplr, function()
								task.wait(3)
								if SetEmote.Enabled then oldemote = bedwars.ClientStoreHandler:getState().Locker.selectedSpray end
								repeat
								if SetEmote.Enabled and bedwars.ClientStoreHandler:getState().Locker.selectedSpray ~= SetEmoteName2[SetEmoteList.Value] then
									if bedwars.ClientStoreHandler:getState().Locker.selectedSpray == SetEmoteName2[SetEmoteList.Value] then return end
									bedwars.ClientStoreHandler:getState().Locker.selectedSpray = SetEmoteName2[SetEmoteList.Value]
								end
								task.wait()
							until bedwars.ClientStoreHandler:getState().Locker.selectedSpray == SetEmoteName2[SetEmoteList.Value] or not SetEmote.Enabled
							end)
							end)
						else
							if oldemote then 
								bedwars.ClientStoreHandler:getState().Locker.selectedSpray = oldemote
								oldemote = nil 
							end
						end
					end
				})
				local SetEmoteName = {}
				for i,v in pairs(bedwars.EmoteMeta) do 
					table.insert(SetEmoteName, v.name)
					SetEmoteName2[v.name] = i
				end
				table.sort(SetEmoteName, function(a, b) return a:lower() < b:lower() end)
				SetEmoteList = SetEmote.CreateDropdown({
					Name = "Emote",
					List = SetEmoteName,
					Function = function()
						if SetEmote.Enabled then 
							bedwars.ClientStoreHandler:getState().Locker.selectedSpray = SetEmoteName2[SetEmoteList.Value]
						end
					end
				})
			end)

			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "BoostHighJumpOptionsButton")
				local SmoothHighJump = {Enabled = false}
				local SmoothJumpTick = {Value = 5}
				local SmoothJumpTime = {Value = 1.2}
				local boostTick = 5
				SmoothHighJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
				Name = "BoostHighJump",
				Function = function(callback)
					if callback then
						task.spawn(function()
							local raycast = workspace:Raycast(lplr.Character.PrimaryPart.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
							local distance = raycast and GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, raycast) or 3232424
							if not isAlive() or not isnetworkowner(entityLibrary.character.HumanoidRootPart) or NebulawareFunctions:LoadTime() < 0.1 or (distance > 5) or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled or GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled then SmoothHighJump.ToggleButton(false) return end
							task.delay(SmoothJumpTime.Value, function()
								if SmoothHighJump.Enabled then
									SmoothHighJump.ToggleButton(false)
								end
							end)	
							repeat
							if not isAlive(lplr) or not isnetworkowner(entityLibrary.character.HumanoidRootPart) or NebulawareFunctions:LoadTime() < 0.1 or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled or GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled then SmoothHighJump.ToggleButton(false) return end
							 lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, boostTick, 0)
							 boostTick = boostTick + SmoothJumpTick.Value
							 if NebulawareStore.jumpTick <= tick() then
							 NebulawareStore.jumpTick = tick() + 3
							 end
							 task.wait()
							until not SmoothHighJump.Enabled
						end)
					else
						NebulawareStore.jumpTick = tick() + (boostTick / 30)
						boostTick = 5
					end
				end
			})
			SmoothJumpTick = SmoothHighJump.CreateSlider({
				Name = "Power",
				Min = 2,
				Max = 10,
				Default = 3,
				Function = function() end
			})
			SmoothJumpTime = SmoothHighJump.CreateSlider({
				Name = "Time",
				Min = 0.2,
				Max = 2,
				Default = 1.2,
				Function = function() end
			})
		end)

		runFunction(function()
			local NoNameTag = {Enabled = false}
			NoNameTag = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
				Name = "NoNameTag",
				Function = function(callback)
					if callback then
						task.spawn(function()
                            if not isAlive() then repeat task.wait() until isAlive() end
							pcall(function() lplr.Character.Head.Nametag:Destroy() end)
							table.insert(NoNameTag.Connections, lplr.Character.Head.ChildAdded:Connect(function(v)
                                if v.Name == "Nametag" then
                                    v:Destroy()
                                end
                            end))
                            table.insert(NoNameTag.Connections, lplr.CharacterAdded:Connect(function()
                                if not isAlive() then repeat task.wait() until isAlive() end
                                NoNameTag.ToggleButton(false)
                                NoNameTag.ToggleButton(false)
                            end))
						end)
					end
				end
			})
		end)

			runFunction(function()
				pcall(GuiLibrary.RemoveObject, "FlyTPOptionsButton")
				local TPFly = {Enabled = false}
				local TPFlyVerticalHeight = {Value = 15}
				local oldgravity
				TPFly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
				Name = "FlyTP",
				HoverText = "a shit fly I would call this :omegalol:",
				Function = function(callback)
					if callback then
						task.spawn(function()
							oldgravity = workspace.Gravity
							workspace.Gravity = 0
							repeat
							 if not TPFly.Enabled then return end
							 if not isnetworkowner(lplr.Character.HumanoidRootPart) or not isAlive(lplr) or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled or NebulawareFunctions:LoadTime() < 0.1 then TPFly.ToggleButton(false) return end
							 lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, TPFlyVerticalHeight.Value, 0)
							 lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, -1, 0)
							 NebulawareStore.jumpTick = tick() + 2
					         task.wait(0.1)
							until not TPFly.Enabled
						end)
					else
						workspace.Gravity = oldgravity ~= 0 and oldgravity or 192
						local raycast = workspace:Raycast(lplr.Character.PrimaryPart.Position, Vector3.new(0, -2000, 0), bedwarsStore.blockRaycast)
		                raycast = raycast and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, raycast) or nil
						NebulawareStore.jumpTick = tick() + (raycast and raycast / 35 or 4.5)
					end
				end
			})
			TPFlyVerticalHeight = TPFly.CreateSlider({
				Name = "Vertical Height",
				Function = function() end,
				Min = 5,
				Max = 100,
				Default = 15
			})
		end)

		runFunction(function()
			local DamageIndicator = {Enabled = false}
			local DamageIndicatorColorToggle = {Enabled = false}
			local DamageIndicatorColor = {Hue = 0, Sat = 0, Value = 0}
			local DamageIndicatorTextToggle = {Enabled = false}
			local DamageIndicatorText = {ObjectList = {}}
			local DamageIndicatorFontToggle = {Enabled = false}
			local DamageIndicatorFont = {Value = "GothamBlack"}
			local DamageIndicatorTextObjects = {}
			local function updateIndicator(indicatorobject)
				pcall(function()
					indicatorobject.TextColor3 = DamageIndicatorColorToggle.Enabled and Color3.fromHSV(DamageIndicatorColor.Hue, DamageIndicatorColor.Sat, DamageIndicatorColor.Value) or indicator.TextColor3
					indicatorobject.Text = DamageIndicatorTextToggle.Enabled and #DamageIndicatorText.ObjectList > 0 and DamageIndicatorText.ObjectList[math.random(1, #DamageIndicatorText.ObjectList)] or indicatorobject.Text
					indicatorobject.Font = DamageIndicatorFontToggle.Enabled and Enum.Font[DamageIndicatorFont.Value] or indicatorobject.Font
				end)
			end
			DamageIndicator = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
				Name = "DamageIndicator",
				Function = function(callback)
					if callback then
						task.spawn(function()
							table.insert(DamageIndicator.Connections, game.DescendantAdded:Connect(function(v)
								pcall(function()
								if v.Name ~= "DamageIndicatorPart" then return end
									local indicatorobj = v:FindFirstChildWhichIsA("BillboardGui"):FindFirstChildWhichIsA("Frame"):FindFirstChildWhichIsA("TextLabel")
									if indicatorobj then
										updateIndicator(indicatorobj)
									end
								end)
							end))
						end)
					end
				end
			})
			DamageIndicatorColorToggle = DamageIndicator.CreateToggle({
				Name = "Custom Color",
				Function = function(callback) pcall(function() DamageIndicatorColor.Object.Visible = callback end) end
			})
			DamageIndicatorColor = DamageIndicator.CreateColorSlider({
				Name = "Text Color",
				Function = function() end
			})
			DamageIndicatorTextToggle = DamageIndicator.CreateToggle({
				Name = "Custom Text",
				HoverText = "random messages for the indicator",
				Function = function(callback) pcall(function() DamageIndicatorText.Object.Visible = callback end) end
			})
			DamageIndicatorText = DamageIndicator.CreateTextList({
				Name = "Text",
				TempText = "Indicator Text",
				AddFunction = function() end
			})
			DamageIndicatorFontToggle = DamageIndicator.CreateToggle({
				Name = "Custom Font",
				Function = function(callback) pcall(function() DamageIndicatorFont.Object.Visible = callback end) end
			})
			DamageIndicatorFont = DamageIndicator.CreateDropdown({
				Name = "Font",
				List = GetEnumItems("Font"),
				Function = function() end
			})
			DamageIndicatorColor.Object.Visible = DamageIndicatorColorToggle.Enabled
			DamageIndicatorText.Object.Visible = DamageIndicatorTextToggle.Enabled
			DamageIndicatorFont.Object.Visible = DamageIndicatorFontToggle.Enabled
		end)

		runFunction(function()
			local mouseposition
			local deathtween
			local DeathTP = {Enabled = false}
			DeathTP = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
				Name = "DeathTP",
				HoverText = "Teleport to the toggle position whenever u respawn.",
				Function = function(callback) 
				if callback then
					task.spawn(function()
						DeathTP.ToggleButton(false)
						pcall(function() NebulawareStore.DeathFunction:Disconnect() end)
						local AutoDeathTP = GuiLibrary.ObjectsThatCanBeSaved.AutoDeathTPOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.AutoDeathTPOptionsButton.Api.Enabled
						mouseposition = workspace:Raycast(gameCamera.CFrame.p, lplr:GetMouse().UnitRay.Direction * 10000, bedwarsStore.blockRaycast)
						if not mouseposition or AutoDeathTP or not vapeInjected then return end
						task.spawn(InfoNotification, "DeathTP", "Death Position Set.", 7)
						NebulawareStore.DeathFunction = lplr.CharacterAdded:Connect(function()
							local AutoDeathTP = GuiLibrary.ObjectsThatCanBeSaved.AutoDeathTPOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.AutoDeathTPOptionsButton.Api.Enabled
							NebulawareStore.DeathFunction:Disconnect()
							if not isAlive() then repeat task.wait() until isAlive() end
							task.wait(0.2)
							if NebulawareStore.Tweening then return end
							if AutoDeathTP then return end
							deathtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.49, Enum.EasingStyle.Linear), {CFrame = CFrame.new(mouseposition.Position) + Vector3.new(0, 5, 0)})
							deathtween:Play()
							deathtween.Completed:Wait()
							task.spawn(InfoNotification, "DeathTP", "Teleported.", 7)
						end)
					end)
				end
			end
			})
		end)

		runFunction(function()
			local BedTP = {Enabled = false}
			local BedTweenMethod = {Value = "Linear"}
			local BedTPVelo = {Value = 5}
			local BedTPSpeed = {Value = 49}
			local bedtween
			local bedtpextramethods = {
				can_of_beans = function(item, bed)
				if not isAlive() then return nil end
				if GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, bed) >= 300 then return nil end
				bedwars.ClientHandler:Get(bedwars.EatRemote):CallServerAsync({
					item = getItem(item).tool
				})
				task.wait(0.2)
				local speed = GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, bed) < 280 and GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, bed) / 23.4 / 32 or 0.49
				bedtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(bed.Position) + Vector3.new(0, 5, 0)})
				bedtween:Play()
                bedtween.Completed:Wait()
                if BedTP.Enabled then
                    NebulawareStore.bedtable[bed] = NebulawareStore.bedtable[bed] or "Unknown"
                    task.spawn(InfoNotification, "BedTP", "Teleported to "..NebulawareStore.bedtable[bed].." Team's Bed.")
                    BedTP.ToggleButton(false)
                end
				return true
				end,
                telepearl = function(item, bed)
                    if not isAlive() then return nil end
                    if not getItem("telepearl") then return nil end
                    item = getItem(item).tool
					if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then task.wait(0.3) end
                    switchItem(item)
                    local projectileexploit = false
                    if GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) projectileexploit = true end
                    bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta.telepearl, "telepearl", "telepearl", bed.Position + Vector3.new(0, 3, 0), "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
                    local fired = bedwars.ClientHandler:Get(bedwars.ProjectileRemote):CallServerAsync(item, "telepearl", "telepearl", bed.Position + Vector3.new(0, 3, 0), bed.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), httpService:GenerateGUID(), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
                   if projectileexploit and not GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.Enabled then GuiLibrary.ObjectsThatCanBeSaved.ProjectileExploitOptionsButton.Api.ToggleButton(false) end
                    if not fired then return nil end
                    if BedTP.Enabled then
						NebulawareStore.bedtable[bed] = NebulawareStore.bedtable[bed] or "Unknown"
						task.spawn(InfoNotification, "BedTP", "Telepearled to "..NebulawareStore.bedtable[bed].." Team's Bed.")
						BedTP.ToggleButton(false)
					end
                    return true
            end,
            jade_hammer = function(item, bed)
                if not isAlive() then return nil end
                if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, bed) > 780 then return nil end
                if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then
					repeat task.wait() until bedwars.AbilityController:canUseAbility("jade_hammer_jump") or not BedTP.Enabled
					task.wait(0.1)
				end
                if not BedTP.Enabled then return end
                if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then return nil end
                item = getItem(item).tool
                switchItem(item)
                bedwars.AbilityController:useAbility("jade_hammer_jump")
                task.wait(0.1)
                bedtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(bed.Position) + Vector3.new(0, 5, 0)})
				bedtween:Play()
                bedtween.Completed:Wait()
                if BedTP.Enabled then
                    NebulawareStore.bedtable[bed] = NebulawareStore.bedtable[bed] or "Unknown"
                    task.spawn(InfoNotification, "BedTP", "Teleported to "..NebulawareStore.bedtable[bed].." Team's Bed.")
                    BedTP.ToggleButton(false)
                end
                return true
            end,
            void_axe = function(item, bed)
                if not isAlive() then return nil end
                if GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, bed) > 780 then return nil end
                if not bedwars.AbilityController:canUseAbility("void_axe_jump") then
					repeat task.wait() until bedwars.AbilityController:canUseAbility("void_axe_jump") or not BedTP.Enabled
					task.wait(0.1)
				end
                if not BedTP.Enabled then return end
                if not bedwars.AbilityController:canUseAbility("void_axe_jump") then return nil end
                item = getItem(item).tool
                switchItem(tool)
                bedwars.AbilityController:useAbility("void_axe_jump")
                task.wait(0.1)
                bedtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(bed.Position) + Vector3.new(0, 5, 0)})
				bedtween:Play()
                bedtween.Completed:Wait()
                if BedTP.Enabled then
                    NebulawareStore.bedtable[bed] = NebulawareStore.bedtable[bed] or "Unknown"
                    task.spawn(InfoNotification, "BedTP", "Teleported to "..NebulawareStore.bedtable[bed].." Team's Bed.")
                    BedTP.ToggleButton(false)
                end
                return true
            end
			}
			BedTP = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
				Name = "BedTP",
				HoverText = "Teleport to a nearby enemy bed.",
				Function = function(callback)
					if callback then
						task.spawn(function()
							  vapeAssert(not bedwarsStore.queueType:find("skywars"), "BedTP", "Can't run in skywars.", 7, true, true, "BedTP")
							  vapeAssert(bedwarsStore.queueType ~= "gun_game", "BedTP", "Can't run in gun game.", 7, true, true, "BedTP")
							  vapeAssert(FindEnemyBed(), "BedTP", "Enemy Beds Not Found.", 7, true, true, "BedTP")
							 if NebulawareFunctions:LoadTime() <= 0.1 or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled then
								BedTP.ToggleButton(false)
								return
							 end
							local currentmethod = nil
							for i,v in pairs(bedwarsStore.localInventory.inventory.items) do
								if bedtpextramethods[v.itemType] ~= nil then
									currentmethod = v.itemType
								end
							end
							if currentmethod == nil or (currentmethod ~= nil and bedtpextramethods[currentmethod](currentmethod, FindEnemyBed()) == nil) then
							vapeAssert(FindTeamBed(), "BedTP", "Team Bed Missing.", 7, true, true, "BedTP")
							pcall(function() lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
							lplr.Character.Humanoid.Health = 0
							table.insert(BedTP.Connections, lplr.CharacterAdded:Connect(function()
								if not isAlive() then repeat task.wait() until isAlive() end
								if not BedTP.Enabled then return end
								task.wait(0.2)
								if not FindEnemyBed() and BedTP.Enabled then BedTP.ToggleButton(false) return end
								local bed = FindEnemyBed()
								bedtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(GetMagnitudeOf2Objects(lplr.Character.HumanoidRootPart, bed) / 23.4 / 32, Enum.EasingStyle[BedTweenMethod.Value]), {CFrame = CFrame.new(bed.Position) + Vector3.new(0, BedTPVelo.Value, 0)})
								bedtween:Play()
								bedtween.Completed:Wait()
								if BedTP.Enabled then
								NebulawareStore.bedtable[bed] = NebulawareStore.bedtable[bed] or "Unknown"
								task.spawn(InfoNotification, "BedTP", "Teleported to "..NebulawareStore.bedtable[bed].." Team's Bed.")
								BedTP.ToggleButton(false)
								end
							end))
						end
						end)
					else
						pcall(function() bedtween:Cancel() end)
						pcall(function() lplr.Character.HumanoidRootPart.Anchored = false end)
					end
			    end
			})
			BedTweenMethod = BedTP.CreateDropdown({
				Name = "Easing Style",
				List = GetEnumItems("EasingStyle"),
				Function = function() end
			})
			BedTPVelo = BedTP.CreateSlider({
				Name = "Height",
				Min = 2,
				Max = 50,
				Default = 5,
				Function = function() end
			})
	end)


	  runFunction(function()
		local hannahRemote = bedwars.NetManaged.HannahPromptTrigger
		local HannahExploit = {Enabled = false}
		local ExecuteRangeCheck = {Enabled = false}
		local ExecuteRange = {Value = 60}
		local executiontick = tick()
		HannahExploit = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "HannahTPAura",
		HoverText = "yes",
		Function = function(callback)
			if callback then
				task.spawn(function()
					table.insert(HannahExploit.Connections, runService.Heartbeat:Connect(function()
					pcall(function()
						if GetCurrentProfile() == "Ghost" and executiontick > tick() then return end
						if not isAlive() or (tick() - NebulawareStore.AliveTick) < 2.5 then return end
						if bedwarsStore.equippedKit ~= "hannah" then return end
						if hannahRemote == nil then
							hannahRemote = bedwars.NetManaged.HannahPromptTrigger
							return
						end
						local players = GetAllTargetsNearPosition(GetCurrentProfile() ~= "Ghost" and ExecuteRangeCheck.Enabled and ExecuteRange.Value or GetCurrentProfile() == "Ghost" and 28 or math.huge)
						for i,v in pairs(players) do
							if GetCurrentProfile() == "Ghost" then task.wait(0.07) end
							if not isAlive() then continue end
							executiontick = tick() + 0.10
							hannahRemote:InvokeServer({
								user = lplr,
								victimEntity = v.Player.Character
							})
						end
					end)
					end))
				end)
			else
				executiontick = tick() - 0.1
			end
		end
	})
	ExecuteRangeCheck = HannahExploit.CreateToggle({
		Name = "Range Check",
		Function = function(callback) ExecuteRange.Object.Visible = callback end
	})
	ExecuteRange = HannahExploit.CreateSlider({
		Name = "Max Distance",
		Function = function() end,
		Min = 15,
		Max = 1000000000000
	})
end)

	    runFunction(function()
			local cameraunlock = {Enabled = false}
			local cameraunlockdistance = {Value = 14}
			local oldzoomdistance = 14
			cameraunlock = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
				Name = "InfiniteCamera",
				HoverText = "Unlock your camera's zoom distance.",
				Function = function(callback)
					if callback then
						task.spawn(function()
							local camera, attribute = pcall(function() return lplr.CameraMaxZoomDistance end)
							if not camera then repeat camera, attribute = pcall(function() return lplr.CameraMaxZoomDistance end) task.wait() until camera end
							oldzoomdistance = attribute
							lplr.CameraMaxZoomDistance = cameraunlockdistance.Value
						end)
					else
						pcall(function() lplr.CameraMaxZoomDistance = oldzoomdistance end)
					end
				end
			})
			oldzoomdistance = cameraunlock.CreateSlider({
				Name = "Zoom-Out Distance",
				Min = 14,
				Max = 10000,
				Function = function(callback) 
					if cameraunlock.Enabled then
					pcall(function() lplr.CameraMaxZoomDistance = callback end) 
					end
				end
			})
		end)

		runFunction(function()
			local Gravity = {Enabled = false}
			local GravitySlider = {Value = 192}
			local oldgravity = 192.2
			Gravity = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
				Name = "Gravity",
				HoverText = "Changes your workspace gravity",
				Function = function(callback)
					if callback then
						task.spawn(function()
						oldgravity = workspace.Gravity
						RunLoops:BindToHeartbeat("Gravity", function()
							pcall(function()
							if NebulawareStore.Tweening then
								workspace.Gravity = oldgravity
								return
							end
							if NebulawareStore.jumpTick > tick() then
								workspace.Gravity = oldgravity
								return
							end 
							if GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled then
								workspace.Gravity = oldgravity
								return
							end
							workspace.Gravity = GravitySlider.Value
						end)
						end)
					end)
				else
					pcall(function() RunLoops:UnbindFromHeartbeat("Gravity") end)
					workspace.Gravity = oldgravity
					end 
				end
			})
			GravitySlider = Gravity.CreateSlider({
				Name = "Gravity",
			    Min = 0,
				Max = 192,
				Default = 192,
				Function = function() end
			})
		end)
				runFunction(function()
					local SpawnParts = {}
					local SpawnPartColor
					local realspawnpart
					local SpawnESP = {Enabled = false}
					SpawnESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
						Name = "SpawnESP",
						Approved = true,
						Function = function(callback)
							if callback then 
								for i,v2 in pairs(workspace.MapCFrames:GetChildren()) do 
									if v2.Name:find("spawn") and v2.Name ~= "spawn" and v2.Name:find("respawn") == nil then
										realspawnpart = Instance.new("Part")
										realspawnpart.Size = Vector3.new(1, 1000, 1)
										realspawnpart.Position = v2.Value.p
										realspawnpart.Anchored = true
										realspawnpart.Parent = workspace
										realspawnpart.CanCollide = false
										realspawnpart.Transparency = 0.5
										realspawnpart.Material = Enum.Material.Neon
										realspawnpart.Color = Color3.fromHSV(SpawnPartColor.Hue, SpawnPartColor.Sat, SpawnPartColor.Value)
										bedwars.QueryUtil:setQueryIgnored(realspawnpart, true)
										table.insert(SpawnParts, realspawnpart)
									end
								end
							else
								for i,v in pairs(SpawnParts) do v:Destroy() end
								table.clear(SpawnParts)
							end
						end
					})
					SpawnPartColor = SpawnESP.CreateColorSlider({
						Name = "Color",
						Function = function(h, s, v) if SpawnESP.Enabled then for i,v in pairs(SpawnParts) do pcall(function() v.Color = Color3.fromHSV(SpawnPartColor.Hue, SpawnPartColor.Sat, SpawnPartColor.Value) end) end end end
					})
				end)

				--[[runFunction(function()
					pcall(GuiLibrary.RemoveObject, "WebhookUtilityOptionsButton")
					local WebhookUtility = {Enabled = false}
					local WebhookLoop = {Enabled = false}
					local WebhookEmbed = {Enabled = false}
					local webhooksent = false
					local WebhookLoopDelay = {Value = 1}
					local Webhook = {Value = ""}
					local WebhookContent = {Value = "This webhook has been sent using Nebukaware."}
					local webhookembedtitle = {Value = "Nebulaware "..NebulawareStore.VersionInfo.MainVersion.." Vape Config"}
					local webhookembedtext = {Value = "This webhook has been sent using the Nebulaware Vape Config."}
					local webhookcolor = {Value = "7269da"}
					WebhookUtility = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
						Name = "WebhookUtility",
						HoverText = "Send webhooks while gaming :omegalol: (discord)",
						Function = function(callback)
							if callback then
								task.spawn(function()
									local loopbroken = false
									local olddelay = WebhookLoopDelay.Value
									task.spawn(function() repeat if WebhookLoopDelay ~= olddelay then loopbroken = true end task.wait() until not WebhookUtility.Enabled end)
									repeat
									if not WebhookUtility.Enabled then return end
									if webhooksent and not WebhookLoop.Enabled then WebhookUtility.ToggleButton(false) return end
									if loopbroken and WebhookLoop.Enabled then WebhookUtility.ToggleButton(false) WebhookUtility.ToggleButton(false) return end
									NebulawareFunctions:FireWebhook({
										Url = Webhook.Value,
										content = WebhookContent.Value,
										embeds = WebhookEmbed.Enabled and {
											{
												title = webhookembedtitle.Value,
												description = webhookembedtext.Value,
												type = "rich",
												color = tonumber("0x"..webhookcolor.Value),
												image = {
													url = "http://www.roblox.com/Thumbs/Avatar.ashx?x=150&y=150&Format=Png&username=" ..
													 tostring(lplr.Name)
												}
											}
										} or {}
									})
									webhooksent = true
									if webhooksent and not WebhookLoop.Enabled then WebhookUtility.ToggleButton(false) return end
									task.wait(WebhookLoopDelay.Value)
									until not WebhookUtility.Enabled
								end)
							else
								webhooksent = false
							end
						end
					})
					WebhookLoop = WebhookUtility.CreateToggle({
						Name = "Repeat",
						HoverText = "If you wanna raid ig.",
						Function = function(callback) pcall(function() WebhookLoopDelay.Object.Visible = callback end) end
					})

					WebhookLoopDelay = WebhookUtility.CreateSlider({
						Name = "Repeat Delay",
						Min = 1,
						Max = 60,
						Function = function() end
					})
					Webhook = WebhookUtility.CreateTextBox({
						Name = "Webhook URL",
						TempText = "Url for the webhook",
						Function = function() end
					})
					WebhookContent = WebhookUtility.CreateTextBox({
						Name = "Content",
						TempText = "content",
						Function = function() end
					})
					WebhookEmbed = WebhookUtility.CreateToggle({
						Name = "Embeds",
						Function = function(callback) 
							pcall(function() webhookembedtitle.Object.Visible = callback end)
							pcall(function() webhookembedtext.Object.Visible = callback end)
							pcall(function() webhookcolor.Object.Visible = callback end)
						end
					})
					webhookembedtitle = WebhookUtility.CreateTextBox({
						Name = "Title",
						TempText = "Title of the embed.",
						Function = function() end
					})
					webhookembedtext = WebhookUtility.CreateTextBox({
						Name = "Description",
						TempText = "description of the webhook.",
						Function = function() end
					})
					webhookcolor = WebhookUtility.CreateTextBox({
						Name = "Color",
						TempText = "color for the webhook. (discord format)",
						Function = function() end
					})
					WebhookLoopDelay.Object.Visible = WebhookLoop.Enabled
					webhookembedtitle.Object.Visible = WebhookEmbed.Enabled
					webhookembedtext.Object.Visible = WebhookEmbed.Enabled
					webhookcolor.Object.Visible = WebhookEmbed.Enabled
				end)]]

				
		runFunction(function()
			pcall(GuiLibrary.RemoveObject, "HealthNotificationsOptionsButton")
			local HealthNotifications = {Enabled = false}
			local HealthSlider = {Value = 65}
			local HealthSound = {Enabled = false}
			local strikedhealth
			HealthNotifications = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
				Name = "HealthNotifications",
				HoverText = "Runs notifications whenever your health was under threshold.",
				ExtraText = function() return "Bedwars" end,
				Function = function(callback)
					if callback then
						task.spawn(function()
							table.insert(HealthNotifications.Connections, vapeEvents.EntityDamageEvent.Event:Connect(function(tab)
								if not isAlive() or tab.entityInstance ~= lplr.Character then return end
								local health = lplr.Character and (lplr.Character:GetAttribute("Health") or lplr.Character.Humanoid.Health)
								local maxhealth = lplr.Character and (lplr.Character:GetAttribute("MaxHealth") or lplr.Character.Humanoid.MaxHealth)
								if strikedhealth and health > strikedhealth then
									strikedhealth = nil
								end
								if health == maxhealth or strikedhealth and health <= strikedhealth and health < maxhealth then return end
								if health <= HealthSlider.Value then
									task.spawn(function()
										if not HealthSound.Enabled then return end
										local sound = Instance.new("Sound")
	                                    sound.PlayOnRemove = true
	                                    sound.SoundId = "rbxassetid://7396762708"
	                                    sound.Parent = workspace
	                                    sound:Destroy()
									end)
									strikedhealth = health + 35
									local healthcheck = health < HealthSlider.Value and "below" or "at"
									InfoNotification("HealthNotifications", "Your health is "..healthcheck.." "..HealthSlider.Value, 10)
							    end
							end))
						end)
					else
						strikedhealth = nil
					end
				end
			})
			HealthSlider = HealthNotifications.CreateSlider({
				Name = "Health",
				Min = 30,
				Max = 200,
				Default = 65,
				Function = function() end
			})
			HealthSound = HealthNotifications.CreateToggle({
				Name = "Sound",
				HoverText = "Plays a bed alarm sound on trigger.",
				Default = true,
				Function = function() end
			})
		end)

		runFunction(function()
			local FunnyExploit = {Enabled = false}
			FunnyExploit = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
				Name = "FunnyExploit",
				HoverText = "Spams the scythe dash (yes its itemless now plss stfu)",
				Function = function(callback)
					if callback then
						task.spawn(function()
							table.insert(FunnyExploit.Connections, runService.Heartbeat:Connect(function()
								local sword = getSword()
								if sword and sword.itemType:find("_scythe") and FindTarget(350, nil, true).RootPart then return end
								bedwars.ClientHandler:Get("SwordSwingMiss"):SendToServer({
									weapon = replicatedStorageService.Items.wood_scythe,
									chargeRatio = 0
								})
							end))
						end)
					end
				end
			})
		end)

		runFunction(function()
			local ProjectileAura = {Enabled = false}
			local ProjectileAuraSkywars = {Enabled = false}
			local ProjectileAuraMobs = {Enabled = false}
			local ProjectileAuraNovel = {Enabled = false}
			local ProjectileTargetMethod = {Value = "Distance"}
			local mobprotectedprojectiles = {"spear", "sticky_firework"}
			local lastswitch = tick()
			ProjectileAura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
				Name = "ProjectileAura",
				ExtraText = function() return "Switch" end,
				Function = function(callback)
					if callback then
						task.spawn(function()
							table.insert(ProjectileAura.Connections, runService.Heartbeat:Connect(function()
								local didshoot = false
								if not bedwarsStore.queueType:find("skywars") and ProjectileAuraSkywars.Enabled then
									return
								end
								if bedwarsStore.matchState == 0 then return end
								local projectiles, ent = GetAllLocalProjectiles(ProjectileAuraNovel.Enabled), FindTarget(nil, true, ProjectileAuraMobs.Enabled, ProjectileTargetMethod.Value == "Health")
								if not ent.RootPart or lastswitch > tick() then return end
								if FindTarget(28, nil, true).RootPart and getSword() then
									if lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= getSword().itemType then
									switchItem(getSword().tool)
									end
								end
								if FindTarget(28, nil, true).RootPart or killauraNearPlayer then return end
								for i,v in pairs(projectiles) do
									local cooldown = NebulawareStore.FrameRate > 35 and NebulawareStore.FrameRate < 80 and NebulawareStore.FrameRate / 45 or NebulawareStore.FrameRate > 80 and 0.30 or 2
									lastswitch = tick() + cooldown
									if not getItem(v.ammo) or NebulawareStore.Tweening then continue end
									if not ent.Human and table.find(mobprotectedprojectiles, i) then continue end
									task.wait(0.10)
									if GetHandItem() and GetHandItem() ~= i and not FindTarget(28, nil, true).RootPart then
										switchItem(getItem(i).tool)
									end
									bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta[i], v.ammo, v.ammo, ent.RootPart.Position + Vector3.new(0, 3, 0), "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
									bedwars.ClientHandler:Get(bedwars.ProjectileRemote):CallServerAsync(getItem(i).tool, v.ammo, v.ammo, ent.RootPart.Position + Vector3.new(0, 3, 0), ent.RootPart.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), httpService:GenerateGUID(), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
									didshoot = true
								end
								if didshoot then
									NebulawareStore.projectileAuraTick = tick() + 0.5
								end
							end))
						end)
					else
						lastswitch = tick() - 0.1
					end
				end
			})
			ProjectileAuraSkywars = ProjectileAura.CreateToggle({
				Name = "Skywars Only",
				Function = function() end,
				Default = true
			})
			ProjectileAuraNovel = ProjectileAura.CreateToggle({
				Name = "Other Projectiles",
				HoverText = "Also uses other projectiles. (fireball, gloop etc.)",
				Function = function() end
			})
			ProjectileAuraMobs = ProjectileAura.CreateToggle({
				Name = "Bosses",
				HoverText = "Targets npcs.",
				Function = function() end
			})
			ProjectileTargetMethod = ProjectileAura.CreateDropdown({
				Name = "Method",
				List = {"Distance", "Health"},
				Function = function() end
			})
		end)

		runFunction(function()
			local ArmorColoring = {Enabled = false}
			local armorcolorboots = {Enabled = false}
			local armorcolorchestplate = {Enabled = false}
			local armorcolorhelmet = {Enabled = false}
			local armorcolorneon = {Enabled = false}
			local armorcolor = {Hue = 0, Sat = 0, Value = 0}
			local oldarmortextures = {}
			local transformedobjects = {}
			local function isArmor(tool) return armorcolorhelmet.Enabled and tool.Name:find("_helmet") or armorcolorchestplate.Enabled and tool.Name:find("_chestplate") or armorcolorboots.Enabled and tool.Name:find("_boots") or nil end
			local function refresharmor()
				local suc = pcall(function()
					for i,v in pairs(lplr.Character:GetChildren()) do
						if v:IsA("Accessory") and v:GetAttribute("ArmorSlot") and isArmor(v) then
							local handle = v:FindFirstChild("Handle")
							if not handle then continue end
							if oldarmortextures[v] == nil then oldarmortextures[v] = handle.TextureID end
							handle.TextureID = ""
							handle.Color = Color3.fromHSV(armorcolor.Hue, armorcolor.Sat, armorcolor.Value)
							handle.Material = armorcolorneon.Enabled and Enum.Material.Neon or Enum.Material.SmoothPlastic
							table.insert(transformedobjects, handle)
						end 
					end
				end)
				return suc
			end
			ArmorColoring = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
				Name = "ArmorColoring",
				HoverText = "Add some glow up to your armor.",
				Function = function(callback)
					if callback then
						task.spawn(function()
							if not isAlive() then repeat task.wait() until isAlive() end
							task.spawn(refresharmor)
							table.insert(ArmorColoring.Connections, lplr.CharacterAdded:Connect(function()
								if not isAlive() then repeat task.wait() until isAlive() end
								ArmorColoring.ToggleButton(false)
								ArmorColoring.ToggleButton(false)
							end))
							table.insert(ArmorColoring.Connections, lplr.Character.ChildAdded:Connect(function(v)
								if v:IsA("Accessory") and v:GetAttribute("ArmorSlot") and isArmor(v) then
									refresharmor()
								end
							end))
						end)
					else
						for i,v in pairs(transformedobjects) do
							if v.Parent and oldarmortextures[v.Parent] then
								pcall(function() v.TextureID = oldarmortextures[v.Parent] end)
								v = nil
							end
						end
					end
				end
			})
			armorcolor = ArmorColoring.CreateColorSlider({
				Name = "Color",
				Function = function()
					if ArmorColoring.Enabled then
						refresharmor()
					end
				end
			})
			armorcolorneon = ArmorColoring.CreateToggle({
				Name = "Neon",
				Function = function()
				if ArmorColoring.Enabled then
					ArmorColoring.ToggleButton(false)
					ArmorColoring.ToggleButton(false)
				end
			    end
			})
			armorcolorhelmet = ArmorColoring.CreateToggle({
				Name = "Helmet",
				Function = function()
				if ArmorColoring.Enabled then
					ArmorColoring.ToggleButton(false)
					ArmorColoring.ToggleButton(false)
				end
			    end
			})
			armorcolorchestplate = ArmorColoring.CreateToggle({
				Name = "Chestplate",
				Function = function()
				if ArmorColoring.Enabled then
					ArmorColoring.ToggleButton(false)
					ArmorColoring.ToggleButton(false)
				end
			    end
			})
			armorcolorboots = ArmorColoring.CreateToggle({
				Name = "Boots",
				Default = true,
				Function = function()
				if ArmorColoring.Enabled then
					ArmorColoring.ToggleButton(false)
					ArmorColoring.ToggleButton(false)
				end
			    end
			})
		end)

		runFunction(function()
			local Disabler = {Enabled = false}
			Disabler = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
				Name = "FirewallBypass",
				Function = function(callback)
					if callback then 
						task.spawn(function()
							repeat task.wait()
								local item = getItemNear("scythe")
								if item and bedwars.CombatController and isAlive() then
									if GetHandItem() and GetHandItem() ~= item.tool and not killauraNearPlayer and NebulawareStore.projectileAuraTick <= tick() then
										switchItem(item.tool)
									end
									bedwars.ClientHandler:Get("ScytheDash"):SendToServer({direction = lplr.Character.Humanoid.MoveDirection + lplr.Character.HumanoidRootPart.CFrame.lookVector})
									if lplr.Character.Head.Transparency ~= 0 then
										bedwarsStore.scythe = tick() + 1
									end 
								end
							until (not Disabler.Enabled)
						end)
					end
				end,
				HoverText = "Float disabler (and some speed check) with scythe"
			})
		end)


local jumpfly = {Enabled = false}

jumpfly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "FunnyFly",
	["Function"] = function(callback)
		if callback then 
			task.spawn(function()
				game.Workspace.Gravity = 24.025
				repeat
					game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 5, 0)
					task.wait(0.4)
				until (not jumpfly.Enabled)
				game.Workspace.Gravity = 196.2
				task.wait(0.2)
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0.00001
			end)
		end
	end,
})


local Messages = {"nebulaware on top", "immortalware? wtf is that config", "acronisware? wtf is that", "inf", "too easy", "nebulaware", "easy wins", "100", "69420", "nebulaware best config", "500", "999",  "1000"}
local old
local FunnyIndicator = {Enabled = false}
FunnyIndicator = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
Name = "NebulawareDamageIndicators",
Function = function(Callback)
	FunnyIndicator.Enabled = Callback
	if FunnyIndicator.Enabled then
		old = debug.getupvalue(bedwars.DamageIndicator, 10)["Create"]
		debug.setupvalue(bedwars.DamageIndicator, 10, {
			Create = function(self, obj, ...)
				spawn(function()
					pcall(function()
						obj.Parent.Text = Messages[math.random(1, #Messages)]
						obj.Parent.TextColor3 = Color3.fromHSV(tick() % 10 / 10, 2, 2)
					end)
				end)
				return game:GetService("TweenService"):Create(obj, ...)
			end
		})
	else
		debug.setupvalue(bedwars.DamageIndicator, 10, {
			Create = old
		})
		old = nil
	end
end
})

local Host = {["Enabled"] = false}
Host = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
    ["Name"] = "Cohost",
    ["HoverText"] = "real 2023 best bedwars script no client sided!1",
    ["Function"] = function(callback)
        if callback then
            local v2 = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out)
            local OfflinePlayerUtil = v2.OfflinePlayerUtil
            local v6 = OfflinePlayerUtil.getPlayer(game.Players.LocalPlayer)
            v6:SetAttribute("Cohost", true)
        else
            local v2 = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out)
            local OfflinePlayerUtil = v2.OfflinePlayerUtil
            local v6 = OfflinePlayerUtil.getPlayer(game.Players.LocalPlayer)
            v6:SetAttribute("Cohost", false)
        end
    end
})

runFunction(function()
    local RGBSwordOutline
    RGBSwordOutline = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
        Name = "SwordOutline",
        Function = function(callback)
            if callback then 
                spawn(function()
                    local cam = game.Workspace.CurrentCamera
                    Connection = cam.Viewmodel.ChildAdded:Connect(function(v)
                        highlight2 = Instance.new('Highlight')
                        highlight2.Parent = v.Handle
                        if v:FindFirstChild("Handle") then
                            pcall(function()
                                highlight2.FillTransparency = 1
                                while wait() do
                                    highlight2.OutlineColor = Color3.fromHSV(tick()%5/5,1,1)
                                end
                            end)
                        end
                    end)
                    spawn(function()
                        repeat task.wait() until unejected == true 
                        EnabledOutlines = false
                        if Connection ~= nil then
                            if type(Connection) == "userdata" then
                                Connection:Disconnect()
                                Connection = nil
                            end
                        end
                    end)
                end)
            else
                EnabledOutlines = false
                if Connection ~= nil then
                    if type(Connection) == "userdata" then
                        Connection:Disconnect()
                        Connection = nil
                    end
                end
            end
        end
    })
end)

runFunction(function()
	fartlol = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ScytheTxtPack",
		HoverText = "yay",
		Function = function(callback)
			if callback then 
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14347599212")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_scythe",
						offset = CFrame.Angles(math.rad(0),math.rad(89),math.rad(-90)),
						model = import:WaitForChild("Wood_Scythe"),
					},
					{
						name = "stone_scythe",
						offset = CFrame.Angles(math.rad(0),math.rad(89),math.rad(-90)),
						model = import:WaitForChild("Stone_Scythe"),
					},
					{
						name = "iron_scythe",
						offset = CFrame.Angles(math.rad(0),math.rad(89),math.rad(-90)),
						model = import:WaitForChild("Iron_Scythe"),
					},
					{
						name = "diamond_scythe",
						offset = CFrame.Angles(math.rad(0),math.rad(89),math.rad(-90)),
						model = import:WaitForChild("Diamond_Scythe"),
					},
				}
				local func = Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end            
							end            
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(-.7,0,-1)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end)
			end
		end
	})
end)

runFunction(function()
    local Dupe = {Enabled = false}
	Dupe = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Godmode",
		Function = function(callback) 
			if callback then
	game:GetService("Workspace")[game:GetService("Players").LocalPlayer.Name]:SetAttribute("MaxHealth", 465465465)
game:GetService("Workspace")[game:GetService("Players").LocalPlayer.Name]:SetAttribute("Health", 465465465)
			end
		end,
		HoverText = "real"
	})
end)


runFunction(function()
    local AntiDeath = {Enabled = false}
    local AntiDeathLow = {Value = 50}
    local AntiDeathHigh = {Value = 35}
    local enabledAlready = false
    AntiDeath = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        Name = "AntiDeath",
        HoverText = "Automatically prevents you from dying (inf fly up)",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    repeat task.wait()
                        if game:GetService("Players").LocalPlayer.Character.Humanoid.Health < AntiDeathLow.Value then
                            game:GetService("Players").LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(0,AntiDeathHigh.Value,0)
                        end
                    until not AntiDeath.Enabled
                end)
            end
        end
    })
    AntiDeathLow = AntiDeath.CreateSlider({
        Name = "Health Trigger",
        Min = 10,
        Max = 100,
        Function = function() end,
        Default = 50
    })
    AntiDeathHigh = AntiDeath.CreateSlider({
        Name = "Boost",
        Min = 1,
        Max = 50,
        Function = function() end,
        Default = 35
    })
end)
-- CREDITS TO MY FRIEND NATHAN
function aura(x)
    local plr = game.Players.LocalPlayer
    local closest_player
    for i, v in pairs(game.Players:GetPlayers()) do
            if v.Character:FindFirstChild("Humanoid") and v ~= plr and v.Team ~= plr.Team then
                local distance = (plr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if distance < x then
                    closest_player = v
            end
        end
    end
    return closest_player
end
--

-- CREDITS TO MY FRIEND NATHAN
function aura2(c)
    local plr = game.Players.LocalPlayer
    local closest_player2
    for i, v in pairs(game.Players:GetPlayers()) do
            if v.Character:FindFirstChild("Humanoid") and v ~= plr and v.Team ~= plr.Team then
                local distance = (plr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if distance < c then
                    closest_player2 = v
            end
        end
    end
    return closest_player2
end
--

game:GetService("RunService").Heartbeat:Connect(function(c)
if getgenv().test2 then
local z = aura2(15)
wait() 
if z ~= nil and z.Character.Humanoid.Health > 0 then
look = z.Character.HumanoidRootPart.CFrame.LookVector * -4
person = z.Character.HumanoidRootPart.CFrame + look
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
wait()
hrp.CFrame = z.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,4)
wait(0.3)
hrp.CFrame = z.Character.HumanoidRootPart.CFrame + Vector3.new(4,0,0)
wait(0.3)
hrp.CFrame = person
wait(0.3)
end
wait(.5)
end
end)


game:GetService("RunService").Heartbeat:Connect(function(x)
if getgenv().test then
local z = aura(15)
wait() 
if z ~= nil and z.Character.Humanoid.Health > 0 then
look = z.Character.HumanoidRootPart.CFrame.LookVector * -3
person = z.Character.HumanoidRootPart.CFrame + look
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
wait()
hrp.CFrame = person
end
wait(.5)
end
end)


runFunction(function()
local tpaura = {Enabled = false}
tpaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
["HoverText"] = "Enable with scythe and firewallbypass",
Name = "ScytheTPAura",
Function = function(callback)
if callback then
getgenv().test = true
else
getgenv().test = false
end
end
})
end)


local anticheat = {["Enabled"] = false}
    anticheat = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "FloatDisabler",
        ["HoverText"] = "Credits to complex",
        ["Function"] = function(callback)
            if callback then
                            print("Still working on this do not expect it to work.")
                            local players = game:GetService("Players")
                local player = players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")

                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                 track:Stop()
                            end
            else
                print("Disabled!")
            end
        end 
    })



local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local function PlayEmote(name: string, id: IntValue)
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local Description = Humanoid and Humanoid:FindFirstChildOfClass("HumanoidDescription")
    if not Description then
        return
    end
    if LocalPlayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        local succ, err = pcall(function()
            Humanoid:PlayEmoteAndGetAnimTrackById(id)
        end)
        if not succ then
            Description:AddEmote(name, id)
            Humanoid:PlayEmoteAndGetAnimTrackById(id)
        end
    else
    print("dummy")
    end
end


function aura3(w)
    local plr = game.Players.LocalPlayer
    local closest_player
    for i, v in pairs(game.Players:GetPlayers()) do
            if v.Character:FindFirstChild("Humanoid") and v ~= plr and v.Team ~= plr.Team then
                local distance = (plr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if distance < w then
                    closest_player = v
            end
        end
    end
    return closest_player
end


game:GetService("RunService").Heartbeat:Connect(function(x)
if getgenv().sex then
local z = aura3(15)
wait() 
if z ~= nil and z.Character.Humanoid.Health > 0 then
PlayEmote(Sleep, 4689362868)
look = z.Character.HumanoidRootPart.CFrame.LookVector * .9
person = z.Character.HumanoidRootPart.CFrame + look
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
wait()
hrp.CFrame = person
end
wait(.5)
end
end)

runFunction(function()
local sexaura = {Enabled = false}
sexaura = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
["HoverText"] = "💀",
Name = "SexAura",
Function = function(callback)
if callback then
getgenv().sex = true
else
getgenv().sex = false
end
end
})
end)

function autowin()
task.spawn(function()
while getgenv().win == true do
wait(0.1)
game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
wait(0.3) 
tweenToNearestBed()
end)
hasTeleported = false
wait(11)
game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
wait(0.3)
tweenToNearestPlayer()
end)
end
hasTeleported = false
end)
end

runFunction(function()
local autowin = {Enabled = false}
autowin = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
["HoverText"] = "cool",
Name = "DuelsAutoWin",
Function = function(callback)
if callback then
getgenv().win = true
autowin()
else
getgenv().win = false
end
end
})
end)


InvisExploit = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
    Name = "Invisibility",
    Function = function(callback)
        if callback then
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local mouse = LocalPlayer:GetMouse()
            local runservice = game:GetService("RunService")
            local noclip = false

            function IsAlive(Player)
                Player = Player or LocalPlayer
                if not Player.Character then return false end
                if not Player.Character:FindFirstChild("Head") then return false end
                if not Player.Character:FindFirstChild("Humanoid") then return false end
                if Player.Character:FindFirstChild("Humanoid").Health < 0.11 then return false end
                return true
            end

            local function SetCollisions(Value)
                for i, v in pairs(LocalPlayer:GetDescendants()) do
                    if v:IsA("BasePart") and v ~= LocalPlayer.Character.PrimaryPart and v.CanCollide then
                        if Value == true then
                            v.CanCollide = false
                        end

                        if Value == false then
                            v.CanCollide = true
                        end
                    end
                end
            end

            task.spawn(function()
                if IsAlive(LocalPlayer) then 
                    local Animation = Instance.new("Animation")
                    local Id = 11335949902
                    Animation.AnimationId = "rbxassetid://".. Id

                    local PlayerAnimation = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(Animation)
                    if PlayerAnimation then
                        LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 3 / -2, 0)
                        LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 3, 1.1)

                        PlayerAnimation.Priority = Enum.AnimationPriority.Action4
                        PlayerAnimation.Looped = true
                        PlayerAnimation:Play()
                        PlayerAnimation:AdjustSpeed(0 / 10)
                        SetCollisions(true)
                    end
                end
            end)

            local character = LocalPlayer.Character

            if character then
                local humanoid = character:WaitForChild("Humanoid")
                local rootPart = character:WaitForChild("HumanoidRootPart")

                local noclipEnabled = false

                local function toggleNoclip()
                    noclipEnabled = not noclipEnabled
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                end

                game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
                    if not gameProcessedEvent then
                        if input.KeyCode == Enum.KeyCode.N then
                            toggleNoclip()
                        end
                    end
                end)

                game:GetService("RunService").Stepped:Connect(function()
                    if noclipEnabled then
                        rootPart.CanCollide = false
                        rootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    end
})

local LogoV2 = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	Name = "Watermark",
	Function = function(callback)
		if callback then 
			

local Converted = {
	["_ScreenGui"] = Instance.new("ScreenGui");
	["_Frame"] = Instance.new("Frame");
	["_UIStroke"] = Instance.new("UIStroke");
	["_UIGradient"] = Instance.new("UIGradient");
	["_LocalScript"] = Instance.new("LocalScript");
	["_TextLabel"] = Instance.new("TextLabel");
	["_TextLabel1"] = Instance.new("TextLabel");
	["_TextLabel2"] = Instance.new("TextLabel");
	["_TextLabel3"] = Instance.new("TextLabel");
}

-- Properties:

Converted["_ScreenGui"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_ScreenGui"].Parent = game:GetService("CoreGui")

Converted["_Frame"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame"].BorderSizePixel = 0
Converted["_Frame"].Position = UDim2.new(0.0122866891, 0, 0.0461165048, 0)
Converted["_Frame"].Size = UDim2.new(0, 304, 0, 27)
Converted["_Frame"].Parent = Converted["_ScreenGui"]
Converted["_Frame"].Active = true
Converted["_Frame"].Selectable = true
Converted["_Frame"].Draggable = true

Converted["_UIStroke"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke"].Parent = Converted["_Frame"]

Converted["_UIGradient"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(21.000000648200512, 0, 255)),
	ColorSequenceKeypoint.new(0.4427609443664551, Color3.fromRGB(96.00000187754631, 1.0000000591389835, 137.00000703334808)),
	ColorSequenceKeypoint.new(0.6952861547470093, Color3.fromRGB(1.0000000591389835, 166.00000530481339, 175.00000476837158)),
	ColorSequenceKeypoint.new(0.9528619050979614, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(5.000000176951289, 230.00000149011612, 255))
}
Converted["_UIGradient"].Parent = Converted["_UIStroke"]

Converted["_TextLabel"].Font = Enum.Font.SourceSans
Converted["_TextLabel"].Text = "NW 4.0"
Converted["_TextLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].TextScaled = true
Converted["_TextLabel"].TextSize = 14
Converted["_TextLabel"].TextWrapped = true
Converted["_TextLabel"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].BackgroundTransparency = 1
Converted["_TextLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel"].BorderSizePixel = 0
Converted["_TextLabel"].Position = UDim2.new(0.0230263155, 0, 0, 0)
Converted["_TextLabel"].Size = UDim2.new(0, 137, 0, 27)
Converted["_TextLabel"].Parent = Converted["_Frame"]

Converted["_TextLabel1"].Font = Enum.Font.SourceSans
Converted["_TextLabel1"].Text = "Nebulaware Private"
Converted["_TextLabel1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].TextScaled = true
Converted["_TextLabel1"].TextSize = 14
Converted["_TextLabel1"].TextWrapped = true
Converted["_TextLabel1"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].BackgroundTransparency = 1
Converted["_TextLabel1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel1"].BorderSizePixel = 0
Converted["_TextLabel1"].Position = UDim2.new(0.233082727, 0, 0, 0)
Converted["_TextLabel1"].Size = UDim2.new(0, 127, 0, 27)
Converted["_TextLabel1"].Parent = Converted["_Frame"]

Converted["_TextLabel2"].Font = Enum.Font.SourceSans
Converted["_TextLabel2"].Text = ""
Converted["_TextLabel2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].TextScaled = true
Converted["_TextLabel2"].TextSize = 14
Converted["_TextLabel2"].TextWrapped = true
Converted["_TextLabel2"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].BackgroundTransparency = 1
Converted["_TextLabel2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel2"].BorderSizePixel = 0
Converted["_TextLabel2"].Position = UDim2.new(0.736842096, 0, 0, 0)
Converted["_TextLabel2"].Size = UDim2.new(0, 70, 0, 27)
Converted["_TextLabel2"].Parent = Converted["_Frame"]

Converted["_TextLabel3"].Font = Enum.Font.SourceSans
Converted["_TextLabel3"].Text = ".gg/nzWbVXa6df"
Converted["_TextLabel3"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel3"].TextSize = 20
Converted["_TextLabel3"].TextWrapped = true
Converted["_TextLabel3"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel3"].BackgroundTransparency = 1
Converted["_TextLabel3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel3"].BorderSizePixel = 0
Converted["_TextLabel3"].Position = UDim2.new(0.654135287, 0, 0, 0)
Converted["_TextLabel3"].Size = UDim2.new(0, 104, 0, 27)
Converted["_TextLabel3"].Parent = Converted["_Frame"]

-- Fake Module Scripts:

local fake_module_scripts = {}


-- Fake Local Scripts:

local function EVCDTZ_fake_script() -- Fake Script: StarterGui.ScreenGui.Frame.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_Frame"]
    local req = require
    local require = function(obj)
        local fake = fake_module_scripts[obj]
        if fake then
            return fake()
        end
        return req(obj)
    end

	local rs = game:GetService("RunService")
	local gr = script.Parent.UIStroke.UIGradient
	
	rs.RenderStepped:Connect(function()
		gr.Rotation += 1
	end)
end

coroutine.wrap(EVCDTZ_fake_script)()

-- Generated using RoadToGlory's Converter v1.1 (RoadToGlory#9879)

-- Instances:

local Converted = {
	["_FPS/PING/CMEM"] = Instance.new("ScreenGui");
	["_Frame"] = Instance.new("Frame");
	["_UIStroke"] = Instance.new("UIStroke");
	["_UIGradient"] = Instance.new("UIGradient");
	["_TextLabel"] = Instance.new("TextLabel");
	["_FPSScript"] = Instance.new("LocalScript");
	["_Frame1"] = Instance.new("Frame");
	["_UIStroke1"] = Instance.new("UIStroke");
	["_UIGradient1"] = Instance.new("UIGradient");
	["_TextLabel1"] = Instance.new("TextLabel");
	["_CMEMScript"] = Instance.new("LocalScript");
	["_Frame2"] = Instance.new("Frame");
	["_UIStroke2"] = Instance.new("UIStroke");
	["_UIGradient2"] = Instance.new("UIGradient");
	["_TextLabel2"] = Instance.new("TextLabel");
	["_PingScript"] = Instance.new("LocalScript");
}

-- Properties:

Converted["_FPS/PING/CMEM"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_FPS/PING/CMEM"].Name = "FPS/PING/CMEM"
Converted["_FPS/PING/CMEM"].Parent = game:GetService("CoreGui")

Converted["_Frame"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame"].BorderSizePixel = 0
Converted["_Frame"].Position = UDim2.new(0.0122866891, 0, 0.0873786435, 0)
Converted["_Frame"].Size = UDim2.new(0, 64, 0, 16)
Converted["_Frame"].Parent = Converted["_FPS/PING/CMEM"]

Converted["_UIStroke"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke"].Parent = Converted["_Frame"]

Converted["_UIGradient"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(43.00000123679638, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 217.0000022649765))
}
Converted["_UIGradient"].Parent = Converted["_UIStroke"]

Converted["_TextLabel"].Font = Enum.Font.SourceSans
Converted["_TextLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].TextScaled = true
Converted["_TextLabel"].TextSize = 14
Converted["_TextLabel"].TextWrapped = true
Converted["_TextLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].BackgroundTransparency = 1
Converted["_TextLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel"].BorderSizePixel = 0
Converted["_TextLabel"].Position = UDim2.new(-0.0135775805, 0, 0, 0)
Converted["_TextLabel"].Size = UDim2.new(0, 64, 0, 16)
Converted["_TextLabel"].Parent = Converted["_Frame"]

Converted["_Frame1"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame1"].BorderSizePixel = 0
Converted["_Frame1"].Position = UDim2.new(0.055290103, 0, 0.0873786435, 0)
Converted["_Frame1"].Size = UDim2.new(0, 145, 0, 16)
Converted["_Frame1"].Parent = Converted["_FPS/PING/CMEM"]

Converted["_UIStroke1"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke1"].Parent = Converted["_Frame1"]

Converted["_UIGradient1"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(43.00000123679638, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 217.0000022649765))
}
Converted["_UIGradient1"].Parent = Converted["_UIStroke1"]

Converted["_TextLabel1"].Font = Enum.Font.SourceSans
Converted["_TextLabel1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].TextScaled = true
Converted["_TextLabel1"].TextSize = 14
Converted["_TextLabel1"].TextWrapped = true
Converted["_TextLabel1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].BackgroundTransparency = 1
Converted["_TextLabel1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel1"].BorderSizePixel = 0
Converted["_TextLabel1"].Position = UDim2.new(-0.068965517, 0, 0, 0)
Converted["_TextLabel1"].Size = UDim2.new(0, 144, 0, 16)
Converted["_TextLabel1"].Parent = Converted["_Frame1"]

Converted["_Frame2"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame2"].BorderSizePixel = 0
Converted["_Frame2"].Position = UDim2.new(0.136518776, 0, 0.0873786435, 0)
Converted["_Frame2"].Size = UDim2.new(0, 64, 0, 16)
Converted["_Frame2"].Parent = Converted["_FPS/PING/CMEM"]

Converted["_UIStroke2"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke2"].Parent = Converted["_Frame2"]

Converted["_UIGradient2"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(43.00000123679638, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 217.0000022649765))
}
Converted["_UIGradient2"].Parent = Converted["_UIStroke2"]

Converted["_TextLabel2"].Font = Enum.Font.SourceSans
Converted["_TextLabel2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].TextScaled = true
Converted["_TextLabel2"].TextSize = 14
Converted["_TextLabel2"].TextWrapped = true
Converted["_TextLabel2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].BackgroundTransparency = 1
Converted["_TextLabel2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel2"].BorderSizePixel = 0
Converted["_TextLabel2"].Position = UDim2.new(-0.0135774612, 0, 0, 0)
Converted["_TextLabel2"].Size = UDim2.new(0, 64, 0, 16)
Converted["_TextLabel2"].Parent = Converted["_Frame2"]

-- Fake Module Scripts:

local fake_module_scripts = {}


-- Fake Local Scripts:

local function NLUGHO_fake_script() -- Fake Script: StarterGui.FPS/PING/CMEM.Frame.TextLabel.FPSScript
    local script = Instance.new("LocalScript")
    script.Name = "FPSScript"
    script.Parent = Converted["_TextLabel"]
    local req = require
    local require = function(obj)
        local fake = fake_module_scripts[obj]
        if fake then
            return fake()
        end
        return req(obj)
    end

	local FPSLabel = script.Parent
	while wait(1) do
		local FPS = game:GetService("Workspace"):GetRealPhysicsFPS()
		FPSLabel.Text = 'FPS: '..math.floor(FPS)
	end
end
local function AOKAMS_fake_script() -- Fake Script: StarterGui.FPS/PING/CMEM.Frame.TextLabel.CMEMScript
    local script = Instance.new("LocalScript")
    script.Name = "CMEMScript"
    script.Parent = Converted["_TextLabel1"]
    local req = require
    local require = function(obj)
        local fake = fake_module_scripts[obj]
        if fake then
            return fake()
        end
        return req(obj)
    end

	local CMEMLabel = script.Parent
	while wait(1) do
		local CMEM = game:GetService("Stats"):GetTotalMemoryUsageMb()
		CMEMLabel.Text = 'Client Memory: '..math.floor(CMEM)
	end
end
local function JVQEAR_fake_script() -- Fake Script: StarterGui.FPS/PING/CMEM.Frame.TextLabel.PingScript
    local script = Instance.new("LocalScript")
    script.Name = "PingScript"
    script.Parent = Converted["_TextLabel2"]
    local req = require
    local require = function(obj)
        local fake = fake_module_scripts[obj]
        if fake then
            return fake()
        end
        return req(obj)
    end

	local PingLabel = script.Parent
	while wait(1) do
		local Ping = 300-((1/wait())*10)
		if Ping < 1 then
			Ping = 1
		end
		PingLabel.Text = 'Ping: '..math.floor(Ping)
	end
end

coroutine.wrap(NLUGHO_fake_script)()
coroutine.wrap(AOKAMS_fake_script)()
coroutine.wrap(JVQEAR_fake_script)()
			else
				local coreGui = game:GetService("CoreGui")
				local screenGuiLogoV2 = coreGui:FindFirstChild("ScreenGui") 
				local screenGuiFPS = coreGui:FindFirstChild("FPS/PING/CMEM") 
				if screenGuiLogoV2 then
					screenGuiLogoV2:Destroy()
				end
				if screenGuiFPS then
					screenGuiFPS:Destroy()
				end
			end
		end
	})

SessionInfo = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
	Name = "Session Info",
	HoverText = "Cool hud",
	Function = function(callback)
		if callback then
			local lplr = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local DropShadowHolder = Instance.new("Frame")
local DropShadow = Instance.new("ImageLabel")
local Frame_2 = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local Frame_3 = Instance.new("Frame")
local DropShadowHolder_2 = Instance.new("Frame")
local DropShadow_2 = Instance.new("ImageLabel")
local TextLabel = Instance.new("TextLabel")
local ImageLabel = Instance.new("ImageLabel")
local TextLabel_2 = Instance.new("TextLabel")
local TextLabel_3 = Instance.new("TextLabel")
local TextLabel_4 = Instance.new("TextLabel")
local TextLabel_5 = Instance.new("TextLabel")
local TextLabel_6 = Instance.new("TextLabel")
local TextLabel_7 = Instance.new("TextLabel")
local TextLabel_8 = Instance.new("TextLabel")
local TextLabel_9 = Instance.new("TextLabel")
local TextLabel_10 = Instance.new("TextLabel")
local TextLabel_11 = Instance.new("TextLabel")
local TextLabel_12 = Instance.new("TextLabel")
local FullscreenExit = Instance.new("ImageLabel")
local MainFrame = Frame
local Drag = Frame_2 
local PlayersNumb = TextLabel_10
local AlivePlrsNumb = TextLabel_11
local KillsNum = TextLabel_3
local DeathsNumb = TextLabel_8
local TimeNumb = TextLabel_9


--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.356
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.00887371972, 0, 0.489077657, 0)
Frame.Size = UDim2.new(0, 277, 0, 346)
Frame.Draggable = true
Frame.Selectable = true 
Frame.Active = true 

DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.Parent = Frame
DropShadowHolder.BackgroundTransparency = 1.000
DropShadowHolder.BorderSizePixel = 0
DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder.ZIndex = 0

DropShadow.Name = "DropShadow"
DropShadow.Parent = DropShadowHolder
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1.000
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 47, 1, 47)
DropShadow.ZIndex = 0
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.500
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0, 0, 0.00289017335, 0)
Frame_2.Size = UDim2.new(0, 277, 0, -4)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(93, 0, 112)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(106, 0, 255))}
UIGradient.Parent = Frame_2

Frame_3.Parent = Frame
Frame_3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame_3.BackgroundTransparency = 0.356
Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0, 0, 1.01734102, 0)
Frame_3.Size = UDim2.new(0, 277, 0, 46)

DropShadowHolder_2.Name = "DropShadowHolder"
DropShadowHolder_2.Parent = Frame_3
DropShadowHolder_2.BackgroundTransparency = 1.000
DropShadowHolder_2.BorderSizePixel = 0
DropShadowHolder_2.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder_2.ZIndex = 0

DropShadow_2.Name = "DropShadow"
DropShadow_2.Parent = DropShadowHolder_2
DropShadow_2.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow_2.BackgroundTransparency = 1.000
DropShadow_2.BorderSizePixel = 0
DropShadow_2.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow_2.Size = UDim2.new(1, 47, 1, 47)
DropShadow_2.ZIndex = 0
DropShadow_2.Image = "rbxassetid://6014261993"
DropShadow_2.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow_2.ImageTransparency = 0.500
DropShadow_2.ScaleType = Enum.ScaleType.Slice
DropShadow_2.SliceCenter = Rect.new(49, 49, 450, 450)

TextLabel.Parent = Frame_3
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.0216606501, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 216, 0, 46)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "NW 4.0"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

ImageLabel.Parent = Frame_3
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.801444054, 0, 0.0869565234, 0)
ImageLabel.Size = UDim2.new(0, 43, 0, 37)
ImageLabel.Image = "rbxassetid://2790547157"

TextLabel_2.Parent = Frame
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0, 0, 0.182080925, 0)
TextLabel_2.Size = UDim2.new(0, 277, 0, 50)
TextLabel_2.Font = Enum.Font.SourceSansBold
TextLabel_2.Text = "Kills:"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 40.000
TextLabel_2.TextWrapped = true
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_3.Parent = Frame
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.285198569, 0, 0.182080925, 0)
TextLabel_3.Size = UDim2.new(0, 198, 0, 50)
TextLabel_3.Font = Enum.Font.SourceSans
TextLabel_3.Text = "10"
TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.TextSize = 40.000
TextLabel_3.TextWrapped = true
TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_4.Parent = Frame
TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.BackgroundTransparency = 1.000
TextLabel_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_4.BorderSizePixel = 0
TextLabel_4.Position = UDim2.new(0, 0, 0.346820801, 0)
TextLabel_4.Size = UDim2.new(0, 277, 0, 50)
TextLabel_4.Font = Enum.Font.SourceSansBold
TextLabel_4.Text = "Deaths:"
TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.TextSize = 40.000
TextLabel_4.TextWrapped = true
TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_5.Parent = Frame
TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.BackgroundTransparency = 1.000
TextLabel_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_5.BorderSizePixel = 0
TextLabel_5.Position = UDim2.new(0, 0, 0.520231187, 0)
TextLabel_5.Size = UDim2.new(0, 277, 0, 50)
TextLabel_5.Font = Enum.Font.SourceSansBold
TextLabel_5.Text = "Time:"
TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.TextSize = 40.000
TextLabel_5.TextWrapped = true
TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_6.Parent = Frame
TextLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.BackgroundTransparency = 1.000
TextLabel_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_6.BorderSizePixel = 0
TextLabel_6.Position = UDim2.new(0, 0, 0.690751433, 0)
TextLabel_6.Size = UDim2.new(0, 277, 0, 50)
TextLabel_6.Font = Enum.Font.SourceSansBold
TextLabel_6.Text = "Players:"
TextLabel_6.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.TextSize = 40.000
TextLabel_6.TextWrapped = true
TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_7.Parent = Frame
TextLabel_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_7.BackgroundTransparency = 1.000
TextLabel_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_7.BorderSizePixel = 0
TextLabel_7.Position = UDim2.new(0, 0, 0.85549134, 0)
TextLabel_7.Size = UDim2.new(0, 277, 0, 50)
TextLabel_7.Font = Enum.Font.SourceSansBold
TextLabel_7.Text = "Alive plrs:"
TextLabel_7.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_7.TextSize = 40.000
TextLabel_7.TextWrapped = true
TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_8.Parent = Frame
TextLabel_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_8.BackgroundTransparency = 1.000
TextLabel_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_8.BorderSizePixel = 0
TextLabel_8.Position = UDim2.new(0.425992787, 0, 0.346820801, 0)
TextLabel_8.Size = UDim2.new(0, 198, 0, 50)
TextLabel_8.Font = Enum.Font.SourceSans
TextLabel_8.Text = "10"
TextLabel_8.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_8.TextSize = 40.000
TextLabel_8.TextWrapped = true
TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_9.Parent = Frame
TextLabel_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_9.BackgroundTransparency = 1.000
TextLabel_9.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_9.BorderSizePixel = 0
TextLabel_9.Position = UDim2.new(0.328519851, 0, 0.520231187, 0)
TextLabel_9.Size = UDim2.new(0, 198, 0, 50)
TextLabel_9.Font = Enum.Font.SourceSans
TextLabel_9.Text = "10"
TextLabel_9.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_9.TextSize = 40.000
TextLabel_9.TextWrapped = true
TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_10.Parent = Frame
TextLabel_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_10.BackgroundTransparency = 1.000
TextLabel_10.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_10.BorderSizePixel = 0
TextLabel_10.Position = UDim2.new(0.454873651, 0, 0.690751433, 0)
TextLabel_10.Size = UDim2.new(0, 198, 0, 50)
TextLabel_10.Font = Enum.Font.SourceSans
TextLabel_10.Text = "10"
TextLabel_10.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_10.TextSize = 40.000
TextLabel_10.TextWrapped = true
TextLabel_10.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_11.Parent = Frame
TextLabel_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_11.BackgroundTransparency = 1.000
TextLabel_11.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_11.BorderSizePixel = 0
TextLabel_11.Position = UDim2.new(0.548736453, 0, 0.85549134, 0)
TextLabel_11.Size = UDim2.new(0, 198, 0, 50)
TextLabel_11.Font = Enum.Font.SourceSans
TextLabel_11.Text = "10"
TextLabel_11.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_11.TextSize = 40.000
TextLabel_11.TextWrapped = true
TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_12.Parent = Frame
TextLabel_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_12.BackgroundTransparency = 1.000
TextLabel_12.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_12.BorderSizePixel = 0
TextLabel_12.Position = UDim2.new(0, 0, 0.00289017335, 0)
TextLabel_12.Size = UDim2.new(0, 276, 0, 50)
TextLabel_12.Font = Enum.Font.SourceSansBold
TextLabel_12.Text = "Session Info"
TextLabel_12.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_12.TextScaled = true
TextLabel_12.TextSize = 1.000
TextLabel_12.TextWrapped = true

FullscreenExit.Name = "Fullscreen Exit"
FullscreenExit.Parent = Frame
FullscreenExit.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
FullscreenExit.BackgroundTransparency = 1.000
FullscreenExit.Position = UDim2.new(0.862815857, 0, 0.913294792, 0)
FullscreenExit.Size = UDim2.new(0, 37, 0, 30)
FullscreenExit.Image = "rbxassetid://2777726146"

local function OKXLKOB_fake_script() 
	local script = Instance.new('LocalScript', Frame_2)

	
	local frame = script.Parent
	local gradient = frame.UIGradient
	

	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),    
		ColorSequenceKeypoint.new(0.25, Color3.new(1,1,1)),
		ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),   
		ColorSequenceKeypoint.new(0.75, Color3.new(1,1,1)), 
		ColorSequenceKeypoint.new(1, Color3.new(1,1,1)),   
	})
	
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),   
		NumberSequenceKeypoint.new(0.25, 1), 
		NumberSequenceKeypoint.new(0.5, 0),  
		NumberSequenceKeypoint.new(0.75, 1), 
		NumberSequenceKeypoint.new(1, 0),   
	})
	
	local tweenService = game:GetService("TweenService")
	local shineSpeed = 2 
	
	local function animateShine()
		local initialOffset = Vector2.new(0, 0)
		local finalOffset = Vector2.new(0.5, 0)  
	
		local tweenInfo = TweenInfo.new(
			shineSpeed,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.Out,
			-1,
			false, 
			0  
		)
	
		local tweenGoal = {
			Offset = finalOffset,
		}
	
		local tween = tweenService:Create(gradient, tweenInfo, tweenGoal)
		tween:Play()
	end
	
	animateShine()
end
coroutine.wrap(OKXLKOB_fake_script)()

local deathCount = 0

local function onDeath()
    deathCount = deathCount + 1
    DeathsNumb.Text = tostring(deathCount)
end

lplr.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(onDeath)  
end)

local character = lplr.Character or lplr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
humanoid.Died:Connect(onDeath)

local function getLocalPlayerKills()
    if lplr:FindFirstChild("leaderstats") and lplr.leaderstats:FindFirstChild("Kills") then
        return lplr.leaderstats.Kills.Value
    else
        return 0 
    end
end


local UIS = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function countAlivePlayers()
    local totalPlayers = 0
    for _, player in pairs(game.Players:GetPlayers()) do
        if game.Workspace:FindFirstChild(player.Name) then
            totalPlayers = totalPlayers + 1
        end
    end
    return totalPlayers
end

local function updateStats()
    local totalPlayers = #game.Players:GetPlayers() 
    local alivePlayers = countAlivePlayers()
    local playerKills = getLocalPlayerKills()
    local playerDeaths = deathCount
    
    PlayersNumb.Text = tostring(totalPlayers)
    AlivePlrsNumb.Text = tostring(alivePlayers)
    KillsNum.Text = tostring(playerKills)
    DeathsNumb.Text = tostring(playerDeaths)
end

updateStats()

local startTime = tick() 

local function updateTimer()
    local elapsedTime = math.floor(tick() - startTime)
    
    local minutes = math.floor(elapsedTime / 60)
    local seconds = elapsedTime % 60
    
    TimeNumb.Text = string.format("%02d:%02d", minutes, seconds) 
end

game:GetService("RunService").Heartbeat:Connect(updateTimer)

local runService = game:GetService("RunService")

runService.Heartbeat:Connect(function()
    updateStats()  
    updateTimer() 
end)


local ImageLabelDrag = ImageLabel 

local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function duringDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end

local function endDrag(input)
    if dragging then
        update(input)
    end
end

ImageLabelDrag.InputBegan:Connect(startDrag)
ImageLabelDrag.InputChanged:Connect(duringDrag)
UIS.InputChanged:Connect(endDrag)


local ImageLabelDrag = FullscreenExit 

local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function duringDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end

local function endDrag(input)
    if dragging then
        update(input)
    end
end

ImageLabelDrag.InputBegan:Connect(startDrag)
ImageLabelDrag.InputChanged:Connect(duringDrag)
UIS.InputChanged:Connect(endDrag)
		else
			local cr = game.Players.LocalPlayer.PlayerGui
			local sg = cr:FindFirstChild("ScreenGui")
			if sg then 
				sg:Destroy()
				print("[DEBUG]:Successfully destroyed Session Info")
			else 
				print("[DEBUG]:Couldnt Find Session Info")
			end
		end
	end
})


local VERSION = "Private/Custom VapeV4ForRoblox"

local vertextsize = game:GetService("TextService"):GetTextSize(GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Text.." "..VERSION, 28, Enum.Font.SourceSans, Vector2.new(99999, 99999))
GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Text = GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Text.." "..VERSION
GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Position = UDim2.new(1, -(vertextsize.X) - 20, 1, -25)
GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Version.Text = GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Version.Text.." "..VERSION







































































