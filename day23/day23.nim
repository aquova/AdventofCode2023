import sequtils, strutils, tables
import ../utils/point

proc offGrid(p: Point, grid: seq[seq[char]]): bool =
    return p.x < 0 or p.y < 0 or p.x > grid[0].high() or p.y > grid.high()

proc getNeighbors(p: Point, grid: seq[seq[char]], p2: bool): seq[Point] =
    let left = p + (-1, 0)
    if not left.offGrid(grid):
        if (p2 and grid[left] != '#') or (not p2 and (grid[left] == '.' or grid[left] == '<')):
            result.add(left)
    let right = p + (1, 0)
    if not right.offGrid(grid):
        if (p2 and grid[right] != '#') or (not p2 and (grid[right] == '.' or grid[right] == '>')):
            result.add(right)
    let up = p + (0, -1)
    if not up.offGrid(grid):
        if (p2 and grid[up] != '#') or (not p2 and (grid[up] == '.' or grid[up] == '^')):
            result.add(up)
    let down = p + (0, 1)
    if not down.offGrid(grid):
        if (p2 and grid[down] != '#') or (not p2 and (grid[down] == '.' or grid[down] == 'v')):
            result.add(down)

proc minimize(table: Table[Point, seq[Point]]): Table[Point, seq[(Point, int)]] =
    for k, v in table.pairs():
        if v.len() == 2: continue
        for n in v:
            var next = n
            var pts = @[k, n]
            while table[next].len() == 2:
                next = if table[next][0] in pts: table[next][1] else: table[next][0]
                pts.add(next)
            if result.hasKey(k):
                result[k].add((next, pts.len() - 1))
            else:
                result[k] = @[(next, pts.len() - 1)]

proc gridToTable(grid: seq[seq[char]], p2: bool): Table[Point, seq[Point]] =
    for y in countup(0, grid.high()):
        for x in countup(0, grid[0].high()):
            let p = (x, y)
            if grid[p] == '#': continue
            let neighbors = p.getNeighbors(grid, p2)
            if neighbors.len() > 0:
                result[p] = neighbors

proc parseInput(input: string): seq[seq[char]] =
    for line in input.splitLines():
        result.add(line.items.toSeq)

proc findLongestPath(grid: Table[Point, seq[Point]], visited: seq[Point], current, goal: Point): int =
    if current == goal: return visited.len() - 1
    let neighbors = grid[current]
    for n in neighbors:
        if n in visited: continue
        let path = findLongestPath(grid, visited & @[n], n, goal)
        result = max(result, path)

proc findLongestPathOptimized(grid: Table[Point, seq[(Point, int)]], visited: seq[Point], distance: int, current, goal: Point): int =
    if current == goal: return distance
    let neighbors = grid[current]
    for n in neighbors:
        let next = n[0]
        if next in visited: continue
        let path = findLongestPathOptimized(grid, visited & @[next], distance + n[1], next, goal)
        result = max(result, path)

proc day23p1*(input: string): string =
    let grid = input.parseInput()
    let start = (1, 0)
    let goal = (grid[0].high() - 1, grid.high())

    let table = grid.gridToTable(false)
    let longest = findLongestPath(table, @[start], start, goal)
    return $longest

proc day23p2*(input: string): string =
    let grid = input.parseInput()
    let start = (1, 0)
    let goal = (grid[0].high() - 1, grid.high())

    let table = grid.gridToTable(true)
    let optimized = table.minimize()
    let longest = findLongestPathOptimized(optimized, @[start], 0, start, goal)
    return $longest
