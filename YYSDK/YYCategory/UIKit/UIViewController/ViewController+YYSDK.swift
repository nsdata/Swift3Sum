//
//  ViewController+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension UIViewController {
    public func extendedLayoutNone() {
        self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - ChildVC相关
    public func addChildViewController(_ childController: UIViewController, toSubView: Bool = false, fillSuperViewConstraint: Bool = false) {
        self.addChildViewController(childController)
        if toSubView {
            self.view.addSubview(childController.view)
            childController.view.frame = self.view.frame
            
            if fillSuperViewConstraint {
                childController.view.addConstraintFillSuperView()
            }
        }
        childController.didMove(toParentViewController: self)
    }
}


// MARK: - 初始化相关

extension UIViewController {
    //根据类名从storyboard中返回对应ViewController
    public static func instanceFromStoryboard(_ storyboardName: String? = nil, id storyboardId: String? = nil, isInitial: Bool = false) -> UIViewController? {
        let classNameString = self.className
        let storyboard = UIStoryboard(name: storyboardName ?? classNameString, bundle: nil)
        
        return isInitial ? storyboard.instantiateInitialViewController() : storyboard.instantiateViewController(withIdentifier: storyboardId ?? classNameString)
    }
}

// MARK: - 快速添加NoDataView

var k_noDataView: UInt8 = 0
extension UIViewController {
    public var noDataView: YYNoDataView? {
        get {
            return objc_getAssociatedObject(self, &k_noDataView) as? YYNoDataView
        }
        set {
            objc_setAssociatedObject(self, &k_noDataView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func showNoDataView(image: UIImage? = nil, text: String? = nil, buttonText: String? = nil, buttonAction: ((UIButton) -> Void)? = nil) {
        if let noDataView = noDataView {
            noDataView.update(image: image, text: text, buttonText: buttonText, buttonAction: buttonAction)
        } else {
            noDataView = YYNoDataView.show(inView: view, image: image, text: text, buttonText: buttonText, buttonAction: buttonAction)
        }
    }
    
    public func dismissNoDataView() {
        noDataView?.removeFromSuperview()
        noDataView = nil
    }
}


// MARK: - 快速添加一个按钮
class _YYButton: UIButton {
    var action: ((UIButton) -> Void)! = nil
}

var k_buttonCount: UInt8 = 0

extension UIViewController {
    public var buttonCount: Int {
        get {
            let value = objc_getAssociatedObject(self, &k_buttonCount) as? Int
            return value ?? 0 //初始化为0
        }
        set {
            objc_setAssociatedObject(self, &k_buttonCount, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addButtonToView(title: String, action: @escaping (UIButton) -> Void) {
        buttonCount += 1
        addButtonToView(title: title, frame: CGRect(x: 0, y: 40*buttonCount, width: 320, height: 40), action: action)
    }
    @discardableResult public func addButtonToView(title: String, frame: CGRect, action: @escaping (UIButton) -> Void) -> UIButton {
        let button = _YYButton(type: .system)
        button.action = action
        button.frame = frame
        button.contentHorizontalAlignment = .center
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(yyButtonClicked(button:)), for: .touchUpInside)
        view.addSubview(button)
        return button
    }
    
    func yyButtonClicked(button: _YYButton) {
        if let action = button.action {
            action(button);
        }
    }
}
















