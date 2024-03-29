AddCSLuaFile()

GM.Name 		= "gCrossroads"
GM.Author 		= "RVVZ & Zenith"
GM.Email 		= ""
GM.Website 		= ""

team.SetUp(100, "Players", Color(255, 255, 0))
team.SetUp(101, "Admins", Color(255, 0, 0))

TEAM_PLAYERS = 100
TEAM_ADMINS = 101

-- Load configs
do
	local files, _ = file.Find(GM.FolderName .. "/gamemode/modules/config/*", "LUA")
	for _, v in ipairs(files) do
		if SERVER then
			AddCSLuaFile(GM.FolderName .. "/gamemode/modules/config/" .. v)
		end
		include(GM.FolderName .. "/gamemode/modules/config/" .. v)
	end
	

	if SERVER then
		AddCSLuaFile(GM.FolderName .. "/gamemode/modules/player_gcrossroads.lua")
	end
	include(GM.FolderName .. "/gamemode/modules/player_gcrossroads.lua")
end
function recursiveInclusion( scanDirectory, isGamemode )
	-- Null-coalescing for optional argument
	isGamemode = isGamemode or false
	
	local queue = { scanDirectory }
	
	-- Loop until queue is cleared
	while #queue > 0 do
		-- For each directory in the queue...
		for _, directory in pairs( queue ) do
			-- print( "Scanning directory: ", directory )
			
			local files, directories = file.Find( directory .. "/*", "LUA" )
			
			-- Include files within this directory
			for _, fileName in pairs( files ) do
				if fileName != "shared.lua" and fileName != "init.lua" and fileName != "cl_init.lua" then
					--print( "Found: ", fileName )
					
					-- Create a relative path for inclusion functions
					-- Also handle pathing case for including gamemode folders
					local relativePath = directory .. "/" .. fileName
					if isGamemode then
						relativePath = string.gsub( directory .. "/" .. fileName, GM.FolderName .. "/gamemode/", "" )
					end
					
					-- Include server files
					if string.match( fileName, "^sv" ) then
						if SERVER then
							include( relativePath )
						end
					end
					
					-- Include shared files
					if string.match( fileName, "^sh" ) then
						AddCSLuaFile( relativePath )
						include( relativePath )
					end
					
					-- Include client files
					if string.match( fileName, "^cl" ) then
						AddCSLuaFile( relativePath )
						
						if CLIENT then
							include( relativePath )
						end
					end
				end
			end
			
			-- Append directories within this directory to the queue
			for _, subdirectory in pairs( directories ) do
				-- print( "Found directory: ", subdirectory )
				table.insert( queue, directory .. "/" .. subdirectory )
			end
			
			-- Remove this directory from the queue
			table.RemoveByValue( queue, directory )
		end
	end
end
recursiveInclusion( GM.FolderName .. "/gamemode", true )