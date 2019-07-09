import libtcod

# Generic type which all our entities in the world derive from
type
  Entity* = ref object
    x*, y*: int
    chr*: char
    color*: Color
    name*: string
    blocks*: bool

func newEntity*(x, y: int, chr: char, color: Color, name: string, blocks=false): Entity =
  new result
  result = Entity(x: x, y: y, chr: chr, color: color, name: name, blocks: blocks)
 
method move*(ent: Entity, dx, dy: int) {.base.} =
  ent.x += dx
  ent.y += dy
  
  
