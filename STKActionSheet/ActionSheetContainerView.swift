//
//  ActionSheetContainerView.swift
//  STKActionSheet
//
//  Created by SatoKei on 2018/11/22.
//  Copyright © 2018 kei.sato. All rights reserved.
//

import UIKit

class ActionSheetContainerView: UIView {

    private let containerView = UIView()
    override var backgroundColor: UIColor? {
        set { containerView.backgroundColor = newValue }
        get { return containerView.backgroundColor }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 8/2
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
        layer.shadowPath = path.cgPath
        layer.shadowOpacity = 0.3
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        containerView.layer.mask = mask
    }

}
