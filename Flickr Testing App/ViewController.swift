//
//  ViewController.swift
//  Flickr Testing App
//
//  Created by sarah on 4/21/18.
//  Copyright © 2018 sarah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    fileprivate func populateArray(photoArray: Array <[String: AnyObject]>) {
        for (i,photoDictionary) in photoArray.enumerated() {
            if let imageURLString = photoDictionary["url_m"] as? String {
                 let rect2 = UIScreen.main.bounds.size
                let imageView = UIImageView(frame: CGRect(x:0, y:320*CGFloat(i), width:rect2.width, height:320))
                if let url = URL(string: imageURLString) {
                    imageView.setImageWith(url)
                    self.scrollView.addSubview(imageView)
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrBy("birds")
    }
        func searchFlickrBy(_ searchString:String) {
        let manager = AFHTTPSessionManager()
        
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "29dcb4f64ee627c5f6008811d7ff1a6c",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchString,
                                             "extras": "url_m",
                                             "per_page": 10]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject as? [String: AnyObject] {
                            print("Response: " + (responseObject as AnyObject).description)
                            if let photos = responseObject["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                    let rect2 = UIScreen.main.bounds.size // Returns CGSize

                                    self.scrollView.contentSize = CGSize(width:rect2.width, height: 320 * CGFloat(photoArray.count))
                                    self.populateArray(photoArray:photoArray)
                                }
                            
                            
                            }
                        
                        }
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var scrollView: UIScrollView!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text{
            searchFlickrBy(searchText)
        }
        
    }

    
    
}

