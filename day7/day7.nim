import algorithm, sequtils, strutils, tables

var jokers_wild = false

const CARD_VALS = {
    'A': 14, 'K': 13, 'Q': 12, 'J': 11, 'T': 10, '9': 9,
    '8': 8, '7': 7, '6': 6, '5': 5, '4': 4, '3': 3, '2': 2,
}.toTable

type PokerType = enum
    JUNK,
    ONE_PAIR,
    TWO_PAIR,
    THREE_OF_A_KIND,
    FULL_HOUSE,
    FOUR_OF_A_KIND,
    FIVE_OF_A_KIND,

type Hand = object
    cards: seq[char]
    bid: int

proc getValue(c: char): int =
    if c == 'J' and jokers_wild:
        return 1
    return CARD_VALS[c]

proc sortCards(lhs, rhs: seq[char]): int =
    for i in countup(0, 4):
        if lhs[i] != rhs[i]:
            return lhs[i].getValue() - rhs[i].getValue()
    return 0

proc newHand(cards: string, bid: int): Hand =
    result.cards = cards.items().toSeq()
    result.bid = bid

proc parseInput(input: string): seq[Hand] =
    for line in input.splitLines():
        let s = line.split(' ')
        result.add(newHand(s[0], parseInt(s[1])))

proc handType(h: Hand): PokerType =
    var matches = toCountTable(h.cards)
    let num_jokers = if jokers_wild: matches.getOrDefault('J') else: 0
    if num_jokers == 5: return FIVE_OF_A_KIND
    if jokers_wild: matches.del('J')
    let (bv, best) = matches.largest()
    case (best + num_jokers):
        of 5: return FIVE_OF_A_KIND
        of 4: return FOUR_OF_A_KIND
        of 3:
            let (_, worst) = matches.smallest()
            if worst == 2: return FULL_HOUSE
            else: return THREE_OF_A_KIND
        of 2:
            matches.del(bv)
            let (_, second_best) = matches.largest()
            if second_best == 2: return TWO_PAIR
            else: return ONE_PAIR
        else: return JUNK

proc sortHands(lhs, rhs: Hand): int =
    let left_type = lhs.handType()
    let right_type = rhs.handType()
    if left_type != right_type:
        return ord(left_type) - ord(right_type)
    return sortCards(lhs.cards, rhs.cards)

proc day7p1*(input: string): string =
    let hands = parseInput(input)
    let s_hands = sorted(hands, sortHands)
    var total = 0
    for idx, h in s_hands.pairs():
        total += (idx + 1) * h.bid
    return $total

proc day7p2*(input: string): string =
    # Global variable hack :)
    jokers_wild = true
    let hands = parseInput(input)
    let s_hands = sorted(hands, sortHands)
    var total = 0
    for idx, h in s_hands.pairs():
        total += (idx + 1) * h.bid
    return $total
