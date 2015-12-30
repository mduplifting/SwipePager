//
//  SwipePagerMenu.swift
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

public class SwipePagerMenu: UIView {
    
    // MARK: - Property
    
    public var title: String?
    public var font: UIFont?
    public var stateNormalColor: UIColor?
    public var stateNormalFontColor: UIColor?
    public var stateHighlightColor: UIColor?
    public var stateHighlightFontColor: UIColor?
    
    private var titelLabel: UILabel = UILabel()
    
    override public var frame: CGRect {
        didSet {
            self.titelLabel.frame = CGRect(
				x:		0,
				y:		0,
				width:	CGRectGetWidth(self.frame),
				height: CGRectGetHeight(self.frame)
            )
        }
    }
    
    // MARK: - LifeCycle
    
    required public init() {
        super.init(frame: CGRect.zero)
        self.titelLabel = UILabel()
        self.titelLabel.backgroundColor = UIColor.clearColor()
        self.titelLabel.textAlignment = .Center
        self.addSubview(self.titelLabel)
    }

    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func config() {
		self.titelLabel.text = self.title
		self.titelLabel.font = self.font
        self.stateNormal()
    }
    
    func stateNormal() {
		self.backgroundColor = self.stateNormalColor
		self.titelLabel.textColor = self.stateNormalFontColor
    }
    
    func stateHighlight() {
        self.backgroundColor = self.stateHighlightColor
        self.titelLabel.textColor = self.stateHighlightFontColor
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
