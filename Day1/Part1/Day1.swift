import Foundation

func findCalibrationValue(_ value: String) -> String {
    // Put all the numbers into an array
    let allNumbers = value.filter { $0.isNumber }
    let firstNumber = String(allNumbers.first ?? Character(""))
    let secondNumber = String(allNumbers.last ?? Character(""))
    return String(firstNumber + secondNumber)
}

guard let fileContents = try? String(contentsOfFile: "Input.txt") else {
    print("An error occured reading input file...")
    exit(1)
}

let inputs = fileContents.components(separatedBy: "\n")

var sum: Int = 0
inputs.forEach { input in
    let calibrationValue = Int(findCalibrationValue(input))!
    sum += calibrationValue
}

print("The sum is: \(sum)")

// Part two

