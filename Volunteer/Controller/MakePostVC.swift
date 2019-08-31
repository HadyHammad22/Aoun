//
//  MakePostVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/31/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class MakePostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buMenu(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
