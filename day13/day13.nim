import sequtils, strutils

type Grid = object
    rows, cols: seq[string]

proc countDiffs(lhs, rhs: string): int =
    # We're assuming they're the same length
    for i in countup(0, lhs.high()):
        if lhs[i] != rhs[i]:
            inc(result)

proc parseGrid(input: string): Grid =
    result.rows = input.splitLines()
    for x in countup(0, result.rows[0].high()):
        var col = ""
        for y in countup(0, result.rows.high()):
            col &= result.rows[y][x]
        result.cols.add(col)

proc countRows(self: Grid, p2: bool): int =
    for y in countup(0, self.rows.high() - 1):
        var diffs = 0
        for dy in countup(0, y):
            let up = y - dy
            let down = y + dy + 1
            if up < 0 or down > self.rows.high():
                break
            diffs += countDiffs(self.rows[up], self.rows[down])
        if (not p2 and diffs == 0) or (p2 and diffs == 1):
            result += y + 1

proc countCols(self: Grid, p2: bool): int =
    for x in countup(0, self.cols.high() - 1):
        var diffs = 0
        for dx in countup(0, x):
            let left = x - dx
            let right = x + dx + 1
            if left < 0 or right > self.cols.high():
                break
            diffs += countDiffs(self.cols[left], self.cols[right])
        if (not p2 and diffs == 0) or (p2 and diffs == 1):
            result += x + 1

proc day13p1*(input: string): string =
    let blocks = input.split("\n\n")
    let grids = blocks.map(proc(x: string): Grid = parseGrid(x))
    var total = 0
    for grid in grids:
        let rows = grid.countRows(false)
        let cols = grid.countCols(false)
        total += 100 * rows + cols
    return $total

proc day13p2*(input: string): string =
    let blocks = input.split("\n\n")
    let grids = blocks.map(proc(x: string): Grid = parseGrid(x))
    var total = 0
    for grid in grids:
        let rows = grid.countRows(true)
        let cols = grid.countCols(true)
        total += 100 * rows + cols
    return $total
