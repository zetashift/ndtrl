import libtcod, game_map

proc initFOV*(map: game_map.Map): libtcod.Map =
  var fovMap = mapNew(map.width.cint, map.height.cint)
  for y in 0 ..< map.height:
    for x in 0 ..< map.width:
      mapSetProperties(fovMap, x.cint, y.cint, not map.tiles[x][y].blockSight, 
                       not map.tiles[x][y].blocked)
  result = fovMap

proc recomputeFOV*(map: libtcod.Map, x, y, radius: int, 
                   lightWalls = true, algorithm = FOV_BASIC) =
  mapComputeFov(map, x.cint, y.cint, radius.cint, lightWalls, algorithm)