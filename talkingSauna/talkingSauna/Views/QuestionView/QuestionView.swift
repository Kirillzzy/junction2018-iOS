
//
//  QuestionView.swift
//  StreamQuiz
//
//  Created by Kirill Averyanov on 1/14/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit

class QuestionView: UIView, QuestionViewProtocol {
  @IBOutlet var mainLabel: UILabel! {
    didSet {
      configureLocalLabel(mainLabel)
    }
  }
  @IBOutlet var mainViewTopConstraint: NSLayoutConstraint!
  let progressDescriptionLabelWidthConstant: CGFloat = 55
  var action: ((_ variantIndex: Int) -> Void)?
  var lastSelectedIndex: Int?
  var animatingLabels = [UILabel]()
  var canPlay: Bool = false
  var isLast: Bool = false
  var isShownSuccessView: Bool = false
  var disabledAlphaButton: Bool = false
  
  func configure(text: String) {
    mainLabel.attributedText = nil
    mainLabel.text = text
    
    removeAnimatingLabels()
    animateWords()
  }
    
  // MARK: - For loading from Nib
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return self.loadFromNibIfEmbeddedInDifferentNib()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .clear
    isMultipleTouchEnabled = false
    backgroundColor = UIColor(hexString: "004CF3").withAlphaComponent(0.8)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    animatingLabels.forEach({ $0.frame = mainLabel.bounds })
  }
}
