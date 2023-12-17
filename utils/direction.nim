import tables
import point

type Direction* = enum
    NORTH, SOUTH, EAST, WEST

const LEFT* = {
    NORTH: WEST, WEST: SOUTH, SOUTH: EAST, EAST: NORTH
}.toTable

const RIGHT* = {
    NORTH: EAST, EAST: SOUTH, SOUTH: WEST, WEST: NORTH
}.toTable

const DELTA*: Table[Direction, Point] = {
    NORTH: (0, -1), SOUTH: (0, 1), EAST: (1, 0), WEST: (-1, 0)
}.toTable
