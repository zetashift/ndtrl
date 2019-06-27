import libtcod, entity, map/game_map

# I wrote this type to make it easier to send it off to the render proc
type
  World* = object
    entities*: seq[Entity]
    map*: game_map.Map

func newWorld*(entities: seq[Entity], map: game_map.Map): World =
  result = World(entities: entities, map: map)