
type
  Rect* = object
    x1*, y1*, x2*, y2*: int

func initRect*(x, y, w, h: int): Rect =
  result = Rect(x1: x, y1: y, x2: x+w, y2: y+h)

func center*(r: Rect): (int, int) =
  let centerX = int((r.x1 + r.x2) / 2)
  let centerY = int((r.y1 + r.y2) / 2)
  result = (centerX, centerY)

func intersect*(this, that: Rect): bool =
  result = this.x1 <= that.x2 and this.x2 >= that.x1 and 
           this.y1 <= that.y2 and this.y2 >= that.y1