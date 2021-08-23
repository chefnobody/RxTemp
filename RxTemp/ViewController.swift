//
//  ViewController.swift
//  RxTemp
//
//  Created by Aaron Connolly on 8/20/21.
//

import UIKit

class ViewController: UIViewController {

    let userViewModel = UserViewModel(rxAPI: .mock)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
