//
//  MenuDataSource.swift
//  capStone
//
//  Created by Colin Walsh on 6/15/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation
import UIKit
class MenuDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! MenuHeaderCell
        cell.titleLabel.text = "Title"
        cell.subtitleLabel.text = "Subtitle"
        cell.profilePicture.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
