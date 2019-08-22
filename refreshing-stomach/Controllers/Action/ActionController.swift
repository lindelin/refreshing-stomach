//
//  ActionController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/16.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import CoreData
import BLTNBoard

class ActionController: UIViewController {
    
    lazy var bulletinManager: BLTNItemManager = {
        let page = LogTypeSelectorBulletinPage(title: "場所")
        page.descriptionText = "どこのおトイレ？"
        page.actionButtonTitle = "登録"
        
        let themeColor = UIColor(named: "theme")!
        page.appearance.actionButtonColor = themeColor
        page.appearance.alternativeButtonTitleColor = themeColor
        page.appearance.actionButtonTitleColor = .white
        
        return BLTNItemManager(rootItem: page)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addLogButtonHasTapped(_ sender: Any) {
        bulletinManager.backgroundViewStyle = .blurredDark
        bulletinManager.showBulletin(above: self)
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
