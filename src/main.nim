import libtcod, input, entity, world, render, map/game_map, map/fov
import options, constants, game_states

var
  key: Key
  mouse: Mouse
  player        = newEntity(int(ScreenWidth / 2), int(ScreenHeight / 2), '@', AMBER, "Player", true)
  entities      = newSeq[Entity]()
  w             = newWorld(player, entities)
  con           = consoleNew(ScreenWidth, ScreenHeight)
  fovRecompute  = true
  gameState     = PlayerTurn
  
# Basic init stuff
consoleSetCustomFont(font, FONT_LAYOUT_ASCII_INROW) 
consoleInitRoot(ScreenWidth, ScreenHeight, title, false, RENDERER_SDL) 
sysSetRenderer(RENDERER_SDL2) 
sysSetFps(60)
var fovMap = initFOV(w.map)

# Game loop starts here
when isMainModule:
  while not consoleIsWindowClosed():
    discard sysCheckForEvent((EVENT_KEY_PRESS.ord or EVENT_MOUSE.ord), addr(key), addr(mouse))
    
    if fovRecompute:
      recomputeFOV(fovMap, player.x, player.y, FovRadius, FovLightWalls, constants.FovAlgorithm)
    renderAll(con, w, fovMap, fovRecompute, ScreenWidth, ScreenHeight)
    fovRecompute = false
    consoleFlush()
    clearAll(con, w)
    
    var action = handleKeys(key)
    
    if action.kind == CommandKind.ckMove and gameState == PlayerTurn:
      let
        (dx, dy) = action.delta
        destX    = player.x + dx
        destY    = player.y + dy
      if not isBlocked(w.map, destX, destY):
        let target = getBlockingEntitiesAtLocation(w.entities, destX, destY)
        if target.isSome():
          echo("You kick the " & target.get.name & " in the nuts.")
        else:
          w.player.move(dx, dy)
          fovRecompute = true 
      gameState = EnemyTurn

    elif action.kind == CommandKind.ckExit: break
    elif action.kind == CommandKind.ckFullScreen: 
      let toggle = not consoleIsFullscreen()
      consoleSetFullscreen(toggle)
    
    #Enemy moves
    if gameState == EnemyTurn:
      for ent in w.entities:
        echo("The " & ent.name & " ponders the meaning of it's existance")
      gameState = PlayerTurn

  libtcod.quit()
