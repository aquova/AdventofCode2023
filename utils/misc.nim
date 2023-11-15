proc find*[T](list: seq[T], v: T): T =
    for idx, item in list.pairs():
        if item == v:
            return idx

proc sign*(v: int): int =
    if v > 0:
        return 1
    elif v < 0:
        return -1
    return 0

proc `-`*[T](a: seq[T], b: seq[T]): seq[T] =
    for i in a:
        if i notin b:
            result.add(i)
