import strutils

type Lens = tuple
    name: string
    val: int

proc newLens(word: string): Lens =
    let info = word.split('=')
    result.name = info[0]
    result.val = parseInt(info[1])

proc calcHASH(word: string): int =
    for c in word:
        result += ord(c)
        result *= 17
        result = result mod 256

proc addLens(boxes: var openArray[seq[Lens]], lens: Lens) =
    let box = lens.name.calcHASH()
    var found = false
    for idx, l in boxes[box].mpairs():
        if l.name == lens.name:
            found = true
            boxes[box][idx] = lens
            break
    if not found:
        boxes[box].add(lens)

proc removeLens(boxes: var openArray[seq[Lens]], id: string) =
    let label = id.split('-')[0]
    let box = label.calcHASH()
    for idx, l in boxes[box].mpairs():
        if l.name == label:
            boxes[box].delete(idx)
            break

proc day15p1*(input: string): string =
    let words = input.split(',')
    var sum = 0
    for word in words:
        sum += word.calcHASH()
    return $sum

proc day15p2*(input: string): string =
    let words = input.split(',')
    var boxes: array[0..255, seq[Lens]]
    for word in words:
        if word.contains('='):
            let lens = newLens(word)
            boxes.addLens(lens)
        else: # Contains '-'
            boxes.removeLens(word)
    var sum = 0
    for box_idx, box in boxes.pairs():
        if box.len() == 0: continue
        for lens_idx, lens in box.pairs():
            sum += (box_idx + 1) * (lens_idx + 1) * lens.val
    return $sum

