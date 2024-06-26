import Foundation
import RxSwift

class EarthquakeService {
    func fetchEarthquakes() -> Observable<[EarthquakeFeature]> {
        let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
        
        return Observable.create { observer in
            print("Starting network request to fetch earthquakes...")
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching earthquakes:", error)
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "ResponseError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    print("Invalid response:", error)
                    observer.onError(error)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error"])
                    print("HTTP Error:", error)
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    print("No data received:", error)
                    observer.onError(error)
                    return
                }
                
                do {
                    print("Received earthquake data. Parsing...")
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    let earthquakesResponse = try decoder.decode(EarthquakesResponse.self, from: data)
                    print("Successfully parsed \(earthquakesResponse.features.count) earthquakes")
                    observer.onNext(earthquakesResponse.features) // Return the entire EarthquakeFeature array
                    observer.onCompleted()
                } catch {
                    print("Error decoding JSON:", error)
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                print("Cancelling network request...")
                task.cancel()
            }
        }
    }
}
