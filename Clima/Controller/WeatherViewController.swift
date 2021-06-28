//
//  ViewController.swift
//  Clima
//
//  Created by Kavya Joshi on 13/05/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//
import UIKit
import CoreLocation

class WeatherViewController: UIViewController  {
   
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var wManager = WeatherManager()
    var LocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.textfield.endEditing(true)
        
        //textfiels should report back our viewcontroller
        textfield.delegate = self
        wManager.delegate = self
        
        LocationManager.delegate = self
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.requestLocation()
        
       
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        
        textfield.endEditing(true)
        
       print(textfield.text!)
     
    }
  
}
   
//MARK: - WeatherManagerDelegate


extension WeatherViewController : WeatherManagerDelegate
{

     
      //delegate Method Implementation
      //first parameter is always the identity of weather manager
      //second is if there is any input required
     
      func getWeatherData(_ weatherManager : WeatherManager, _ weather: WeatherModel) {
            DispatchQueue.main.async{
                
                
                self.temperatureLabel.text =  weather.temperatureString
                self.cityLabel.text = weather.cityName
                self.conditionImageView.image = UIImage(systemName: weather.conditionName )
            }
            print(weather.conditionName)
           }
        
      func didFailWithError(Error : Error)
      {
        print(Error)
        }
    
}
    
    
//MARK: - UITextFieldDelegate
    
extension WeatherViewController : UITextFieldDelegate  {
    
    //***************************************
     //Delegate Methods
     
     
     
     //when person taps in return button or go button in keypad
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textfield.endEditing(true)
         print(textfield.text!)
         
         return true
     }
     
       //user tapps outside the textfield or keypad, we will be asked if text field should end editing or not???
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           
           if textfield.text != ""
           {
               return true
           }
           else {
               textfield.placeholder = "Type Something"
               return false
           }
       }
     
     
     //When user really did end editing, we need to clean the textfields
     func textFieldDidEndEditing(_ textField: UITextField) {
         
         if let cityName = textfield.text {
         
         wManager.fetchWeather(cityName: cityName )
         
         textfield.text = ""
         textfield.placeholder = "Search"
                     
             
             
         }
    
    
}

}
 //MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("got location data")
       if  let location = locations.last
       {
        
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        print("\(lat), \(lon)")
        wManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
