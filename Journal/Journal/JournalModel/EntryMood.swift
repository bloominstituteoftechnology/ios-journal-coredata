
import Foundation
import UIKit
import CoreData

enum EntryMood : String {
	case DeeplyUnhappy = "🙃"
	case Dissatisfied = "😕"
	case Fine = "🙂"
	case Joyful = "😋"

	static let all:[EntryMood] = [.DeeplyUnhappy, .Dissatisfied, .Fine, .Joyful]
}
