import Foundation

guard let fileContents = try? String(contentsOfFile: "Input.txt") else {
    print("An error occured reading input file...")
    exit(1)
}

let inputs = fileContents.components(separatedBy: "\n")
