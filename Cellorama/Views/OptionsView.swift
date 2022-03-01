//
//  OptionsView.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/24/22.
//

import UIKit

final class Options {
    
    enum Kind: CaseIterable {
    
        case animate
        case legacy
        case sections
        case items
        case size
        case columns
        
        var label: UILabel {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .callout)
            switch self {
            case .animate: label.text = "Animate"
            case .legacy: label.text = "Legacy layout"
            case .sections: label.text = "Section count"
            case .items: label.text = "Item count"
            case .size: label.text = "Card size"
            case .columns: label.text = "Column count"
            }
            return label
        }
        
        var value: UIView {
            let view: UIView
            switch self {
            case .animate:
                let item = UISwitch()
                item.isOn = options.animate
                item.addTarget(options, action: #selector(animateChanged), for: .valueChanged)
                view = item
            case .legacy:
                let item = UISwitch()
                item.isOn = options.isLegacy
                item.addTarget(options, action: #selector(legacyChanged), for: .valueChanged)
                view = item
            case .sections:
                let slider = UISlider()
                slider.minimumValue = 0
                slider.maximumValue = 100
                slider.isContinuous = false
                slider.value = Float(options.sections)
                slider.addTarget(options, action: #selector(sectionsChanged), for: .valueChanged)
                view = slider
            case .items:
                let slider = UISlider()
                slider.minimumValue = 0
                slider.maximumValue = 100
                slider.isContinuous = false
                slider.value = Float(options.items)
                slider.addTarget(options, action: #selector(itemsChanged), for: .valueChanged)
                view = slider
            case .size:
                let segments = UISegmentedControl(items: View.Size.allCases.map { $0.name })
                segments.selectedSegmentIndex = options.size.rawValue
                segments.addTarget(options, action: #selector(sizeChanged), for: .valueChanged)
                view = segments
            case .columns:
                let stepper = UIStepper()
                stepper.minimumValue = 1
                stepper.maximumValue = 5
                stepper.value = Double(options.columns)
                stepper.addTarget(options, action: #selector(columnsChanged), for: .valueChanged)
                view = stepper
            }
            return view
        }
        
    }
    
    var animate: Bool = false { didSet { updateHandler?(.animate) } }
    var isLegacy: Bool = false { didSet { updateHandler?(.legacy) } }
    var sections: Int = 10 { didSet { updateHandler?(.sections) } }
    var items: Int = 20 { didSet { updateHandler?(.items) } }
    var size: View.Size = .small { didSet { updateHandler?(.size) } }
    var columns: Int = 1 { didSet { updateHandler?(.columns) } }
    
    var updateHandler: ((Kind) -> ())?
    
    @objc private func animateChanged(toggle: UISwitch) {
        animate = toggle.isOn
    }
    
    @objc private func legacyChanged(toggle: UISwitch) {
        isLegacy = toggle.isOn
    }
    
    @objc private func sectionsChanged(slider: UISlider) {
        sections = Int(slider.value)
    }
    
    @objc private func itemsChanged(slider: UISlider) {
        items = Int(slider.value)
    }
    
    @objc private func sizeChanged(segments: UISegmentedControl) {
        size = View.Size(rawValue: segments.selectedSegmentIndex) ?? size
    }
    
    @objc private func columnsChanged(stepper: UIStepper) {
        columns = Int(stepper.value)
    }
    
}

var options: Options {
    guard let options = optionsMap[currentTabStyle] else { fatalError() }
    return options
}

var optionsMap: [TabViewController.Style: Options] = [
    .zone: Options(),
    .grid(0): Options(),
    .carousel: Options(),
    .mixed: Options()
]

final class OptionsView: UIView {
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 12.0
        return stack
    }()
    
    var visible: Bool = false
    
    init(style: TabViewController.Style) {
        super.init(frame: .zero)
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12.0)
        }
        
        // Temporarily hack so refs line up
        currentTabStyle = style
        
        Options.Kind.allCases.forEach { kind in
            let entry = UIStackView()
            entry.alignment = .center
            entry.axis = .horizontal
            entry.distribution = .fill
            entry.spacing = 16.0
            entry.addArrangedSubview(kind.label)
            entry.addArrangedSubview(kind.value)
            stack.addArrangedSubview(entry)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
