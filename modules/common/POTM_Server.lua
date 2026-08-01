-- Created by D4nt
-- Improved POTM logic by Digno & Copilot & Grok
-- Activación inteligente: solo usa POTM si existe archivo
-- Versión sin label Home/Away en carpetas POTM

local m = {}
local fileroot = ".\\content\\POTM"

local match_active = false
local debug_enabled = true  -- pon true solo para debug
local ceremonia_home = false

local function safe_log(msg)
  if debug_enabled then log("[POTM] " .. msg) end
end

---------------------------------------------------------
-- RESET TOTAL AL INICIO DEL PARTIDO
---------------------------------------------------------
local function set_random(ctx)
  match_active = false
  safe_log("Reset completo al inicio del partido")
end

---------------------------------------------------------
-- GENERADOR DE CLAVES (sin Home/Away)
---------------------------------------------------------
local function make_key(ctx, filename)
  if not match_active then return {} end   -- {} vacío, no nil

  local tid   = ctx.tournament_id
  local home  = ctx.home_team
  local away  = ctx.away_team

  local potm_keys = {}

  local function build_key()
    local potm_key

    if tid == 19 then potm_key = "La Liga"
    elseif tid == 18 then potm_key = "Serie A"
    elseif tid == 17 then potm_key = "Premier League"

    elseif tid == 2 or tid == 3 or tid == 4 or
           tid == 1026 or tid == 1027 or
           tid == 2050 or tid == 2051 or
           tid == 3074 or tid == 3075 or
           tid == 4098 or tid == 4099 or
           tid == 5122 or tid == 5123 or
           tid == 6146 or tid == 6147 or
           tid == 7170 or tid == 7171 or
           tid == 8194 or tid == 8195
    then
      potm_key = "UEFA Champions League"

    elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or
           tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or
           tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or
           tid == 12293 or tid == 6
    then
      potm_key = "UEFA Europa League"

    elseif tid == 65535 or tid == 1 or tid == 56 or tid == 57 or tid == 58 then
 
      -- Exhibición → detectar liga por equipos (opción corta)

      potm_key = "Exhibition Match"   -- valor por defecto

      if home and away and home ~= 0 and away ~= 0 then

        -- Premier League
        if  (home == 4071 or home == 101 or home == 107 or home == 4180 or home == 377 or home == 102 or home == 382 or home == 177 or home == 178 or home == 104 or home == 204 or home == 103 or home == 173 or home == 100 or home == 106 or home == 389 or home == 207 or home == 179 or home == 105 or home == 208) and
            (away == 4071 or away == 101 or away == 107 or away == 4180 or away == 377 or away == 102 or away == 382 or away == 177 or away == 178 or away == 104 or away == 204 or away == 103 or away == 173 or away == 100 or away == 106 or away == 389 or away == 207 or away == 179 or away == 105 or away == 208) then
          potm_key = "Premier League"

        -- EFL Championship
        elseif (home == 201 or home == 176 or home == 1761 or home == 1760 or home == 378 or home == 379 or home == 4183 or home == 2610 or home == 1589 or home == 4363 or home == 205 or home == 387 or home == 388 or home == 4192 or home == 1327 or home == 391 or home == 4193 or home == 4194 or home == 395 or home == 396 or home == 1909 or home == 399 or home == 398 or home == 400) and
               (away == 201 or away == 176 or away == 1761 or away == 1760 or away == 378 or away == 379 or away == 4183 or away == 2610 or away == 1589 or away == 4363 or away == 205 or away == 387 or away == 388 or away == 4192 or away == 1327 or away == 391 or away == 4193 or away == 4194 or away == 395 or away == 396 or away == 1909 or away == 399 or away == 398 or away == 400) then
          potm_key = "EFL Championship"

        -- Serie A
        elseif (home == 234 or home == 186 or home == 4220 or home == 235 or home == 124 or home == 336 or home == 119 or home == 120 or home == 122 or home == 4237 or home == 121 or home == 4914 or home == 327 or home == 125 or home == 4244 or home == 240 or home == 1919 or home == 1600 or home == 333 or home == 190) and
               (away == 234 or away == 186 or away == 4220 or away == 235 or away == 124 or away == 336 or away == 119 or away == 120 or away == 122 or away == 4237 or away == 121 or away == 4914 or away == 327 or away == 125 or away == 4244 or away == 240 or away == 1919 or away == 1600 or away == 333 or away == 190) then
          potm_key = "Serie A"

        -- La Liga
        elseif (home == 258 or home == 172 or home == 263 or home == 4308 or home == 361 or home == 103 or home == 362 or home == 2187 or home == 370 or home == 195 or home == 259 or home == 261 or home == 194 or home == 109 or home == 196 or home == 266 or home == 265 or home == 357 or home == 110 or home == 267) and
               (away == 258 or away == 172 or away == 263 or away == 4308 or away == 361 or away == 103 or away == 362 or away == 2187 or away == 370 or away == 195 or away == 259 or away == 261 or away == 194 or away == 109 or away == 196 or away == 266 or away == 265 or away == 357 or away == 110 or away == 267) then
          potm_key = "La Liga"

        -- Ligue 1
        elseif (home == 209 or home == 180 or home == 403 or home == 112 or home == 407 or home == 420 or home == 414 or home == 216 or home == 213 or home == 215 or home == 217 or home == 113 or home == 181 or home == 114 or home == 182 or home == 4213 or home == 1329 or home == 1330 or home == 218 or home == 221) and
               (away == 209 or away == 180 or away == 403 or away == 112 or away == 407 or away == 420 or away == 414 or away == 216 or away == 213 or away == 215 or away == 217 or away == 113 or away == 181 or away == 114 or away == 182 or away == 4213 or away == 1329 or away == 1330 or away == 218 or away == 221) then
          potm_key = "Ligue 1"

        -- Bundesliga
        elseif (home == 4124 or home == 128 or home == 127 or home == 4128 or home == 126 or home == 225 or home == 226 or home == 227 or home == 4125 or home == 4126 or home == 4137 or home == 5010 or home == 436 or home == 184 or home == 231 or home == 4140 or home == 185 or home == 232) and
               (away == 4124 or away == 128 or away == 127 or away == 4128 or away == 126 or away == 225 or away == 226 or away == 227 or away == 4125 or away == 4126 or away == 4137 or away == 5010 or away == 436 or away == 184 or away == 231 or away == 4140 or away == 185 or away == 232) then
          potm_key = "Bundesliga"

        -- J League
        elseif (home == 144 or home == 146 or home == 147 or home == 149 or home == 150 or home == 152 or home == 163 or home == 165 or home == 153 or home == 154 or home == 155 or home == 156 or home == 157 or home == 168 or home == 158 or home == 159 or home == 169 or home == 170) and
               (away == 144 or away == 146 or away == 147 or away == 149 or away == 150 or away == 152 or away == 163 or away == 165 or away == 153 or away == 154 or away == 155 or away == 156 or away == 157 or away == 168 or away == 158 or away == 159 or away == 169 or away == 170) then
          potm_key = "J League"

        -- Credit Suisse Super League
        elseif (home == 1950 or home == 1706 or home == 4965 or home == 4962 or home == 1955 or home == 4937 or home == 4968 or home == 1957 or home == 1228 or home == 1958) and
               (away == 1950 or away == 1706 or away == 4965 or away == 4962 or away == 1955 or away == 4937 or away == 4968 or away == 1957 or away == 1228 or away == 1958) then
          potm_key = "Credit Suisse Super League"

        end
      end

    elseif tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or
           tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or
           tid == 8226 or tid == 35
    then
      potm_key = "FIFA World Cup"

    elseif tid == 15 or tid == 1039 or tid == 2063 or tid == 3087 or
           tid == 4143 or tid == 4111 or tid == 5135 or tid == 6159 or
           tid == 7183 or tid == 8207 or tid == 16
    then
      potm_key = "AFC Champions League Elite"

    elseif tid == 7 then potm_key = "UEFA Super Cup"
    elseif tid == 79 or tid == 83 then potm_key = "EFL Championship"
    elseif tid == 23 then potm_key = "FA Cup"
    elseif tid == 86 then potm_key = "Community Shield"
    elseif tid == 20 then potm_key = "Ligue 1"
    elseif tid == 50 then potm_key = "Bundesliga"

    elseif tid == 1 or tid == 47 or tid == 48 or
           tid == 1071 or tid == 2095 or tid == 3119 or
           tid == 4143 or tid == 5167 or tid == 6191 or
           tid == 7215 or tid == 8239
    then
      potm_key = "FIFA Club World Cup"

    elseif tid == 25 then potm_key = "Copa Del Rey"

    else
      return nil
    end

    return string.format("%s:%s", potm_key, filename)
  end

  local key = build_key()
  if key then table.insert(potm_keys, key) end

  return potm_keys
end

---------------------------------------------------------
-- GET FILEPATH INTELIGENTE
---------------------------------------------------------
local function get_filepath(ctx, filename)

  ---------------------------------------------------------
  -- ACTIVACIÓN DEL MÓDULO
  ---------------------------------------------------------
  if filename:match("ent_.*%.fdc") then
    match_active = true
    safe_log("Entrada detectada → módulo activado")
    return
  end

  if not match_active then 
    safe_log("Módulo inactivo → ignorando: " .. filename)
    return 
  end

  ---------------------------------------------------------
  -- DESACTIVACIÓN
  ---------------------------------------------------------
  if filename:match("MatchEnd%.json$") then
    safe_log("MatchEnd.json detectado → módulo desactivado")
    match_active = false
    return
  end

  -- Log ampliado para todos los tu_* (ayuda a debuggear)
  if filename:match("^tu_") then
    safe_log("Ceremonia detectada (tu_*): " .. filename .. " | ceremonia_home = " .. tostring(ceremonia_home))
  end

  ---------------------------------------------------------
  -- FIX PARA MARCADORES ALTOS / REPARTO DE GOLES + FORZADO INICIAL DEL JUGADOR
  -- Redirigir TODAS las combi y undershirt a pickup bueno
  -- + Forzar pickup del jugador en el PRIMERO que llegue (si no se hizo antes)
  ---------------------------------------------------------
  local is_undershirt_or_combi = filename:match("tu_pickup_undershirt_a") or filename:match("tu_pickup_combi_a")
  local is_handshake = filename:match("tu_referee_handshake")

  if is_undershirt_or_combi or is_handshake then
      safe_log("Detectada undershirt / combi / handshake → chequeando forzado")

      -- Variable auxiliar para saber si es el primer undershirt/combi de la ceremonia
      -- (usamos una variable nueva porque ceremonia_home podría estar true de antes)
      if not _G.first_undershirt_forced then
          safe_log("¡PRIMER undershirt/combi/handshake DETECTADO → FORZANDO PICKUP INICIAL DEL JUGADOR!")
          _G.first_undershirt_forced = true   -- marca global para esta partida (se resetea en set_random)

          local target = "common\\demo\\fixdemo\\timeup\\cut_data\\tu_pickup_good_a_pl_home.fdc"
          
          if filename:match("_pl_away") or filename:match("_away%.") then
              target = "common\\demo\\fixdemo\\timeup\\cut_data\\tu_pickup_good_a_pl_away.fdc"
              safe_log(" → forzando pickup inicial AWAY")
          else
              safe_log(" → forzando pickup inicial HOME (por defecto)")
          end

          local keys = make_key(ctx, target)
          for _, key in ipairs(keys) do
              local potm_label = key:match("^(.-):")
              local full_path = string.format("%s\\%s\\%s", fileroot, potm_label, target)

              local f = io.open(full_path, "r")
              if f then
                  f:close()
                  safe_log("ÉXITO: FORZADO INICIAL DEL JUGADOR: " .. full_path)
                  return full_path   -- retorna inmediatamente el pickup del jugador
              end
          end
          
          safe_log("No se encontró el pickup inicial → fallback a estable")
      end

      -- Si ya se forzó el inicial (o no se encontró), fuerza el ESTABLE en los siguientes
      safe_log("Forzando pickup ESTABLE desde undershirt/combi/handshake")
      
      local target_stable = "common\\demo\\fixdemo\\timeup\\cut_data\\tu_pickup_good_a_pl_home.fdc"
      
      if filename:match("_pl_away") then
          target_stable = "common\\demo\\fixdemo\\timeup\\cut_data\\tu_pickup_good_a_pl_away.fdc"
          safe_log(" → versión AWAY para pickup estable")
      else
          safe_log(" → versión HOME para pickup estable")
      end

      local keys = make_key(ctx, target_stable)
      for _, key in ipairs(keys) do
          local potm_label = key:match("^(.-):")
          local full_path = string.format("%s\\%s\\%s", fileroot, potm_label, target_stable)

          local f = io.open(full_path, "r")
          if f then
              f:close()
              safe_log("FORZANDO PICKUP ESTABLE: " .. full_path)
              return full_path
          end
      end
      
      safe_log("No se encontró pickup estable → fallback normal")
      return
  end

  ---------------------------------------------------------
  -- FORZADO INTELIGENTE ORIGINAL (por si acaso llega un tu_full o tu_pickup normal)
  ---------------------------------------------------------
  if (filename:match("tu_full") or filename:match("tu_pickup") or filename:match("tu_referee_handshake")) and not ceremonia_home then
    
    safe_log("¡PRIMERA CÁMARA REAL DETECTADA! → forzando inicio con jugador")
    ceremonia_home = true

    local target
    if filename:match("_away%.fdc") or filename:match("_pl_away%.fdc") then
      target = "common\\demo\\fixdemo\\timeup\\cut_data\\tu_pickup_good_a_pl_away.fdc"
      safe_log("Detectado Away → forzando pickup away")
    else
      target = "common\\demo\\fixdemo\\timeup\\cut_data\\tu_pickup_good_a_pl_home.fdc"
      safe_log("Detectado Home → forzando pickup home")
    end

    local keys = make_key(ctx, target)
    for _, key in ipairs(keys) do
      local potm_label = key:match("^(.-):")
      local full_path = string.format("%s\\%s\\%s", fileroot, potm_label, target)

      local f = io.open(full_path, "r")
      if f then
        f:close()
        safe_log("INICIO FORZADO CON JUGADOR: " .. full_path)
        return full_path
      end
    end
    
    safe_log("No se encontró el pickup → fallback normal")
    return
  end

  ---------------------------------------------------------
  -- LÓGICA NORMAL PARA EL RESTO DE ARCHIVOS
  ---------------------------------------------------------
  local keys = make_key(ctx, filename)
  
  if not keys or #keys == 0 then 
    safe_log("No hay claves válidas para: " .. filename .. " → ignorando")
    return 
  end

  for _, key in ipairs(keys) do
    local potm_label = key:match("^(.-):")
    local full_path = string.format("%s\\%s\\%s", fileroot, potm_label, filename)

    local f = io.open(full_path, "r")
    if f then
      f:close()
      safe_log("Archivo POTM encontrado: " .. full_path)
      return full_path
    end
  end

  safe_log("No existe archivo POTM para " .. filename .. " → usar escena normal")
  return
end

---------------------------------------------------------
-- INIT
---------------------------------------------------------
function m.init(ctx)
  if fileroot:sub(1,1) == "." then
    fileroot = ctx.sider_dir .. fileroot:sub(2)  -- corregido: sub(2) para quitar el "."
  end

  ctx.register("set_teams", set_random)
  ctx.register("livecpk_make_key", make_key)
  ctx.register("livecpk_get_filepath", get_filepath)

  safe_log("POTM inteligente cargado (sin label Home/Away)")
end

return m