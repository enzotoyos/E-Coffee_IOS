//
//  coffeeController.swift
//  E-COFFEE
//
//  Created by enzo toyos on 06/12/2020.
//

import UIKit

class coffeeController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var hautGauche: UIImageView!
    @IBOutlet weak var hautDroite: UIImageView!
    @IBOutlet weak var basGauche: UIImageView!
    @IBOutlet weak var basDroite: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            hautGauche.image = UIImage(named: "chiapas mexique" )!
            hautDroite.image = UIImage(named: "montecillos")!
            basGauche.image = UIImage(named: "pasco perou")!
            basDroite.image = UIImage(named: "Risaralda")!
        case 1:
            hautDroite.image = UIImage(named: "montecillos")!
        default:
            break
        }
    }
}
