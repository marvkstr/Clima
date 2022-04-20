//
//  WeatherManager.swift
//  Clima
//
//  Created by Marvin Köster on 13.04.22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=f784d6d22263c28867f00a7d281b1ebb"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safedata = data {
                    self.parseJSON(weatherData: safedata)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            weatherModel.conditionName
        } catch {
            print(error)
        }
    }
}
