from algorithm import sorted

type Range*[T] = object
    left, right: T

proc newRange*[T](left: T, right: T): Range[T] =
    result.left = left
    result.right = right

proc contains*[T](r:Range[T], v: T): bool =
    return r.left <= v and v <= r.right

proc overlaps*[T](a: Range[T], b: Range[T]): bool =
    return a.contains(b.left) or a.contains(b.right)

proc merge*[T](a: Range[T], b: Range[T]): Range[T] =
    return newRange(min(a.left, b.left), max(a.right, b.right))

proc cmp*[T](a: Range[T], b: Range[T]): int =
    return system.cmp(a.left, b.left)

proc combine*[T](ranges: seq[Range[T]]): seq[Range[T]] =
    let sorted = sorted(ranges, cmp)
    var current = sorted[0]
    var idx = 1
    while idx < sorted.len():
        let other = sorted[idx]
        if current.overlaps(other):
            current = current.merge(other)
        else:
            result.add(current)
            current = other
        inc(idx)
    result.add(current)

proc size*[T](r: Range[T]): T =
    return r.right - r.left + 1

