//
//  ExchangeViewController.swift
//  CurrencyApp
//
//  Created by Taha on 24.03.2021.
//

import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet weak var ExchangeCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ExchangeCardView.layer.cornerRadius = 5
        ExchangeCardView.layer.masksToBounds = true
        ExchangeCardView.backgroundColor = .lightGray
    }
    



}
