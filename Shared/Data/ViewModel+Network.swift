//
//  ViewModel+Network.swift
//  WeatherSwiftUI
//
//  Created by Gary on 6/1/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation
import Combine
import os.log


/*
    You need a AccuWeather API key which you can get a free low-use key here: https://developer.accuweather.com/getting-started (start with Register button at the top of the screen)

    You can find location codes a number of ways here: https://developer.accuweather.com/accuweather-locations-api/apis
 */


let locationCode = "337169"         // Mountain View, CA
let accuWeatherapikey = "<your AccuWeather api key>"  // <your AccuWeather api key>

extension URL {

    static var weather: URL? {
        URL(string: "https://dataservice.accuweather.com/currentconditions/v1/\(locationCode)?apikey=\(accuWeatherapikey)&details=true")
    }

    static var forecastWeather: URL? {
        URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(locationCode)?apikey=\(accuWeatherapikey)&details=true")
    }

    static var hourlyForecastWeather: URL? {
        URL(string: "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/\(locationCode)?apikey=\(accuWeatherapikey)&details=false")
    }

}

extension ViewModel {

    public func getWeather(completion: ((ViewModel) -> Void)? = nil) {

        let currentWeatherPublisher = DataFetcher.fetch(url: URL.weather, myType: [CurrentData].self)
        let forecastWeatherPublisher = DataFetcher.fetch(url: URL.forecastWeather, myType: ForecastData.self)

        // wait until both fetches finish before updating the data and forcing the UI to refresh
        let _ = Publishers.Zip(currentWeatherPublisher, forecastWeatherPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let theError):
                    self.handleDownloadError(error: theError)
                }
            }, receiveValue: { (current, forecast) in
                DispatchQueue.main.async {
                    if current.count > 0 {
                        self.current = current.first!
                    }
                    self.forecast = forecast
                    completion?(self)
                }
            })
            .store(in: &disposables)
    }

    // in real life you might want a bit more than this...
    func handleDownloadError(error: NetworkError) {
        switch error {
        case NetworkError.invalidHTTPResponse:
            //print(error.errorDescription)
            break
        case NetworkError.invalidServerResponse:
            //print(error.errorDescription)
            break
        case NetworkError.jsonParsingError:
            //print(error.errorDescription)
            break
        default:
            //print(error.errorDescription)
            break
        }
    }

    // weather for small widget - not used. getWeather is quick enough. no need to complicate things.
    func getCurrentWeather() {
        let currentWeatherPublisher = DataFetcher.fetch(url: URL.weather, myType: [CurrentData].self)

        let _ = currentWeatherPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let theError):
                    self.handleDownloadError(error: theError)
                }
            }, receiveValue: { current in
                if current.count > 0 {
                    self.current = current.first!
                }

            })
            .store(in: &disposables)
    }

    // medium widget - possibly. show hourly forecast for day along with current weather? but don't think that will fit.
    func getHourlyForecastWeather() {
        let currentWeatherPublisher = DataFetcher.fetch(url: URL.weather, myType: [CurrentData].self)
        let hourlyForecastWeatherPublisher = DataFetcher.fetch(url: URL.hourlyForecastWeather, myType: [HourlyData].self)

        // wait until both fetches finish before updating the data and forcing the UI to refresh
        let _ = Publishers.Zip(currentWeatherPublisher, hourlyForecastWeatherPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let theError):
                    self.handleDownloadError(error: theError)
                }
            }, receiveValue: { (current, hourlyForecast) in
                if current.count > 0 {
                    self.current = current.first!
                }
                self.hourlyForecast.hourlyForecasts = hourlyForecast
            })
            .store(in: &disposables)
    }

}
