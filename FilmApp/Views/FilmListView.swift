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
                            //.border(Color.init(red: 66, green: 63, blue: 62, opacity: 1))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.init(red: 23, green: 16, blue: 16, opacity: 1), lineWidth: 2)
                                )
                        
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
                }.cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.init(red: 66, green: 63, blue: 62, opacity: 1), lineWidth: 2)
                    )
            }.navigationBarTitle("Peliculas")
            .onAppear {
                self.viewModel.fetchFilms()
            }
        }.preferredColorScheme(.dark)
    }

    func formatRating(rating:Float) -> String {
        return NSString(format: "%.1f", rating) as String
       
    }
}


// MARK: - Preview View and function
struct ContentView_Previews: PreviewProvider {
    static var filmViewModel: FilmViewModel {
        let resutl = FilmViewModel()
        //var currentFilm = Film
        
        /*ForEach((1...10).reversed(), id: \.self) {
            currentFilm = Film()
            currentFilm.
        }*/

        
        return resutl
    }
    
    static var previews: some View {
        FilmListView()
        /*List{
            NavigationView {
                NavigationLink("hola", destination: PreviewView())
            }.background(Color.purple) //(Color.init(red: 43, green: 43, blue: 43, opacity: 1))
        }.background(Color.purple)*/
    }
    
    /*func loadJson(filename fileName: String) -> [Person]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.person
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }*/
}

struct PreviewView: View {
    var body: some View {
        Text("hola")
    }
}
