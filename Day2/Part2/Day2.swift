import Foundation

// Configuration
let RedCubesTotal = 12
let GreenCubesTotal = 13
let BlueCubesTotal = 14

guard let fileContents = try? String(contentsOfFile: "Input.txt") else {
    print("An error occured reading input file...")
    exit(1)
}

// Removes "Game x: "
func removeGamePrefix(_ game: String) -> String {
    let expression = try! Regex(#"Game [0-9]+[:] "#)
    return String(game.trimmingPrefix(expression))
}

// Gets the 3 sets of times the elf shows the cube
func getGameSets(_ game: String) -> [String] {
    return game.components(separatedBy: ";")
}

var games = fileContents.components(separatedBy: "\n").map { removeGamePrefix($0) }

func minimumSetOfCubes(_ game: String) -> Int {
    var maxRed = 0
    var maxGreen = 0
    var maxBlue = 0

    let gameSets = getGameSets(game)
    for gameSet in gameSets {
        let cubes = gameSet.components(separatedBy: ",")

        for cube in cubes {
            let cube = cube.trimmingCharacters(in: .whitespacesAndNewlines)
            let cubeCount = Int(String(cube.components(separatedBy: " ").first!))! // 😬
            if cube.contains("red") {
                if cubeCount > maxRed { maxRed = cubeCount }
            } else if cube.contains("green") {
                if cubeCount > maxGreen { maxGreen = cubeCount }
            } else {
                if cubeCount > maxBlue { maxBlue = cubeCount }
            }
        }
    }

    return maxRed * maxGreen * maxBlue
}

var sum: Int = 0
for game in games {
    let power = minimumSetOfCubes(game)
    sum += power
}

print("The sum of possible games is: \(sum)")
