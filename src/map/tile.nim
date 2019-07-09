
type
  Tile* = object
    blocked*: bool
    blockSight*: bool
    explored*: bool

func initTile*(blocked: bool, blockSight: bool, explored = false): Tile =
  result = Tile(blocked: blocked, blockSight: blockSight, explored: explored)
