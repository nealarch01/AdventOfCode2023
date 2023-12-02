import Foundation

guard let fileContents = try? String(contentsOfFile: "Input.txt") else {
    print("An error occured reading input file...")
    exit(1)
}

let inputs = fileContents.components(separatedBy: "\n")

let numbers = [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
]

func findCalibrationValue(_ input: String) -> Int {
    var indexes = [Int:String]()

    // Find all the spelled out numbers
    for (index, element) in numbers.enumerated() {
        let substringRanges = input.ranges(of: element) 
        for substringRange in substringRanges {
            let substringStartIndex = input.distance(from: input.startIndex, to: substringRange.lowerBound)
            indexes[substringStartIndex] = String(index + 1)
        }
    }

    // Find the shorthand digits
    for (index, element) in input.enumerated() {
        if element.isNumber {
            indexes[index] = String(element)
        }
    }

    let keys = indexes.map { $0.key }
    let min = keys.min()!
    let max = keys.max()!

    return Int(indexes[min]! + indexes[max]!)!
}

var count = 1
var sum = 0
for input in inputs {
    let calibrationValue = findCalibrationValue(input)
    sum += calibrationValue
}

print("The sum is: \(sum)")
