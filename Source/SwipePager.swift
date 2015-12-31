//
//  SwipePager.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 naoto yamaguchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

public enum SwipePagerPosition {
	case Top
	case Bottom
}

public protocol SwipePagerDataSource: class {
	func sizeForMenu(swipePager: SwipePager) -> CGSize
	func menuViews(swipePager: SwipePager) -> [SwipePagerMenu]
	func viewControllers(swipePager: SwipePager) -> [UIViewController]
}

public protocol SwipePagerDelegate: class {
	func swipePager(swipePager: SwipePager, didMoveToPage page: Int)
}

public class SwipePager: UIView, UIPageViewControllerDataSource,
UIPageViewControllerDelegate {

	// MARK: - Property

	public weak var dataSource: SwipePagerDataSource?
	public weak var delegate: SwipePagerDelegate?
	public var transitionStyle: UIPageViewControllerTransitionStyle!
	public var menuPosition: SwipePagerPosition!
	public var currentPage = 0
	public var swipeEnabled = true

	private var menuScrollView = UIScrollView()
	private var menuViewArray = [SwipePagerMenu]()
	private var menuSize = CGSize.zero
	private var currentIndex = 0
	private var pageViewController = UIPageViewController()
	private var viewControllers = [UIViewController]()

	// MARK: - LifeCycle

	required public init(frame: CGRect, transitionStyle: UIPageViewControllerTransitionStyle,
		menuPosition: SwipePagerPosition = .Top) {
		super.init(frame: frame)
		self.transitionStyle = transitionStyle
		self.menuPosition = menuPosition
		self.initializeView()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	public func reloadData() {
		self.settingCurrentPage()
		self.menuScrollViewReloadData()
		self.pageViewControllerReloadData()
	}

	// MARK: - Private

	private func initializeView() {

		self.menuScrollView = UIScrollView()
		self.menuScrollView.showsHorizontalScrollIndicator = true
		self.addSubview(self.menuScrollView)

		self.pageViewController = UIPageViewController(
			transitionStyle: self.transitionStyle,
			navigationOrientation: .Horizontal,
			options: nil
		)
		self.pageViewController.dataSource = self
		self.pageViewController.delegate = self

		self.insertSubview(self.pageViewController.view, belowSubview: self.menuScrollView)
	}

	private func menuScrollViewReloadData() {
		if let menuSize = self.dataSource?.sizeForMenu(self) {
			self.menuSize = menuSize
		}



		self.layoutMenuScrollView(currentPage: self.currentPage)
	}

	private func layoutMenuScrollView(currentPage currentPage: Int) {
		var index = 0

		if let menuViewArray = self.dataSource?.menuViews(self) {

			self.menuViewArray = menuViewArray

			for view in menuViewArray {
				view.frame = CGRect(
					x:		self.menuSize.width * CGFloat(index),
					y:		0,
					width:	self.menuSize.width,
					height: self.menuSize.height
				)
				view.config()
				view.tag = index
				view.userInteractionEnabled = true
				let gesture = UITapGestureRecognizer(target: self, action: "didTapMenu:")
				view.addGestureRecognizer(gesture)
				self.menuScrollView.addSubview(view)
				index++
			}
		}

		self.menuScrollView.contentSize = CGSize(
			width:	self.menuSize.width * CGFloat(index),
			height: self.menuSize.height
		)

		self.moveMenuScrollViewToCurrentIndex(currentPage)
	}

	private func pageViewControllerReloadData() {


		if self.swipeEnabled == false {
			for view in self.pageViewController.view.subviews {
				if let scrollView = view as? UIScrollView {
					scrollView.scrollEnabled = false
				}
			}
		}

		if let viewControllerArray = self.dataSource?.viewControllers(self) {
			self.viewControllers = viewControllerArray
			if self.viewControllers.count > 0 {
				self.pageViewController.setViewControllers(
					[self.viewControllers[self.currentPage]],
					direction: .Forward,
					animated: false,
					completion: nil
				)
			}
		}
	}

	func didTapMenu(gesture: UITapGestureRecognizer) {
		weak var weakSelf = self

		if let index = gesture.view?.tag {
			var direction: UIPageViewControllerNavigationDirection?
			if self.currentIndex > index {
				direction = .Reverse
			}
			else if self.currentIndex < index {
				direction = .Forward
			}
			if let validDirection = direction {
				self.pageViewController.setViewControllers(
					[self.viewControllers[index]],
					direction: validDirection,
					animated: true,
					completion: { (bool) -> Void in
						if bool {
							weakSelf?.didMoveToPage()
						}
					}
				)
			}
			self.currentIndex = index
			self.moveMenuScrollViewToCurrentIndex(index)
		}
	}

	public func selectViewControllerAtIndex(index: Int, animated: Bool = false) {
		self.pageViewController.setViewControllers(
			[self.viewControllers[index]],
			direction: index > self.currentIndex ? .Forward : .Reverse,
			animated: animated,
			completion: nil
		)
		self.moveMenuScrollViewToCurrentIndex(index, animated: animated)
	}

	private func moveMenuScrollViewToCurrentIndex(index: Int, animated: Bool = true) {
		let frame = CGRect(
			x: CGFloat(index) * self.menuSize.width + self.menuSize.width * 0.5
				- (CGRectGetWidth(self.frame) * 0.5), // TODO: Confirmation
			y: 0,
			width: CGRectGetWidth(self.menuScrollView.frame),
			height: CGRectGetHeight(self.menuScrollView.frame)
		)
		self.menuScrollView.scrollRectToVisible(frame, animated: animated)
		self.menuHighlight(index: index)
	}

	private func indexOfViewController(viewController: UIViewController) -> Int {
		for var i = 0; i < self.viewControllers.count; i++ {
			if viewController == self.viewControllers[i] {
				return i
			}
		}
		return NSNotFound
	}

	private func menuHighlight(index index: Int) {
		for var i = 0; i < self.menuViewArray.count; i++ {
			let menu = self.menuViewArray[i]
			menu.stateNormal()
			if i == index {
				menu.stateHighlight()
			}
		}
	}

	private func settingCurrentPage() {
		var correct = true
		if self.currentPage >= self.dataSource?.menuViews(self).count {
			correct = false
		}
		if self.currentPage >= self.dataSource?.viewControllers(self).count {
			correct = false
		}
		if correct == false {
			self.currentPage = 0
		}
	}

	private func didMoveToPage() {
		self.delegate?.swipePager(self, didMoveToPage: self.currentIndex)
	}

	// MARK: - UIPageViewControllerDataSource

	public func pageViewController(pageViewController: UIPageViewController,
		viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
			var index = self.indexOfViewController(viewController)
			if index == NSNotFound {
				return nil
			}
			index--
			if (index >= 0) && (index < self.viewControllers.count) {
				return self.viewControllers[index]
			}
			return nil
	}

	public func pageViewController(pageViewController: UIPageViewController,
		viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
			var index = self.indexOfViewController(viewController)
			if index == NSNotFound {
				return nil
			}
			index++
			if (index >= 0) && (index < self.viewControllers.count) {
				return self.viewControllers[index]
			}
			return nil
	}

	// MARK: - UIPageViewControllerDelegate

	public func pageViewController(pageViewController: UIPageViewController,
		willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
			if pendingViewControllers.count > 0 {
				let viewControllers = pendingViewControllers as [UIViewController]
				let viewController = viewControllers[0] as UIViewController
				self.currentIndex = self.indexOfViewController(viewController)
			}
	}

	public func pageViewController(pageViewController: UIPageViewController,
		didFinishAnimating finished: Bool,
		previousViewControllers: [UIViewController],
		transitionCompleted completed: Bool) {
			if completed == true {
				self.moveMenuScrollViewToCurrentIndex(self.currentIndex)
				self.didMoveToPage()
			}
	}

	override public func layoutSubviews() {
		super.layoutSubviews()
		if self.menuPosition == .Top {
			self.pageViewController.view.frame = CGRect(
				x:		0,
				y:		self.menuSize.height,
				width:	CGRectGetWidth(self.frame),
				height: CGRectGetHeight(self.frame) - CGRectGetMinY(self.frame) - self.menuSize.height
			)
			self.menuScrollView.frame = CGRect(
				x:		0,
				y:		0,
				width:	CGRectGetWidth(self.frame),
				height: self.menuSize.height
			)
		} else {
			self.pageViewController.view.frame = CGRect(
				x:		0,
				y:		0,
				width:	CGRectGetWidth(self.frame),
				height: CGRectGetHeight(self.frame) - self.menuSize.height
			)
			self.menuScrollView.frame = CGRect(
				x:		0,
				y:		CGRectGetHeight(self.frame) - self.menuSize.height,
				width:	CGRectGetWidth(self.frame),
				height: self.menuSize.height
			)
		}
	}

}
