import libtcod, world, entity, util, tables

proc drawEntity(con: Console, e: Entity) =
  consoleSetDefaultForeground(con, e.color)
  consolePutChar(con, e.x.cint, e.y.cint, e.chr, BKGND_NONE)

proc clearEntity(con: Console, e: Entity) =
  consolePutChar(con, e.x.cint, e.y.cint, ' ', BKGND_NONE)

proc renderAll*(con: Console, w: World, screenW, screenH: int) =
  # Draw the map first
  for y in 0 ..< w.map.height:
    for x in 0 ..< w.map.width:
      let wall = w.map.tiles[x][y].blockSight
      if wall:
        consoleSetCharBackground(con, x.cint, y.cint, colors["dark_wall"], BKGND_SET)
      else:
        consoleSetCharBackground(con, x.cint, y.cint, colors["dark_ground"], BKGND_SET)

  for ent in w.entities:
    drawEntity(con, ent)
  consoleBlit(con, 0, 0, screenW.cint, screenH.cint, nil, 0, 0)

proc clearAll*(con: Console, w: World) =
  for ent in w.entities:
    clearEntity(con, ent)
