//
//  TableCell.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class TableCell: UITableViewCell, Reusable {
    
    enum Kind {
        case container
        case element
    }
    
    var kind: Kind
    
    init(kind: Kind) {
        self.kind = kind
        super.init(style: .default, reuseIdentifier: TableCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
