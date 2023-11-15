type Vec2*[T] = tuple
    x, y: T

type Point* = Vec2

proc newVec2*[T](x, y: T): Vec2[T] =
    result.x = x
    result.y = y

proc newPoint*[T](x, y: T): Point[T] =
    return newVec2(x, y)

proc `+`*[T](a: Vec2[T], b: Vec2[T]): Vec2[T] =
    return (a.x + b.x, a.y + b.y)

proc `+=`*[T](a: var Vec2[T], b: Vec2[T]) =
    a = a + b

proc `-`*[T](a: Vec2[T], b: Vec2[T]): Vec2[T] =
    return (a.x - b.x, a.y - b.y)

proc `-=`*[T](a: var Vec2[T], b: Vec2[T]) =
    a = a - b

proc `*`*[T](a: Vec2[T], v: T): Vec2[T] =
    return (a.x * v, a.y * v)

proc `*=`*[T](a: var Vec2[T], v: T) =
    a = a * v

proc manhattan_dist*[T](a: Vec2[T], b: Vec2[T]): T =
    return abs(a.x - b.x) + abs(a.y - b.y)

iterator neighbors*[T](p: Vec2[T]): Vec2[T] =
    yield (p.x - 1, p.y)
    yield (p.x + 1, p.y)
    yield (p.x, p.y - 1)
    yield (p.x, p.y + 1)

