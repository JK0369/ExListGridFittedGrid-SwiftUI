//
//  PhotoModel.swift
//  ExListGridFittedGrid
//
//  Created by 김종권 on 2022/09/26.
//

struct PhotoModel: Codable {
  struct Item: Codable {
    struct Media: Codable {
      let m: String
    }
    let media: Media
    let description: String
  }
  let items: [Item]
}

extension PhotoModel {
  var url: String? {
    items.first?.media.m
  }
  var photoUrlStrings: [String] {
    items.map(\.media.m)
  }
  var coreItems: [(String, String)] {
    var res = [(String, String)]()
    for i in 0..<items.count {
      res.append((items[i].media.m, items[i].description))
    }
    return res
  }
}
