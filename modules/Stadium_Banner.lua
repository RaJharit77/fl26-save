--Stadium Banners for PES 2020
--Edited by FuNZoTiK on 01/06/2020

local function stadium_id(ctx)
    stadium = ctx.stadium
	if string.len(stadium) == 1 then
	   stid = "st00" .. stadium
	elseif string.len(stadium) == 2 then
	   stid = "st0" .. stadium
	elseif string.len(stadium) == 3 then
	   stid = "st" .. stadium
	end
	ad_cl = string.format("ad_%s_cl.fpk", stid)
	ad_uel = string.format("ad_%s_el.fpk", stid)
	ad_uecl = string.format("ad_%s_uecl.fpk", stid)
	ad_sc = string.format("ad_%s_sc.fpk", stid)
	ad_eu = string.format("ad_%s_eu.fpk", stid)
end

function rewrite(ctx, filename)
	tid = ctx.tournament_id
    if ad_cl and ad_uel and ad_uecl and ad_sc then
       if tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4 then
     	  if ctx.stadium == 2 then
		  else
		  return string.gsub(filename, "ad_st%d%d%d_normal.fpk", ad_cl)
		  end
	   elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then
     	  if ctx.stadium == 2 then
		  else
		  return string.gsub(filename, "ad_st%d%d%d_normal.fpk", ad_uel)
		  end
	   elseif tid == 47 or tid == 1071 or tid == 2095 or tid == 3119 or tid == 4143 or tid == 5167 or tid == 6191 or tid == 7215 or tid == 8239 or tid == 48 then
     	  if ctx.stadium == 2 then
		  else
		  return string.gsub(filename, "ad_st%d%d%d_normal.fpk", ad_uecl)
		  end
	   elseif tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42 then
     	  if ctx.stadium == 2 then
		  else
		  return string.gsub(filename, "ad_st%d%d%d_normal.fpk", ad_eu)
		  end  
	   elseif tid == 7 then
     	  if ctx.stadium == 2 then
		  else
          return string.gsub(filename, "ad_st%d%d%d_normal.fpk", ad_sc)
		  end
	   else
		  return nil
       end
	end
end

local function get_filepath(ctx, filename, key)
	tid = ctx.tournament_id
    if key then
       if tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 3 then
	    	filepath = ctx.sider_dir .. ".\\content\\Stadium_Banner\\" .. filename
	   elseif tid == 47 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 48 then
	    	filepath = ctx.sider_dir .. ".\\content\\Stadium_Banner\\" .. filename
	   elseif tid == 7 then
	    	filepath = ctx.sider_dir .. ".\\content\\Stadium_Banner\\" .. filename
	   elseif tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35 then
	   		if ctx.match_info == 53 then
	    		filepath = ctx.sider_dir .. ".\\content\\Stadium_Banner\\FIFA World Cup\\Final\\" .. filename
	    	else
	    		filepath = ctx.sider_dir .. ".\\content\\Stadium_Banner\\FIFA World Cup\\Group_Knockout\\" .. filename
	    	end
	   else
       end
       return filepath
    end
end


function init(ctx)
    ctx.register("livecpk_rewrite", rewrite)
    ctx.register("after_set_conditions", stadium_id)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }