import heapqueue, strutils, tables
import ../utils/[direction, point]

const STRAIGHT_LIMIT = 3
const ULTRA_STRAIGHT_MIN = 4
const ULTRA_STRAIGHT_MAX = 10

type Grid = seq[seq[int]]

type Node = object
    pos: Point
    dir: Direction
    straight, loss: int

proc `<`(lhs, rhs: Node): bool = lhs.loss < rhs.loss

proc newNode(p: Point, d: Direction, straight, loss: int): Node =
    result.pos = p
    result.dir = d
    result.straight = straight
    result.loss = loss

proc offGrid(grid: Grid, p: Point): bool =
    return p.x < 0 or p.x > grid[0].high() or p.y < 0 or p.y > grid.high()

proc parseInput(input: string): Grid =
    for line in input.splitLines():
        var row: seq[int]
        for c in line:
            row.add(parseInt($c))
        result.add(row)

proc contains(visited: seq[Node], node: Node): bool =
    for n in visited:
        if n.pos == node.pos and n.dir == node.dir and n.straight == node.straight:
            return true
    return false

proc findBest(grid: Grid, p2: bool): int =
    let straight_min = if p2: ULTRA_STRAIGHT_MIN else: 0
    let straight_max = if p2: ULTRA_STRAIGHT_MAX else: STRAIGHT_LIMIT
    let goal = (grid[0].high(), grid.high())
    var visited: seq[Node]
    var q: HeapQueue[Node]
    q.push(newNode((0, 0), EAST, 0, 0))
    q.push(newNode((0, 0), SOUTH, 0, 0))
    while q.len() > 0:
        let current = q.pop()
        if current.pos == goal and straight_min <= current.straight:
            return current.loss
        if visited.contains(current): continue
        visited.add(current)
        # Add straight ahead
        if current.straight < straight_max:
            let next_p = current.pos + DELTA[current.dir]
            if not offGrid(grid, next_p):
                let next_straight = newNode(next_p, current.dir, current.straight + 1, current.loss + grid[next_p])
                q.push(next_straight)
        # Add left, right
        if straight_min <= current.straight:
            for d in [LEFT[current.dir], RIGHT[current.dir]]:
                let next_p = current.pos + DELTA[d]
                if offGrid(grid, next_p): continue
                let next = newNode(next_p, d, 1, current.loss + grid[next_p])
                q.push(next)

proc day17p1*(input: string): string =
    let grid = parseInput(input)
    let best = grid.findBest(false)
    return $best

proc day17p2*(input: string): string =
    let grid = parseInput(input)
    let best = grid.findBest(true)
    return $best
