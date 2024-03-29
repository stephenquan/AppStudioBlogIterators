function solve(x, y) {
  return _asyncToGenerator(function*() {
    maze[y][x] = someDude
    printDaMaze()
    yield timer.sleep(100)
    if (x === endingPoint[0] && y === endingPoint[1]) return true
    if (x > 0 && maze[y][x - 1] === free && (yield solve(x - 1, y))) return true
    if (x < mazeWidth && maze[y][x + 1] === free && (yield solve(x + 1, y))) return true
    if (y > 0 && maze[y - 1][x] === free && (yield solve(x, y - 1))) return true
    if (y < mazeHeight && maze[y + 1][x] === free && (yield solve(x, y + 1))) return true
    maze[y][x] = free
    printDaMaze()
    yield timer.sleep(100)
    return false
  } )()
}
