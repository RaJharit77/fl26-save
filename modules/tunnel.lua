-- módulo de túnel y cinematicas para PES 2020 : Jostike Games
-- solo sider 6.1 



local fileroot = ".\\content\\tunnel"

local function get_ids(ctx)
    rdm = math.random (1,4)
end

local function make_key(ctx, filename)


    if ctx.stadium == 63 then
	if ctx.timeofday == 0 then     
        tunnel = "Stadium\\Veltis Arena Ex"        
        end
elseif ctx.stadium == 07 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Old Trafford Ex"        
		end		
elseif ctx.stadium == 22 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Juventus Ex"       
		end
elseif ctx.stadium == 11 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Allianz arena Ex"       
		end	
elseif ctx.stadium == 03 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Etihad Ex"       
        else
        tunnel = "Stadium\\Etihad"
        end						
elseif ctx.stadium == 27 then	  
    if ctx.timeofday == 0 then    
		tunnel = "Stadium\\Monumental Ex"       
		else
		tunnel = "Stadium\\Monumental Ex" 
		end		
elseif ctx.stadium == 28 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Bombonera Ex"       
		else
		tunnel = "Stadium\\Bombonera Ex"   
		end	
elseif ctx.stadium == 06 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Roma Ex"       
		else
		tunnel = "Stadium\\Roma Ex"   
		end
elseif ctx.stadium == 31 then
	if ctx.timeofday == 1 then  
        tunnel = "Stadium\\Arena Munchen Ex"                   
	    end							
elseif ctx.stadium == 52 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Emirates Ex"       
		end			
elseif ctx.stadium == 56 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\WandaMetropolitano Ex"       
		else
		tunnel = "Stadium\\WandaMetropolitano Ex"  
		end			
elseif ctx.stadium == 86 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Monumental U Ex"       
		else
        tunnel = "Stadium\\Monumental U"
        end		
elseif ctx.stadium == 85 then
	if ctx.timeofday == 0 then  
        tunnel = "Stadium\\Nacional Ex"       
		else
        tunnel = "Stadium\\Nacional"
        end


	elseif ctx.tournament_id == 34 or ctx.tournament_id == 1058 or ctx.tournament_id == 2082 or ctx.tournament_id == 3106 or ctx.tournament_id == 4130 or ctx.tournament_id == 5154 or ctx.tournament_id == 6178 or ctx.tournament_id == 7202 or ctx.tournament_id == 8226 then
        tunnel = "Competition\\FIFA World Cup 2022\\Group_Stage"
        elseif ctx.tournament_id == 35 then 
               if ctx.match_info == 53 then
                       tunnel = "Competition\\FIFA World Cup 2022\\Final"
               else 
                       tunnel = "Competition\\FIFA World Cup 2022\\Knockout"
               end
		end	

											
	else
        tunnel = nil
    end
    if tunnel ~= nil then
        return string.format("%s:%s", tunnel, filename)
    end
end

local function get_filepath(ctx, filename, key)
    if key and tunnel ~= nil then
        return string.format("%s\\%s\\%s", fileroot, tunnel, filename)
    end
end

function make_log(ctx)
    if tunnel ~= ni then
       logResult = tunnel
       logResult = string.gsub(logResult, "Stadium\\", "")
       log("-------- " .. logResult)
    end
end

local function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
    ctx.register("trophy_rewrite", make_log)
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }