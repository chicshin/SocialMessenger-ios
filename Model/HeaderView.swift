//
//  HeaderView.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/15/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    let date: UILabel = {
        let dateStamp = UILabel()
        dateStamp.translatesAutoresizingMaskIntoConstraints = false
        dateStamp.backgroundColor = .clear
        dateStamp.textColor = .lightGray
        dateStamp.font = UIFont.systemFont(ofSize: 12)
        return dateStamp
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1).withAlphaComponent(0.7)
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(date)
        

        bubbleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bubbleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalToConstant: 26).isActive = true

        date.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: -27).isActive = true
        date.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 15).isActive = true
        date.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -15).isActive = true
//        date.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: -27).isActive = true
//        date.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
//        date.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        date.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
