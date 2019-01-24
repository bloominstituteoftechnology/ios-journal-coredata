//
//  Entry+Encodable.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/23/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation

extension Entry: Encodable  {

    enum CodingKeys: String, CodingKey {

       case bodyText
       case identifier
       case mood
       case timestamp
       case title


        }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(bodyText, forKey: .bodyText)
            try container.encode(title, forKey: .title)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(identifier, forKey: .identifier)
            try container.encode(mood, forKey: .mood)
        } catch {
            print("could not encode keys")
        }
    }
    }


