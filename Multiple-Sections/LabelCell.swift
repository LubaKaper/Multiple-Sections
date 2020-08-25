//
//  LabelCell.swift
//  Multiple-Sections
//
//  Created by Liubov Kaper  on 8/18/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {
    
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
            return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        textLAbelConstraints()
    }
    
    private func textLAbelConstraints() {
        addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
}

