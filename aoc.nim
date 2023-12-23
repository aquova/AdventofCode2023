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
import day12/day12
import day13/day13
import day14/day14
import day15/day15
import day16/day16
import day17/day17
import day18/day18
import day19/day19
import day20/day20
import day21/day21
import day22/day22

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
  "day12p1": DayProc(day12p1), "day12p2": DayProc(day12p2),
  "day13p1": DayProc(day13p1), "day13p2": DayProc(day13p2),
  "day14p1": DayProc(day14p1), "day14p2": DayProc(day14p2),
  "day15p1": DayProc(day15p1), "day15p2": DayProc(day15p2),
  "day16p1": DayProc(day16p1), "day16p2": DayProc(day16p2),
  "day17p1": DayProc(day17p1), "day17p2": DayProc(day17p2),
  "day18p1": DayProc(day18p1), "day18p2": DayProc(day18p2),
  "day19p1": DayProc(day19p1), "day19p2": DayProc(day19p2),
  "day20p1": DayProc(day20p1), "day20p2": DayProc(day20p2),
  "day21p1": DayProc(day21p1), "day21p2": DayProc(day21p2),
  "day22p1": DayProc(day22p1), "day22p2": DayProc(day22p2),
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
