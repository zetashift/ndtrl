import libtcod

type
  CommandKind* = enum
    ckMove, ckFullScreen, ckExit, ckNothing
  Command* = ref object
    case kind*: CommandKind
    of ckMove: delta*: tuple[x: cint, y: cint]
    of ckFullScreen: discard
    of ckExit: exit*: bool
    of ckNothing: discard

proc handleKeys*(key: Key): Command =
  case key.vk:
    of K_UP: result = Command(kind: ckMove, delta: (0.cint, -1.cint))
    of K_DOWN: result = Command(kind: ckMove, delta: (0.cint, 1.cint))
    of K_LEFT: result = Command(kind: ckMove, delta: (-1.cint, 0.cint))
    of K_RIGHT: result = Command(kind: ckMove, delta: (1.cint, 0.cint))
    of K_F10: result = Command(kind: ckFullScreen)
    of K_ESCAPE: result = Command(kind: ckExit, exit: true)
    else: result = Command(kind: ckNothing)
