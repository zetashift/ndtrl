import libtcod, entity, map/game_map, map/rect, random, constants, options

# I wrote this type to make it easier to send it off to the render proc
type
  World* = object
    player*: Entity
    entities*: seq[Entity]
    map*: game_map.Map

proc newWorld*(player: Entity, entities: var seq[Entity]): World =
  var map = newMap(ScreenWidth, ScreenHeight)
  map.generateMap(maxRooms, roomMinSize, roomMaxSize, maxMonstersPerRoom, player, entities)
  result = World(player: player, entities: entities, map: map)
          
func getBlockingEntitiesAtLocation*(entities: seq[Entity], destX, destY: int): Option[Entity]=
  result = none(Entity)
  for ent in entities:
    if ent.blocks and ent.x == destX and ent.y == destY: result = some(ent)
    
  
  