import sequtils, strutils
import ../utils/range
import ../utils/point

type EmptySpaces = tuple
    rows, cols: seq[int]

proc parseEmpty(rows: seq[string]): EmptySpaces =
    for y, row in rows.pairs():
        if row.all(proc(x: char): bool = x == '.'):
            result.rows.add(y)
    # Is there a good way to get a column as a sequence?
    for x in countup(0, rows[0].high()):
        var found = true
        for y in countup(0, rows.high()):
            if rows[y][x] == '#':
                found = false
                break
        if found:
            result.cols.add(x)

proc parseGalaxies(rows: seq[string]): seq[Point] =
    for y, row in rows.pairs():
        for x, cell in row.pairs():
            if cell == '#':
                result.add((x, y))

proc expandingDist(p1, p2: Point, empty: EmptySpaces, scale: int): int =
    let x_range = newIntRange(p1.x, p2.x)
    var dx = x_range.size()
    for col in empty.cols:
        if x_range.contains(col):
            dx += scale - 1
    let y_range = newIntRange(p1.y, p2.y)
    var dy = y_range.size()
    for row in empty.rows:
        if y_range.contains(row):
            dy += scale - 1
    return dx + dy - 2 # Subtract 1 from x and y so we don't count endpoint

proc day11p1*(input: string): string =
    let rows = input.splitLines()
    let empty = rows.parseEmpty()
    let galaxies = rows.parseGalaxies()
    var total = 0
    for i in countup(0, galaxies.high() - 1):
        for j in countup(i, galaxies.high()):
            let dist = expandingDist(galaxies[i], galaxies[j], empty, 2)
            total += dist
    return $total

proc day11p2*(input: string): string =
    let rows = input.splitLines()
    let empty = rows.parseEmpty()
    let galaxies = rows.parseGalaxies()
    var total = 0
    for i in countup(0, galaxies.high() - 1):
        for j in countup(i, galaxies.high()):
            let dist = expandingDist(galaxies[i], galaxies[j], empty, 1000000)
            total += dist
    return $total
