import sequtils, strutils

proc last(v: seq[int]): int =
    return v[v.high()]

proc isAllZero(vals: seq[int]): bool =
    return vals.all(proc(x: int): bool = x == 0)

proc diffs(vals: seq[int]): seq[int] =
    for i in countup(0, vals.high() - 1):
        result.add(vals[i + 1] - vals[i])

proc extrapolate(vals: seq[int], forwards: bool): seq[int] =
    var diffs = vals.diffs()
    if diffs.isAllZero():
        return vals
    if forwards:
        let next = vals.last() + extrapolate(diffs, forwards).last()
        return vals & next
    else:
        let prev = vals[0] - extrapolate(diffs, forwards)[0]
        return prev & vals

proc day9p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let vals = line.split().map(proc(x: string): int = parseInt(x))
        let ex = extrapolate(vals, true)
        total += ex.last()
    return $total

proc day9p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let vals = line.split().map(proc(x: string): int = parseInt(x))
        let ex = extrapolate(vals, false)
        total += ex[0]
    return $total
