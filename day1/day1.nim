import sequtils, strutils, tables

const NUMBERS = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
}.toTable()

proc getDigit(s: string, left, use_substrings: bool): int =
    let left_indices = toSeq(countup(0, s.len() - 1))
    let right_indices = toSeq(countdown(s.len() - 1, 0))
    let indices = if left: left_indices else: right_indices
    for i in indices:
        let c = s[i]
        if c.isDigit():
            return parseInt($c)
        elif use_substrings:
            for n in NUMBERS.keys():
                if s.continuesWith(n, i):
                    return NUMBERS[n]
    return 0

proc day1p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let left = getDigit(line, true, false)
        let right = getDigit(line, false, false)
        total += left * 10 + right
    return $total

proc day1p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let left = getDigit(line, true, true)
        let right = getDigit(line, false, true)
        total += left * 10 + right
    return $total
