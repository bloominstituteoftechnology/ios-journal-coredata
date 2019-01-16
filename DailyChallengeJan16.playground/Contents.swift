import UIKit

func makeChange(forAmount: Double, withCost: Double) -> String {
    guard forAmount > withCost, forAmount > 0, withCost >= 0 else {
        return "You are not due any change."
    }
    var dollars = 0
    var quarters = 0
    var dimes = 0
    var nickels = 0
    var pennies = 0
    var changeDue = forAmount - withCost
    var dollarsString = ""
    var quartersString = ""
    var dimesString = ""
    var nickelsString = ""
    var penniesString = ""
    while changeDue != 0 {
        if changeDue >= 1.00 {
            changeDue -= 1.00
            dollars += 1
        }
        else if changeDue >= 0.25 {
            changeDue -= 0.25
            quarters += 1
        }
        else if changeDue >= 0.10 {
            changeDue -= 0.10
            dimes += 1
        }
        else if changeDue >= 0.05 {
            changeDue -= 0.05
            nickels += 1
        }
        else if changeDue >= 0.01 {
            changeDue -= 0.01
            pennies += 1
        }
    }
    if dollars != 1 {
        dollarsString = "\(dollars) dollars"
    } else {
        dollarsString = "\(dollars) dollar"
    }
    if quarters != 1 {
        quartersString = "\(quarters) quarters"
    } else {
        quartersString = "\(quarters) quarter"
    }
    if dimes != 1 {
        dimesString = "\(dimes) dimes"
    } else {
        dimesString = "\(dimes) dime"
    }
    if nickels != 1 {
        nickelsString = "\(nickels) nickels"
    } else {
        nickelsString = "\(nickels) nickel"
    }
    if dollars != 1 {
        penniesString = "\(pennies) pennies"
    } else {
        penniesString = "\(pennies) penny"
    }
    
    return "Your change is \(dollarsString), \(quartersString), \(dimesString), \(nickelsString) and \(penniesString)."
}

makeChange(forAmount: 5.00, withCost: 1.01)

//makeChange(fromAmount: 5.00, withCost: 2.15)  // returns "Your change is $2.85. That is 2 dollars, 3 quarters, 1 dime, 0 nickels and 0 pennies."
