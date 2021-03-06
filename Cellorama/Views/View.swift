//
//  View.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class View: UIView {
    
    enum Size: CaseIterable {
        case small
        case medium
        case large
        case xlarge
        case dynamic
        
        static var random: Size { [.small, .medium, .large, .xlarge].randomElement()! }
        
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
        
        applyCorner(to: layer)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.text = element.data
        
        size.configure(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
