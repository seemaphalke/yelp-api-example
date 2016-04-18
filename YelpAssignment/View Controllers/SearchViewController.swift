//
//  SearchViewController.swift
//  YelpAssignment
//
//  Created by seema phalke on 2016-04-15.
//  Copyright © 2016 seema phalke. All rights reserved.
//

import Foundation
import UIKit


class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var button: UIButton!
    var sortAZ:Bool = false
    
    var client: YelpClient!
    
    let yelpConsumerKey = "C6uWCSlZN-pt1qMSzQyeAQ"
    let yelpConsumerSecret = "mCV_4NS3bvZjxCSNvA8e_1djmtE"
    let yelpToken = "IFT9QzRtzVcfH0O6LR7TK5hwtDKKdZBc"
    let yelpTokenSecret = "_7yceRZuAeaIDuJnHRo7gWfWRFc"
    
    
    
    var userLocation: UserLocation!
    
    var results: Array<YelpBusiness> = []
    var offset: Int = 0
    var total: Int!
    let limit: Int = 20
    var lastResponse: NSDictionary!

    
    @IBAction func buttonClicked(sender: AnyObject) { //Touch Up Inside action
        //sortButton.backgroundColor = UIColor.whiteColor()
        self.sortAZ = !self.sortAZ
        if(self.sortAZ){
            //self.sortButton.title = "Sort Z-A"
             self.button.setImage(UIImage(named: "Z-A") ,forState: UIControlState.Normal)
        }else{
            //self.sortButton.title = "Sort A-Z"
              self.button.setImage(UIImage(named: "A-Z") ,forState: UIControlState.Normal)
        }
        self.clearResults()
        self.performSearch(searchBar.text!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        self.userLocation = UserLocation()
        
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "e.g. pizza, butter chicken"
        self.navigationItem.titleView = self.searchBar
        
    }
    
    final func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.clearResults()
        self.performSearch(searchBar.text!)
    }
    
    final func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.clearResults()
        }
    }
    
    final func performSearch(term: String, offset: Int = 0, limit: Int = 20) {
        self.searchBar.text = term
        self.searchBar.resignFirstResponder()
        self.onBeforeSearch()
        self.client.searchWithTerm(term, parameters: self.getSearchParameters(), offset: offset, limit: 20, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let results = (response["businesses"] as! Array).map({
                (business: NSDictionary) -> YelpBusiness in
                return YelpBusiness(dictionary: business)
            })
            self.results += results
            if(self.sortAZ){
                self.results.sortInPlace { $0.name < $1.name }
            }
   
            self.total = response["total"] as! Int
            self.lastResponse = response as! NSDictionary
            self.offset = self.results.count
            self.onResults(self.results, total: self.total, response: self.lastResponse)
            }, failure: {
                (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print(error)
        })
    }
    
    func getSearchParameters() -> Dictionary<String, String> {
        let parameters = [
            "ll": "\(userLocation.latitude),\(userLocation.longitude)"
        ]

        return parameters
    }
    
    func onBeforeSearch() -> Void {}
    
    func onResults(results: Array<YelpBusiness>, total: Int, response: NSDictionary) -> Void {
    }
    
    final func clearResults() {
        self.results = []
        self.offset = 0
        self.onResultsCleared()
    }
    
    func onResultsCleared() -> Void {}
    
    func showDetailsForResult(result: YelpBusiness) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("Details") as! DetailsViewController
        controller.business = result
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as! UINavigationController
            if (navigationController.viewControllers[0] is DetailsViewController) {
                _ = navigationController.viewControllers[0] as! DetailsViewController
                
            }
        }
    }

    
    func synchronize(searchView: SearchViewController) {
        self.searchBar.text = searchView.searchBar.text
        self.results = searchView.results
        self.total = searchView.total
        self.offset = searchView.offset
        self.lastResponse = searchView.lastResponse
        
        if self.results.count > 0 {
            if(self.sortAZ){
                self.results.sortInPlace { $0.name < $1.name }
            }
            self.onResults(self.results, total: self.total, response: self.lastResponse)
        } else {
            self.onResultsCleared()
        }
    }
    
}

