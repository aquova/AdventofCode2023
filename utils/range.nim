type Range*[T] = object
    left, right: T

proc newRange*[T](left, right: T): Range[T] =
    if left < right:
        result.left = left
        result.right = right
    else:
        result.left = right
        result.right = left

proc contains*[T](r:Range[T], v: T): bool =
    return r.left <= v and v <= r.right

proc overlaps*[T](a: Range[T], b: Range[T]): bool =
    return a.contains(b.left) or a.contains(b.right)

proc merge*[T](a: Range[T], b: Range[T]): Range[T] =
    return newRange(min(a.left, b.left), max(a.right, b.right))

proc cmp*[T](a: Range[T], b: Range[T]): int =
    return system.cmp(a.left, b.left)

proc size*[T](r: Range[T]): T =
    return r.right - r.left + 1

