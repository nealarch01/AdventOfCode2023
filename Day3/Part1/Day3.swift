import Foundation

guard let fileContents = try? String(contentsOfFile: "Input.txt") else {
    print("An error occured reading input file...")
    exit(1)
}

let inputs = fileContents.components(separatedBy: "\n")

func isSymbol(_ character: Character) -> Bool {
    return !character.isNumber && character != Character(".")
}

func findAdjacentNumbers(_ inputs: [String]) -> Int {
    var inputs = inputs // Mutable variable

    let numberRegex = try! Regex(#"[0-9]+"#)

    var sum = 0

    func crossOutNumber(_ rowIndex: Int, _ columnIndex: Int) {
        let numbersInRow = inputs[rowIndex].ranges(of: numberRegex)

        for numberInRow in numbersInRow {
            let startingIndex = inputs[rowIndex].distance(from: inputs[rowIndex].startIndex, to: numberInRow.lowerBound)
            let endingIndex = inputs[rowIndex].distance(from: inputs[rowIndex].startIndex, to: numberInRow.upperBound)

            if columnIndex >= startingIndex && columnIndex <= endingIndex {
                // Get the number
                let number = String(inputs[rowIndex][numberInRow])

                // Add to the running sum
                sum += Int(number)!

                // Remove the number
                inputs[rowIndex].replaceSubrange(numberInRow, with: String(repeating: ".", count: number.count))
            }
        }
    }

    func isNumber(_ rowIndex: Int, _ columnIndex: Int) -> Bool {
        let columnIndex = inputs[rowIndex].index(inputs[rowIndex].startIndex, offsetBy: columnIndex)
        return inputs[rowIndex][columnIndex].isNumber
    }

    func checkLeft(_ rowIndex: Int, _ columnIndex: Int) {
        let columnIndex = columnIndex - 1
        if columnIndex < 0 { return }
        if isNumber(rowIndex, columnIndex) { crossOutNumber(rowIndex, columnIndex) }
    }

    func checkRight(_ rowIndex: Int, _ columnIndex: Int) {
        let columnIndex = columnIndex + 1
        if columnIndex >= inputs[rowIndex].count { return }
        if isNumber(rowIndex, columnIndex) { crossOutNumber(rowIndex, columnIndex) }
    }

    func checkUp(_ rowIndex: Int, _ columnIndex: Int) {
        let rowIndex = rowIndex - 1
        if rowIndex < 0 { return }
        if isNumber(rowIndex, columnIndex) { crossOutNumber(rowIndex, columnIndex) }
        checkRight(rowIndex, columnIndex)
        checkLeft(rowIndex, columnIndex)
    }

    func checkDown(_ rowIndex: Int, _ columnIndex: Int) {
        let rowIndex = rowIndex + 1
        if rowIndex >= inputs.count { return }
        if isNumber(rowIndex, columnIndex) { crossOutNumber(rowIndex, columnIndex) }
        checkRight(rowIndex, columnIndex)
        checkLeft(rowIndex, columnIndex)
    }

    for (rowIndex, rowValues) in inputs.enumerated() {
        for (columnIndex, columnValue) in rowValues.enumerated() {
            // Check if the current character is a symbol
            if !isSymbol(columnValue) { continue }
            // Check right
            checkLeft(rowIndex, columnIndex)

            // Check right
            checkRight(rowIndex, columnIndex)

            // Check up
            checkUp(rowIndex, columnIndex)

            // Check down
            checkDown(rowIndex, columnIndex)
        }
    }

    return sum
}

let sum = findAdjacentNumbers(inputs)
print(sum)
