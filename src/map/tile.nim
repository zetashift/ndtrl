
type
  Tile* = object
    blocked*: bool
    blockSight*: bool

func initTile*(blocked: bool, blockSight: bool): Tile =
  result = Tile(blocked: blocked, blockSight: blockSight)
