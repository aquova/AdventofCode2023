import math, strscans, strutils, tables

type Node = tuple
    left, right: string

proc parseInput(l: seq[string]): Table[string, Node] =
    for line in l:
        let (valid, start, left, right) = line.scanTuple("$w = ($w, $w)")
        if valid:
            result[start] = (left, right)

proc numStepsUntilZ(start: string, nodes: Table[string, Node], directions: string, zzz: bool): int =
    var
        current = start
        idx = 0
    while true:
        if zzz and current == "ZZZ":
            break
        elif not zzz and current[2] == 'Z':
            break

        let d = directions[idx mod directions.len()]
        let next = nodes[current]
        if d == 'L':
            current = next.left
        else:
            current = next.right
        inc(idx)
    return idx

proc day8p1*(input: string): string =
    let lines = input.splitLines()
    let directions = lines[0]
    let node_tbl = parseInput(lines[2..lines.high()])
    let n = numStepsUntilZ("AAA", node_tbl, directions, true)
    return $n

proc day8p2*(input: string): string =
    let lines = input.splitLines()
    let directions = lines[0]
    let node_tbl = parseInput(lines[2..lines.high()])
    var a_nodes: seq[int]
    for n in node_tbl.keys():
        if n[2] == 'A':
            let min_steps = numStepsUntilZ(n, node_tbl, directions, false)
            a_nodes.add(min_steps)
    return $lcm(a_nodes)
