//
//  ViewController.swift
//  TestSearchTextField
//
//  Created by Jack Ngai on 7/12/17.
//  Copyright © 2017 Jack Ngai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SearchTextField

class ViewController: UIViewController {
    
    var gamesArray:[Game]?
    
    let myTextField = SearchTextField(frame: CGRect(x: 10, y: 100, width: 200, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        myTextField.backgroundColor = .white
        
        setupViews()
        configureCustomSearchTextField()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews(){
        view.addSubview(myTextField)
    }
    
    fileprivate func configureCustomSearchTextField() {
        // Set theme - Default: light
        myTextField.theme = SearchTextFieldTheme.lightTheme()
        
        // Modify current theme properties
        myTextField.theme.font = UIFont.systemFont(ofSize: 12)
        myTextField.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        myTextField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        myTextField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        myTextField.theme.cellHeight = 50
        myTextField.theme.placeholderColor = UIColor.brown.withAlphaComponent(0.5)
        
        // Max number of results - Default: No limit
        myTextField.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        myTextField.maxResultsListHeight = 200
        
        // Set specific comparision options - Default: .caseInsensitive
        myTextField.comparisonOptions = [.caseInsensitive]
        
        // Customize highlight attributes - Default: Bold
        myTextField.highlightAttributes = [NSBackgroundColorAttributeName: UIColor.yellow, NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)]
        
        // Handle item selection - Default behaviour: item title set to the text field
        myTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.myTextField.text = item.title
        }
        
        // Update data source when the user stops typing
        myTextField.userStoppedTypingHandler = {
            if let criteria = self.myTextField.text {
                if criteria.characters.count > 1 {
                    
                    // Show loading indicator
                    self.myTextField.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.myTextField.filterItems(results)
                        
                        // Stop loading indicator
                        self.myTextField.stopLoadingIndicator()
                    }
                }
            }
        }
    }

    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
        
        let headers: HTTPHeaders = ["X-Mashape-Key":"6ZrY0Zzd9cmshElg8fzEgqJFFuGZp1fw1k4jsnkF3roQLBNEJX", "Accept":"application/json"]
        
        let parameters: Parameters = ["fields":"name,cover", "limit":"5","search":criteria]
        
        Alamofire.request("https://igdbcom-internet-game-database-v1.p.mashape.com/games/?", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseArray { [weak self](response: DataResponse<[Game]>) in
            
            guard let strongSelf = self else {
                return
            }
            
            var results = [SearchTextFieldItem]()
            
            strongSelf.gamesArray = response.result.value
            
            if let gamesArray = strongSelf.gamesArray{
                for game in gamesArray{
                    if let gameName = game.name{
                        results.append(SearchTextFieldItem(title: gameName))
                    }
                }
            }
            
            DispatchQueue.main.async {
                callback(results)
            }
            
        }
    }
}




