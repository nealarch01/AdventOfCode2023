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

func isGamePossible(_ game: String) -> Bool {
    let gameSets = getGameSets(game)
    for gameSet in gameSets {
        var redCount: Int = 0
        var greenCount: Int = 0
        var blueCount: Int = 0
        
        let cubes = gameSet.components(separatedBy: ",")

        for cube in cubes {
            let cube = cube.trimmingCharacters(in: .whitespacesAndNewlines)
            let cubeCount = Int(String(cube.components(separatedBy: " ").first!))! // 😬
            if cube.contains("red") {
                redCount += cubeCount
            } else if cube.contains("green") {
                greenCount += cubeCount
            } else {
                blueCount += cubeCount
            }
        }

        if redCount > RedCubesTotal || greenCount > GreenCubesTotal || blueCount > BlueCubesTotal {
            return false
        }
    }
    return true
}

var games = fileContents.components(separatedBy: "\n").map { removeGamePrefix($0) }

var gameIDSum = 0
for (index, game) in games.enumerated() {
    if isGamePossible(game) {
        gameIDSum += (index + 1)
    }
}

print("The sum of possible games is: \(gameIDSum)")
