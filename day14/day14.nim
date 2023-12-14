import sequtils, strutils, tables

const P2_CYCLES = 1000000000

type Grid = seq[seq[char]]

proc parseInput(input: string): Grid =
    for line in input.splitLines():
        result.add(line.items().toSeq())

proc rollUp(grid: var Grid) =
    for x in countup(0, grid[0].high()):
        var empty = -1
        for y in countup(0, grid.high()):
            let c = grid[y][x]
            case c:
                of '.':
                    if empty == -1:
                        empty = y
                of 'O':
                    if empty != -1:
                        grid[empty][x] = 'O'
                        grid[y][x] = '.'
                        empty += 1
                of '#':
                    empty = -1
                else: discard

proc rotateCw(grid: Grid): Grid =
    for x in countup(0, grid[0].high()):
        var row: seq[char]
        for y in countdown(grid.high(), 0):
            row.add(grid[y][x])
        result.add(row)

proc fullCycle(grid: var Grid) =
    for _ in countup(1, 4):
        grid.rollUp()
        grid = grid.rotateCw()

proc getScore(grid: Grid): int =
    let height = grid.len()
    for y, row in grid.pairs():
        for x, cell in row.pairs():
            if cell == 'O':
                result += height - y

proc day14p1*(input: string): string =
    var grid = parseInput(input)
    grid.rollUp()
    let score = grid.getScore()
    return $score

proc day14p2*(input: string): string =
    var grid = parseInput(input)
    var cache = initTable[Grid, int]()
    cache[grid] = 0
    var i = 0
    var skipped = false
    while i < P2_CYCLES:
        grid.fullCycle()
        inc(i)
        if not skipped and cache.hasKey(grid):
            skipped = true
            let cycle_len = i - cache[grid]
            let remainder = (P2_CYCLES - i) mod cycle_len
            i = P2_CYCLES - remainder
        cache[grid] = i
    let score = grid.getScore()
    return $score
