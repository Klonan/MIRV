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
      }
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
  icon = "__base__/graphics/icons/artillery-turret.png",
  icon_size = 64, icon_mipmaps = 4,
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
  icon_size = 64, icon_mipmaps = 4,
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
      target_effects =
      {
        {
          type = "nested-result",
          action =
          {
            type = "area",
            target_entities = false,
            trigger_from_target = true,
            repeat_count = 2000,
            radius = 100,
            action_delivery =
            {
              type = "artillery",
              projectile = "artillery-projectile",
              starting_speed = 0.75,
              starting_speed_deviation = 0.01,
              direction_deviation = 0,
              range_deviation = 0.5
            }
          }
        },
        --{
        --  type = "show-explosion-on-chart",
        --  scale = 35/32
        --}
      }
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
  animation =
  {
    filename = "__base__/graphics/entity/rocket/rocket.png",
    frame_count = 8,
    line_length = 8,
    width = 9,
    height = 35,
    shift = {0, 0},
    priority = "high"
  },
  shadow =
  {
    filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
    frame_count = 1,
    width = 7,
    height = 24,
    priority = "high",
    shift = {0, 0}
  },
  smoke =
  {
    {
      name = "smoke-fast",
      deviation = {0.15, 0.15},
      frequency = 1,
      position = {0, 1},
      slow_down_factor = 1,
      starting_frame = 3,
      starting_frame_deviation = 5,
      starting_frame_speed = 0,
      starting_frame_speed_deviation = 5
    }
  }
}

local remote =
{
  type = "capsule",
  name = "mirv-targeting-remote",
  localise_name = "MIRV targetting remote",
  icon = "__base__/graphics/icons/artillery-targeting-remote.png",
  icon_size = 64, icon_mipmaps = 4,
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

data:extend
{
  turret,
  gun,
  ammo,
  projectile,
  remote,
  flare

}