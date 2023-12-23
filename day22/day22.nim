import algorithm, sets, strscans, strutils, tables
import ../utils/point3d

type Brick = tuple
    start, final: Point3D

proc isSubset[T](a, b: seq[T]): bool =
    for item in a:
        if item notin b: return false
    return true

proc getPoints(brick: Brick): seq[Point3D] =
    for x in countup(brick.start.x, brick.final.x):
        for y in countup(brick.start.y, brick.final.y):
            for z in countup(brick.start.z, brick.final.z):
                result.add((x, y, z))

proc overlaps(a, b: Brick): bool =
    # There's probably a nice, simple mathematical way to detect if two overlap
    # But I had nothing but trouble with this. They don't have very many points,
    # just get them all and see if their intersection is empty, fuck it
    let apts = a.getPoints().toHashSet()
    let bpts = b.getPoints().toHashSet()
    return apts.intersection(bpts).len() > 0

proc cmpBrick(lhs, rhs: Brick): int =
    if lhs.start.z < rhs.start.z: -1 else: 1

proc belowBrick(brick: Brick): Brick =
    return (brick.start - (0, 0, 1), brick.final - (0, 0, 1))

proc drop(bricks: var seq[Brick]): Table[int, seq[int]] =
    var vital: Table[int, seq[int]]
    for idx, brick in bricks.mpairs():
        vital[idx] = @[]
        var tmp = brick
        while tmp.start.z > 1:
            let below = tmp.belowBrick()
            var overlap = false
            for i, other in bricks.pairs():
                if brick == other: continue
                if below.overlaps(other):
                    vital[idx].add(i)
                    overlap = true
            if overlap: break
            tmp = below
        brick = tmp
    return vital

proc reverse(tbl: Table[int, seq[int]]): Table[int, seq[int]] =
    for key, val in tbl:
        for v in val:
            if result.hasKey(v):
                if key notin result[v]:
                    result[v].add(key)
            else:
                result[v] = @[key]

proc parseInput(input: string): seq[Brick] =
    for line in input.splitLines():
        let (valid, ax, ay, az, bx, by, bz) = line.scanTuple("$i,$i,$i~$i,$i,$i")
        if valid:
            let brick = (newPoint3D(ax, ay, az), newPoint3D(bx, by, bz))
            result.add(brick)

proc day22p1*(input: string): string =
    var bricks = input.parseInput()
    bricks.sort(cmpBrick)
    let vital = bricks.drop()
    var cnt: seq[int]
    for v in vital.values:
        if v.len() == 1 and v[0] notin cnt:
            cnt.add(v)
    return $(bricks.len() - cnt.len())

proc day22p2*(input: string): string =
    var bricks = input.parseInput()
    bricks.sort(cmpBrick)
    let below = bricks.drop()
    let above = below.reverse()
    var cnt = 0
    for i in countup(0, bricks.high()):
        var stack = @[i]
        var falling = @[i]
        while stack.len() > 0:
            let j = stack.pop()
            if not above.hasKey(j): continue
            let top = above[j]
            for t in top:
                let bottom = below[t]
                if bottom.isSubset(falling):
                    stack.add(t)
                    if t notin falling:
                        falling.add(t)
        cnt += falling.len() - 1
    return $cnt

