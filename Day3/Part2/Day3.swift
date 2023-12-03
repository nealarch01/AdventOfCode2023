import Foundation

guard let fileContents = try? String(contentsOfFile: "Input.txt") else {
    print("An error occured reading input file...")
    exit(1)
}

let inputs = fileContents.components(separatedBy: "\n")

func isSymbol(_ character: Character) -> Bool {
    return !character.isNumber && character != Character(".")
}



func findAdjacentGearRatioSum(_ inputs: [String]) -> Int {
    let numberRegex = try! Regex(#"[0-9]+"#)
    var sum = 0

    func getAdjacentNumber(_ rowIndex: Int, _ columnIndex: Int) -> Int {
        let numbersInRow = inputs[rowIndex].ranges(of: numberRegex)

        for numberInRow in numbersInRow {
            let startingIndex = inputs[rowIndex].distance(from: inputs[rowIndex].startIndex, to: numberInRow.lowerBound)
            let endingIndex = inputs[rowIndex].distance(from: inputs[rowIndex].startIndex, to: numberInRow.upperBound)

            if columnIndex >= startingIndex && columnIndex <= endingIndex {
                // Get the number
                let number = String(inputs[rowIndex][numberInRow])
                
                return Int(number)!
            }
        }

        fatalError("This probably shouldn't happen..")
    }

   func isNumber(_ rowIndex: Int, _ columnIndex: Int) -> Bool {
        let columnIndex = inputs[rowIndex].index(inputs[rowIndex].startIndex, offsetBy: columnIndex)
        return inputs[rowIndex][columnIndex].isNumber
    }

    func checkLeft(_ rowIndex: Int, _ columnIndex: Int) -> Int? {
        let columnIndex = columnIndex - 1
        if columnIndex < 0 { return nil }

        return isNumber(rowIndex, columnIndex) ? getAdjacentNumber(rowIndex, columnIndex) : nil
    }

    func checkRight(_ rowIndex: Int, _ columnIndex: Int) -> Int? {
        let columnIndex = columnIndex + 1
        if columnIndex >= inputs[rowIndex].count { return nil }

        return isNumber(rowIndex, columnIndex) ? getAdjacentNumber(rowIndex, columnIndex) : nil
    }

    func checkUp(_ rowIndex: Int, _ columnIndex: Int) -> (right: Int?, left: Int?) {
        let rowIndex = rowIndex - 1
        if rowIndex < 0 { return (nil, nil) }

        if isNumber(rowIndex, columnIndex) { return (getAdjacentNumber(rowIndex, columnIndex), nil) }

        return (checkRight(rowIndex, columnIndex), checkLeft(rowIndex, columnIndex))
    }

    func checkDown(_ rowIndex: Int, _ columnIndex: Int) -> (right: Int?, left: Int?) {
        let rowIndex = rowIndex + 1
        if rowIndex >= inputs.count { return (nil, nil) }

        if isNumber(rowIndex, columnIndex) { return (getAdjacentNumber(rowIndex, columnIndex), nil) }

        return (checkRight(rowIndex, columnIndex), checkLeft(rowIndex, columnIndex))
    }

    for (rowIndex, rowValues) in inputs.enumerated() {
        for (columnIndex, columnValue) in rowValues.enumerated() {
            // Check if the current character is a symbol
            if !isSymbol(columnValue) { continue }

            var adjacentNumbers = [Int?]()

            // Check right
            adjacentNumbers.append(checkLeft(rowIndex, columnIndex))

            // Check right
            adjacentNumbers.append(checkRight(rowIndex, columnIndex))

            // Check up
            let topValues = checkUp(rowIndex, columnIndex)
            adjacentNumbers.append(topValues.right)
            adjacentNumbers.append(topValues.left)

            // Check down
            let bottomValues = checkDown(rowIndex, columnIndex)
            adjacentNumbers.append(bottomValues.right)
            adjacentNumbers.append(bottomValues.left)

            let compactedNumbers = adjacentNumbers.compactMap { $0 }

            if compactedNumbers.isEmpty || compactedNumbers.count == 1 { continue }

            sum += compactedNumbers.reduce(1, { $0 * $1 })
        }
    }

    return sum
}


let sum = findAdjacentGearRatioSum(inputs)
print(sum)
