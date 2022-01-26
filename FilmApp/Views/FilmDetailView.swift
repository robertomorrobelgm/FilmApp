//
//  FilmView.swift
//  FilmApp
//
//  Created by Roberto Morrobel on 1/19/22.
//

import Foundation
import SwiftUI


struct FilmDetailView: View{
    var film: Film = Film()
    var modelView: FilmViewModel
    init(film: Film, modelView: FilmViewModel){
        self.film = film
        self.modelView = modelView
    }

    var body: some View{
        ScrollView {
            VStack(alignment: .leading, spacing:16){
                
                HStack{
                    Image(uiImage: Tools.createImage(film: film))
                        .resizable()
                        .frame(height: 500)
                    
                    Spacer()
                }
                
                HStack{
                    Text("Visitas: " + String( (film.viewCounter ?? 0) + 1))
                        
                    Spacer()
                    
                    Text("Rating: " + String(film.rating ?? 0))
                        .foregroundColor(.blue)
                }
                
                Text("Sinopsis")
                    .bold()
                
                Text(film.overview ?? "")
                    .font(.system(size: 16, weight: Font.Weight.light, design: Font.Design.rounded))
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Spacer()
            }.padding()
            .navigationTitle(film.title ?? "")
            .onAppear{
                self.modelView.registFilmVisit(film: self.film)
            }
        }
    }
}
