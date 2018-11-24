//
//  QuestionViewProtocol.swift
//  StreamQuiz
//
//  Created by Kirill Averyanov on 5/29/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit

protocol QuestionViewProtocol: class {
  
  var mainLabel: UILabel! { get set }
  var animatingLabels: [UILabel] { get set }
  var alpha: CGFloat { get set }
  
  func configureLocalLabel(_ label: UILabel)
  func configure(text: String)
  
  func removeAnimatingLabels()
  func animateWords()
  
  func show(_ value: Bool)
  func layoutIfNeeded()
}

extension QuestionViewProtocol {
  
  func removeAnimatingLabels() {
    animatingLabels.forEach({ $0.removeFromSuperview() })
    animatingLabels.removeAll()
  }
  
  func animateWords() {
    guard let text = mainLabel.text else { return }
    let words = text.components(separatedBy: " ")
    removeAnimatingLabels()
    for _ in words {
      for _ in 0 ..< 2 {
        let newLabel = UILabel(frame: mainLabel.bounds)
        configureLocalLabel(newLabel)
        newLabel.text = mainLabel.text
        mainLabel.addSubview(newLabel)
        animatingLabels.append(newLabel)
      }
    }
    let mainAttributedString = NSMutableAttributedString(string: text)
    mainAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.clear,
                                      range: NSRange(location: 0, length: text.count))
    mainLabel.attributedText = mainAttributedString
    
    for label in animatingLabels {
      label.attributedText = mainAttributedString
    }
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.04, execute: { [weak self] in
      var startLocation = 0
      for (index, word) in words.enumerated() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.12 * Double(index), execute: { [weak self] in
          for i in 0 ..< 2 {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: UIColor.clear,
                                          range: NSRange(location: 0, length: text.count))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: i == 0 ? UIColor.white : UIColor.yellow,
                                          range: NSRange(location: startLocation, length: word.count))
            guard self?.animatingLabels.count ?? 0 > index * 2 + i else { return }
            let label = self?.animatingLabels[index * 2 + i]
            label?.attributedText = attributedString
            let distance: CGFloat = 5
            if let label = label {
              label.frame = CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height + distance)
            }
            let duration: TimeInterval = 0.12
            let delay: TimeInterval = 0.08
            
            if i == 1 {
              startLocation += word.count + 1
              UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                label?.alpha = 0
                self?.layoutIfNeeded()
              }, completion: { _ in
                label?.removeFromSuperview()
              })
            }
            
            UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
              if let label = label {
                label.frame = CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height - distance)
                self?.layoutIfNeeded()
              }
            }, completion: nil)
          }
        })
      }
    })
  }
  
  func configureLocalLabel(_ label: UILabel) {
    label.textColor = UIColor.white
    // iPhone 8 and smaller screen
    let size: CGFloat = UIScreen.main.bounds.height < 670 ? 22 : 35
    label.font = UIFont.appFont(.systemProBoldFont(size: size))
    label.textAlignment = .left
    label.numberOfLines = 5
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.4
  }
  
  func show(_ value: Bool) {
    if value {
      mainLabel.alpha = 0
      layoutIfNeeded()
    }
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.alpha = value ? 1 : 0
      self?.mainLabel.alpha = value ? 1 : 0
      self?.layoutIfNeeded()
    }
    UIView.animate(withDuration: 0.2, delay: 0.12, options: .curveLinear, animations: { [weak self] in
      self?.layoutIfNeeded()
    })
  }
}
