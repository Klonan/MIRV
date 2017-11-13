script.on_event(defines.events.on_put_item, function(event)

  local player = game.players[event.player_index]
  local stack = player.cursor_stack
  if not (stack.valid and stack.valid_for_read) then return end
  if stack.name ~= "mirv-item" then return end
  local rand = math.random
  local position = event.position
  local surface = player.surface
  player.remove_item({name = "mirv-item", count = 1})
  player.clean_cursor()
  local target_smoke = surface.create_trivial_smoke{name = "mirv-smoke", position = position}
  surface.create_trivial_smoke{name = "mirv-smoke-2", position = position}
  player.force.chart(surface,{{position.x-80, position.y-80},{position.x+80, position.y+80}})
  local alert_target = player.surface.create_entity{name = "mirv-target", position = position}
  local entry_position = {x = position.x+150, y = position.y-550}
  for k = 1, 5 do
    local new_position = {x = position.x+rand(-8*k, 8*k), y = position.y+rand(-8*k, 8*k)}
    local target = surface.create_entity{name = "mirv-target", position = new_position}
    surface.create_entity{name = "atomic-rocket", position = entry_position, target = target, speed = (rand()/5), force = "player"}
    target.destroy()
  end
  for k, player in pairs (game.connected_players) do
    player.add_custom_alert(alert_target, {type = "item", name = "mirv-item"}, {"launch-detected"}, true)
  end
  game.play_sound({path = "entity-build/mirv-target"})
  alert_target.destroy()
end)

script.on_event(defines.events.on_built_entity, function(event)

  local entity = event.created_entity
  if entity.name == "mirv-entity" then
    game.players[event.player_index].insert{name = "mirv-item"}
    entity.destroy()
    return
  end
  if entity.name == "entity-ghost" and entity.ghost_name == "mirv-entity" then
    entity.destroy()
    return
  end

end)

script.on_configuration_changed(function(data)
  if not data then return end
  if not data.mod_changes then return end
  local mod_data = data.mod_changes["MIRV"]
  if not mod_data then return end
  if not mod_data.old_version then
    setup_remote_call()
  end
end)

script.on_init(setup_remote_call)

function setup_remote_call()
  local interface_name = "silo_script"
  if not remote.interfaces[interface_name] then return end
  remote.call(interface_name, "add_tracked_item", "mirv-rocket")
  remote.call(interface_name, "set_show_launched_without_satellite", false)
  log("MIRV - Called silo script interface")
end