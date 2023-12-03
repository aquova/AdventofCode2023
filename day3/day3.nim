import strutils

type Point = tuple
    x, y: int

type Number = object
    valid: bool
    num: int
    pts: seq[Point]

proc newNumber(): Number =
    result.valid = false

proc isValid(self: Number): bool =
    return self.valid

proc getNeighbors(self: Number, width, height: int): seq[Point] =
    for pt in self.pts:
        let lx = max(0, pt.x - 1)
        let hx = min(pt.x + 1, width - 1)
        let ly = max(0, pt.y - 1)
        let hy = min(pt.y + 1, height - 1)
        for xx in countup(lx, hx):
            for yy in countup(ly, hy):
                let p = (xx, yy)
                if p notin self.pts and p notin result:
                    result.add(p)

proc addDigit(self: var Number, digit, x, y: int) =
    self.valid = true
    self.num = self.num * 10 + digit
    self.pts.add((x, y))

proc isPartNumber(self: Number, grid: seq[string]): bool =
    let width = grid[0].len()
    let height = grid.len()
    for neighbor in self.getNeighbors(width, height):
        let c = grid[neighbor.y][neighbor.x]
        if c != '.' and not c.isDigit():
            return true
    return false

proc containsPt(self: Number, pt: Point): bool =
    return pt in self.pts

proc getNumbers(grid: seq[string]): seq[Number] =
    let height = grid.len()
    let width = grid[0].len()
    for y in countup(0, height - 1):
        var n = newNumber()
        for x in countup(0, width - 1):
            let c = grid[y][x]
            if c.isDigit():
                n.addDigit(parseInt($c), x, y)
            elif n.isValid():
                result.add(n)
                n = newNumber()
        if n.isValid():
            result.add(n)

iterator gearNeighbors(x, y: int): Point =
    for x in countup(x - 1, x + 1):
        for y in countup(y - 1, y + 1):
            yield (x, y)

proc day3p1*(input: string): string =
    var total = 0
    let lines = input.splitLines()
    let nums = getNumbers(lines)
    for n in nums:
        if n.isPartNumber(lines):
            total += n.num
    return $total

proc day3p2*(input: string): string =
    var total = 0
    let lines = input.splitLines()
    let nums = getNumbers(lines)
    for y in countup(0, lines.len() - 1):
        for x in countup(0, lines[y].len() - 1):
            let c = lines[y][x]
            if c != '*':
                continue
            var gears: seq[Number]
            for n in nums:
                for pt in gearNeighbors(x, y):
                    if n.containsPt(pt) and n notin gears:
                        gears.add(n)
            if gears.len() == 2:
                total += gears[0].num * gears[1].num
    return $total
