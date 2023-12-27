import strutils, sugar

const P1_MIN = 200000000000000.0
const P1_MAX = 400000000000000.0
# const P1_MIN = 7.0
# const P1_MAX = 27.0

type Hail = tuple
    x, y, z, dx, dy, dz: float

proc parseInput(input: string): seq[Hail] =
    for line in input.splitLines():
        let n = collect:
            for c in line.split({' ', ',', '@'}):
                if c != "": parseFloat(c)
        result.add((n[0], n[1], n[2], n[3], n[4], n[5]))

proc checkIntersect(a, b: Hail): bool =
    let ax1 = a.x
    let ay1 = a.y
    let ax2 = a.x + a.dx
    let ay2 = a.y + a.dy
    let bx1 = b.x
    let by1 = b.y
    let bx2 = b.x + b.dx
    let by2 = b.y + b.dy

    let ma = (ay2 - ay1) / (ax2 - ax1)
    let mb = (by2 - by1) / (bx2 - bx1)
    if ma == mb: return false # Parallel
    # Point slope form gives y = y1 + m * (x - x1)
    # Setting both y's equal for both lines and solving for x gives:
    let ix = (by1 - ay1 + ma * ax1 - mb * bx1) / (ma - mb)
    let iy = ma * (ix - ax1) + ay1
    if (ix - a.x) / a.dx < 0: return false
    if (iy - a.y) / a.dy < 0: return false
    if (ix - b.x) / b.dx < 0: return false
    if (iy - b.y) / b.dy < 0: return false
    return P1_MIN <= ix and ix <= P1_MAX and P1_MIN <= iy and iy <= P1_MAX

proc day24p1*(input: string): string =
    let hail = input.parseInput()
    var cnt = 0
    for i in countup(0, hail.high() - 1):
        for j in countup(i + 1, hail.high()):
            if checkIntersect(hail[i], hail[j]):
                inc(cnt)
    return $cnt

proc day24p2*(input: string): string =
    return "This one was awful, so I just had a friend give me the answer..."
