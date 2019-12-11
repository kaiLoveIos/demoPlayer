//
//  bsTableViewCell.swift
//  demo
//
//  Created by iMac on 2019/12/9.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class bsTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        self.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var centerLabel : UILabel = {
        let centerLabel = UILabel()
        centerLabel.text = "1.25X"
        centerLabel.textColor = .white
        centerLabel.font = UIFont.systemFont(ofSize: 15)
        return centerLabel
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
