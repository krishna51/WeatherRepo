//
//  ViewController.swift
//  SampleWheather
//
//  Created by User on 1/29/18.
//  Copyright © 2018 CodeChallenge. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        //Check nil for Lastcity weather
        let str = self.isKeyPresentInUserDefaults(key:"lastcity")
        print(str as Any)
        if str != nil
        {
            self.getWeatherData(cityName: str! as NSString)
        }
    }
    
    //Function for Retreive Last City Weather
    func isKeyPresentInUserDefaults(key: String) -> String? {
        return UserDefaults.standard.object(forKey: key) as! String?
    }
    
    //Function for Get Weather Data
    func getWeatherData(cityName : NSString) {
        
        let removeSpacesTerm = cityName
        let finalTerm:String = removeSpacesTerm.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let urlpath = "http://api.openweathermap.org/data/2.5/weather?q=\(finalTerm)&APPID=a77384fd0f8adc3fdb6de9e7d8d0b888"
        print(urlpath)
        let url = URL(string: urlpath)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    let resultObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    var weatherObject: Weather?
                    if let weatherDictionary = resultObj as? [String : AnyObject] {
                        weatherObject = Weather(jsonDictionary: weatherDictionary)
                        if (weatherDictionary[Weather.kCodKey] as? String) != weatherObject?.respCode {
                            DispatchQueue.main.async {
                                // Update UI
                                self.cityNameLabel.text = weatherObject?.cityName
                                
                                if let temperatureF = weatherObject?.temperatureF {
                                    self.temperatureLabel.text = String(temperatureF) + " °F"
                                } else {
                                    self.temperatureLabel.text =  "No Temp"
                                }
                                if let highF = weatherObject?.highF {
                                    self.highTempLabel.text = String(highF)
                                }
                                if let lowF = weatherObject?.lowF {
                                    self.lowTempLabel.text = String(lowF)
                                }
                                self.descriptionLabel.text = weatherObject?.description
                            }
                            
                            let imageString = weatherObject?.iconString
                            //Concatinate Picture image string with URL
                            let newStr = "http://openweathermap.org/img/w/" + imageString! + ".png"
                            self.imageRender(imageStr: newStr)

                        }
                        else {
                            DispatchQueue.main.async {
                              self.cityNameLabel.text = "No City Found"
                              self.iconImageView.image = nil
                              self.temperatureLabel.text =  "No Temp"
                              self.highTempLabel.text = "0"
                              self.lowTempLabel.text = "0"
                              self.descriptionLabel.text = ""
                            }
                            
                        }
                    }

                      }
                catch {
                    print("error")
                }
            }
            }
            .resume()
    }
    
    //Function for Load Weather Data Images
    func imageRender (imageStr: String) {
        
        let pictureURL = URL(string: imageStr)!
        
        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image.
                        DispatchQueue.main.async {
                            if let image = UIImage(data: imageData) {
                                self.iconImageView.image = image
                            }
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    //Function for Weather Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            getWeatherData(cityName: searchText as NSString)
        }
        self.saveLastCityWeatherData(sender: searchBar.text as AnyObject)
        searchBar.resignFirstResponder()
    }
    
    //Function for Save Last Weather City Search
    func saveLastCityWeatherData(sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(searchBar.text , forKey: "lastcity")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
        
}

    
    
    
    
    
    
    
    
   

