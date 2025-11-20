//
//  MapButton.swift
//  AllTrailsMapSearchDemoStoryboard
//
//  Created by Daniel Spady on 11/19/25.
//

import UIKit

class MapButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        let darkGreenColor = UIColor(red: 0x2C, green: 0x56, blue: 0x01)
        self.backgroundColor = darkGreenColor
        self.layer.cornerRadius = 8
        self.setTitleColor(.white, for: .normal)
        self.tintColor = .white
        showMapView()
    }
    
    func showMapView() {
        self.setTitle("Map", for: .normal)
        let image = UIImage(resource: .map)
        image.withTintColor(.white)
        self.setImage(image, for: .normal)
    }
    
    func showListView() {
        self.setTitle("List", for: .normal)
        let image = UIImage(resource: .list)
        image.withTintColor(.white)
        self.setImage(image, for: .normal)
    }
}
