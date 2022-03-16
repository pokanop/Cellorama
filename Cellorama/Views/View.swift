//
//  View.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class View: UIView {
    
    enum Size: RawRepresentable, CaseIterable {
        case small
        case medium
        case large
        case xlarge
        case dynamic
        
        static var random: Size { [.small, .medium, .large, .xlarge].randomElement()! }
        
        var name: String {
            switch self {
            case .small: return "sm"
            case .medium: return "md"
            case .large: return "lg"
            case .xlarge: return "xl"
            case .dynamic: return "dy"
            }
        }
        
        var rawValue: Int {
            switch self {
            case .small: return 0
            case .medium: return 1
            case .large: return 2
            case .xlarge: return 3
            case .dynamic: return 4
            }
        }
        
        init?(rawValue: Int) {
            switch rawValue {
            case 0: self = .small
            case 1: self = .medium
            case 2: self = .large
            case 3: self = .xlarge
            case 4: self = .dynamic
            default: return nil
            }
        }
        
        func configure(_ view: View) {
            switch self {
            case .small:
                view.snp.remakeConstraints { make in
                    make.height.width.equalTo(60.0)
                }
            case .medium:
                view.snp.remakeConstraints { make in
                    make.height.equalTo(60.0)
                    make.width.equalTo(100.0)
                }
            case .large:
                view.snp.remakeConstraints { make in
                    make.height.equalTo(100.0)
                    make.width.equalTo(160.0)
                }
            case .xlarge:
                view.snp.remakeConstraints { make in
                    make.height.equalTo(220.0)
                    make.width.equalTo(320.0)
                }
            case .dynamic: return
            }
        }
    }
    
    var size: Size = .small {
        didSet { size.configure(self) }
    }
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        view.numberOfLines = 2
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    
    init(element: Element) {
        super.init(frame: .zero)
        
        backgroundColor = element.color
        size = element.size
        
        applyCorner()
        applyShadow()
        
        let container = UIView()
        container.layer.masksToBounds = true
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.text = element.data
        
        addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        size.configure(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        optimizeShadow()
    }
    
}


extension UIView {
    
    func applyCorner(to layer: CALayer? = nil) {
        let layer = layer ?? self.layer
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

    func applyShadow(to layer: CALayer? = nil) {
        let layer = layer ?? self.layer
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
    }
    
    func optimizeShadow(on layer: CALayer? = nil) {
        let layer = layer ?? self.layer
        
        if layer.cornerRadius > 0 {
            layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                            cornerRadius: layer.cornerRadius).cgPath
        } else {
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        }
    }

}
