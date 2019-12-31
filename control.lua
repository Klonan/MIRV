local custom_alert = {type = "item", name = "mirv-rocket"}
local alert_message = {"launch-detected"}
local alert_sound = {path = "entity-build/mirv-target"}
local mirv_item = "mirv-rocket"
local mirv_smoke = "mirv-smoke"
local mirv_smoke_2 = "mirv-smoke-2"
local mirv_target = "mirv-target"
local nuke = "atomic-rocket"
local mirv_entity = "mirv-entity"
local launcher = "mirv-launcher"
local insert_param = {name = "mirv-ammo", count = 5}
local mirv_effect_id = "mirv-launch"
local mirv_projectile = "mirv-projectile"
local mirv_pollution_trigger = "mirv-pollute"

local make_mirv_launcher = function(silo)
  local launcher = silo.surface.create_entity
  {
    name = launcher,
    position = silo.position,
    force = silo.force
  }
  launcher.insert(insert_param)
  launcher.destructible = false

end

local on_rocket_launched = function(event)
  local rocket = event.rocket
  if not (rocket and rocket.valid) then return end

  local silo = event.rocket_silo
  if not (silo and silo.valid) then return end

  local item_count = rocket.get_item_count(mirv_item)
  if item_count == 0 then return end

  make_mirv_launcher(silo)

end

local add_to_tracked_items = function()

  if remote.interfaces["silo_script"] then
    remote.call("silo_script", "add_tracked_item", "mirv-rocket")
  end

end

local call_nuke = function(surface, position, source)

  --position = {x = 16 + (32 * math.floor(position.x / 32)), y = 16 + (32 * math.floor(position.y / 32))}

  surface.request_to_generate_chunks(position, 5)
  --surface.force_generate_chunk_requests()

  local source_position = source.position

  local create_entity = surface.create_entity

  local target = create_entity
  {
    name = mirv_target,
    position = position,
    force = "neutral"
  }

  local offset = ((position.x - source_position.x) / 2)
  offset = math.min(offset, 2000)
  offset = math.max(offset, -2000)

  local projectile = create_entity
  {
    name = mirv_projectile,
    position = {position.x - offset, target.position.y - 2500},
    force = source.force,
    target = target,
    speed = math.random(500, 650) / 100
  }

  for k, player in pairs (game.connected_players) do
    if player.surface == surface then
      player.add_custom_alert(target, custom_alert, alert_message, true)
    end
  end

  surface.play_sound(alert_sound)

  surface.create_trivial_smoke{name = mirv_smoke, position = position}
  surface.create_trivial_smoke{name = mirv_smoke_2, position = position}

end

local mirv_script_trigger = function(event)

  local source = event.source_entity
  if not (source and source.valid) then
    return
  end

  local position = event.target_position
  if not position then return end

  local surface = source.surface

  local flares = surface.find_entities_filtered{name = "mirv-flare", position = position}
  for k, flare in pairs (flares) do
    flare.destroy()
    --game.print("Killed flare "..k)
  end

  call_nuke(surface, position, source)

  local item_count = source.get_item_count("mirv-ammo")
  if item_count == 1 then

    source.destructible = false
    source.destroy()

  end

end

local mirv_pollute_trigger = function(event)
  local position = event.target_position
  if not position then return end
  local surface = game.get_surface(event.surface_index)
  if not surface then return end

  surface.pollute(position, 666)
  game.pollution_statistics.on_flow(launcher, 666)
end

local on_script_trigger_effect = function(event)
  if event.effect_id == mirv_effect_id then
    mirv_script_trigger(event)
    return
  end

  if event.effect_id == mirv_pollution_trigger then
    mirv_pollute_trigger(event)
    return
  end

end

remote.add_interface("mirv",
{
  call_nuke = call_nuke
})

local lib = {}

lib.events =
{
  [defines.events.on_rocket_launched] = on_rocket_launched,
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,

}

lib.on_init = function()
  add_to_tracked_items()
end

lib.on_configuration_changed = function()
  add_to_tracked_items()
end

local handler = require("event_handler")

handler.add_lib(lib)
