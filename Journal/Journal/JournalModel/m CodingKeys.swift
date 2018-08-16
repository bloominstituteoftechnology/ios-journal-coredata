
import Foundation
import UIKit

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
