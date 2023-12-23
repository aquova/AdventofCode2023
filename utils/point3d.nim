type Point3D* = tuple
    x, y, z: int

proc newPoint3D*(x, y, z: int): Point3D =
    return (x, y, z)

proc `x=`*(self: var Point3D, x: int) =
    self.x = x

proc `y=`*(self: var Point3D, y: int) =
    self.y = y

proc `z=`*(self: var Point3D, z: int) =
    self.z = z

proc `+`*(a, b: Point3D): Point3D =
    return (a.x + b.x, a.y + b.y, a.z + b.z)

proc `+=`*(a: var Point3D, b: Point3D) =
    a = a + b

proc `-`*(a, b: Point3D): Point3D =
    return (a.x - b.x, a.y - b.y, a.z - b.z)

proc `-=`*(a: var Point3D, b: Point3D) =
    a = a - b

proc `[]`*[T](space: seq[seq[seq[T]]], p: Point3D): T =
    return space[p.z][p.y][p.x]

proc `[]=`*[T](space: var seq[seq[seq[T]]], p: Point3D, v: T) =
    space[p.z][p.y][p.x] = v
