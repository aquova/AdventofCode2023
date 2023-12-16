import sequtils, strutils, tables
import ../utils/point

type Direction = enum
    NORTH, SOUTH, EAST, WEST

type Beam = object
    pos: Point
    dir: Direction

type Grid = seq[seq[char]]
type EnergizedGrid = seq[seq[seq[Beam]]]

const DIRECTION_NEXT = {
    NORTH: (0, -1), SOUTH: (0, 1), EAST: (1, 0), WEST: (-1, 0)
}.toTable

proc `[]`[T](grid: seq[seq[T]], p: Point): T =
    return grid[p.y][p.x]

# Only for debugging, but I'll leave it
proc `$`(eg: EnergizedGrid): string =
    var strings: seq[string]
    for y, row in eg.pairs():
        var line = ""
        for x, cell in row.pairs():
            line &= (if cell.len() > 0: "#" else: ".")
        strings.add(line)
    return strings.join("\n")

proc newBeam(p: Point, d: Direction): Beam =
    result.pos = p
    result.dir = d

proc newGrid(input: string): Grid =
    return input.splitLines().map(proc(line: string): seq[char] = line.items().toSeq())

proc onGrid(grid: Grid, p: Point): bool =
    return p.x >= 0 and p.x < grid[0].len() and p.y >= 0 and p.y < grid.len()

proc followBeam(grid: Grid, beam: Beam): seq[Beam] =
    let symbol = grid[beam.pos]
    case symbol:
        of '.':
            result.add(newBeam(beam.pos + DIRECTION_NEXT[beam.dir], beam.dir))
        of '-':
            if beam.dir == EAST or beam.dir == WEST:
                result.add(newBeam(beam.pos + DIRECTION_NEXT[beam.dir], beam.dir))
            else:
                for d in [WEST, EAST]:
                    result.add(newBeam(beam.pos + DIRECTION_NEXT[d], d))
        of '|':
            if beam.dir == NORTH or beam.dir == SOUTH:
                result.add(newBeam(beam.pos + DIRECTION_NEXT[beam.dir], beam.dir))
            else:
                for d in [NORTH, SOUTH]:
                    result.add(newBeam(beam.pos + DIRECTION_NEXT[d], d))
        of '\\':
            let next_dir = case beam.dir:
                of NORTH: WEST
                of SOUTH: EAST
                of EAST: SOUTH
                of WEST: NORTH
            result.add(newBeam(beam.pos + DIRECTION_NEXT[next_dir], next_dir))
        of '/':
            let next_dir = case beam.dir:
                of NORTH: EAST
                of SOUTH: WEST
                of EAST: NORTH
                of WEST: SOUTH
            result.add(newBeam(beam.pos + DIRECTION_NEXT[next_dir], next_dir))
        else: discard

proc newEnergizedGrid(width, height: int): EnergizedGrid =
    for y in countup(1, height):
        var row: seq[seq[Beam]]
        for x in countup(1, width):
            var beams: seq[Beam]
            row.add(beams)
        result.add(row)

proc add(eg: var EnergizedGrid, b: Beam) =
    eg[b.pos.y][b.pos.x].add(b)

proc contains(eg: EnergizedGrid, b: Beam): bool =
    let cell = eg[b.pos]
    return cell.contains(b)

proc fire(grid: Grid, start: Beam): int =
    var energized = newEnergizedGrid(grid[0].len(), grid.len())
    var stack = @[start]
    energized.add(start)
    while stack.len() > 0:
        let current = stack.pop()
        if not onGrid(grid, current.pos): continue
        let next = followBeam(grid, current)
        for n in next:
            if onGrid(grid, n.pos) and not energized.contains(n):
                energized.add(n)
                stack.add(n)
    for y, row in energized.pairs():
        for x, cell in row.pairs():
            if cell.len() > 0:
                inc(result)

proc day16p1*(input: string): string =
    let input_grid = newGrid(input)
    let start = newBeam((0, 0), EAST)
    let energized = fire(input_grid, start)
    return $energized

proc day16p2*(input: string): string =
    let input_grid = newGrid(input)
    let max_x = input_grid[0].high()
    let max_y = input_grid.high()
    var best = 0
    # Top row
    for x in countup(0, max_x):
        let start = newBeam((x, 0), SOUTH)
        best = max(best, fire(input_grid, start))
    # Bottom row
    for x in countup(0, max_x):
        let start = newBeam((x, max_y), NORTH)
        best = max(best, fire(input_grid, start))
    # Left column
    for y in countup(0, max_y):
        let start = newBeam((0, y), EAST)
        best = max(best, fire(input_grid, start))
    # Right column
    for y in countup(0, max_y):
        let start = newBeam((max_x, y), WEST)
        best = max(best, fire(input_grid, start))

    return $best
