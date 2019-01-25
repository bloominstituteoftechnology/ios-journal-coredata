import Foundation

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        
        case bodyText
        case title
        case timeStamp
        case identifier
        case mood
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(title, forKey: .title)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mood, forKey: .mood)
        
    }
    
    
}
