//
//  WATextField.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 16/09/2024.
//

import UIKit

class WATextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        
        textColor = .secondaryLabel
        tintColor = .secondaryLabel
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        textAlignment = .center
        
        autocorrectionType = .no //turn auto-correct off
        returnKeyType = .go //customised what return key says
        clearButtonMode = .whileEditing //adds small x to clear textfield
        placeholder = "Enter a location"
    }

}
