//
//  File.swift
//  Clima
//
//  Created by Kavya Joshi on 13/05/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

protocol WeatherManagerDelegate
{
 func getWeatherData(_ weatherManager : WeatherManager, _ weather: WeatherModel)
    func didFailWithError(Error : Error)
}




import Foundation
import UIKit

struct WeatherManager
{
    
    var delegate : WeatherManagerDelegate?
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7d5320e0c599fef71c10c000900648e4&units=metric"
    
    func fetchWeather(cityName : String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }
    
    
    
    func fetchWeather(lat : Double ,lon : Double)
    {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        print(urlString)
          performRequest(urlString)
    }
    
    
    //Networking
    //1. Create URL
    //2. create URLSession
    //3. Give URLSession a task
    //4. Start a task
    
    func performRequest(_ urlString: String)
    {
        //1.
        if  let url = URL(string: urlString){
        //2.
            let session = URLSession(configuration: .default)
            
        //3.
            let task = session.dataTask(with: url) { (data, response, error) in
                 if error != nil {
                     print(error!)
                    self.delegate?.didFailWithError(Error: error!)
                     return
                 }
                 
                 
                 if let safeData = data {
                    
                    //for printing data
                   //  let dataString = String(data: safeData, encoding: .utf8)
                    // print(dataString)
                    
                    //parseJSON
                    
                   if let weather =  self.parseJSON( safeData)
                   {
                    print(weather)
                    print(self.delegate!)
                    self.delegate?.getWeatherData( self, weather)
                    }
                 }
                
            }
            
            
        //4.
            task.resume()
    }
}
    
    func parseJSON(_ weatherData : Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let name = decodedData.name
            
            print("****city retrieved = \(name)")
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            return  WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            
        }
        catch {
            print(error)
            delegate?.didFailWithError(Error: error)
            return nil
        }
    
        
        
    }
    
    
}
