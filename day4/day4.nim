import math, sequtils, strutils, sugar

proc getNumMatches(line: string): int =
    let sections = line.split({':', '|'})
    let winners = sections[1].splitWhitespace()
    let matches = collect:
        for x in sections[2].splitWhitespace():
            if x in winners: x
    return matches.len()

proc day4p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let matches = line.getNumMatches()
        if matches != 0:
            total += 1 shl (matches - 1)
    return $total

proc day4p2*(input: string): string =
    let lines = input.splitLines()
    var cards = repeat(1, lines.len())
    for idx, line in lines.pairs():
        let matches = line.getNumMatches()
        if matches == 0: continue
        for dx in countup(1, matches):
            if idx + dx < cards.len():
                cards[idx + dx] += cards[idx]
    return $sum(cards)
