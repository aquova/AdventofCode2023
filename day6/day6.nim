import math, sequtils, strutils

type Race = tuple
    time, dist: int

# This apparently doesn't exist in the std
proc toString(chars: seq[char]): string =
    for c in chars:
        result.add($c)

proc parseP1(input: string): seq[Race] =
    let words = input.splitLines()
    let raw_t = words[0].splitWhitespace()
    let raw_d = words[1].splitWhitespace()
    for i in countup(1, raw_t.high()):
        result.add((parseInt(raw_t[i]), parseInt(raw_d[i])))

proc parseP2(input: string): Race =
    let words = input.splitLines()
    let time = words[0].filter(proc(c: char): bool = c.isDigit())
    let dist = words[1].filter(proc(c: char): bool = c.isDigit())
    return (parseInt(time.toString()), parseInt(dist.toString()))

proc countRecords(r: Race): int =
    let a = -1
    let b = r.time
    let c = -r.dist
    let term = sqrt(float(b ^ 2 - 4 * a * c))
    let lower = (float(-b) + term) / float(2 * a)
    let higher = (float(-b) - term) / float(2 * a)
    return int(floor(higher) - ceil(lower)) + 1

# proc countRecords(r: Race): int =
#     result = 0
#     for wait in countup(0, r.time):
#         let run = r.time - wait
#         if r.dist < run * wait:
#             inc(result)

proc day6p1*(input: string): string =
    var score = 1
    let races = parseP1(input)
    for r in races:
        score *= r.countRecords()
    return $score

proc day6p2*(input: string): string =
    let race = parseP2(input)
    return $race.countRecords()
