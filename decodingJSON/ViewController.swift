//
//  ViewController.swift
//  decodingJSON
//
//  Created by Ahmet Bostancıklıoğlu on 3.01.2023.
//

import UIKit
import Foundation
class ViewController: UIViewController {

    @IBOutlet weak var weatherTemp: UILabel!
    let urlOfCity: String? = "Gaziantep"
    var responseData: Response?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        json { error in
            if error == nil {
                print("success")
                DispatchQueue.main.async {
                    
                 //   print(self.responseData?.main?.temp! as Any )
                    var temparature = self.responseData?.main?.temp
                    temparature = temparature! - 273.15
                    print(String(format: "%.1f", temparature!))
                    self.weatherTemp.text! = "\(String(format: "%.1f", temparature! )) °C"
                }
                
            }else {
                print("error: \(String(describing: error))")
            }
        }
    }

    
    func json(completed: @escaping (Error?) -> ()) {
        let urlKey = "b8809c1e58fc1eb37467250b3f34742d"
        if  let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(urlKey)&q=" + urlOfCity!) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error == nil, let data = data {
                    do {
                        self.responseData = try JSONDecoder().decode(Response.self, from: data)
                        completed(nil)
                    } catch {
                        completed(error)
                    }
                }
            }.resume()
        }
    }
    
}

struct Response: Codable {
    var coord: Coord?
       var weather: [Weathers]?
       var main: Main?
       var visibility: Int?
       var wind: Wind?
       var rain: Rain?
       var clouds: Clouds?
       var dt: Int?
       var sys: Sys?
       var timezone: Int?
       var id: Int?
       var name: String?
       var cod: Int?

}
struct Coord: Codable {
    var lon: Double?
    var lat: Double?
}

struct Weathers: Codable {
    var id: String { _id! }
    private var _id: String?
    var base: String?
    
    mutating func prepare() {
        _id = _id ?? UUID().uuidString
    }
}

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Main: Codable {
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Int?
    var humidity: Int?
}

struct Wind: Codable {
    var speed: Double?
    var deg: Int?
}

struct Rain: Codable{
    var umh: Int?
}

struct Clouds: Codable {
    var all: Int?
}

struct Sys: Codable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
    
}
