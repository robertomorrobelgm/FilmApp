//
//  FilmViewModel.swift
//  FilmApp
//
//  Created by Roberto Morrobel on 1/19/22.
//

import Foundation
import Combine

class FilmViewModel : ObservableObject {
    var cancellableSet: Set<AnyCancellable> = []

    @Published var films: [Film] = []{
        didSet{
            if oldValue.isEmpty {
                films.sort { $0.rating ?? 0 > $1.rating ?? 0 }
            }
            saveFilmList()
        }
    }
    
    func registFilmVisit(film: Film) {
        if let counter = film.viewCounter {
            film.viewCounter! = counter + 1
        } else {
            film.viewCounter = 1
        }
        
        saveFilmList()
    }

    func fetchFilms(){
        if !films.isEmpty{
            return
        }
        
        if let localData = loadFilmListFromLocal() {
            films = localData
        } else {
            loadFilmListFromAPI()
        }
    }
    
    func loadFilmListFromAPI() {
        let url = URL(string: Constants.movieDiscoveryURL)
        
        guard url != nil else {
            print("Wrong or bad URL \(String(describing: url))")
            return
        }
        
        URLSession.shared
            .dataTaskPublisher(for: url!)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: FilmRequestResponse.self, decoder: JSONDecoder())
            .map{ item in item.results}
            .map{ return $0 }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \FilmViewModel.films, on: self)
            .store(in: &cancellableSet)
    }
    
    func saveFilmList(){
        let storage = UserDefaults.standard
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(films)
            storage.set(data, forKey: "filmList")
            print(data)
        } catch {
            print("Unable to Encode Film (\(error))")
        }
    }
    
    func loadFilmListFromLocal() -> [Film]?{
        if let data = UserDefaults.standard.data(forKey: "filmList") {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([Film].self, from: data)
                print("decoded data = \(result)")
                return result

            } catch {
                print("Unable to Decode Film (\(error))")
            }
        }
        
        return nil
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
