local util = require("tf_util/tf_util")

data:extend({
  {
    type = "item",
    name = "mirv-rocket",
    icon = "__MIRV__/mirv_rocket.png",
    icon_size = 32,
    flags = {},
    subgroup = "defensive-structure",
    order = "z[MIRV]",
    stack_size = 1,
  },
  {
    type = "recipe",
    name = "mirv-rocket",
    energy_required = 10,
    enabled = false,
    category = "crafting",
    ingredients =
    {
      {"atomic-bomb", 20},
      {"rocket-fuel", 50},
      {"rocket-control-unit", 10}
    },
    result= "mirv-rocket",
    order = "z[MIRV]"
  },
  {
    type = "arrow",
    name = "mirv-entity",
    render_layer = "object",
    icon = "__MIRV__/mirv_item.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    selectable_in_game = false,
    order = "z[MIRV]",
    max_health = 1,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    drawing_box = {{-32, -32},{32,32}},
    circle_picture =
    {
      filename = "__MIRV__/mirv_template.png",
      priority = "extra-high",
      width = 768,
      height = 548,
      scale = 3,
      shift = util.by_pixel(0,-32)
    },
    arrow_picture =
    {
      filename = "__core__/graphics/empty.png",
      priority = "extra-high",
      width = 1,
      height = 1,
    }
  },
  {
    type = "trivial-smoke",
    name = "mirv-smoke",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    duration = 440,
    fade_in_duration = 0,
    fade_away_duration = 0,
    spread_duration = 380,
    start_scale = 3,
    end_scale = 1,
    cyclic = true,
    affected_by_wind = false,
    movement_slow_down_factor = 0,
    color = {r = 1, g = 1, b = 1},
    render_layer = "lower-object",
    animation =
    {
      width = 624,
      height = 440,
      line_length = 3,
      frame_count = 12,
      axially_symmetrical = false,
      direction_count = 1,
      priority = "high",
      animation_speed = 0.25,
      filename = "__MIRV__/mirv_anim.png"
    }
  },
  {
    type = "trivial-smoke",
    name = "mirv-smoke-2",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    duration = 440,
    fade_in_duration = 0,
    fade_away_duration = 0,
    spread_duration = 380,
    start_scale = 3,
    end_scale = 1,
    cyclic = true,
    affected_by_wind = false,
    movement_slow_down_factor = 0,
    color = {r = 1, g = 1, b = 1},
    render_layer = "lower-object",
    animation =
    {
      width = 800,
      height = 565,
      line_length = 1,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      priority = "high",
      animation_speed = 0.25,
      filename = "__MIRV__/mirv_static.png"
    }
  },
  {
    type = "simple-entity-with-owner",
    name = "mirv-target",
    render_layer = "object",
    icon = "__MIRV__/mirv-target.png",
    icon_size = 32,
    flags = {},
    order = "z[MIRV]",
    max_health = 1,
    selectable_in_game = false,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{0, 0}, {0, 0}},
    picture =
    {
      filename = "__core__/graphics/empty.png",
      priority = "extra-high",
      width = 1,
      height = 1
    },
    build_sound =
    {
      filename = "__MIRV__/launch-sound.ogg",
      volume = 1
    }
  },
  {
    type = "technology",
    name = "mirv-technology",
    icon = "__MIRV__/mirv-technology.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "mirv-rocket"
      },
      {
        type = "unlock-recipe",
        recipe = "mirv-targeting-remote"
      },
    },
    prerequisites = {"rocket-silo", "atomic-bomb"},
    unit =
    {
      count = 10000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 45
    },
    order = "e-a-c"
  }
})

local turret =
{
  type = "artillery-turret",
  name = "mirv-launcher",
  localised_name = {"item-name.mirv-rocket"},
  icon = "__MIRV__/mirv_rocket.png",
  icon_size = 32,
  flags = {"placeable-neutral", "placeable-player", "player-creation"},

  --collision_box = {{-1.45, -1.45}, {1.45, 1.45}},
  --selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
  collision_mask = {},

  inventory_size = 1,
  ammo_stack_limit = 5,
  automated_ammo_count = 1,
  gun = "mirv-launcher-gun",
  turret_rotation_speed = 1,
  manual_range_modifier = 1000000,
  disable_automatic_firing = false,

  base_picture = util.empty_sprite(),
  cannon_barrel_pictures = util.empty_sprite(),
  cannon_base_pictures = util.empty_sprite(),
  order = "lol",
  alert_when_attacking = false

}

local gun =
{
  type = "gun",
  name = "mirv-launcher-gun",
  localised_name = {"item-name.mirv-rocket"},
  icon = "__base__/graphics/icons/tank-cannon.png",
  icon_size = 64, icon_mipmaps = 4,
  flags = {"hidden"},
  subgroup = "gun",
  order = "z[artillery]-a[cannon]",
  attack_parameters =
  {
    type = "projectile",
    ammo_category = util.ammo_category("mirv-launcher"),
    cooldown = 15 * 60,
    movement_slow_down_factor = 0,
    range = 1000
  },
  stack_size = 1
}

local ammo =
{
  type = "ammo",
  name = "mirv-ammo",
  icon = "__base__/graphics/icons/atomic-bomb.png",
  icon_size = 1, icon_mipmaps = 1,
  ammo_type =
  {
    target_type = "position",
    category = util.ammo_category("mirv-launcher"),
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {

          {
            type = "script",
            effect_id = "mirv-launch"
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              radius = 120,
              target_entities = false,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = {amount = 0 , type = "physical"}
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  subgroup = "ammo",
  order = "d[rocket-launcher]-c[atomic-bomb]",
  stack_size = 10
}

local nuke_target_effects =
{
  {
    type = "nested-result",
    action =
    {
      type = "area",
      target_entities = false,
      trigger_from_target = true,
      repeat_count = 50,
      radius = 10,
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            entity_name = "nuke-explosion"
          }
        }
      }
    }
  },
  {
    type = "script",
    effect_id = "mirv-pollute"
  }
}

local do_whacka_do = function()
  local watra = 1 + ((math.random() - 0.5))
  return
  {
    filename = "__base__/graphics/entity/bigass-explosion/hr-bigass-explosion-36f.png",
    flags = { "compressed" },
    animation_speed = 0.5 * watra,
    width = 324,
    height = 416,
    frame_count = 36,
    shift = util.by_pixel(0, -48),
    scale = 1 / watra,
    stripes =
    {
      {
        filename = "__base__/graphics/entity/bigass-explosion/hr-bigass-explosion-36f-1.png",
        width_in_frames = 6,
        height_in_frames = 3
      },
      {
        filename = "__base__/graphics/entity/bigass-explosion/hr-bigass-explosion-36f-2.png",
        width_in_frames = 6,
        height_in_frames = 3
      }
    }
  }
end

local nuke_explosion =
{
  type = "explosion",
  name = "nuke-explosion",
  flags = {"not-on-map"},
  animations =
  {
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
    do_whacka_do(), do_whacka_do(), do_whacka_do(),
  },
  light = {intensity = 1, size = 50, color = {r=1.0, g=1.0, b=1.0}},
  sound =
  {
    aggregation =
    {
      max_count = 2,
      remove = true
    },
    variations =
    {
      {
        filename = "__base__/sound/fight/large-explosion-1.ogg",
        volume = 1.0
      },
      {
        filename = "__base__/sound/fight/large-explosion-2.ogg",
        volume = 1.0
      }
    }
  }
}

local fire_util = require("tf_util/tf_fire_util")
local fiery_particle =
{
  type = "optimized-particle",
  name = "fiery-particle",
  life_time = 100,
  movement_modifier = 0,
  pictures = fire_util.create_fire_pictures{scale = 2}
}


data:extend{fiery_particle}

local pictures = fire_util.create_fire_pictures({scale = 3, shift = {0, 3}})



local total = #pictures
local proj_count = math.ceil(2000 / total)
for k, picture in pairs (pictures) do

  local effect =
  {
    type = "nested-result",
    action =
    {
      {

        type = "area",
        target_entities = false,
        trigger_from_target = true,
        repeat_count = proj_count,
        radius = 100,
        action_delivery =
        {
          type = "artillery",
          projectile = "mirv-nuke-projectile"..k,
          starting_speed = 0.75,
          starting_speed_deviation = 0.2,
          direction_deviation = 0,
          range_deviation = 0.5
        }
      }
    }
  }

  table.insert(nuke_target_effects, effect)

  local nested_projectile =
  {
    type = "artillery-projectile",
    name = "mirv-nuke-projectile"..k,
    flags = {"not-on-map"},
    map_color = {1, 1, 1},
    reveal_map = true,
    picture = picture,
    chart_picture =
    {
      filename = "__base__/graphics/entity/artillery-projectile/artillery-shoot-map-visualization.png",
      flags = { "icon" },
      frame_count = 1,
      width = 64,
      height = 64,
      priority = "high",
      scale = math.random(20, 30) / 100
    },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "nested-result",
            action =
            {
              type = "area",
              radius = 5.0,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = {amount = 2000 , type = "physical"}
                  }
                }
              }
            }
          },
          {

            type = "create-particle",
            repeat_count = 3,
            particle_name = "fiery-particle",
            initial_height = 0.1,
            --speed_from_center = 0.08,
            --speed_from_center_deviation = 0.1,
            offset_deviation = {{-3, -3}, {3,3}}
            --initial_vertical_speed = 0.18,
            --initial_vertical_speed_deviation = 0.15,

          },
          {
            type = "show-explosion-on-chart",
            scale = math.random(6, 12)/32
          },
          {
            type = "create-entity",
            entity_name = "nuke-explosion"
          },
          --{
          --  type = "create-entity",
          --  entity_name = "nuke-scorchmark",
          --  offset_deviation = {{-4, -4},{4, 4}}
          --},
        }
      }
    }
  }
  data:extend{nested_projectile}
end

local projectile =
{
  type = "artillery-projectile",
  name = "mirv-projectile",
  flags = {"not-on-map"},
  acceleration = 0.01,
  reveal_map = false,
  map_color = {r = 0, g = 1, b = 0},
  action =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      target_effects = nuke_target_effects
    }
  },
  chart_picture =
  {
    layers =
    {

      {
        filename = "__base__/graphics/entity/artillery-projectile/artillery-shoot-map-visualization.png",
        flags = { "icon" },
        frame_count = 1,
        width = 64,
        height = 64,
        priority = "high",
        scale = 1
      },
      {
        filename = "__MIRV__/mirv_rocket.png",
        width = 32,
        height = 32,
        scale = 0.5,
        frame_count = 1
      }
    }
  },
  light = {intensity = 0.8, size = 15},
  picture =
  {
    filename = "__base__/graphics/entity/rocket-silo/02-rocket.png",
    width = 154,
    height = 300,
    scale = 0.5,
    shift = util.by_pixel(-4, -28),
    hr_version = {
      filename = "__base__/graphics/entity/rocket-silo/hr-02-rocket.png",
      width = 310,
      height = 596,
      shift = util.by_pixel(-5, -27),
      scale = 0.25
    }
  },
  shadow =
  {
    filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
    frame_count = 1,
    width = 7,
    height = 24,
    priority = "high",
    shift = {0, 0}
  }
}

local remote =
{
  type = "capsule",
  name = "mirv-targeting-remote",
  icon = "__MIRV__/mirv-targeting-remote.png",
  icon_size = 64,
  capsule_action =
  {
    type = "artillery-remote",
    flare = "mirv-flare"
  },
  subgroup = "capsule",
  order = "zz",
  stack_size = 1
}

local flare =
{
  type = "artillery-flare",
  name = "mirv-flare",
  icon = "__base__/graphics/icons/artillery-targeting-remote.png",
  icon_size = 64, icon_mipmaps = 4,
  flags = {"placeable-off-grid", "not-on-map"},
  map_color = {r=1, g=0.5, b=0},
  life_time = 60 * 60,
  initial_height = 0,
  initial_vertical_speed = 0,
  initial_frame_speed = 1,
  shots_per_flare = 1,
  early_death_ticks = 3 * 60,
  shot_category = util.ammo_category("mirv-launcher"),
  pictures =
  {
    {
      filename = "__core__/graphics/shoot-cursor-red.png",
      priority = "low",
      width = 258,
      height = 183,
      frame_count = 1,
      scale = 1,
      flags = {"icon"}
    },
    --{
    --  filename = "__base__/graphics/entity/sparks/sparks-02.png",
    --  width = 36,
    --  height = 32,
    --  frame_count = 19,
    --  line_length = 19,
    --  shift = {0.03125, 0.125},
    --  tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
    --  animation_speed = 0.3,
    --}
  }
}

local remote_recipe =
{
  type = "recipe",
  name = "mirv-targeting-remote",
  enabled = false,
  ingredients =
  {
    {"processing-unit", 1},
    {"radar", 1}
  },
  result = "mirv-targeting-remote"
}

data:extend
{
  turret,
  gun,
  ammo,
  projectile,
  remote,
  flare,
  remote_recipe,
  nuke_explosion

}