import libtcod

const
  font*               = "../assets/sm_16.png"
  ScreenWidth*        = 80
  ScreenHeight*       = 50
  MapWidth*           = 80
  MapHeight*          = 45
  FovAlgorithm*       = FOV_DIAMOND
  FovLightWalls*      = true
  FovRadius*          = 7
  roomMaxSize*        = 10
  roomMinSize*        = 6
  maxRooms*           = 30
  maxMonstersPerRoom* = 3
  title*              = "Nim Does the Roguelike Tutorial"