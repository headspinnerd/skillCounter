//
//  SpeechBubble.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-23.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

enum Position {
    case top
    case left
    case right
    case bottom
}

class SpeechBubble: UIView {  // a bit strange when you specify (position left - partition 1,2 ) or (position right - partition 1,2 )
    
    var color:UIColor = .gray
    var position: Position = .bottom
    var partition: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init(withColor frame: CGRect, color: UIColor? = .none, position: Position? = .bottom, partition: CGFloat? = 1) {
        self.init(frame: frame)
        
        if let color = color, let position = position, let partition = partition {
            self.color = color
            self.position = position
            self.partition = partition
        }
        self.draw(CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        
        let rounding:CGFloat = rect.width * 0.04
        
        //Draw the main frame
        var bubbleFrame = CGRect()
        switch position {
        case .bottom: bubbleFrame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 3 / 4)
        case .top: bubbleFrame = CGRect(x: 0, y: rect.height * 1 / 4, width: rect.width, height: rect.height * 3 / 4)
        case .right: bubbleFrame = CGRect(x: 0, y: 0, width: rect.width * 5 / 6, height: rect.height)
        case .left: bubbleFrame = CGRect(x: rect.width * 1 / 6, y: 0, width: rect.width * 5 / 6, height: rect.height)
        }

        let bubblePath = UIBezierPath(roundedRect: bubbleFrame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: rounding, height: rounding))
        
        //Color the bubbleFrame
        color.setStroke()
        color.setFill()
        bubblePath.stroke()
        bubblePath.fill()
        
        //Add the point
        let context = UIGraphicsGetCurrentContext()
        
        //Start the line
        context?.beginPath()
        var startLineY: CGFloat = 0
        var closeLineY: CGFloat = 0
        switch position {
        case .bottom:
            startLineY = bubbleFrame.maxY
            closeLineY = bubbleFrame.maxY
        case .top:
            startLineY = bubbleFrame.minY
            closeLineY = bubbleFrame.minY
        case .left, .right :
            switch partition {
            case 0,1: startLineY = bubbleFrame.minY + bubbleFrame.height * partition/4
                      closeLineY = bubbleFrame.minY + bubbleFrame.height * (partition+1)/4
            case 2,3: startLineY = bubbleFrame.minY + bubbleFrame.height * (partition+1)/4
                      closeLineY = bubbleFrame.minY + bubbleFrame.height * partition/4
            default: break
            }
            switch partition {
            case 0: startLineY += rect.height * 0.04
                    closeLineY += rect.height * 0.04
            case 3: startLineY -= rect.height * 0.04
                    closeLineY -= rect.height * 0.04
            default: break
            }
        }
        var startLineX: CGFloat = 0
        var closeLineX: CGFloat = 0
        switch position {
        case .right:
            startLineX = bubbleFrame.maxX
            closeLineX = bubbleFrame.maxX
        case .left:
            startLineX = bubbleFrame.minX
            closeLineX = bubbleFrame.minX
        case .bottom, .top:
            switch partition {
            case 0...2: startLineX = bubbleFrame.minX + bubbleFrame.width * partition/6
                        closeLineX = bubbleFrame.minX + bubbleFrame.width * (partition+1)/6
            case 3...5: startLineX = bubbleFrame.minX + bubbleFrame.width * (partition+1)/6
                        closeLineX = bubbleFrame.minX + bubbleFrame.width * partition/6
            default :break
            }
            switch partition {
            case 0: startLineX += rect.width * 0.04
                    closeLineX += rect.width * 0.04
            case 5: startLineX -= rect.width * 0.04
                    closeLineX -= rect.width * 0.04
            default: break
            }
        }
        context?.move(to: CGPoint(x: startLineX, y: startLineY))
    
        var tangent1EndX: CGFloat = 0
        var tangent1EndY: CGFloat = 0
        var tangent2End = CGPoint()
        switch position {
        case .bottom:
            tangent1EndY = rect.maxY
            switch partition {
            case 0...2:
                tangent1EndX = rect.maxX * partition/6
                tangent2End = CGPoint(x: bubbleFrame.maxX, y: bubbleFrame.minY)
            case 3...5:
                tangent1EndX = rect.maxX * (partition+1)/6
                tangent2End = CGPoint(x: bubbleFrame.minX, y: bubbleFrame.minY)
            default :break
            }
            switch partition {
            case 0: tangent1EndX += rect.width * 0.04
            case 5: tangent1EndX -= rect.width * 0.04
            default: break
            }
        case .top:
            tangent1EndY = rect.minY
            switch partition {
            case 0...2:
                tangent1EndX = rect.maxX * partition/6
                tangent2End = CGPoint(x: bubbleFrame.maxX, y: bubbleFrame.maxY)
            case 3...5:
                tangent1EndX = rect.maxX * (partition+1)/6
                tangent2End = CGPoint(x: bubbleFrame.minX, y: bubbleFrame.maxY)
            default :break
            }
            switch partition {
            case 0: tangent1EndX += rect.width * 0.04
            case 5: tangent1EndX -= rect.width * 0.04
            default: break
            }
        case .right:
            tangent1EndX = rect.maxX
            switch partition {
            case 0,1:
                tangent1EndY = rect.maxY * partition/4
                tangent2End = CGPoint(x: bubbleFrame.minX,y: bubbleFrame.maxY)
            case 2,3:
                tangent1EndY = rect.maxY * (partition+1)/4
                tangent2End = CGPoint(x: bubbleFrame.minX,y: bubbleFrame.minY)
            default: break
            }
            switch partition {
            case 0: tangent1EndY += rect.height * 0.04
            case 3: tangent1EndY -= rect.height * 0.04
            default: break
            }
        case .left:
            tangent1EndX = rect.minX
            switch partition {
            case 0,1:
                tangent1EndY = rect.maxY * partition/4
                tangent2End = CGPoint(x: bubbleFrame.maxX,y: bubbleFrame.maxY)
            case 2,3:
                tangent1EndY = rect.maxY * (partition+1)/4
                tangent2End = CGPoint(x: bubbleFrame.maxX,y: bubbleFrame.minY)
            default: break
            }
            switch partition {
            case 0: tangent1EndY += rect.height * 0.04
            case 3: tangent1EndY -= rect.height * 0.04
            default: break
            }
        }
        //Draw a rounded point
        context?.addArc(tangent1End: CGPoint(x: tangent1EndX, y: tangent1EndY), tangent2End: tangent2End, radius: rounding * 0.5)
        
        //Close the line
        context?.addLine(to: CGPoint(x: closeLineX, y: closeLineY))
        context?.closePath()
        
        //fill the color
        context?.setFillColor(color.cgColor)
        context?.fillPath();
    }
}
