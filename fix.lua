local oldfunction; 
oldfunction = hookfunction(debug.info, function(...)
	local args = {...}
	if (args[1] == 2 and args[2] == "f") then
		return nil
	else
		return oldfunction(...);
	end
end);
repeat task.wait() until game:IsLoaded()

for Index, Data in next, getgc(true) do
	if typeof(Data) == "function" and debug.getinfo(Data).name == "Immutable" then
		hookfunction(Data, function()
			return function()
				print("attempted crash")
			end
		end)
	end
end




for i, v in ipairs(getgc()) do
	pcall(function()
		if type(v) == "function" then
			local info = debug.getinfo(v)
			local up = debug.getconstants(v)
			if table.find(up, "MethodError") and table.find(up, "ServerError") and table.find(up, "ReadError") then
				print("Hooked 1")
				hookfunction(v, function()
					return function()
						print("method kick")
					end
				end)
			end
		end 
	end)
end


for i, v in ipairs(getgc()) do
	pcall(function()
		if type(v) == "function" then
			local info = debug.getinfo(v)
			local up = debug.getconstants(v)
			local up2 = debug.getconstants(v)
			if table.find(up, "Disconnected from server") then
				print(v)
				hookfunction(v, function()
					return function()
						print("attempt disconnect")
					end
				end)
			end
		end 
	end)
end

for i, v in ipairs(getgc()) do
	pcall(function()
		if type(v) == "function" then
			local info = debug.getinfo(v)
			local up = debug.getconstants(v)
			local up2 = debug.getconstants(v)
			if table.find(up2, "fakePlayer") then
				print(v)
				hookfunction(v, function()
					return  function()
						print("attempt kill")
					end
				end)
			end
		end 
	end)
end



for i, v in ipairs(getgc()) do
	pcall(function()
		if type(v) == "function" then
			local info = debug.getinfo(v)
			local up = debug.getconstants(v)
			local up2 = debug.getconstants(v)
			if table.find(up, "Tampering with Client [read rt0001]") and table.find(up, "ReadError") and table.find(up, "Potentially dangerous index") then
				print(v)
				hookfunction(v, function()
					return nil
				end)
			end
		end 
	end)
end




for i, v in ipairs(getgc()) do
	pcall(function()
		if type(v) == "function" then
			local info = debug.getinfo(v)
			if info.source and string.find(info.source, "Anti") then

				print("Found function2:", tostring(v))

			end
		end 
	end)
end

local LocalPlayer = game.Players.LocalPlayer
local oldhmmi
local oldhmmnc
oldhmmi = hookmetamethod(game, "__index", function(self, method)
	if self == LocalPlayer and method:lower() == "kick" then
		return error("Expected ':' not '.' calling member function Kick", 2)
	end
	return oldhmmi(self, method)
end)
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
	if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
		return
	end
	return oldhmmnc(self, ...)
end)

function findRemoteEventWithFunction(parent)
	-- Iterate through all the children of the parent
	for _, child in ipairs(parent:GetChildren()) do
		-- Check if the child is a RemoteEvent
		if child:IsA("RemoteEvent") then
			-- Iterate through all the children of the RemoteEvent
			for _, grandchild in ipairs(child:GetChildren()) do
				-- Check if the grandchild is a RemoteFunction named "__function"
				if grandchild:IsA("RemoteFunction") and grandchild.Name == "__FUNCTION" then
					-- Return the RemoteEvent if found
					return child
				end
			end
		end
	end
	-- Return nil if no such RemoteEvent is found
	return nil
end
local rf = findRemoteEventWithFunction(game:GetService("ReplicatedStorage"))
local ofunc
ofunc = hookfunction(rf.FireServer, function (...)
	local args = {...}
    if args[2] == "BadMemes" then
        print("blocked adonis rcall")
	    return nil
    end
    print(...)
    return ofunc(...)
end)
