import libtcod, world, entity, util, tables

proc drawEntity(con: Console, e: Entity, m: Map) =
  if mapIsInFov(m, e.x.cint, e.y.cint):
    consoleSetDefaultForeground(con, e.color)
    consolePutChar(con, e.x.cint, e.y.cint, e.chr, BKGND_NONE)

proc clearEntity(con: Console, e: Entity) =
  consolePutChar(con, e.x.cint, e.y.cint, ' ', BKGND_NONE)

proc renderAll*(con: Console, w: World, fovMap: Map, fovRecompute: bool, screenW, screenH: int) =
  if fovRecompute:
    for y in 0 ..< w.map.height:
      for x in 0 ..< w.map.width:
        let 
          visible = mapIsInFov(fovMap, x.cint, y.cint)
          wall = w.map.tiles[x][y].blockSight
        
        if visible:
          if wall:
            consoleSetCharBackground(con, x.cint, y.cint, colors["light_wall"], BKGND_SET)
          else:
            consoleSetCharBackground(con, x.cint, y.cint, colors["light_ground"], BKGND_SET)
          w.map.tiles[x][y].explored = true
        elif w.map.tiles[x][y].explored:
          if wall:
            consoleSetCharBackground(con, x.cint, y.cint, colors["dark_wall"], BKGND_SET)
          else:
            consoleSetCharBackground(con, x.cint, y.cint, colors["dark_ground"], BKGND_SET)
  drawEntity(con, w.player, fovMap)
  for ent in w.entities:
    drawEntity(con, ent, fovMap)
  consoleBlit(con, 0, 0, screenW.cint, screenH.cint, nil, 0, 0)

proc clearAll*(con: Console, w: World) =
  clearEntity(con, w.player)
  for ent in w.entities:
    clearEntity(con, ent)
