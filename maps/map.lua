return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 10,
  height = 8,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "Moutain",
      firstgid = 1,
      filename = "Mountain.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "Mountain.png",
      imagewidth = 272,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 136,
      tiles = {}
    }
  },
  layers = {
    {
      type = "imagelayer",
      name = "BG",
      visible = true,
      opacity = 1,
      offsetx = -39,
      offsety = 0,
      image = "clouds.png",
      properties = {}
    },
    {
      type = "tilelayer",
      name = "a",
      x = 0,
      y = 0,
      width = 10,
      height = 8,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 45, 46,
        0, 0, 0, 0, 0, 0, 0, 0, 62, 29,
        0, 0, 0, 0, 0, 0, 0, 0, 62, 29,
        0, 0, 0, 0, 15, 0, 0, 100, 62, 29,
        9, 9, 9, 9, 9, 94, 94, 94, 9, 9
      }
    },
    {
      type = "tilelayer",
      name = "b",
      x = 0,
      y = 0,
      width = 10,
      height = 8,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 76,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 93,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 93,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 110,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
