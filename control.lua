local custom_alert = {type = "item", name = "mirv-item"}
local alert_message = {"launch-detected"}
local alert_sound = {path = "entity-build/mirv-target"}
local mirv_item = "mirv-item"
local mirv_smoke = "mirv-smoke"
local mirv_smoke_2 = "mirv-smoke-2"
local mirv_target = "mirv-target"
local nuke = "atomic-rocket"
local mirv_entity = "mirv-entity"

script.on_event(defines.events.on_put_item, function(event)

  local player = game.players[event.player_index]
  local stack = player.cursor_stack
  if not (stack.valid and stack.valid_for_read) then return end
  if stack.name ~= mirv_item then return end
  local rand = math.random
  local position = event.position
  local surface = player.surface
  local force = player.force
  player.remove_item({name = mirv_item, count = 1})
  player.clean_cursor()
  surface.create_trivial_smoke{name = mirv_smoke, position = position}
  surface.create_trivial_smoke{name = mirv_smoke_2, position = position}
  force.chart(surface, {{position.x - 80, position.y - 80}, {position.x + 80, position.y + 80}})
  local entry_position = {x = position.x + rand(-150, 150), y = position.y - 550}
  local create_entity = surface.create_entity
  for k = 1, 5 do
  local new_position = {x = position.x + rand( -8 * k, 8 * k), y = position.y + rand( -8 * k, 8 * k)}
  local target = create_entity{name = mirv_target, position = new_position}
  create_entity{name = nuke, position = entry_position, target = target, speed = (rand() / 5), force = force}
  target.destroy()
end
local alert_target = surface.create_entity{name = mirv_target, position = position}
  for k, player in pairs (game.connected_players) do
    player.add_custom_alert(alert_target, custom_alert, alert_message, true)
  end
  game.play_sound(alert_sound)
  alert_target.destroy()
end)

script.on_event(defines.events.on_built_entity, function(event)

  local entity = event.created_entity
  if entity.name == mirv_entity then
    game.players[event.player_index].insert{name = mirv_item}
    entity.destroy()
    return
  end

  if entity.name == "entity-ghost" and entity.ghost_name == mirv_entity then
    entity.destroy()
    return
  end

end)
