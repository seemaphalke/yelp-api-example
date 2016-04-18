//
//  YelpBussiness.swift
//  
//
//  Created by seema phalke on 2016-04-15.
//
//

import Foundation

import CoreLocation

class YelpBusiness {
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    var name: String {
        get {
            return self.dictionary["name"] as! String
        }
    }
    
    var imageURL: NSURL? {
        get {
            if let image = self.dictionary["image_url"] as? String {
                return NSURL(string: image.stringByReplacingOccurrencesOfString("ms.jpg", withString: "ls.jpg", options: [], range: nil))
            }
            return nil
        }
    }
    
    var ratingImageURL: NSURL {
        get {
            return NSURL(string: self.dictionary["rating_img_url_large"] as! String)!
        }
    }
    
    var reviewCount: Int {
        get {
            return self.dictionary["review_count"] as! Int
        }
    }
    
    
    var latitude: Double? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["latitude"] as! Double)
                }
            }
            return nil
        }
    }
    
    var longitude: Double? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["longitude"] as! Double)
                }
            }
            return nil
        }
    }
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: self.latitude!, longitude: self.longitude!)
        }
    }
    
    var shortAddress: String {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let address = location["address"] as? Array<String> {
                    if let neighborhoods = location["neighborhoods"] as? Array<String> {
                        return (address + [neighborhoods[0]]).joinWithSeparator(", ")
                    }
                    return address.joinWithSeparator(", ")
                }
            }
            return ""
        }
    }
    
    var displayAddress: String {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let address = location["display_address"] as? Array<String> {
                    return address.joinWithSeparator(", ")
                }
            }
            return ""
        }
    }
    
    var displayCategories: String {
        get {
            if let categories = self.dictionary["categories"] as? Array<Array<String>> {
                return categories.map({ $0[0] }).joinWithSeparator(", ")
            }
            return ""
        }
    }
    
}