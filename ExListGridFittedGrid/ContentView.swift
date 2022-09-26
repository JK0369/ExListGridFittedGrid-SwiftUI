//
//  ContentView.swift
//  ExListGridFittedGrid
//
//  Created by 김종권 on 2022/09/26.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ContentViewModel()
  private var photoWidth: CGFloat {
    UIScreen.main.bounds.width
  }
  private var threeDividedWidth: CGFloat {
    (UIScreen.main.bounds.width - 20) / 3 // -20: 좌우 패딩
  }
  private var twoDividedWidth: CGFloat {
    (UIScreen.main.bounds.width - 20) / 2
  }
  
  init() {
    viewModel.fetchPhoto()
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        NavigationLink("List") {
          getList()
        }
        NavigationLink("Grid") {
          getGrid()
        }
        NavigationLink("FittedGrid") {
          getFittedGrid()
        }
      }
      .navigationTitle("사진")
    }
  }
  
  @ViewBuilder
  private func getList() -> some View {
    ScrollView {
      LazyVStack {
        ForEach(viewModel.photos) { photo in
          NavigationLink(
            destination: {
              getImage(photo: photo, forceWidth: photoWidth)
            },
            label: {
              getImage(photo: photo, forceWidth: photoWidth)
            }
          )
        }
      }
    }
  }
  
  @ViewBuilder
  private func getGrid() -> some View {
    let gridItems: [GridItem] = [
      GridItem(.fixed(threeDividedWidth)),
      GridItem(.fixed(threeDividedWidth)),
      GridItem(.fixed(threeDividedWidth))
    ]
    
    ScrollView {
      LazyVGrid(columns: gridItems) {
        ForEach(viewModel.photos) { photo in
          NavigationLink(
            destination: {
              getImage(photo: photo, forceWidth: threeDividedWidth)
            },
            label: {
              getImage(photo: photo, forceWidth: threeDividedWidth)
            }
          )
        }
      }
    }
  }
  
  @ViewBuilder
  private func getFittedGrid() -> some View {
    let splitTwoArray = viewModel.photos.splitTwoArray
    let array1 = splitTwoArray[0]
    let array2 = splitTwoArray[1]
    
    ScrollView {
      HStack(alignment: .top) {
        LazyVStack(spacing: 8) {
          ForEach(array1) { photo in
            NavigationLink(
              destination: {
                getImage(photo: photo, forceWidth: twoDividedWidth)
              },
              label: {
                getImage(photo: photo, forceWidth: twoDividedWidth)
              }
            )
          }
        }
        LazyVStack(spacing: 8) {
          ForEach(array2) { photo in
            NavigationLink(
              destination: {
                getImage(photo: photo, forceWidth: twoDividedWidth)
              },
              label: {
                getImage(photo: photo, forceWidth: twoDividedWidth)
              }
            )
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func getImage(photo: Photo, forceWidth: Double) -> some View {
    Image(uiImage: photo.uiImage)
      .resizable()
      .frame(
        width: forceWidth,
        height: getHeight(forceWidth: forceWidth, imageWidth: photo.width, imageHeight: photo.height)
      )
  }
  
  private func getHeight(forceWidth: Double, imageWidth: Double, imageHeight: Double) -> Double {
    forceWidth * imageHeight / imageWidth
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
