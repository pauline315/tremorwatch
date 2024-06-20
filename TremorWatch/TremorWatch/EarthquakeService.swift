//
//  EarthquakeService.swift
//  TremorWatch
//
//  Created by EMTECH MAC on 12/06/2024.
//

import Foundation
import RxSwift

class EarthquakeService {
    func fetchEarthquakes() -> Observable<[Earthquake]> {
        let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
        
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .millisecondsSince1970
                        let earthquakesResponse = try decoder.decode(EarthquakesResponse.self, from: data)
                        observer.onNext(earthquakesResponse.features.map { $0.properties })
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

struct EarthquakesResponse: Codable {
    let features: [EarthquakeFeature]
}

struct EarthquakeFeature: Codable {
    let properties: Earthquake
}
