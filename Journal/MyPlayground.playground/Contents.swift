import UIKit

let date = Date()
let formated = DateFormatter()
formated.dateFormat = "yyyy-MM-dd  hh:mm a"

print(formated.string(from: date))
