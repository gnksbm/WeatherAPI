//
//  WeatherInfoLabel.swift
//  WeatherAPI
//
//  Created by gnksbm on 6/9/24.
//

import UIKit

final class WeatherInfoLabel: UIView {
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    var placeholder: String?
    
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    convenience init(placeholder: String) {
        self.init()
        textLabel.text = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder() {
        textLabel.text = placeholder
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func configureLayout() {
        [textLabel].forEach { addSubview($0) }
        
        textLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self).offset(10)
            make.trailing.bottom.equalTo(self).offset(-10)
        }
    }
}
