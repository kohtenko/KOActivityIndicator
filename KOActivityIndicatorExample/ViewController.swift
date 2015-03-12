//
//  ViewController.swift
//  KOActivityIndicator
//
//  Created by okohtenko on 11/03/15.
//  Copyright (c) 2015 kohtenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var activity1: KOActivityIndicator!
    @IBOutlet var activity2: KOActivityIndicator!
    @IBOutlet var activity3: KOActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity1.style = .SpinInMove
        activity2.style = .SpinInEnd
    }
    
    @IBAction func startPressed(){
        activity1.startAnimating()
        activity2.startAnimating()
        activity3.startAnimating()
    }
    
    @IBAction func stopPressed(){
        activity1.stopAnimating()
        activity2.stopAnimating()
        activity3.stopAnimating()
    }
    

}

