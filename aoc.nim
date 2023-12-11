import os, strutils, tables

type DayProc = proc(input: string): string

import day1/day1
import day2/day2
import day3/day3
import day4/day4
import day5/day5
import day6/day6
import day7/day7
import day8/day8
import day9/day9
import day10/day10
import day11/day11

const FUNCTION_TABLE = {
  "day1p1": DayProc(day1p1), "day1p2": DayProc(day1p2),
  "day2p1": DayProc(day2p1), "day2p2": DayProc(day2p2),
  "day3p1": DayProc(day3p1), "day3p2": DayProc(day3p2),
  "day4p1": DayProc(day4p1), "day4p2": DayProc(day4p2),
  "day5p1": DayProc(day5p1), "day5p2": DayProc(day5p2),
  "day6p1": DayProc(day6p1), "day6p2": DayProc(day6p2),
  "day7p1": DayProc(day7p1), "day7p2": DayProc(day7p2),
  "day8p1": DayProc(day8p1), "day8p2": DayProc(day8p2),
  "day9p1": DayProc(day9p1), "day9p2": DayProc(day9p2),
  "day10p1": DayProc(day10p1), "day10p2": DayProc(day10p2),
  "day11p1": DayProc(day11p1), "day11p2": DayProc(day11p2),
}.toTable()

proc main() =
  if paramCount() < 2:
    echo("./aoc dayXpY path/to/input.txt")
    quit(0)

  var f: File
  let function_name = paramStr(1)
  let input_name = paramStr(2)
  let success = f.open(input_name, FileMode.fmRead)
  if not success:
    echo("Unable to open " & input_name)
    quit(1)

  var input = f.readAll()
  input.stripLineEnd()

  echo(FUNCTION_TABLE[function_name](input))

when isMainModule:
  main()
