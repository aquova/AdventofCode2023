import deques, math, sequtils, strutils, tables

const RX_INPUTS = ["vg", "kp", "gc", "tx"]
const RX_SENDER = "bq"

type NodeKind = enum
    BROADCAST,
    FLIP_FLOP,
    CONJUNCTION

type Node = object
    outputs: seq[string]
    case kind: NodeKind
        of CONJUNCTION: states: Table[string, bool]
        else: state: bool

type Signal = tuple
    state: bool
    sender, recipiant: string

proc newNode(name: string, outputs: seq[string]): Node =
    if name == "broadcaster":
        return Node(outputs: outputs, kind: BROADCAST, state: false)
    elif '%' in name:
        return Node(outputs: outputs, kind: FLIP_FLOP, state: false)
    else:
        var input_tbl: Table[string, bool]
        return Node(outputs: outputs, kind: CONJUNCTION, states: input_tbl)

proc addConjunctionInput(n: var Node, input: string) =
    if n.kind != CONJUNCTION: assert(false, "Trying to amend a non-conjunction node")
    n.states[input] = false

proc parseInput(input: string): Table[string, Node] =
    for line in input.splitLines():
        let map = line.split(" -> ")
        let name = map[0].multiReplace(("%", ""), ("&", ""))
        let outputs = map[1].split(", ")
        result[name] = newNode(map[0], outputs)
    for k, v in result.pairs():
        for output in v.outputs:
            if result.hasKey(output) and result[output].kind == CONJUNCTION:
                result[output].addConjunctionInput(k)

# Return sequence of signals and their next recipiant
proc handleSignal(self: var Node, s: Signal): seq[(bool, string)] =
    case self.kind:
        of BROADCAST:
            for output in self.outputs:
                result.add((s.state, output))
        of FLIP_FLOP:
            if s.state: return # Only act on low edge
            self.state = not self.state
            for output in self.outputs:
                result.add((self.state, output))
        of CONJUNCTION:
            self.states[s.sender] = s.state
            let send = not self.states.values.toSeq.all(proc(x: bool): bool = x)
            for output in self.outputs:
                result.add((send, output))

proc pressButton(nodes: var Table[string, Node]): (int, int) =
    var queue = initDeque[Signal]()
    queue.addLast((false, "button", "broadcaster"))
    while queue.len() > 0:
        let signal = queue.popFirst()
        if signal.state: inc(result[1]) else: inc(result[0])
        if not nodes.hasKey(signal.recipiant): continue
        let next = nodes[signal.recipiant].handleSignal(signal)
        for (next_value, next_recipiant) in next:
            let next_signal = (next_value, signal.recipiant, next_recipiant)
            queue.addLast(next_signal)

proc willSendTrueToRx(nodes: var Table[string, Node], input: string): bool =
    var queue = initDeque[Signal]()
    queue.addLast((false, "button", "broadcaster"))
    while queue.len() > 0:
        let signal = queue.popFirst()
        if signal.sender == input and signal.recipiant == RX_SENDER and signal.state:
            return true
        if not nodes.hasKey(signal.recipiant): continue
        let next = nodes[signal.recipiant].handleSignal(signal)
        for (next_value, next_recipiant) in next:
            let next_signal = (next_value, signal.recipiant, next_recipiant)
            queue.addLast(next_signal)
    return false

proc day20p1*(input: string): string =
    var nodes = parseInput(input)
    var low_pulses, high_pulses = 0
    for _ in countup(1, 1000):
        let (l, h) = pressButton(nodes)
        low_pulses += l
        high_pulses += h
    return $(low_pulses * high_pulses)

proc day20p2*(input: string): string =
    # rx has a single conjunction feeding into it, which has four inputs
    # Need to find cycles for those four, then extrapolate
    let og_nodes = parseInput(input)
    var rx_len: seq[int]
    for rxi in RX_INPUTS:
        var cnt = 0
        var nodes = og_nodes
        while true:
            inc(cnt)
            if willSendTrueToRx(nodes, rxi):
                rx_len.add(cnt)
                break
    return $lcm(rx_len)
