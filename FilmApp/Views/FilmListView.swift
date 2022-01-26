//
//  FilsmView.swift
//  FilmApp
//
//  Created by Roberto Morrobel on 1/19/22.
//

import Foundation
import SwiftUI

struct FilmListView: View {
    @StateObject var viewModel = FilmViewModel()
    
    var body: some View{
        NavigationView {
            List(viewModel.films, id: \.self ){ item in
                NavigationLink(destination: FilmDetailView(film: item, modelView: viewModel)) {
                    HStack {
                        //Logo image
                        Image(uiImage: Tools.createImage(film: item))
                            .resizable()
                            .frame(width: 100, height: 150)
                        
                        VStack(alignment: .leading, spacing: 4){
                            //Title text
                            Text("Titulo: ").bold() + Text(item.title ?? "")
                            
                            //Rating text
                            Text("Rating: " + formatRating(rating: item.rating ?? 0))
                                .foregroundColor(.blue)
                                .fixedSize(horizontal: true, vertical: true)
                                .font(.system(size: 16, weight: Font.Weight.semibold, design: Font.Design.rounded))
                        }
                    }
                }
            }.navigationBarTitle("Peliculas")
            .onAppear {
                self.viewModel.fetchFilms()
            }
        }
    }

    func formatRating(rating:Float) -> String {
        return NSString(format: "%.1f", rating) as String
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}
