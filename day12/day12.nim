import sequtils, tables
import strutils except repeat

type Data = tuple
    record_idx, num_idx, current: int

proc countSolutions(record: string, nums: seq[int], record_idx, num_idx, current: int, cache: var Table[Data, int]): int =
    if record_idx == record.len():
        if num_idx == nums.len() and current == 0:
            return 1
        elif num_idx == nums.len() - 1 and nums[num_idx] == current:
            return 1
        else: return 0

    let key = (record_idx, num_idx, current)
    if cache.hasKey(key):
        return cache[key]

    for c in ['.', '#']:
        if record[record_idx] == c or record[record_idx] == '?':
            if c == '.' and current == 0:
                result += countSolutions(record, nums, record_idx + 1, num_idx, 0, cache)
            elif c == '.' and current > 0 and num_idx < nums.len() and nums[num_idx] == current:
                result += countSolutions(record, nums, record_idx + 1, num_idx + 1, 0, cache)
            elif c == '#':
                result += countSolutions(record, nums, record_idx + 1, num_idx, current + 1, cache)
    cache[key] = result

proc day12p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let words = line.split(' ')
        let nums = words[1].split(',').map(proc(x: string): int = parseInt(x))
        var cache: Table[Data, int]
        total += countSolutions(words[0], nums, 0, 0, 0, cache)
    return $total

proc day12p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let words = line.split(' ')
        let nums = words[1].split(',').map(proc(x: string): int = parseInt(x))
        let extended_record = words[0].repeat(5).join("?")
        let extended_nums = nums.cycle(5)
        var cache: Table[Data, int]
        total += countSolutions(extended_record, extended_nums, 0, 0, 0, cache)
    return $total
