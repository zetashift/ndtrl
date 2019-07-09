import tables, libtcod

const colors* = { "dark_wall": colorRGB(0,0 ,100),
                  "dark_ground": colorRGB(50,50,150),
                  "light_wall": colorRGB(130,110,50),
                  "light_ground": colorRGB(200,180,50)}.toTable