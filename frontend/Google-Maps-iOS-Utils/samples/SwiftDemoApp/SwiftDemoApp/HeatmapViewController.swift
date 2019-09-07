/* Copyright (c) 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import GoogleMaps
import UIKit
import Alamofire
import SwiftyJSON

class HeatmapViewController: UIViewController, GMSMapViewDelegate {
    private var mapView: GMSMapView!
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var button: UIButton!
    
    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.2, 1.0] as? [NSNumber]
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 43.06417, longitude: 141.34694, zoom: 5)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        //    makeButton()
    }
    
    override func viewDidLoad() {
        // Set heatmap options.
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.radius = 90
        heatmapLayer.opacity = 0.6
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints!,
                                            colorMapSize: 256)
        addHeatmap()
        
        // Set the heatmap to the mapview.
        heatmapLayer.map = mapView
    }
    
    // Parse JSON data and add it to the heatmap layer.
    func addHeatmap()  {
        var list = [GMUWeightedLatLng]()
        let lat_lng : [String:[CLLocationDegrees]] =
            ["hokkaido"  : [43.06417,141.34694] ,
             "aomori"    : [40.82444,140.74],
             "iwate"     : [39.70361,141.1525],
             "miyagi"    : [38.26889,140.87194],
             "akita"     : [39.71861,140.1025],
             "yamagata"  : [38.24056,140.36333],
             "fukushima" : [37.75,140.46778],
             "ibaraki"   : [36.34139,140.44667],
             "tochigi"   : [36.56583,139.88361],
             "gunma"     : [36.39111,139.06083],
             "saitama"   : [35.85694,139.64889],
             "chiba"     : [35.60472,140.12333],
             "tokyo"     : [35.68944,139.69167],
             "kanagawa"  : [35.44778,139.6425],
             "niigata"   : [37.90222,139.02361],
             "toyama"    : [36.69528,137.21139],
             "ishikawa"  : [36.59444,136.62556],
             "fukui"     : [36.06528,136.22194],
             "yamanashi" : [35.66389,138.56833],
             "nagano"    : [36.65139,138.18111],
             "gifu"      : [35.39111,136.72222],
             "shizuoka"  : [34.97694,138.38306],
             "aichi"     : [35.18028,136.90667],
             "mie"       : [34.73028,136.50861],
             "shiga"     : [35.00444,135.86833],
             "kyoto"     : [35.02139,135.75556],
             "osaka"     : [34.68639,135.52],
             "hyogo"     : [34.69139,135.18306],
             "nara"      : [34.68528,135.83278],
             "wakayama"  : [34.22611,135.1675],
             "tottori"   : [35.50361,134.23833],
             "shimane"   : [35.47222,133.05056],
             "okayama"   : [34.66167,133.935],
             "hiroshima" : [34.39639,132.45944],
             "yamaguchi" : [34.18583,131.47139],
             "tokushima" : [34.06583,134.55944],
             "kagawa"    : [34.34028,134.04333],
             "ehime"     : [33.84167,132.76611],
             "kochi"     : [33.55972,133.53111],
             "fukuoka"   : [33.60639,130.41806],
             "saga"      : [33.24944,130.29889],
             "nagasaki"  : [32.74472,129.87361],
             "kumamoto"  : [32.78972,130.74167],
             "oita"      : [33.23806,131.6125],
             "miyazaki"  : [31.91111,131.42389],
             "kagoshima" : [31.56028,130.55806],
             "okinawa"   : [26.2125,127.68111]]
        do {
            if let path = Bundle.main.url(forResource: "police_stations", withExtension: "json") {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    for item in object {
                        let prefecture = item["Prefecture"] as! String
                        let count = item["Count"] as! Int * 100
                        if let coordInfo = lat_lng[prefecture] {
                            var i = 0
                            while i <= count {
                                i += 1
                                let lat = coordInfo[0] + CLLocationDegrees.random(in: -0.2 ... 0.2)
                                let lng = coordInfo[1] + CLLocationDegrees.random(in: -0.2 ... 0.2)
                                let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat, lng), intensity: 1.0)
                                list.append(coords)
                            }
                        }
                    }
                } else {
                    print("Could not read the JSON.")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = list
    }
    
    @objc func removeHeatmap() {
        heatmapLayer.map = nil
        heatmapLayer = nil
        // Disable the button to prevent subsequent calls, since heatmapLayer is now nil.
        button.isEnabled = false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // Add a button to the view.
    func makeButton() {
        // A button to test removing the heatmap.
        button = UIButton(frame: CGRect(x: 5, y: 150, width: 200, height: 35))
        button.backgroundColor = .blue
        button.alpha = 0.5
        button.setTitle("Remove heatmap", for: .normal)
        button.addTarget(self, action: #selector(removeHeatmap), for: .touchUpInside)
        self.mapView.addSubview(button)
    }
}
