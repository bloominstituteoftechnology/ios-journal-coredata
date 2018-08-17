
import Foundation
import UIKit
import CoreData

struct EntryStub: Equatable, Codable
{
	var title:String
	var text:String
	var timestamp:Date
	var identifier:String
	var mood:String

	static func ==(l:EntryStub, r:JournalEntry) ->Bool
	{
		return l.identifier == r.getIdSafely()
	}
}
