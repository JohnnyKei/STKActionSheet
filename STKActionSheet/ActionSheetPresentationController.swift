//
//  ActionSheetPresentationController.swift
//  STKActionSheet
//
//  Created by SatoKei on 2018/11/22.
//  Copyright © 2018 kei.sato. All rights reserved.
//

import UIKit

class ActionSheetPresentationController: UIPresentationController {

    var contentSize: CGSize = .zero
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    private let dimmingView = UIView()
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:))))
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.alpha = 0
        containerView.insertSubview(dimmingView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
            self?.dimmingView.alpha = 1
            }, completion: nil)
    }
    override func presentationTransitionDidEnd(_ completed: Bool) {
    }
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
            self?.dimmingView.alpha = 0
            }, completion: nil)
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    override func containerViewWillLayoutSubviews() {
        if let containerView = containerView {
            dimmingView.frame = containerView.bounds
        }
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    override func containerViewDidLayoutSubviews() {
    }
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if contentSize.width == 0 || contentSize.height == 0 {
            return parentSize
        } else {
            var size = contentSize
            // safearea
            size.height += presentedViewController.bottomLayoutGuide.length
            return size
        }
    }
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        guard let containerBounds = containerView?.bounds else { return presentedViewFrame }
        presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
        presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height
        return presentedViewFrame
    }
    @objc private func handleSingleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
