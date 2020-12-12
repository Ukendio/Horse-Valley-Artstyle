
-- Init
local House = workspace.Camera:FindFirstChildOfClass("Model")
local Invalids = {}
local WALL_HEIGHT = 12


-- Check organization
local Ceiling = House:FindFirstChild("Ceiling")
if not Ceiling then
	warn("No Ceiling model!")
	return
end
local Exterior = House:FindFirstChild("Exterior")
if not Exterior then
	warn("No Exterior model!")
	return
end
local Interior = House:FindFirstChild("Interior")
if not Interior then
	warn("No Interior model!")
	return
end
local Door = nil
for _, v in pairs(Exterior:GetChildren()) do
	if v.Name == "door" then
		if not Door then
			Door = v
		else
			game.Selection:Set({v})
			warn("One exterior door only!")
			return
		end
	end
end
if not Door then
	warn("No door!")
	return
end


-- Fix rooms name and check hierarchy
for k, v in pairs(Interior:GetChildren()) do
	v.Name = "room" .. k
	if not v:FindFirstChild("Floor") then
		game.Selection:Set({v})
		warn("No Floor model")
		return
	elseif not v:FindFirstChild("Walls") then
		game.Selection:Set({v})
		warn("No Walls model")
		return
	end
end


-- Fix material, color, castshadow
for _, v in pairs(House:GetDescendants()) do
	if v:IsA("BasePart") then

		v.Material = Enum.Material.SmoothPlastic
		v.CanCollide = true
		v.CastShadow = (v.Parent.Name == "Ceiling" or (v.Parent.Name == "walls" and v.Parent.Parent == Exterior))

		if v.Name == "Glass" then
			v.Color = Color3.fromRGB(255, 255, 255)
			v.Reflectance = 0.75
			v.Transparency = 0.75
		end

		if v.Parent.Name == "Ceiling" or v.Parent.Name == "Walls" and v.Parent.Parent == Interior then
			v.Color = Color3.fromRGB(255, 255, 255)
		end
	end
end


-- Transpose walls (thickness = z, width = x, height = z)
local numTransposedParts = 0
local transposingWalls = {}
for _, room in pairs(Interior:GetChildren()) do
	for _, v in pairs(room.Floor:GetChildren()) do
		if v.ClassName == "Part" then
			table.insert(transposingWalls, v)
		end
	end
end
for _, v in pairs(Exterior.walls:GetChildren()) do
	if v.ClassName == "Part" then
		table.insert(transposingWalls, v)
	end
end
for _, v in pairs(transposingWalls) do
	local size = v.Size
	local min = "X"
	if math.min(size.X, size.Y, size.Z) == size.Y then
		min = "Y"
	elseif math.min(size.X, size.Y, size.Z) == size.Z then
		min = "Z"
	end
	if min == "X" then
		numTransposedParts = numTransposedParts + 1
		v.Size = Vector3.new(size.Z, size.Y, size.X)
		v.CFrame = v.CFrame*CFrame.Angles(0, math.pi / 2, 0)
	elseif min == "Y" then
		numTransposedParts = numTransposedParts + 1
		v.Size = Vector3.new(size.X, size.Z, size.Y)
		v.CFrame = v.CFrame*CFrame.Angles(math.pi / 2, 0, 0)
	end
	if math.round(v.Orientation.Z) ~= 0 then
		numTransposedParts = numTransposedParts + 1
		v.Size = Vector3.new(size.Y, size.X, size.Z)
		v.CFrame = v.CFrame*CFrame.Angles(0, 0, -1*math.sign(v.Orientation.Z)*math.pi / 2)
	end
end
print("Number of transposed parts:", numTransposedParts)


-- Check door size
local doorPaintable = Door:FindFirstChild("Paintable")
if not doorPaintable then
	game.Selection:Set({Door})
	warn("Door must have a paintable part!")
	return
end
if math.round(doorPaintable.Size.X*10) ~= 45 
or math.round(doorPaintable.Size.Y*100) ~= 775
or math.round(doorPaintable.Size.Z*10) ~= 5 then
	game.Selection:Set({doorPaintable})
	print('a:', math.round(doorPaintable.Size.X*10), math.round(doorPaintable.Size.Y*100), math.round(doorPaintable.Size.Z*10))
	warn("Door size is incorrect!")
	return
end


-- Check walls size
for _, v in pairs(Exterior.walls:GetChildren()) do
	local size = v.Size
	if (size.Y > 10 and math.round(size.Y) ~= WALL_HEIGHT) or math.round(v.Size.Z*100) ~= 25 then
		table.insert(Invalids, v)
	end
end
for _, room in pairs(Interior:GetChildren()) do
	for _, v in pairs(room.Walls:GetChildren()) do
		local size = v.Size
		if (size.Y > 10 and math.round(size.Y) ~= WALL_HEIGHT) or math.round(v.Size.Z*100) ~= 25 then
			table.insert(Invalids, v)
		end
	end
end
if #Invalids > 0 then
	game.Selection:Set(Invalids)
	warn("Wall must be .. " .. WALL_HEIGHT .. " in Y and 0.25 in Z")
	return
end


-- Check ceiling and floor size
for _, v in pairs(Ceiling:GetChildren()) do
	if math.round(v.Size.Y*1000) ~= 125 then
		table.insert(Invalids, v)
	end
end
for _, room in pairs(Interior:GetChildren()) do
	for _, v in pairs(room.Floor:GetChildren()) do
		if math.round(v.Size.Y*1000) ~= 125 then
			table.insert(Invalids, v)
		end
	end
end
if #Invalids > 0 then
	game.Selection:Set(Invalids)
	warn("Floor and Ceiling must be 0.125 height")
	return
end


-- Create Base
local Base = House:FindFirstChild("Base")
if not Base then
	local modelCFrame, modelSize = House:GetBoundingBox() 
	Base = Instance.new("Part")
	Base.Parent = House
	Base.Name = "Base"
	Base.CanCollide = false
	Base.Anchored = true
	Base.CastShadow = false
	Base.Transparency = 125
	Base.Material = Enum.Material.SmoothPlastic
	Base.CFrame = modelCFrame - Vector3.new(0, modelSize.Y*0.5 + 0.5, 0)
	Base.Size = Vector3.new(2, 1, 2)
end


-- Check ceiling height
for _, v in pairs(Ceiling:GetChildren()) do
	local height = v.Position.Y - Base.Position.Y
	local heightDiv = height%WALL_HEIGHT
	heightDiv = math.floor(heightDiv*1000)
	if heightDiv ~= 437 then
		warn("Ceiling positioned at wrong height")
		return
	end
end


-- Check floor height
for _, room in pairs(Interior:GetChildren()) do
	for _, v in pairs(room.Floor:GetChildren()) do
		local height = v.Position.Y - Base.Position.Y
		local heightDiv = height%WALL_HEIGHT
		heightDiv = math.floor(heightDiv*1000)
		if heightDiv ~= 562 then
			warn("Floor positioned at wrong height")
			return
		end
	end
end

for _, v in pairs(workspace.Camera:GetDescendants()) do
    if v:IsA("BasePart") then
        local size = v.Size
        size = size*1000
        if math.floor(size.X%125) ~= 0 or math.floor(size.Y)%125 ~= 0 or math.floor(size.Z)%125 ~= 0 then
            print('a:', size.X%125, size.Y%125, size.Z%125)
            table.insert(Invalids, v)
        end
    end    
end
if #Invalids > 0 then
    game.Selection:Set(Invalids)
else
    print('Great! No invalid size found.')
end

local Parts = {}
local Selections = {}

local function RoundVector3(vector3)
    return Vector3.new(
        math.floor(vector3.X*1000 + 0.5)*0.001, 
        math.floor(vector3.Y*1000 + 0.5)*0.001, 
        math.floor(vector3.Z*1000 + 0.5)*0.001
    )
end

for _, v in pairs(workspace.Camera:GetDescendants()) do
    if v:IsA("BasePart") then
        table.insert(Parts, {
            v,
            RoundVector3(v.Position),
            RoundVector3(v.Size),
            RoundVector3(v.Orientation),
        })
    end
end

for i = #Parts, 1, -1 do
    local part1 = Parts[i]
    for _, part2 in pairs(Parts) do
        if part1[1] ~= part2[1] then
            if part1[2] == part2[2]
            and part1[3] == part2[3]
            and part1[4] == part2[4] then
                print('found duplicate')
                table.insert(Selections, part2[1])
                table.remove(Parts, i)
            end
        end
    end
end

game.Selection:Set(Selections)

-- Finish
warn("THIS SCRIPT DO NOT REPLACE MANUAL REVIEW")
print('Success! This house looks great :)')

return {}