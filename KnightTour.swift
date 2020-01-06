//
//  KnightAll64.swift
//  testKnight
//
//  Created by Praharsh Kalliyatt Panoli on 04/12/19.
//  Copyright © 2019 Praharsh Kalliyatt Panoli. All rights reserved.
//

import Foundation

let rowMax = 3
let colMax = 7
// how to move knight to all 64 squares in a sequence
class Square: Printable {
  let row: Int
  let col: Int
  var visited = false
  var neighbors: [(row: Int, col: Int)] = []
  var nextNeighborToScan = -1
  
  init(row:Int, col: Int) {
    self.row = row
    self.col = col
    loadNeighbors()
  }
  
  func loadNeighbors() {
    let tempNeighbors: [(row: Int, col: Int)] = [(self.row + 2, self.col + 1),
                                                 (self.row + 2, self.col - 1),
                                                 (self.row - 2, self.col + 1),
                                                 (self.row - 2, self.col - 1),
                                                 (self.row + 1, self.col + 2),
                                                 (self.row + 1, self.col - 2),
                                                 (self.row - 1, self.col + 2),
                                                 (self.row - 1, self.col - 2)]
    self.neighbors = tempNeighbors.filter({ (row: Int, col: Int) -> Bool in
      return ((row >= 0) && (row <= rowMax) && (col >= 0) && (col <= colMax))
    })
  }
  
  func printMe() -> String {
    //First Convert Column to A-H
    let file = ["A","B","C","D","E","F","G","H"][col]
    return ("row: \(row) col: \(col) square: \(file)\(row + 1)")
  }
  
  func nextNeighbor() -> (row: Int, col: Int)? {
    nextNeighborToScan = nextNeighborToScan + 1
    if ((nextNeighborToScan >= 0) && (nextNeighborToScan < neighbors.count )) {
      return self.neighbors[nextNeighborToScan]
    } else {
      nextNeighborToScan = -1
      return nil
    }
  }
}

protocol Printable {
  func printMe() -> String
}

struct Stack<T: Printable>  {
  var stackArray: [T] = []
  var maxCount = 0
  
  mutating func push(newItem: T) {
    stackArray.append(newItem)
  }
  
  mutating func pop() -> T? {
    let currentCount = count()
    if (currentCount > maxCount) {
      maxCount = currentCount
      print("Count is \(maxCount) now.  Currnet Stack is the biggest So far... Let's print it")
      printAll()
    }
    return stackArray.removeLast()
  }
  
  func peek() -> T? {
    return stackArray.last
  }
  
  func count() -> Int {
    return stackArray.count
  }
  
  func printAll() {
    if stackArray.count > 0 {
      for elementNumber in 0...(self.stackArray.count - 1) {
        print(" \(elementNumber) >> \(self.stackArray[elementNumber].printMe())")
      }
    }
    else{
      print("Nothing to print")
    }
  }
}

func findKnightSeq() {
  
  // Create stack
  var squareStack = Stack<Square>()

  // Create all Squares
  var squares: [Square] = []
  for i in 0...rowMax {
    for j in 0...colMax {
      squares.append(Square(row: i, col: j))
    }
  }
    
  // Mark first Square
  let square00 = squares[0]
  square00.visited = true
  squareStack.push(newItem: square00)
  let total = (rowMax + 1) * (colMax + 1)
  while ((squareStack.count() < total) && (squareStack.count() != 0)) {
    // get top from stack
    let topOfStack = squareStack.peek()
    //print("adding to stack : " + (topOfStack?.printMe() ?? ""))
    topOfStack?.visited = true
    var neighborScanDone = false
    while(!neighborScanDone) {
      // get next neighbour tuple
      if let next = topOfStack?.nextNeighbor() {
        let nextNeighbor = squares[(next.row * (colMax + 1) + next.col)]
        if !nextNeighbor.visited {
          neighborScanDone = true
          squareStack.push(newItem: nextNeighbor)
          //print(nextNeighbor.printMe())
        }
      } else {
        topOfStack?.visited = false
        _ = squareStack.pop()
        neighborScanDone = true
      }
    }
  }
  
  print("printing whole stack")
  squareStack.printAll()
}
