//
//  ClockView.swift
//  Task4CALayersAndAnimation(optional)
//
//  Created by Tymofii (Work) on 29.09.2021.
//

import UIKit

class ClockView: UIView {
    
    // MARK: - Configuration
    
    enum Configuration {
        static let itemSpacing: CGFloat = 20
        static let mainRingIndent: CGFloat = 140
        static let mainRingWidth: CGFloat = 100
        static let tachymeterScaleIndent: CGFloat = 47
        static let tachymeterScaleLongWidth: CGFloat = 10
        static let tachymeterScaleShortWidth: CGFloat = 5
        static let innerDashesIndent: CGFloat = 65
        static let innerDashesWidth: CGFloat = 10
        static let innerCirclesRadius: CGFloat = 10
        static let innerCirclesIndent: CGFloat = 35
        static let innerCircleText = ["10", "20", "30", "40", "50"]
        static let innerCircleTextRadius: CGFloat = 60
        static let centerCircleRadius: CGFloat = 5
        static let hourHandWidth: CGFloat = 8
        static let minuteHandWidth: CGFloat = 7
        static let secondHandWidth: CGFloat = 3
        static let innerTriangleOneCornerByY: CGFloat = 35
        static let innerTriangleTwoCornerByX: CGFloat = -15
        static let innerTriangleTwoCornerByY: CGFloat = 20
        static let innerTriangleThreeCornerByX: CGFloat = 15
        static let innerTriangleThreeCornerByY: CGFloat = 20
    }
    
    // MARK: - UI element
    
    private lazy var sunButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
        button.tintColor = .white
        button.layer.setAffineTransform(CGAffineTransform(scaleX: 1.5, y: 1.5))
        
        return button
    }()
    
    private lazy var moonButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        button.tintColor = .white
        button.layer.setAffineTransform(CGAffineTransform(scaleX: 1.5, y: 1.5))
        
        return button
    }()
    
    // MARK: - Variable
    
    private var clockColor: UIColor = .white {
        didSet {
            if clockColor == .white {
                sunButton.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
            } else {
                sunButton.setImage(UIImage(systemName: "sun.max"), for: .normal)
            }
            
        }
    }
    
    private var clockBackgroundColor: UIColor = .black {
        didSet {
            if clockColor == .black {
                moonButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
            } else {
                moonButton.setImage(UIImage(systemName: "moon"), for: .normal)
            }
        }
    }
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupSubview() {
        addSubview(sunButton)
        addSubview(moonButton)
        
        sunButton.addTarget(self, action: #selector(changeColor(sender: )), for: .touchUpInside)
        moonButton.addTarget(self, action: #selector(changeColor(sender: )), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        sunButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sunButton.topAnchor.constraint(equalTo: topAnchor, constant: Configuration.itemSpacing),
            sunButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Configuration.itemSpacing)
        ])
        
        moonButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moonButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Configuration.itemSpacing),
            moonButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Configuration.itemSpacing)
        ])
    }
    
    // MARK: - UIAction
    
    @objc private func changeColor(sender: UIButton) {
        if sender == sunButton {
            clockColor = clockColor == .white ? .black : .white
        } else {
            clockBackgroundColor =  clockBackgroundColor == .black ? .white : .black
        }
    }
    
    override public func draw(_ rect: CGRect) {
        circleLayer(rect: rect, radius: Configuration.mainRingIndent, fillColor: .white)
        circleLayer(rect: rect, radius: Configuration.mainRingWidth, fillColor: .black)
        lineByCircle(count: 60, radius: Configuration.tachymeterScaleIndent, rect: rect)
        drawCirclesByCircle(12, rect: rect, indent: Configuration.innerCirclesIndent)
        lineByCircleIn(count: 6, radius: Configuration.innerDashesIndent, rect: rect)
        textByCircleIn(count: Configuration.innerCircleText.count, radius: Configuration.innerCircleTextRadius, rect: rect)
        drawTriangle(
            corner: CGPoint(
                x: rect.midX,
                y: rect.minY + Configuration.innerTriangleOneCornerByY),
            two: CGPoint(
                x: rect.midX - Configuration.innerTriangleTwoCornerByX,
                y: rect.minY + Configuration.innerTriangleTwoCornerByY),
            three: CGPoint(
                x: rect.midX + Configuration.innerTriangleThreeCornerByX,
                y: rect.minY + Configuration.innerTriangleThreeCornerByY))
        arrowsLayout(rect)
        circleLayer(rect: rect, radius: Configuration.centerCircleRadius, fillColor: .white)
    }
    
    // MARK: - Draw circle
    
    private func circleLayer(rect: CGRect, radius: CGFloat, fillColor: UIColor) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = fillColor.cgColor
        circleLayer.lineWidth = 3
        circleLayer.strokeColor = UIColor.white.cgColor
        
        layer.addSublayer(circleLayer)
    }
    
    private func drawCirclesByCircle(_ count: Int, rect: CGRect, indent: CGFloat) {
        var startAngle: Double = 0
        let angle: Double = 360 / Double(count)
        let rad = Double.pi / 180
        for _ in 1...count {
            let x = rect.minX + indent * 2 * cos(Double(startAngle) * rad)
            let y = rect.minY + indent * 2 * sin(Double(startAngle) * rad)
            let elemetRect = CGRect(x: x, y: y, width: rect.width, height: rect.height)
            circleLayer(rect: elemetRect, radius: Configuration.innerCirclesRadius, fillColor: .white)
            startAngle += angle
        }
    }
    
    // MARK: - Draw line
    
    private func lineLayer(startPoint: CGPoint, endPoint: CGPoint, fillColor: UIColor, lineWidth: CGFloat) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        linePath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = lineWidth
        lineLayer.lineCap = CAShapeLayerLineCap.round
        lineLayer.strokeColor = fillColor.cgColor
        
        layer.addSublayer(lineLayer)
    }
    
    private func lineByCircle(count: Int, radius: CGFloat, rect: CGRect) {
        var startAngle = 0
        let angle = 360 / count
        let radiusStart = radius
        let radiusEnd = radius - Configuration.tachymeterScaleShortWidth
        let rad = Double.pi / 180
        for i in 0...count - 1 {
            var xs = rect.midX
            var ys = rect.midY
            var xe = rect.midX
            var ye = rect.midY
            if i % 5 == 0 {
                xs += radiusStart * 2 * cos(Double(startAngle) * rad)
                ys += radiusStart * 2 * sin(Double(startAngle) * rad)
                xe += radiusEnd * 2 * cos(Double(startAngle) * rad)
                ye += radiusEnd * 2 * sin(Double(startAngle) * rad)
            } else {
                xs += radiusStart * 2 * cos(Double(startAngle) * rad)
                ys += radiusStart * 2 * sin(Double(startAngle) * rad)
                xe += (radiusEnd + 2) * 2 * cos(Double(startAngle) * rad)
                ye += (radiusEnd + 2) * 2 * sin(Double(startAngle) * rad)
            }
            let startPoint = CGPoint(x: xs, y: ys)
            let endPoint = CGPoint(x: xe, y: ye)
            lineLayer(startPoint: startPoint, endPoint: endPoint, fillColor: .white, lineWidth: 2)
            startAngle += angle
        }
    }
    
    private func lineByCircleIn(count: Int, radius: CGFloat, rect: CGRect) {
        var startAngle = 0
        let angle = 360 / count
        let radiusStart = radius
        let radiusEnd = radius - Configuration.innerDashesWidth
        let rad = Double.pi / 180
        for _ in 0...count - 1 {
            let xs = rect.midX + radiusStart * 2 * cos(Double(startAngle) * rad)
            let ys = rect.midY + radiusStart * 2 * sin(Double(startAngle) * rad)
            let xe = rect.midX + (radiusEnd + 2) * 2 * cos(Double(startAngle) * rad)
            let ye = rect.midY + (radiusEnd + 2) * 2 * sin(Double(startAngle) * rad)
            let startPoint = CGPoint(x: xs, y: ys)
            let endPoint = CGPoint(x: xe, y: ye)
            lineLayer(startPoint: startPoint, endPoint: endPoint, fillColor: .black, lineWidth: 4)
            startAngle += angle
        }
    }
    
    // MARK: - Draw text
    
    private func textLayer(point: CGPoint, text: String) {
        let textLayer = CATextLayer()
        textLayer.frame = .init(x: point.x, y: point.y, width: bounds.width, height: bounds.height)
        textLayer.string = text
        textLayer.fontSize = 25
        textLayer.foregroundColor = UIColor.black.cgColor
        
        layer.addSublayer(textLayer)
    }
    
    private func textByCircleIn(count: Int, radius: CGFloat, rect: CGRect) {
        var startAngle = -30
        let angle = 360 / (count + 1)
        let rad = Double.pi / 180
        let text = Configuration.innerCircleText
        var numberText = 0
        for i in 0...count {
            if i != count {
                let xs = rect.midX + radius * 2 * cos(Double(startAngle) * rad)
                let ys = rect.midY + radius * 2 * sin(Double(startAngle) * rad)
                textLayer(point: CGPoint(x: xs - 15, y: ys - 15), text: text[numberText])
                numberText += 1
            }
            startAngle += angle
        }
    }
    
    // MARK: - Draw triangle
    
    private func drawTriangle(corner one: CGPoint, two: CGPoint, three: CGPoint) {
        let path = CGMutablePath()
        path.move(to: one)
        path.addArc(tangent1End: one, tangent2End: two, radius: 2)
        path.addArc(tangent1End: two, tangent2End: three, radius: 2)
        path.addArc(tangent1End: three, tangent2End: one, radius: 2)
        path.closeSubpath()

        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.red.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
    
    // MARK: - Draw arrows
    
    private func arrowsLayout(_ rect: CGRect) {
        // Create and draw hour hand layer
        let hourHandLayer = CALayer()
        hourHandLayer.backgroundColor = UIColor.black.cgColor
        hourHandLayer.cornerRadius = 5
        hourHandLayer.borderColor = UIColor.white.cgColor
        hourHandLayer.borderWidth = 2
        hourHandLayer.shadowColor = UIColor.black.cgColor
        hourHandLayer.shadowRadius = 5
        hourHandLayer.shadowOffset = .init(width: -5, height: -5)
        hourHandLayer.shadowOpacity = 1
        hourHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
        hourHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Create and draw minute hand layer
        let minuteHandLayer = CALayer()
        minuteHandLayer.backgroundColor = UIColor.black.cgColor
        minuteHandLayer.cornerRadius = 5
        minuteHandLayer.borderWidth = 2
        minuteHandLayer.borderColor = UIColor.white.cgColor
        minuteHandLayer.shadowColor = UIColor.black.cgColor
        minuteHandLayer.shadowRadius = 5
        minuteHandLayer.shadowOffset = .init(width: -5, height: -5)
        minuteHandLayer.shadowOpacity = 1
        minuteHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
        minuteHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Create and draw second hand layer
        let secondHandLayer = CALayer()
        secondHandLayer.backgroundColor = UIColor.red.cgColor
        secondHandLayer.cornerRadius = 5
        secondHandLayer.shadowColor = UIColor.black.cgColor
        secondHandLayer.shadowOffset = .init(width: -5, height: -5)
        secondHandLayer.shadowRadius = 5
        secondHandLayer.shadowOpacity = 1
        secondHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
        secondHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Set size of all hands
        if rect.size.width > rect.size.height {
            hourHandLayer.bounds = CGRect(x: 0, y: 0, width: Configuration.hourHandWidth, height: (rect.size.height / 2) - (rect.size.height * 0.2))
            minuteHandLayer.bounds = CGRect(x: 0, y: 0, width: Configuration.minuteHandWidth, height: (rect.size.height / 2) - (rect.size.height * 0.1))
            secondHandLayer.bounds = CGRect(x: 0, y: 0, width: Configuration.secondHandWidth, height: rect.size.height / 2 - 10)
        } else {
            hourHandLayer.bounds = CGRect(x: 0, y: 0, width: Configuration.hourHandWidth, height: (rect.size.width / 2) - (rect.size.width * 0.2))
            minuteHandLayer.bounds = CGRect(x: 0, y: 0, width: Configuration.minuteHandWidth, height: (rect.size.width / 2) - (rect.size.width * 0.1))
            secondHandLayer.bounds = CGRect(x: 0, y: 0, width: Configuration.secondHandWidth, height: rect.size.width / 2 - 10)
        }
        
        // Add all hand layers to as sublayers
        layer.addSublayer(hourHandLayer)
        layer.addSublayer(minuteHandLayer)
        layer.addSublayer(secondHandLayer)
        
        // Get current hours, minutes and seconds
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        // Calculate the angles for the each hand
        let hourAngle = CGFloat(hours * (360 / 12)) + CGFloat(minutes) * (1.0 / 60) * (360 / 12)
        let minuteAngle = CGFloat(minutes * (360 / 60))
        let secondsAngle = CGFloat(seconds * (360 / 60))
        
        // Transform the hands according to the calculated angles
        hourHandLayer.transform = CATransform3DMakeRotation(hourAngle / CGFloat(180 * Double.pi), 0, 0, 1)
        minuteHandLayer.transform = CATransform3DMakeRotation(minuteAngle / CGFloat(180 * Double.pi), 0, 0, 1)
        secondHandLayer.transform = CATransform3DMakeRotation(secondsAngle / CGFloat(180 * Double.pi), 0, 0, 1)
        
        // Create animation for seconds hand
        let secondsHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        secondsHandAnimation.repeatCount = Float.infinity
        secondsHandAnimation.duration = 60
        secondsHandAnimation.isRemovedOnCompletion = false
        secondsHandAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        secondsHandAnimation.fromValue = (secondsAngle + 180) * CGFloat(Double.pi / 180)
        secondsHandAnimation.byValue = 2 * Double.pi
        secondHandLayer.add(secondsHandAnimation, forKey: "secondsHandAnimation")
        
        // Create animation for minutes hand
        let minutesHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        minutesHandAnimation.repeatCount = Float.infinity
        minutesHandAnimation.duration = 60 * 60
        minutesHandAnimation.isRemovedOnCompletion = false
        minutesHandAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        minutesHandAnimation.fromValue = (minuteAngle + 180) * CGFloat(Double.pi / 180)
        minutesHandAnimation.byValue = 2 * Double.pi
        minuteHandLayer.add(minutesHandAnimation, forKey: "minutesHandAnimation")
        
        // Create animation for hours hand
        let hoursHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        hoursHandAnimation.repeatCount = Float.infinity
        hoursHandAnimation.duration = CFTimeInterval(60 * 60 * 12);
        hoursHandAnimation.isRemovedOnCompletion = false
        hoursHandAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        hoursHandAnimation.fromValue = (hourAngle + 180)  * CGFloat(Double.pi / 180)
        hoursHandAnimation.byValue = 2 * Double.pi
        hourHandLayer.add(hoursHandAnimation, forKey: "hoursHandAnimation")
    }
}

