//
//  LogCell.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/22.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(log: Log) {
        titleLabel.text = log.createdAt?.diffForHumans()
        detailTextLabel?.text = "\(log.createdAt?.toStringWithCurrentLocale() ?? "")・\(LogType.name(code: log.type ?? ""))"
    }

}
