//
//  Array+Extension.swift
//  ExListGridFittedGrid
//
//  Created by 김종권 on 2022/09/26.
//

import Foundation

extension Array {
  var splitTwoArray: [Self] {
    var res = [[Element]]()
    
    var list1 = [Element]()
    var list2 = [Element]()
    
    self
      .enumerated()
      .forEach { ind, val in
        ind % 2 == 0 ? list1.append(val) : list2.append(val)
      }
    
    res.append(list1)
    res.append(list2)
    
    return res
  }
}
