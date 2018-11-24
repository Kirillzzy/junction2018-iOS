//
//  ViewController.swift
//  talkingSauna
//
//  Created by Kirill Averyanov on 11/23/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit
import Pastel

class ViewController: UIViewController {
  
  @IBOutlet var animateButton: UIButton! {
    didSet {
      animateButton.layer.masksToBounds = true
      animateButton.backgroundColor = .white
      animateButton.setTitle("Hearing..", for: .normal)
      animateButton.titleLabel?.font = UIFont.appFont(.systemMediumFont(size: 22))
      animateButton.layer.cornerRadius = 60
//      animateButton.withShadow(color: UIColor.black)
    }
  }
  @IBOutlet var firstTitleLabel: UILabel! {
    didSet {
      firstTitleLabel.textColor = .white
      firstTitleLabel.font = UIFont.appFont(.systemMediumFont(size: 50))
      firstTitleLabel.text = ""
    }
  }
  @IBOutlet var secondTitleLabel: UILabel! {
    didSet {
      secondTitleLabel.textColor = .white
      secondTitleLabel.font = UIFont.appFont(.systemMediumFont(size: 50))
      secondTitleLabel.text = ""
    }
  }
  @IBOutlet var thirdTitleLabel: UILabel! {
    didSet {
      thirdTitleLabel.textColor = .white
      thirdTitleLabel.font = UIFont.appFont(.systemMediumFont(size: 50))
      thirdTitleLabel.text = ""
    }
  }
  @IBOutlet var fourthTitleLabel: UILabel! {
    didSet {
      fourthTitleLabel.textColor = .white
      fourthTitleLabel.font = UIFont.appFont(.systemMediumFont(size: 50))
      fourthTitleLabel.text = ""
    }
  }
  @IBOutlet var fifthTitleLabel: UILabel! {
    didSet {
      fifthTitleLabel.textColor = .white
      fifthTitleLabel.font = UIFont.appFont(.systemMediumFont(size: 24))
      fifthTitleLabel.text = ""
    }
  }
  @IBOutlet var firstDescriptionLabel: UILabel! {
    didSet {
      firstDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.6)
      firstDescriptionLabel.font = UIFont.appFont(.systemMediumFont(size: 16))
      firstDescriptionLabel.text = "inside"
    }
  }
  @IBOutlet var secondDescriptionLabel: UILabel! {
    didSet {
      secondDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.6)
      secondDescriptionLabel.font = UIFont.appFont(.systemMediumFont(size: 16))
      secondDescriptionLabel.text = "outside"
    }
  }
  @IBOutlet var thirdDescriptionLabel: UILabel! {
    didSet {
      thirdDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.6)
      thirdDescriptionLabel.font = UIFont.appFont(.systemMediumFont(size: 16))
      thirdDescriptionLabel.text = "stove"
    }
  }
  @IBOutlet var fourthDescriptionLabel: UILabel! {
    didSet {
      fourthDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.6)
      fourthDescriptionLabel.font = UIFont.appFont(.systemMediumFont(size: 16))
      fourthDescriptionLabel.text = "oxygen"
    }
  }
  @IBOutlet var fifthDescriptionLabel: UILabel! {
    didSet {
      fifthDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.6)
      fifthDescriptionLabel.font = UIFont.appFont(.systemMediumFont(size: 16))
      fifthDescriptionLabel.text = "was the highest\ntemperature"
    }
  }
  private var playAnimation = true
  var pastelView: PastelView!
  var buttonGradientLayer: CAGradientLayer!
  var longPollService: LongPollSwiftService?
  var timer: Timer?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateData()
    pastelView = PastelView(frame: view.bounds)
    
    // Custom Direction
    pastelView.startPastelPoint = .bottomLeft
    pastelView.endPastelPoint = .topRight
    
    // Custom Duration
    pastelView.animationDuration = 3
    
    // Custom Color
    pastelView.setColors([UIColor(red: 150/255, green: 39/255, blue: 176/255, alpha: 1.0),
                          UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                          UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                          UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                          UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                          UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                          UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
    
    pastelView.startAnimation()
    view.insertSubview(pastelView, at: 0)
    
    buttonGradientLayer = CAGradientLayer()
    buttonGradientLayer.colors = [UIColor(hexString: "1782FF").cgColor,
                                  UIColor(hexString: "0A05FF").cgColor]
    animateButton.layer.insertSublayer(buttonGradientLayer, at: 0)
    
    longPollService = LongPollSwiftService(longPollUrlInitialString: "reset", delegate: self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    playAnimation = true
    springImageView()
    
    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] _ in
      self?.updateData()
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    timer?.invalidate()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    pastelView.frame = view.bounds
    buttonGradientLayer.frame = animateButton.bounds
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  func updateData() {
    NetworkManager.sendRequest(with: "measurements", completion: { json in
      guard let json = json else { return }
      
      DispatchQueue.main.async { [weak self] in
        self?.firstTitleLabel.text = json["inside"].stringValue + "°"
        self?.secondTitleLabel.text = json["outdoor"].stringValue + "°"
        self?.thirdTitleLabel.text = json["stove"].stringValue + "°"
        self?.fourthTitleLabel.text = json["oxygen"].stringValue + "%"
        self?.fifthTitleLabel.text = json["highest_temperature"].stringValue + "°"
      }
    })
  }
  
  func springImageView() {
    if !playAnimation { return }
    
    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: { [weak self] in
      self?.animateButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      self?.animateButton.layoutIfNeeded()
    }) { [weak self] _ in
      UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2,
                     initialSpringVelocity: 5, options: .curveEaseInOut,
                     animations: { [weak self] in
                      self?.animateButton.transform = .identity
                      self?.animateButton.layoutIfNeeded()
        }, completion: { [weak self] _ in
          self?.springImageView()
      })
    }
  }
  
  @IBAction func animateButtonAction(_ sender: Any) {
//    playAnimation = !playAnimation
//    if playAnimation {
//      springImageView()
//    }
  }
  
}

extension ViewController: LongPollSwiftServiceDelegate {
  func longPollService(_ service: LongPollSwiftService, jsonEvents: JSON) {
    if jsonEvents["type"].stringValue == "reload" {
      longPollService?.startLongPoll()
      return
    }
    print(jsonEvents)
  }
}
