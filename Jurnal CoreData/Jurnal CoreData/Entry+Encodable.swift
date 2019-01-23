//
//  Entry+Encodable.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/23/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation

extension Entry: Encodable  {

    enum CodingKeys: String {

       case bodyText = "bodyText"
       case identifier = "identifier"
       case mood = "mood"
       case timestamp =  "timestamp"
       case title = "title"


        }
    
    public func encode(to encoder: Encoder) throws {
        var container = container(keyedBy: CodingKeys.self)
        
    }
    }


