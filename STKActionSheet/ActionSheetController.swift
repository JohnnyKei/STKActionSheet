//
//  ActionSheetController.swift
//  STKActionSheet
//
//  Created by SatoKei on 2018/11/22.
//  Copyright © 2018 kei.sato. All rights reserved.
//

import UIKit

public class ActionSheetAction: NSObject {

    public var isEnabled: Bool = true
    public let title: String?
    public let image: UIImage?
    internal let handler: ((ActionSheetAction) -> Void)?
    internal let configurationHandler: ((UILabel) -> Void)?
    public init(title: String?, image: UIImage?, configurationHandler: ((UILabel) -> Void)? = nil, handler: ((ActionSheetAction) -> Void)? = nil) {
        self.title = title
        self.image = image
        self.configurationHandler = configurationHandler
        self.handler = handler
        super.init()
    }
}

public class ActionSheetController: UIViewController, UIViewControllerTransitioningDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    private(set) var actions: [ActionSheetAction] = []
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    public init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func addAction(_ action: ActionSheetAction) {
        actions.append(action)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assert(!actions.isEmpty, "ActionSheetController must have an action to display")
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        let containerView = ActionSheetContainerView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(containerView)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -16)
            ])
    }
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: collectionView.frame.size.width, height: Cell.cellHeight)
        layout.invalidateLayout()
    }
    func getHeight() -> CGFloat {
        if actions.isEmpty { return 0 }
        let itemCount = CGFloat(actions.count)
        return itemCount * Cell.cellHeight + (16.0 * 2)
    }
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = ActionSheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.contentSize = CGSize(width: presented.view.frame.size.width, height: getHeight())
        return presentationController
    }
    private func getAction(at indexPath: IndexPath) -> ActionSheetAction? {
        if indexPath.item < actions.count {
            return actions[indexPath.item]
        }
        return nil
    }
    // MARK:
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        if let action = getAction(at: indexPath) {
            cell.titleLabel.text = action.title
            cell.imageView.image = action.image
            cell.isEnabled = action.isEnabled
            action.configurationHandler?(cell.titleLabel)
        }
        return cell
    }
    // MARK:
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let action = getAction(at: indexPath), action.isEnabled {
            dismiss(animated: true) {
                action.handler?(action)
            }
        }
    }
    private class Cell: UICollectionViewCell {
        static let cellHeight: CGFloat = 56 + 1
        let imageView = UIImageView()
        let titleLabel = UILabel()
        private let border = UIView()
        var isEnabled: Bool = true {
            didSet {
                if isEnabled {
                    imageView.alpha = 1
                    titleLabel.alpha = 1
                } else {
                    imageView.alpha = 0.2
                    titleLabel.alpha = 0.2
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            border.translatesAutoresizingMaskIntoConstraints = false
            border.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9294117647, blue: 0.9215686275, alpha: 1)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.textColor = #colorLiteral(red: 0.168627451, green: 0.1647058824, blue: 0.1529411765, alpha: 1)
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            contentView.addSubview(border)
            contentView.addSubview(imageView)
            contentView.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -0.5),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                imageView.widthAnchor.constraint(equalToConstant: 24),
                imageView.heightAnchor.constraint(equalToConstant: 24),
                titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                border.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                border.heightAnchor.constraint(equalToConstant: 1),
                border.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func prepareForReuse() {
            super.prepareForReuse()
            imageView.image = nil
            titleLabel.text = nil
        }
    }
}
