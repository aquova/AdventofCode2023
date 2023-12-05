import sequtils, strscans, strutils

type Map = tuple
    src, dst, n: int

type Entry = seq[Map]
type Almanac = seq[Entry]

proc contains(self: Map, v: int): bool =
    return self.src <= v and v < self.src + self.n

proc parseEntry(data: string): Entry =
    for line in data.splitLines():
        let (valid, dst, src, n) = line.scanTuple("$i $i $i")
        if valid:
            let m = (src, dst, n)
            result.add(m)

proc getValue(self: Entry, v: int): int =
    for m in self:
        if m.contains(v):
            let delta = v - m.src
            return m.dst + delta
    return v

proc newAlmanac(raw: seq[string]): Almanac =
    for e in raw:
        let entry = parseEntry(e)
        result.add(entry)

proc getSeedLocation(info: Almanac, seed: int): int =
    result = seed
    for entry in info:
        result = entry.getValue(result)

proc day5p1*(input: string): string =
    let raw = input.split("\n\n")
    let info = newAlmanac(raw[1..<raw.len()])
    let seeds = raw[0].split(':')[1].splitWhitespace()
    var lowest = high(int)
    for seed in seeds:
        let si = parseInt(seed)
        let loc = info.getSeedLocation(si)
        lowest = min(loc, lowest)
    return $lowest

when defined(multithreaded):
    import sugar, threadpool
    {.experimental: "parallel".}

    type seedRange = tuple
        start, stop: int

    proc parallelHelper(info: Almanac, range: seedRange): int =
        result = high(int)
        for s in countup(range.start, range.stop):
            let loc = info.getSeedLocation(s)
            result = min(loc, result)

    proc day5p2*(input: string): string =
        let raw = input.split("\n\n")
        let info = newAlmanac(raw[1..raw.high()])
        let seeds = raw[0].split(':')[1].splitWhitespace().map(proc(x: string): int = parseInt(x))
        let ranges: seq[seedRange] = collect:
            for idx in countup(0, seeds.high, 2):
                (seeds[idx], seeds[idx] + seeds[idx + 1] - 1)
        var lowest = newSeq[int](ranges.len())
        parallel:
            for i in countup(0, lowest.high()):
                lowest[i] = spawn parallelHelper(info, ranges[i])
        return $min(lowest)
else:
    proc day5p2*(input: string): string =
        let raw = input.split("\n\n")
        let info = newAlmanac(raw[1..<raw.len()])
        let seeds = raw[0].split(':')[1].splitWhitespace().map(proc(x: string): int = parseInt(x))
        var lowest = high(int)
        for idx in countup(0, seeds.len() - 1, 2):
            for si in countup(seeds[idx], seeds[idx] + seeds[idx + 1] - 1):
                let loc = info.getSeedLocation(si)
                lowest = min(loc, lowest)
            echo("Block done")
        return $lowest
