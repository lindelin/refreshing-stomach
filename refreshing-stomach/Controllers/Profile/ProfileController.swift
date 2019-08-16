//
//  ProfileController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/14.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import CoreData

class ProfileController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        photoView.image = UIImage.getUserPhoto()
        nameLabel.text = UserDefaults.getUser(forKey: .name)
        let age = Date.createFormFormat(string: UserDefaults.getUser(forKey: .birthday)!)?.age()
        infoLabel.text = "\(UserDefaults.getUser(forKey: .sex)!) / \(age!)歳"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            self.logout()
        }
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
