import libtcod

# Generic type which all our entities in the world derive from
type
  Entity* = ref object
    x*, y*: int
    chr*: char
    color*: Color

func newEntity*(x, y: int, chr: char, color: Color): Entity =
  new result
  result = Entity(x: x, y: y, chr: chr, color: color)
 
method move*(ent: Entity, dx, dy: int) {.base.} =
  ent.x += dx
  ent.y += dy
  
