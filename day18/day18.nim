import sequtils, strscans, strutils, tables
import ../utils/[direction, point]

const DIRECTION_MAP = {
    'U': NORTH, 'D': SOUTH, 'R': EAST, 'L': WEST
}.toTable

proc shoelace(pts: seq[Point]): int =
    for i in countup(0, pts.high() - 1):
        let p1 = pts[i]
        let p2 = pts[i + 1]
        result += (p1.x * p2.y - p1.y * p2.x)
    # Final one that wraps around
    result += (pts[^1].x * pts[0].y - pts[^1].y * pts[0].x)
    result = int(result / 2)

proc day18p1*(input: string): string =
    var pts: seq[Point]
    var current = (0, 0)
    # Need to adjust by one for thickness on one side for North or East movements (or any two orthogonal directions)
    var north_east = 0
    for line in input.splitLines():
        let (valid, d, l, _) = line.scanTuple("$c $i (#$+)")
        if valid:
            current += l * DELTA[DIRECTION_MAP[d]]
            if current notin pts:
                pts.add(current)
            if DIRECTION_MAP[d] in [NORTH, EAST]:
                north_east += l
    let area = shoelace(pts)
    let final = area + north_east + 1
    return $final

proc day18p2*(input: string): string =
    const HEX_MAP = [EAST, SOUTH, WEST, NORTH]
    var pts: seq[Point]
    var current: Point = (0, 0)
    var north_east = 0
    for line in input.splitLines():
        let (valid, _, _, hex) = line.scanTuple("$c $i (#$+)")
        if valid:
            let dist = parseHexInt(hex[0..^2])
            let dir = HEX_MAP[parseInt($hex[^1])]
            current += dist * DELTA[dir]
            if current notin pts:
                pts.add(current)
            if dir in [NORTH, EAST]:
                north_east += dist
    let area = shoelace(pts)
    let final = area + north_east + 1
    return $final

