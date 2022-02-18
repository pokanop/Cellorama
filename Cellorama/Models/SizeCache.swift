//
//  SizeCache.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/18/22.
//

import UIKit

final class SizeCache {
    
    var sizes: [UUID: CGSize] = [:]
    var maxHeights: [UUID: CGFloat] = [:]
    
    func size(for identifier: UUID) -> CGSize {
        sizes[identifier] ?? .zero
    }
    
    func setSize(_ size: CGSize, for identifier: UUID) {
        sizes[identifier] = size
    }
    
    func maxHeight(for identifier: UUID, with container: Container? = nil) -> CGFloat {
        let height = maxHeights[identifier] ?? .zero
        return container?.maxHeight(for: height) ?? height
    }
    
    func setMaxHeight(_ height: CGFloat, for identifier: UUID) {
        maxHeights[identifier] = max(height, maxHeight(for: identifier))
    }
    
    func clear() {
        sizes = [:]
        maxHeights = [:]
    }
    
}

var sizeCache: SizeCache = SizeCache()
