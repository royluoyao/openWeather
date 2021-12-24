//
//  Weather/Users/user/openWeather/openWeatherModels.swift
//  openWeather
//
//  Created by user on 2021/12/24.
//

import Foundation
import UIKit

struct OneCall : Decodable, Hashable {
    let lat : Double?
    let lon : Double?
    let timezone : String?
    let timezone_offset : Double?
    let current : Current?
    let daily : [Daily]?
}
struct Current : Decodable, Hashable {
    let dt : Double?
    let sunrise : Double?
    let sunset : Double?
    let temp : Double?
    let feels_like : Double?
    let pressure : Double?
    let humidity : Double?
    let dew_point : Double?
    let uvi : Double?
    let clouds : Double?
    let visibility : Double?
    let wind_speed : Double?
    let wind_deg : Double?
    let weather : [Weather]?
}
struct Weather : Decodable, Hashable {
    let id : Double?
    let main : String?
    let description : String?
    var icon : String?
}

struct Daily : Decodable, Hashable {
    let dt : Double?
    let sunrise : Double?
    let sunset : Double?
    let moonrise : Double?
    let moonset : Double?
    let moon_phase : Double?
    let temp : Temp?
    let feels_like : FeelsLike?
    let pressure : Double?
    let humidity : Double?
    let dew_point : Double?
    let wind_speed : Double?
    let wind_deg : Double?
    let wind_gust : Double?
    let weather : [Weather]?
    let clouds : Double?
    let pop : Double?
    let uvi : Double?
}

struct Temp : Decodable, Hashable {
    let day : Double?
    let min : Double?
    let max : Double?
    let night : Double?
    let eve : Double?
    let morn : Double?
}

struct FeelsLike : Decodable, Hashable {
    let day : Double?
    let night : Double?
    let eve : Double?
    let morn : Double?
}
