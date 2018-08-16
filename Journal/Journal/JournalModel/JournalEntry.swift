
import Foundation
import UIKit
import CoreData

extension JournalEntry: Encodable
{
	convenience init(_ title:String, _ text:String, _ mood:EntryMood = EntryMood.Fine, moc:NSManagedObjectContext = CoreDataStack.shared.mainContext)
	{
		self.init(context: moc)
		self.title = title
		self.text = text
		self.timestamp = Date()
		self.identifier = UUID().uuidString
		self.mood = mood.rawValue
	}

	convenience init(_ stub:EntryStub, moc:NSManagedObjectContext = CoreDataStack.shared.mainContext)
	{
		self.init(context: moc)
		applyStub(stub)
	}

	func applyStub(_ stub:EntryStub)
	{
		self.title = stub.title
		self.text = stub.text
		self.timestamp = stub.timestamp
		self.identifier = stub.identifier
		self.mood = stub.mood
	}

	enum CodingKeys:CodingKey
	{
		case title
		case text
		case timestamp
		case identifier
		case mood
	}

	public func encode(to encoder: Encoder) throws
	{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: CodingKeys.title)
		try container.encode(text, forKey: CodingKeys.text)
		try container.encode(timestamp, forKey: CodingKeys.timestamp)
		try container.encode(getIdSafely(), forKey: CodingKeys.identifier)
		try container.encode(mood, forKey: CodingKeys.mood)
	}

	func getIdSafely() -> String
	{
		let id = self.identifier ?? UUID().uuidString
		self.identifier = id
		return id
	}

	func getStub() -> EntryStub
	{
		let stub:EntryStub = EntryStub(
			title: self.title ?? "nil",
			text: self.text ?? "nil",
			timestamp: self.timestamp ?? Date(),
			identifier: self.identifier ?? UUID().uuidString,
			mood: self.mood ?? EntryMood.Fine.rawValue)
		return stub
	}
}
