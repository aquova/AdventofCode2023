type IntRange* = object
    left, right: int

proc newIntRange*(left, right: int): IntRange =
    if left < right:
        result.left = left
        result.right = right
    else:
        result.left = right
        result.right = left

proc left*(r: IntRange): int = r.left
proc right*(r: IntRange): int = r.right

proc contains*(r:IntRange, v: int): bool =
    return r.left <= v and v <= r.right

proc overlaps*(a: IntRange, b: IntRange): bool =
    return a.contains(b.left) or a.contains(b.right)

proc merge*(a: IntRange, b: IntRange): IntRange =
    return newIntRange(min(a.left, b.left), max(a.right, b.right))

proc cmp*(a: IntRange, b: IntRange): int =
    return system.cmp(a.left, b.left)

proc size*(r: IntRange): int =
    return r.right - r.left + 1

# Split left puts v to the left half, otherwise the right
proc split*(r: IntRange, v: int, split_left: bool): seq[IntRange] =
    if not r.contains(v) or v == r.left or v == r.right: return @[r]
    let new_right = if split_left: v else: v - 1
    result.add(newIntRange(r.left, new_right))
    result.add(newIntRange(new_right + 1, r.right))
