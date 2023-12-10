type Point* = tuple
    x, y: int

proc newPoint*(x, y: int): Point =
    result.x = x
    result.y = y

proc `+`*(a: Point, b: Point): Point =
    return (a.x + b.x, a.y + b.y)

proc `+=`*(a: var Point, b: Point) =
    a = a + b

proc `-`*(a: Point, b: Point): Point =
    return (a.x - b.x, a.y - b.y)

proc `-=`*(a: var Point, b: Point) =
    a = a - b

proc `*`*(a: Point, v: int): Point =
    return (a.x * v, a.y * v)

proc `*=`*(a: var Point, v: int) =
    a = a * v

proc manhattan_dist*(a: Point, b: Point): int =
    return abs(a.x - b.x) + abs(a.y - b.y)

iterator neighbors*(p: Point): Point =
    yield (p.x - 1, p.y)
    yield (p.x + 1, p.y)
    yield (p.x, p.y - 1)
    yield (p.x, p.y + 1)

