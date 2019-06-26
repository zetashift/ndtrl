import libtcod, input

const
  font = "../assets/sm_16.png"
  ScreenWidth = 80
  ScreenHeight = 50
  title = "Nim Does the Roguelike Tutorial"

var
  key: Key
  mouse: Mouse
  playerX = cint(ScreenWidth / 2)
  playerY = cint(ScreenHeight / 2)
  con = consoleNew(ScreenWidth, ScreenHeight)

# Basic init stuff
consoleSetCustomFont(font, FONT_LAYOUT_ASCII_INROW)
consoleInitRoot(ScreenWidth, ScreenHeight, title, false, RENDERER_SDL)
sysSetRenderer(RENDERER_SDL2)
sysSetFps(60)

# Game loop starts here

when isMainModule:
  while not consoleIsWindowClosed():
    consoleSetDefaultForeground(con, WHITE)
    consoleSetDefaultBackground(con, BLACK)
    consolePutChar(con, playerX, playerY, '@', BKGND_NONE)
    consoleBlit(con, 0, 0, ScreenWidth, ScreenHeight, nil, 0, 0)
    consoleFlush()
    consolePutChar(con, playerX, playerY, ' ', BKGND_NONE)
    discard sysCheckForEvent((EVENT_KEY_PRESS.ord or EVENT_MOUSE.ord), addr(key), addr(mouse))
    var action = handleKeys(key)
  
    if action.kind == CommandKind.ckMove:
      let (dx, dy) = action.delta
      playerX += dx
      playerY += dy
    
    elif action.kind == CommandKind.ckExit: break
    elif action.kind == CommandKind.ckFullScreen: 
      let toggle = not consoleIsFullscreen()
      consoleSetFullscreen(toggle)

  libtcod.quit()
