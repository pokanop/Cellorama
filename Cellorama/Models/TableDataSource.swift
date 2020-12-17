//
//  TableDataSource.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

struct TableDataSource {
    
    var items: [Item] = []
    var numberOfItems: Int { items.count }
    
    func configureCell(_ cell: TableCell, for item: Item) {}
    
}
