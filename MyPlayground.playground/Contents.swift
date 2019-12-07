import UIKit

var str = "Hello, playground"

func printNumbers(upto n: Int) {
    for number in 1...n {
        var count = 0
        for num in 1..<number {
            if number % num == 0 {
                count += 1
            }
        }
        if count <= 1 {
            print(number, "is prime")
        }
    }
}

printNumbers(upto: 100)
