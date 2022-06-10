//
//  WeakBox.swift
//  SetappSample-Catalyst
//
//  Created by Aleksandr.Bilous on 29.04.2022.
//

import Foundation

struct WeakBox<Value: AnyObject> {
  weak var value: Value?
  
  init(value: Value) {
    self.value = value
  }
}
