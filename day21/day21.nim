import math, sequtils, strutils, sugar, tables
import ../utils/point

const P1_STEPS = 64
const P2_STEPS = 26501365

type Grid = seq[seq[char]]

proc parseInput(input: string): Grid =
    for line in input.splitLines():
        let row = line.items().toSeq()
        result.add(row)

proc getStart(grid: Grid): Point =
    for y, row in grid.pairs():
        for x, cell in row.pairs():
            if cell == 'S':
                return (x, y)

proc offGrid(pt: Point, grid: Grid): bool =
    return pt.x < 0 or pt.y < 0 or pt.x > grid[0].high() or pt.y > grid.high()

proc takeStep(grid: Grid, cache: var Table[Point, int], step: int, p2: bool) =
    let pts = collect:
        for k, v in cache.pairs():
            if v == step - 1: k
    for pt in pts:
        for n in pt.neighbors():
            if not p2 and n.offGrid(grid): continue
            let adj_n = if p2: (n.x.floorMod(grid[0].len()), n.y.floorMod(grid.len())) else: n
            if grid[adj_n] != '#' and not cache.hasKey(n):
                cache[n] = step

# Use Lagrange formula to generate quadratic from three known points
# https://math.stackexchange.com/questions/2657136/given-3-points-how-can-i-find-a-quadratic-equation-that-intersects-all-of-these
proc quadratic(x: int, pts: seq[Point]): int =
    let (x1, y1) = pts[0]
    let (x2, y2) = pts[1]
    let (x3, y3) = pts[2]
    let term1 = float(y1) * ((x - x2) / (x1 - x2)) * ((x - x3) / (x1 - x3))
    let term2 = float(y2) * ((x - x1) / (x2 - x1)) * ((x - x3) / (x2 - x3))
    let term3 = float(y3) * ((x - x1) / (x3 - x1)) * ((x - x2) / (x3 - x2))
    return int(term1 + term2 + term3)

proc day21p1*(input: string): string =
    let grid = input.parseInput()
    let start = grid.getStart()
    var cache: Table[Point, int]
    cache[start] = 0
    for i in countup(1, P1_STEPS):
        takeStep(grid, cache, i, false)
    let matches = cache.values.toSeq.filter(proc(x: int): bool = x mod 2 == 0) # Checking even because P1_STEPS is even
    return $matches.len()

proc day21p2*(input: string): string =
    let grid = input.parseInput()
    let start = grid.getStart()
    var cache: Table[Point, int]
    cache[start] = 0
    var i = 0
    var xy: seq[Point]
    while true:
        inc(i)
        takeStep(grid, cache, i, true)
        # The input he gives us is special in a few ways. The input is a square of 131x131, and the target is 65 + 131 * X
        # For reasons I'm not quite sure about, the f(x) values turn out to be quadratic
        # Thus, we will get the first three y values, generate the quadratic, then extrapolate out
        if i mod 131 == 65:
            let matches = collect:
                for v in cache.values:
                    if v mod 2 == i mod 2: v
            xy.add((i, matches.len()))
            if xy.len() == 3: break
    return $quadratic(P2_STEPS, xy)
