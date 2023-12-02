import re, strutils

const RED_MAX = 12
const GREEN_MAX = 13
const BLUE_MAX = 14

proc isValid(input: string): bool =
    let red_matches = input.findAll(re"\d+ red")
    for r in red_matches:
        let words = r.split(" ")
        if parseInt(words[0]) > RED_MAX:
            return false

    let green_matches = input.findAll(re"\d+ green")
    for g in green_matches:
        let words = g.split(" ")
        if parseInt(words[0]) > GREEN_MAX:
            return false

    let blue_matches = input.findAll(re"\d+ blue")
    for b in blue_matches:
        let words = b.split(" ")
        if parseInt(words[0]) > BLUE_MAX:
            return false
    return true

proc getPower(input: string): int =
    var r_power, g_power, b_power = 0

    let red_matches = input.findAll(re"\d+ red")
    for r in red_matches:
        let words = r.split(" ")
        r_power = max(r_power, parseInt(words[0]))

    let green_matches = input.findAll(re"\d+ green")
    for g in green_matches:
        let words = g.split(" ")
        g_power = max(g_power, parseInt(words[0]))

    let blue_matches = input.findAll(re"\d+ blue")
    for b in blue_matches:
        let words = b.split(" ")
        b_power = max(b_power, parseInt(words[0]))
    return r_power * g_power * b_power

proc day2p1*(input: string): string =
    var total = 0
    for idx, line in input.splitLines().pairs():
        let valid = line.isValid()
        if valid:
            total += idx + 1
    return $total

proc day2p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        total += line.getPower()
    return $total
