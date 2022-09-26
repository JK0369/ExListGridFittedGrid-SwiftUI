//
//  ContentViewModel.swift
//  ExListGridFittedGrid
//
//  Created by 김종권 on 2022/09/26.
//

import Foundation
import UIKit

final class ContentViewModel: ObservableObject {
  @Published var photos = [Photo]()
  
  func fetchPhoto() {
    DispatchQueue.global().async {
      guard
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=texas&tagmode=any&format=json&nojsoncallback=1")
      else { return }
      URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
        guard
          let ss = self,
          let data = data,
          let photoModel = try? JSONDecoder().decode(PhotoModel.self, from: data)
        else { return }
        
        var newPhotos = [Photo]()
        photoModel
          .coreItems
          .forEach { urlString, description in
            let widthHeight = ss.getWidthHeight(description: description)
            if let uiImage = ImageCache.shared.object(forKey: urlString as NSString) {
              newPhotos.append(.init(url: urlString, uiImage: uiImage, width: widthHeight.0, height: widthHeight.1))
            } else {
              guard
                let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let uiImage = UIImage(data: data)
              else { return }
              ImageCache.shared.setObject(uiImage, forKey: urlString as NSString)
              newPhotos.append(.init(url: urlString, uiImage: uiImage, width: widthHeight.0, height: widthHeight.1))
            }
          }
        DispatchQueue.main.async {
          ss.photos = ss.photos + newPhotos
        }
      }.resume()
    }
  }
  
  private func getWidthHeight(description: String) -> (Double, Double) {
    let array = description.split(separator: " ").map(String.init)
    let widthStr = array
      .first(where: { $0.prefix(5) == "width" })!
      .replacingOccurrences(of: "\"", with: "")
      .replacingOccurrences(of: "width=", with: "")
    let heightStr = array
      .first(where: { $0.prefix(6) == "height" })!
      .replacingOccurrences(of: "\"", with: "")
      .replacingOccurrences(of: "height=", with: "")
    return (Double(widthStr)!, Double(heightStr)!)
  }
}

