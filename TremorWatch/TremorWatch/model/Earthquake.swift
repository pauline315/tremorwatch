import Foundation

struct EarthquakeProperties: Codable {
    let mag: Double
    let place: String
    let time: TimeInterval
    let updated: TimeInterval?
    let tz: String?
    let url: String
    let detail: String
    let felt: String?
    let cdi: String?
    let mmi: String?
    let alert: String?
    let status: String
    let tsunami: Int
    let sig: Int
    let net: String
    let code: String
    let ids: String
    let sources: String
    let types: String
    let nst: Int
    let dmin: Double
    let rms: Double
    let gap: Int
    let magType: String
    let type: String
    let title: String
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

struct EarthquakeFeature: Codable {
    let type: String
    let properties: EarthquakeProperties
    let geometry: Geometry
    let id: String
}


struct EarthquakesResponse: Codable {
    let features: [EarthquakeFeature]
}
