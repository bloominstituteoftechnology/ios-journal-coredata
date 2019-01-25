
import Foundation

// "Since you're using 'Class Definition' codegen in your data model, you don't have access to the Entry class directly. The effec this has is that when you adopt Encodable, its required method can't be synthesized for you.

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        
        case title = "title"
        case bodyText = "bodyText"
        case timestamp = "timeStamp"
        case identifier = "identifier"
        case mood = "mood"
        
    }
    
    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode each of the 5 attributes of the Entry individually
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mood, forKey: .mood)
        
    }
    
    
    
    
    
    
}
