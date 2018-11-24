//
//  ViewController.swift
//  talkingSauna
//
//  Created by Kirill Averyanov on 11/23/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit
import Pastel
import Charts

class ViewController: UIViewController {
  
  @IBOutlet var animateButton: UIButton! {
    didSet {
      animateButton.setImage(#imageLiteral(resourceName: "img_button"), for: .normal)
    }
  }
  @IBOutlet var mainDescriptionLabel: UILabel! {
    didSet {
      mainDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.6)
      mainDescriptionLabel.font = UIFont.appFont(.systemMediumFont(size: 16))
      mainDescriptionLabel.text = "current condition"
    }
  }
  @IBOutlet var mainTitleLabel: UILabel! {
    didSet {
      mainTitleLabel.textColor = .white
      mainTitleLabel.font = UIFont.appFont(.systemMediumFont(size: 50))
      mainTitleLabel.text = ""
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
      fifthDescriptionLabel.text = "current enthalpy"
    }
  }
  @IBOutlet var askLabel: UILabel! {
    didSet {
      askLabel.textColor = UIColor.black.withAlphaComponent(0.6)
      askLabel.font = UIFont.appFont(.systemMediumFont(size: 20))
      askLabel.text = "Ask current temperature"
    }
  }
  @IBOutlet var chartView: LineChartView! {
    didSet {
      chartView.noDataText = ""
      chartView.xAxis.drawGridLinesEnabled = false
      chartView.leftAxis.drawGridLinesEnabled = false
      chartView.rightAxis.drawGridLinesEnabled = false
      chartView.leftAxis.removeAllLimitLines()
      chartView.xAxis.labelPosition = .bottom
      chartView.xAxis.axisLineColor = UIColor(hexString: "EFEEF0")
      chartView.leftAxis.axisLineColor = UIColor(hexString: "EFEEF0")
      chartView.rightAxis.enabled = false
      chartView.leftAxis.enabled = false
      chartView.xAxis.enabled = false
      chartView.chartDescription?.enabled = false
      chartView.leftAxis.labelTextColor = UIColor(hexString: "9AA1AB")
      chartView.xAxis.labelTextColor = UIColor(hexString: "9AA1AB")
      chartView.leftAxis.xOffset = 0
      chartView.xAxis.yOffset = 0
      chartView.legend.enabled = false
      chartView.xAxis.avoidFirstLastClippingEnabled = true
    }
  }
  private var playAnimation = true
  var pastelView: PastelView!
  var longPollService: LongPollSwiftService?
  var timer: Timer?
  var points = [Double]()
  var lastXTime: Double = 0
  var quality: Double = 0 {
    didSet {
      var string = ""
      switch quality {
      case ...100:
        string = "Wait a bit more ❄️"
      case 100 ... 200:
        string = "Just heated 🌝"
      case 200 ... 300:
        string = "For oldy 👴🏼"
      case 300 ... 400:
        string = "Just right 👌🏻"
      case 400 ... 500:
        string = "Hardcore 💥"
      case 500 ... 600:
        string = "Hot! 🔥"
      case 600 ... 650:
        string = "HELL YEAH 💀"
      case 650...:
        string = "I'd call emergency 🚨"
      default:
        string = "idk"
      }
      mainTitleLabel.text = string
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateData(first: "m_cache", second: "last_measurements")
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
    
    longPollService = LongPollSwiftService(longPollUrlInitialString: "reset", delegate: self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    playAnimation = true
    springImageView()
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] _ in
      self?.updateData()
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    timer?.invalidate()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    pastelView.frame = view.bounds
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  func updateData(first: String = "measurements", second: String = "last_measurement") {
    NetworkManager.sendRequest(with: first, completion: { json in
      guard let json = json else { return }
      
      DispatchQueue.main.async { [weak self] in
        self?.firstTitleLabel.text = json["inside"].stringValue + "°"
        self?.secondTitleLabel.text = json["outdoor"].stringValue + "°"
        self?.thirdTitleLabel.text = json["stove"].stringValue + "°"
        self?.fourthTitleLabel.text = json["oxygen"].stringValue + "%"
        self?.quality = json["enthalpy"].doubleValue
      }
    })
    NetworkManager.sendRequest(with: second) { json in
      guard let json = json else { return }
      
      DispatchQueue.main.async { [weak self] in
        if second == "last_measurement" {
          if self?.points.count ?? 0 > 0 {
            self?.points.remove(at: 0)
            self?.initialUpdateChart()
            self?.updateChart(point: json["measurement"].doubleValue)
            self?.fifthTitleLabel.text = json["measurement"].stringValue
          }
          return
        }
        var points = [Double]()
        for item in json["measurements"].arrayValue {
          points.append(item.doubleValue)
        }
        
        self?.points = points
        self?.initialUpdateChart()
      }
    }
  }
  
  func initialUpdateChart() {
    var dataEntries: [ChartDataEntry] = []
    for (index, point) in points.enumerated() {
      let dataEntry = ChartDataEntry(x: Double(index), y: point)
      dataEntries.append(dataEntry)
      lastXTime = Double(index)
    }
    let lineChartDataSet = LineChartDataSet(values: dataEntries, label: nil)
    
    var colors = [UIColor]()
    for _ in 0 ..< points.count {
      colors.append(UIColor(hexString: "76ADE2"))
    }

    lineChartDataSet.circleColors = colors
    lineChartDataSet.circleRadius = 0
    lineChartDataSet.circleHoleRadius = 0
    lineChartDataSet.mode = .cubicBezier
    lineChartDataSet.setColor(UIColor.white)
    lineChartDataSet.lineWidth = 2.4
    lineChartDataSet.highlightColor = UIColor(hexString: "CAD7EE")
    lineChartDataSet.highlightLineWidth = 2
    lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
    lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
    
    let lineChartData = LineChartData(dataSet: lineChartDataSet)
    lineChartData.setValueTextColor(UIColor.clear)
    chartView.data = lineChartData
  }
  
  func updateChart(point: Double) {
    lastXTime += 1
    points.append(point)
    chartView.data?.addEntry(ChartDataEntry(x: lastXTime, y: point), dataSetIndex: 0)
    chartView.notifyDataSetChanged()
    chartView.moveViewToX(lastXTime)
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
    if jsonEvents["type"].stringValue == "text" {
      AudioHelper.playText(string: jsonEvents["message"].stringValue)
    }
    print(jsonEvents)
  }
}
