//
//  ViewController.swift
//  TestSearchTextField
//
//  Created by Jack Ngai on 7/12/17.
//  Copyright © 2017 Jack Ngai. All rights reserved.
//

import UIKit
import SearchTextField

class ViewController: UIViewController {
    
    let myTextField = SearchTextField(frame: CGRect(x: 10, y: 100, width: 200, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        myTextField.filterStrings(["Rad", "Ray", "Rope"])
        myTextField.backgroundColor = .red
        
        setupViews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews(){
        view.addSubview(myTextField)
    }


}

