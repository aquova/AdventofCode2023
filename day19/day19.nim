import strscans, strutils, tables
import ../utils/range

type Part = tuple
    x, m, a, s: int

type Eval = object
    rating: string
    lt: bool
    val: int
    approve: string

type Workflow = object
    evals: seq[Eval]
    final: string

type WorkflowRange = object
    name: string
    xmas: Table[string, IntRange]

proc newWorkflowRange(name: string): WorkflowRange =
    result.name = name
    result.xmas["x"] = newIntRange(1, 4000)
    result.xmas["m"] = newIntRange(1, 4000)
    result.xmas["a"] = newIntRange(1, 4000)
    result.xmas["s"] = newIntRange(1, 4000)

proc parseEval(input: string): Eval =
    let pieces = input.split({'<', '>', ':'})
    result.rating = pieces[0]
    result.val = parseInt(pieces[1])
    result.approve = pieces[2]
    result.lt = '<' in input

proc parseWorkflows(input: string): Table[string, Workflow] =
    for line in input.splitLines():
        var workflow: Workflow
        let words = line.split({'{', '}'})
        let flows = words[1].split(',')
        for flow in flows[0..^2]:
            let e = parseEval(flow)
            workflow.evals.add(e)
        workflow.final = flows[^1]
        result[words[0]] = workflow

proc parseParts(input: string): seq[Part] =
    for line in input.splitLines():
        let (valid, x, m, a, s) = line.scanTuple("{x=$i,m=$i,a=$i,s=$i}")
        if valid:
            let p = (x, m, a, s)
            result.add(p)

proc cmp(lhs, rhs: int, lt: bool): bool =
    if lt: return lhs < rhs
    else: return lhs > rhs

proc checkEval(p: Part, eval: Eval): bool =
    case eval.rating:
        of "x": return cmp(p.x, eval.val, eval.lt)
        of "m": return cmp(p.m, eval.val, eval.lt)
        of "a": return cmp(p.a, eval.val, eval.lt)
        of "s": return cmp(p.s, eval.val, eval.lt)
        else: assert(false, "Invalid character")

proc checkApproval(p: Part, workflows: Table[string, Workflow]): bool =
    var name = "in"
    while true:
        if name == "A": return true
        if name == "R": return false
        let workflow = workflows[name]
        var found = false
        for eval in workflow.evals:
            let early = checkEval(p, eval)
            if early:
                name = eval.approve
                found = true
                break
        if not found:
            name = workflow.final

proc findRange(workflows: Table[string, Workflow]): int =
    let first = newWorkflowRange("in")
    var stack: seq[WorkflowRange]
    stack.add(first)
    while stack.len() > 0:
        var current = stack.pop()
        if current.name == "A":
            var total = 1
            for v in current.xmas.values():
                total *= v.size()
            result += total
            continue
        if current.name == "R": continue
        let flows = workflows[current.name]
        for eval in flows.evals:
            var next = current
            if eval.lt:
                if current.xmas[eval.rating].contains(eval.val):
                    let split = current.xmas[eval.rating].split(eval.val, false)
                    current.xmas[eval.rating] = split[1]
                    next.xmas[eval.rating] = split[0]
                    next.name = eval.approve
                    stack.add(next)
                elif current.xmas[eval.rating].right() < eval.val:
                    next.name = eval.approve
                    stack.add(next)
                    break
            else:
                if current.xmas[eval.rating].contains(eval.val):
                    let split = current.xmas[eval.rating].split(eval.val, true)
                    current.xmas[eval.rating] = split[0]
                    next.xmas[eval.rating] = split[1]
                    next.name = eval.approve
                    stack.add(next)
                elif current.xmas[eval.rating].left() > eval.val:
                    next.name = eval.approve
                    stack.add(next)
                    break
        current.name = flows.final
        stack.add(current)

proc day19p1*(input: string): string =
    let blocks = input.split("\n\n")
    let workflows = parseWorkflows(blocks[0])
    let parts = parseParts(blocks[1])
    var total = 0
    for part in parts:
        let approved = checkApproval(part, workflows)
        if approved:
            total += part.x + part.m + part.a + part.s
    return $total

proc day19p2*(input: string): string =
    let blocks = input.split("\n\n")
    let workflows = parseWorkflows(blocks[0])
    let total = findRange(workflows)
    return $total
