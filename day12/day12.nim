import math, sequtils, sugar
import strutils except repeat # Want to use sequtils's repeat, not strutils

type Record = object
    info: string
    groups: seq[int]

proc parseInput(line: string): Record =
    let blocks = line.split(' ')
    result.info = blocks[0]
    result.groups = blocks[1].split(',').map(proc(x: string): int = parseInt(x))

proc scaleRecord(self: var Record, scale: int) =
    let repeat_info = self.info.repeat(scale)
    self.info = repeat_info.join("?")
    self.groups = self.groups.cycle(scale)

proc generatePossibility(info: string, mask: int): string =
    var v = mask
    result = info
    for idx, c in info.pairs():
        if c == '?':
            let nc = if (v and 1) != 0: '#' else: '.'
            result[idx] = nc
            v = v shr 1

proc isValid(info: string, target: seq[int]): bool =
    let groups: seq[int] = collect:
        for c in info.split('.'):
            if c.len() > 0: c.len()
    return groups == target

proc countPossibilities(self: Record): int =
    result = 0
    let unknown_count = self.info.count('?')
    let num_possibilities = 1 shl unknown_count
    let num_true = sum(self.groups)
    for i in countup(0, num_possibilities - 1):
        let p = generatePossibility(self.info, i)
        if p.count('#') != num_true:
            continue
        if p.isValid(self.groups):
            inc(result)

proc day12p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let record = parseInput(line)
        let cnt = record.countPossibilities()
        total += cnt
    return $total

when defined(multithreaded):
    import threadpool
    {.experimental: "parallel".}

    proc parallelHelper(line: string, idx: int): int =
        echo(idx)
        var record = parseInput(line)
        let single = record.countPossibilities()
        record.scaleRecord(2)
        let double = record.countPossibilities()
        let scale = int(double / single)
        return single * scale ^ 4

    proc day12p2*(input: string): string =
        let lines = input.splitLines()
        var sums = newSeq[int](lines.len())
        parallel:
            for i in countup(0, sums.high()):
                sums[i] = spawn parallelHelper(lines[i], i)
        return $sum(sums)
else:
    proc day12p2*(input: string): string =
        var total = 0
        for idx, line in input.splitLines().pairs():
            var record = parseInput(line)
            let single = record.countPossibilities()
            record.scaleRecord(2)
            let double = record.countPossibilities()
            let scale = int(double / single)
            let cnt = single * scale ^ 4
            total += cnt
        return $total
