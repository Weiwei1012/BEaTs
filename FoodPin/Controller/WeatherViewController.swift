//
//  WeatherViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/1/7.
//  Copyright © 2021 NDHU_CSIE. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet var cityName: UILabel!
    @IBOutlet var weatherState: UILabel!
    
    private let API_URL = "https://api.openweathermap.org/data/2.5/weather?"
    private let API_KEY = "5446cea7c0e250b85d9b6a663da609a9"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getForecast(location: "Taipei")
    }
    
    func getForecast(location: String) {
        
        guard let accessURL = URL(string: API_URL + "q=\(location)&units=metric&lang=zh_tw&appid=\(API_KEY)") else {
            return
        }
        
        let request = URLRequest(url: accessURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            //parse data
            if let data = data {
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(WeatherForecastData.self, from: data) {
                    print("============== Weather Full data ==============")
                    print(weatherData)
                    print("============== Weather Partial data ==============")
                    print("City: \(weatherData.name)")
                    print("Coordinate: (\(weatherData.coord.lon),\(weatherData.coord.lat))")
                    print("Temperature: \(weatherData.main.temp)°C")
                    print("Descrition: \(weatherData.weather[0].description)")
                    OperationQueue.main.addOperation {
                        self.cityName.text = weatherData.name
                        self.weatherState.text = weatherData.weather[0].description
                    }
                }
            }
        })
        
        task.resume()
    }

}
