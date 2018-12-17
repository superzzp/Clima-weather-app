//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "982bbc015903b7d73b93970f9b62a54c"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.
        //set self as delegate of location manager, so location manager knows
        //who to report to once we found the data we are looking for
        locationManager.delegate = self
        //Need to choose accuracy everytime we are using the locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //RequestWhenInUse trigger popup for authorization
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData (url: String, parameters: [String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            if response.result.isSuccess {
                print("successfully get JSON response!")
                //Functionality provided by swiftJSON to convert "any" to JSON easily
                //force unwrapped after checking success
                let jso: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: jso)
                print(jso)
            }else {
                print("fail to get JSON response!")
                self.cityLabel.text = "Fail to get location infomation"
                
            }
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData (json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
        }else{
            // if json["main"]["temp"] == nil
            cityLabel.text = "Weather Unavaliable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData () {
        cityLabel.text = weatherDataModel.city
        let temperature:String = String(weatherDataModel.temperature)
        //° == shift + option + 8
        temperatureLabel.text = "\(temperature)"
        weatherIcon.image = UIImage(named: weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition))
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            //stop updating location, with lag
            locationManager.stopUpdatingLocation()
            //force func to only get location back once
            locationManager.delegate = nil
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            //let altitude = location.altitude
            print("longtitude = \(location.coordinate.longitude), latitute = \(location.coordinate.latitude)")
            //dictionary
            let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavaliable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "changeCityName") {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    //Write the userEnteredANewCityName Delegate method here:
    //delegate method, initiated by the ChangeCityViewController class
    func userEnteredANewCityName(city: String) {
        let param: [String:String] = ["q":city, "appid":APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: param)
    }

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


