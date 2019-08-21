//
//  ActionController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/16.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import CoreData

class ActionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addLogButtonHasTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let log = Log(context: appDelegate.persistentContainer.viewContext)
        log.id = UUID()
        log.type = "100"
        log.createdAt = Date()
        appDelegate.saveContext()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
