--Entrances fix for default stadiums of PES 2020
--Edited by FuNZoTiK on 06/07/2020

local fileroot = ".\\content\\Entrance_fix"

function make_key(ctx, filename)
-- Final matches
    if ctx.match_info == 53 then
	   if ctx.stadium == 1 then
         Entrance_fix = "Final\\st001"
       elseif ctx.stadium == 2 then
         Entrance_fix = "Final\\st002"
       elseif ctx.stadium == 11 then
         Entrance_fix = "Final\\st011"
       elseif ctx.stadium == 14 then
         Entrance_fix = "Final\\st014"
       elseif ctx.stadium == 30 then
         Entrance_fix = "Final\\st030"
       elseif ctx.stadium == 45 then
		   if ctx.timeofday == 1 and ctx.season == 1 then  
			   Entrance_fix = "Final\\st045\\Sports Park Ex - Night Winter"
		   else
			   Entrance_fix = "Final\\st045\\Sports Park Ex - Day & Night"        
		   end
	   else
	     Entrance_fix = nil
	   end
    else
--Common matches
    if ctx.stadium == 1 then
		   if ctx.tournament_id == 2 or ctx.tournament_id == 1026 or ctx.tournament_id == 2050 or ctx.tournament_id == 3074 or ctx.tournament_id == 4098 or ctx.tournament_id == 5122 or ctx.tournament_id == 6146 or ctx.tournament_id == 7170 or ctx.tournament_id == 8194 or ctx.tournament_id == 3 or ctx.tournament_id == 1027  or ctx.tournament_id == 2051 or ctx.tournament_id == 3075 or ctx.tournament_id == 4099 or ctx.tournament_id == 5123 or ctx.tournament_id == 6147 or ctx.tournament_id == 7171 or ctx.tournament_id == 8195 or ctx.tournament_id == 4 or ctx.tournament_id == 5 or ctx.tournament_id == 1029 or ctx.tournament_id == 2053 or ctx.tournament_id == 3077 or ctx.tournament_id == 4101 or ctx.tournament_id == 5125 or ctx.tournament_id == 6149 or ctx.tournament_id == 7173 or ctx.tournament_id == 8197 or ctx.tournament_id == 9221 or ctx.tournament_id == 10245 or ctx.tournament_id == 11269 or ctx.tournament_id == 12293 or ctx.tournament_id == 6 then
			   Entrance_fix = "Common\\st001\\UCL, UEL"
		   else
			   Entrance_fix = "Common\\st001"
		   end
       elseif ctx.stadium == 2 then
         Entrance_fix = "Common\\st002"
       elseif ctx.stadium == 5 then
         Entrance_fix = "Common\\st005"
       elseif ctx.stadium == 6 then
         Entrance_fix = "Common\\st006"
       elseif ctx.stadium == 7 then
		   if ctx.tournament_id == 2 or ctx.tournament_id == 1026 or ctx.tournament_id == 2050 or ctx.tournament_id == 3074 or ctx.tournament_id == 4098 or ctx.tournament_id == 5122 or ctx.tournament_id == 6146 or ctx.tournament_id == 7170 or ctx.tournament_id == 8194 or ctx.tournament_id == 3 or ctx.tournament_id == 1027  or ctx.tournament_id == 2051 or ctx.tournament_id == 3075 or ctx.tournament_id == 4099 or ctx.tournament_id == 5123 or ctx.tournament_id == 6147 or ctx.tournament_id == 7171 or ctx.tournament_id == 8195 or ctx.tournament_id == 4 or ctx.tournament_id == 5 or ctx.tournament_id == 1029 or ctx.tournament_id == 2053 or ctx.tournament_id == 3077 or ctx.tournament_id == 4101 or ctx.tournament_id == 5125 or ctx.tournament_id == 6149 or ctx.tournament_id == 7173 or ctx.tournament_id == 8197 or ctx.tournament_id == 9221 or ctx.tournament_id == 10245 or ctx.tournament_id == 11269 or ctx.tournament_id == 12293 or ctx.tournament_id == 6 then
			   Entrance_fix = "Common\\st007\\UCL, UEL"
		   else
			   Entrance_fix = "Common\\st007"
		   end
       elseif ctx.stadium == 10 then
         Entrance_fix = "Common\\st010"
       elseif ctx.stadium == 11 then
         Entrance_fix = "Common\\st011"
       elseif ctx.stadium == 14 then
         Entrance_fix = "Common\\st014"
       elseif ctx.stadium == 16 then
         Entrance_fix = "Common\\st016"
       elseif ctx.stadium == 20 then
         Entrance_fix = "Common\\st020"
       elseif ctx.stadium == 22 then
         Entrance_fix = "Common\\st022"
       elseif ctx.stadium == 23 then
         Entrance_fix = "Common\\st023"
       elseif ctx.stadium == 27 then
          Entrance_fix = "Common\\st074"
       elseif ctx.stadium == 28 then
         Entrance_fix = "Common\\st028"
       elseif ctx.stadium == 30 then
		   if ctx.tournament_id == 2 or ctx.tournament_id == 1026 or ctx.tournament_id == 2050 or ctx.tournament_id == 3074 or ctx.tournament_id == 4098 or ctx.tournament_id == 5122 or ctx.tournament_id == 6146 or ctx.tournament_id == 7170 or ctx.tournament_id == 8194 or ctx.tournament_id == 3 or ctx.tournament_id == 1027  or ctx.tournament_id == 2051 or ctx.tournament_id == 3075 or ctx.tournament_id == 4099 or ctx.tournament_id == 5123 or ctx.tournament_id == 6147 or ctx.tournament_id == 7171 or ctx.tournament_id == 8195 or ctx.tournament_id == 4 or ctx.tournament_id == 5 or ctx.tournament_id == 1029 or ctx.tournament_id == 2053 or ctx.tournament_id == 3077 or ctx.tournament_id == 4101 or ctx.tournament_id == 5125 or ctx.tournament_id == 6149 or ctx.tournament_id == 7173 or ctx.tournament_id == 8197 or ctx.tournament_id == 9221 or ctx.tournament_id == 10245 or ctx.tournament_id == 11269 or ctx.tournament_id == 12293 or ctx.tournament_id == 6 then
			   Entrance_fix = "Common\\st030\\UCL, UEL"
		   else
			   Entrance_fix = "Common\\st030"
		   end
       elseif ctx.stadium == 33 then
         Entrance_fix = "Common\\st033"
       elseif ctx.stadium == 34 then
         Entrance_fix = "Common\\st034"
       elseif ctx.stadium == 36 then
         Entrance_fix = "Common\\st036"
       elseif ctx.stadium == 40 then
         Entrance_fix = "Common\\st040"
       elseif ctx.stadium == 41 then
         Entrance_fix = "Common\\st041"
       elseif ctx.stadium == 45 then
		   if ctx.timeofday == 1 and ctx.season == 1 then  
			   Entrance_fix = "Common\\st045\\Sports Park Ex - Night Winter"
		   else
			   Entrance_fix = "Common\\st045\\Sports Park Ex - Day & Night"        
		   end
       elseif ctx.stadium == 49 then
         Entrance_fix = "Common\\st049"
       elseif ctx.stadium == 52 then
         Entrance_fix = "Common\\st052"
       elseif ctx.stadium == 59 then
         Entrance_fix = "Common\\st059"
       elseif ctx.stadium == 61 then
         Entrance_fix = "Common\\st061"
       elseif ctx.stadium == 62 then
         Entrance_fix = "Common\\st062"
       elseif ctx.stadium == 63 then
         Entrance_fix = "Common\\st063"
       elseif ctx.stadium == 64 then
         Entrance_fix = "Common\\st064"
       elseif ctx.stadium == 65 then
         Entrance_fix = "Common\\st065"
       elseif ctx.stadium == 66 then
         Entrance_fix = "Common\\st066"
       elseif ctx.stadium == 70 then
         Entrance_fix = "Common\\st070"
       elseif ctx.stadium == 71 then
         Entrance_fix = "Common\\st071"
       elseif ctx.stadium == 74 then
         Entrance_fix = "Common\\st074"
       elseif ctx.stadium == 79 then
         Entrance_fix = "Common\\st079"
       elseif ctx.stadium == 81 then
         Entrance_fix = "Common\\st081"
       elseif ctx.stadium == 82 then
         Entrance_fix = "Common\\st082"
	   else
		 Entrance_fix = nil
       end
	end
    if Entrance_fix ~= nil then
       return string.format("%s:%s", Entrance_fix, filename)
    end
end

local function get_filepath(ctx, filename, key)
    if key and Entrance_fix ~= nil then
        return string.format("%s\\%s\\%s", fileroot, Entrance_fix, filename)
    end
end

function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }
