import sequtils, strscans, strutils

type Map = tuple
    src, dst, n: int

type Entry = seq[Map]

type Almanac = object
    seed_sol: Entry
    soil_fertilizer: Entry
    fertilizer_water: Entry
    water_light: Entry
    light_temp: Entry
    temp_humidity: Entry
    humidity_location: Entry

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
    # This could just be a single seq[Entry], but this helps me think
    result.seed_sol = parseEntry(raw[0])
    result.soil_fertilizer = parseEntry(raw[1])
    result.fertilizer_water = parseEntry(raw[2])
    result.water_light = parseEntry(raw[3])
    result.light_temp = parseEntry(raw[4])
    result.temp_humidity = parseEntry(raw[5])
    result.humidity_location = parseEntry(raw[6])

proc getSeedLocation(self: Almanac, seed: int): int =
    let soil = self.seed_sol.getValue(seed)
    let fert = self.soil_fertilizer.getValue(soil)
    let water = self.fertilizer_water.getValue(fert)
    let light = self.water_light.getValue(water)
    let temp = self.light_temp.getValue(light)
    let humid = self.temp_humidity.getValue(temp)
    let loc = self.humidity_location.getValue(humid)
    return loc

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
