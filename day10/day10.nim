import sequtils, strutils, sugar, tables
import ../utils/point

type Direction = enum
    NORTH, SOUTH, EAST, WEST

const DIR_SYMBOLS: Table[Direction, Table[char, Direction]] = {
    NORTH: {'|': NORTH, '7': WEST, 'F': EAST}.toTable,
    SOUTH: {'|': SOUTH, 'L': EAST, 'J': WEST}.toTable,
    EAST: {'-': EAST, '7': SOUTH, 'J': NORTH}.toTable,
    WEST: {'-': WEST, 'L': NORTH, 'F': SOUTH}.toTable
}.toTable

const DIR_DELTA: Table[Direction, Point] = {
    NORTH: (0, -1),
    SOUTH: (0, 1),
    EAST: (1, 0),
    WEST: (-1, 0),
}.toTable

const RIGHT_PIPES = ['-', 'F', 'L']
const DOWN_PIPES = ['|', 'F', '7']

type Grid = seq[seq[char]]

proc `[]`(grid: Grid, p: Point): char =
    return grid[p.y][p.x]

proc size(grid: Grid): int =
    return grid[0].len() * grid.len()

proc validIndex(grid: Grid, p: Point): bool =
    return p.x >= grid[0].low() and p.x <= grid[0].high() and p.y >= grid.low() and p.y <= grid.high()

iterator borderPoints(grid: Grid): Point =
    let max_x = grid[0].high()
    for y in countup(0, grid.high()):
        yield (0, y)
        yield (max_x, y)
    for x in countup(1, max_x - 1):
        yield (x, 0)
        yield (x, grid.high())

proc replaceS(grid: Grid, pt: Point): char =
    let north = pt + DIR_DELTA[NORTH]
    let is_north = north.y >= 0 and DIR_SYMBOLS[NORTH].hasKey(grid[north])
    let south = pt + DIR_DELTA[SOUTH]
    let is_south = south.y < grid.high() and DIR_SYMBOLS[SOUTH].hasKey(grid[south])
    let east = pt + DIR_DELTA[EAST]
    let is_east = east.x < grid[0].high() and DIR_SYMBOLS[EAST].hasKey(grid[east])
    let west = pt + DIR_DELTA[WEST]
    let is_west = west.x >= 0 and DIR_SYMBOLS[WEST].hasKey(grid[west])

    if is_north and is_south: return '|'
    elif is_north and is_east: return 'L'
    elif is_north and is_west: return 'J'
    elif is_south and is_east: return 'F'
    elif is_south and is_west: return '7'
    elif is_east and is_west: return '-'
    raise newException(IOError, "Invalid start position")

proc scale(grid: Grid): Grid =
    for y, row in grid.pairs():
        var scaledRow: seq[char]
        var newRow: seq[char]
        for x, cell in row.pairs():
            var current = cell
            if current == 'S':
                current = grid.replaceS((x, y))
                scaledRow.add(current)
            else:
                scaledRow.add(cell)
            if current in RIGHT_PIPES: scaledRow.add('-') else: scaledRow.add('.')
            if current in DOWN_PIPES: newRow.add('|') else: newRow.add('.')
            newRow.add('.')
        result.add(scaledRow)
        result.add(newRow)

proc pruneJunk(grid: Grid, valid: seq[Point]): Grid =
    for y, row in grid.pairs():
        var newRow: seq[char]
        for x, cell in row.pairs():
            let pt = (x, y)
            if pt in valid:
                newRow.add(cell)
            else:
                newRow.add('.')
        result.add(newRow)

type Walker = object
    start: Point
    pos: Point
    dir: Direction

proc newWalker(grid: Grid): Walker =
    block findStart:
        for y, row in grid.pairs():
            for x, cell in row.pairs():
                if cell == 'S':
                    result.start = (x, y)
                    result.pos = result.start
                    break findStart
    for dir in Direction:
        let next = result.pos + DIR_DELTA[dir]
        if grid.validIndex(next):
            let cell = grid[next]
            if DIR_SYMBOLS[dir].hasKey(cell):
                result.dir = dir
                break

proc getPosInLoop(self: var Walker, grid: Grid): seq[Point] =
    while true:
        self.pos = self.pos + DIR_DELTA[self.dir]
        let next = grid[self.pos]
        result.add(self.pos)
        if self.pos == self.start:
            break
        self.dir = DIR_SYMBOLS[self.dir][next]

proc findOutside(grid: Grid): int =
    var
        outside: seq[Point]
        visited: seq[Point]
        stack: seq[Point]
    for pt in grid.borderPoints():
        if pt notin visited and grid[pt] == '.':
            stack.add(pt)
            while stack.len() > 0:
                let current = stack.pop()
                if current in visited:
                    continue
                visited.add(current)
                if grid[current] == '.':
                    outside.add(current)
                    for np in current.neighbors():
                        if grid.validIndex(np):
                            stack.add(np)
    # Scale back to 1x by only keeping points directly mapping
    let final: seq[Point] = collect:
        for p in outside:
            if p.x mod 2 == 0 and p.y mod 2 == 0: (int(p.x / 2), int(p.y / 2))
    return final.len()

proc day10p1*(input: string): string =
    let grid = input.splitLines().map(proc(x: string): seq[char] = x.items().toSeq())
    var walker = newWalker(grid)
    let pts = walker.getPosInLoop(grid)
    return $int(pts.len() / 2)

proc day10p2*(input: string): string =
    var grid = input.splitLines().map(proc(x: string): seq[char] = x.items().toSeq())
    var walker = newWalker(grid)
    let pipes = walker.getPosInLoop(grid)
    grid = grid.pruneJunk(pipes)

    let scaled_grid = grid.scale()
    let outside = scaled_grid.findOutside()
    return $(grid.size() - pipes.len() - outside)
