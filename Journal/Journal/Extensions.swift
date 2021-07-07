//
//  Extensions.swift
//  Journal
//
//  Created by Bradley Diroff on 3/24/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation

extension DateFormatter {
  static var shortFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
  }()
}
