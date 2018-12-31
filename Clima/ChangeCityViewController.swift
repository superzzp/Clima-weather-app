//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Alex Zhang on 29/12/2018.
//

import UIKit


//Write the protocol declaration here:
//the function inside the protocol are the function we will call in this class for the delegate class to run
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}


class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    //the role of a delegate can be filled or not filled
    var delegate: ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        //1 Get the city name the user entered in the text field
        var cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        //delegate? means if delegate not nil, continue to do sth
        //if delegate is nil, ignore the entire line of the code
        //optional chaining (vs conditional binding)
        delegate?.userEnteredANewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        //do nothing after dismiss completed, so nil
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
