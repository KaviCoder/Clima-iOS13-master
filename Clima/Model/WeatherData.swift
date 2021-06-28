//
//  WeatherData.swift
//  Clima
//
//  Created by Kavya Joshi on 18/05/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


//we want weather and temperature data parse from JSON

struct WeatherData: Decodable
{
    
    let name : String
    let main : Main
    let weather : [Weather]
    
}

struct Main: Decodable
{
    let temp: Double
}

struct Weather: Decodable
{
    let id: Int
    let description : String
}
