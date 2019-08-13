//
//  WelcomeController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/13.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToWelcomeView(unwindSegue: UIStoryboardSegue) {
        print(unwindSegue)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
