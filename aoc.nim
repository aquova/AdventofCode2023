import os, strutils, tables

type DayProc = proc(input: string): string

import day1/day1

const FUNCTION_TABLE = {
  "day1p1": DayProc(day1p1), "day1p2": DayProc(day1p2),
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
