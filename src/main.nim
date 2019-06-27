import libtcod, input, entity, world, render, map/game_map

const
  font = "../assets/sm_16.png"
  ScreenWidth = 80
  ScreenHeight = 50
  MapWidth = 80
  MapHeight = 45
  roomMaxSize = 10
  roomMinSize = 6
  maxRooms = 30
  title = "Nim Does the Roguelike Tutorial"

var
  key: Key
  mouse: Mouse
  player = newEntity(int(ScreenWidth / 2), int(ScreenHeight / 2), '@', AMBER)
  enemy = newEntity(int(ScreenWidth / 2 - 5), int(ScreenHeight / 2), 'k', GREEN)
  entities = @[player, enemy]
  map = newMap(MapWidth, MapHeight)
  w = newWorld(entities, map)
  con = consoleNew(ScreenWidth, ScreenHeight)

# Basic init stuff

consoleSetCustomFont(font, FONT_LAYOUT_ASCII_INROW)
consoleInitRoot(ScreenWidth, ScreenHeight, title, false, RENDERER_SDL)
sysSetRenderer(RENDERER_SDL2)
sysSetFps(60)
map.generateMap(maxRooms, roomMinSize, roomMaxSize, player)

# Game loop starts here

when isMainModule:
  while not consoleIsWindowClosed():
    discard sysCheckForEvent((EVENT_KEY_PRESS.ord or EVENT_MOUSE.ord), addr(key), addr(mouse))
    renderAll(con, w, ScreenWidth, ScreenHeight)
    consoleFlush()
    clearAll(con, w)
    var action = handleKeys(key)
  
    if action.kind == CommandKind.ckMove:
      let (dx, dy) = action.delta
      if not isBlocked(map, player.x + dx, player.y+dy):
        player.move(dx, dy)

    elif action.kind == CommandKind.ckExit: break
    elif action.kind == CommandKind.ckFullScreen: 
      let toggle = not consoleIsFullscreen()
      consoleSetFullscreen(toggle)

  libtcod.quit()
