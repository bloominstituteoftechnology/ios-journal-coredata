//
//  UIView+Layout.swift
//  Currency Swap
//
//  Created by Shawn Gee on 2/12/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

extension UIView {
    enum Axis {
        case horizontal, vertical
    }
    
    @discardableResult
    func centerInSuperview(_ axis: Axis? = nil, multiplier: CGFloat = 1.0) -> UIView {
        guard let superview = superview else { fatalError("View has no superview center in")}
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let axis = axis else {
            return self.centerInSuperview(.horizontal).centerInSuperview(.vertical)
        }
        
        switch axis {
        case .horizontal:
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: multiplier, constant: 0).isActive = true
        case .vertical:
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: multiplier, constant: 0).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    func fillSuperview(_ axis: Axis? = nil) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { fatalError("View has no superview fill")}
        
        guard let axis = axis else {
            return self.fillSuperview(.horizontal).fillSuperview(.vertical)
        }
        
        switch axis {
        case .horizontal:
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            ])
        case .vertical:
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            ])
        }
        return self
    }
    
    @discardableResult
      func constrain(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
          self.translatesAutoresizingMaskIntoConstraints = false
          if let width = width {
              self.widthAnchor.constraint(equalToConstant: width).isActive = true
          }
          if let height = height {
              self.heightAnchor.constraint(equalToConstant: height).isActive = true
          }
          return self
      }
}

