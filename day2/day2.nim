import strutils

const RED_MAX = 12
const GREEN_MAX = 13
const BLUE_MAX = 14

type Cube = tuple
    r, g, b: int

proc isValid(self: Cube): bool =
    return self.r <= RED_MAX and self.g <= GREEN_MAX and self.b <= BLUE_MAX

proc getPower(self: Cube): int =
    return self.r * self.g * self.b

proc parseCube(input: string): Cube =
    result.r = 0
    result.g = 0
    result.b = 0
    let blocks = input.split({':', ',', ';'})
    for b in blocks:
        let words = b.strip(leading=true, trailing=true).split(" ")
        case words[1]:
            of "red":
                result.r = max(result.r, parseInt(words[0]))
            of "green":
                result.g = max(result.g, parseInt(words[0]))
            of "blue":
                result.b = max(result.b, parseInt(words[0]))
            else:
                discard

proc day2p1*(input: string): string =
    var total = 0
    for idx, line in input.splitLines().pairs():
        let cube = line.parseCube()
        if cube.isValid():
            total += idx + 1
    return $total

proc day2p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let cube = line.parseCube()
        total += cube.getPower()
    return $total
