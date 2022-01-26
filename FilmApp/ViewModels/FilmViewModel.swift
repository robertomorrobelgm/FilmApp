//
//  FilmModelView.swift
//  FilmApp
//
//  Created by Roberto Morrobel (ClaroDom) on 1/19/22.
//

import Foundation
import Combine

class FilmViewModel : ObservableObject {
    var cancellableSet: Set<AnyCancellable> = []

    @Published var films: [Film] = []
    
    func registAVisit( film:Film) {
        var item = film
        item.viewCounter? += 1
    }

    func fetchFilms(){
        if !films.isEmpty{
            return
        }
        
        let storage = UserDefaults.standard
        let savedFilmlist = storage.array(forKey: "filmList")// as? [Film]
        if savedFilmlist != nil && !(savedFilmlist?.isEmpty ?? true) {
            films = savedFilmlist as! [Film]
        } else {
            loadFilmListFromAPI(saveIn: storage)
        }
    }
    
    func loadFilmListFromAPI(saveIn:UserDefaults) {
        let url = URL(string: Constants.movieDiscoveryURL)!
        //let url = URL(string: "")
        
        /*if url == nil{
            print("Wron or bad URL: \(String(describing: url))")
            return
        }*/
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: FilmRequestResponse.self, decoder: JSONDecoder())
            .map{ item in item.results}
            .map{
                print($0)
                return $0
            }
            /*.sink(receiveCompletion: {
                print ("Received completion: \($0).")
                },
                  receiveValue: {
                    dataResponse in print ("Received data: \(dataResponse).")
                  }
            )*/
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \FilmViewModel.films, on: self)
            .store(in: &cancellableSet)
    }
}


struct FilmRequestResponse : Decodable {
    let page : Int
    let results : [Film]
    let total_results : Int
    let total_pages : Int

    enum CodingKeys: String, CodingKey {

        case page = "page"
        case results = "results"
        case total_results = "total_results"
        case total_pages = "total_pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        results = try values.decode([Film].self, forKey: .results)
        total_results = try values.decode(Int.self, forKey: .total_results)
        total_pages = try values.decode(Int.self, forKey: .total_pages)
    }
}
