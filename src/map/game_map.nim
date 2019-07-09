import libtcod, tile, rect, ../entity, random, sequtils, sugar

type
  Map* = ref object
    width*, height*: int
    tiles*: seq[seq[Tile]]

method createRoom*(map: Map, room: Rect) {.base.} =
  for x in room.x1+1 ..< room.x2:
    for y in room.y1+1 ..< room.y2:
      map.tiles[x][y].blocked = false
      map.tiles[x][y].blockSight = false

method createHorizTunnel(map: Map, x1, x2, y: int) {.base.} =
  for x in min(x1, x2) ..< max(x1,x2):
    map.tiles[x][y].blocked = false
    map.tiles[x][y].blockSight = false

method createVertTunnel(map:Map, y1, y2, x: int) {.base.} =
  for y in min(y1, y2) .. max(y1, y2):
    map.tiles[x][y].blocked = false
    map.tiles[x][y].blockSight = false

func newMap*(w, h: int): Map =
  new result
  result.width = w
  result.height = h
  result.tiles = newSeq[seq[Tile]](w)
  for x in 0 ..< w:
    result.tiles[x] = newSeq[Tile](h)
    for y in 0 ..< h:
      result.tiles[x][y] = initTile(true, true)

proc placeEntities*(m: Map, entities: var seq[Entity], room: Rect, 
                      maxMonstersPerRoom: int) =
  let numOfMonsters = rand(0 .. maxMonstersPerRoom)
  
  for i in 0 .. numOfMonsters:
    var
      x = rand(room.x1+1 ..< room.x2)
      y = rand(room.y1+1 ..< room.y2)
      found = entities.filter(ent => ent.x == x and ent.y == y)
    var monster: Entity
    if m.tiles[x][y].blocked: continue
    if found.len == 0:
      if rand(100) < 80: monster = newEntity(x, y, 'k', DESATURATED_GREEN, "Kobold", true)
      else: monster = newEntity(x, y, 'O', DARKER_GREEN, "Troll", true)
      entities.add(monster)

method generateMap*(map: Map, maxRooms, roomMinSize, roomMaxSize, maxMonstersPerRoom: int, 
                    player: Entity, entities: var seq[Entity]) {.base.} =
  randomize()
  var
    rooms = newSeq[Rect]()
    numRooms = 0
  
  for r in 0 .. maxRooms:
    let
      w = rand(roomMinSize .. roomMaxSize)
      h = rand(roomMinSize .. roomMaxSize)
      x = rand(map.width - w - 1)
      y = rand(map.height - h - 1)
      newRoom = initRect(x, y, w, h)
      (newX, newY) = newRoom.center()
    if numRooms == 0:
            player.x = newX
            player.y = newY
    
    block checkRooms:
      for otherRoom in rooms:
        if not rooms.len <= 1 and newRoom.intersect(otherRoom): break checkRooms
        map.createRoom(newRoom)
        let (prevX, prevY) = rooms[numRooms-1].center()
        if rand(0..1) == 1:
          map.createHorizTunnel(prevX, newX, prevY)
          map.createVertTunnel(prevY, newY, newX)
        else:
          map.createVertTunnel(prevY, newY, prevX)
          map.createHorizTunnel(prevX, newX, newY)
      map.placeEntities(entities, newRoom, maxMonstersPerRoom)
      rooms.add(newRoom)
      numRooms += 1  
  
func isBlocked*(map: Map, x, y: int): bool =
  result = false
  if map.tiles[x][y].blocked:
    result = true

  