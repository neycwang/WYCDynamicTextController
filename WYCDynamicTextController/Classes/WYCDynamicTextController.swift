//
//  WYCDynamicTextController.swift
//  Pods
//
//  Created by apple on 2017/2/19.
//
//

import UIKit

public enum panGestureState
{
    case UPPERLEFT
    case LOWERLEFT
    case UPPERRIGHT
    case LOWERRIGHT
    case MIDDLE
    case NONE
}

open class WYCDynamicTextController: UIViewController
{
    public var textField: UITextField!
    
    private var width, height: CGFloat!
    public var gestureState: panGestureState = .NONE
    {
        didSet
        {
            stateChanged()
        }
    }
    
    public var minFrameLength: CGFloat = 16
    public var minDist: CGFloat = 14
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        width = view.frame.width
        height = view.frame.height
        
        textField = UITextField(frame: CGRect(x: 96, y: 96, width: 192, height: 24))
        textField.font = .systemFont(ofSize: 24)
        textField.returnKeyType = .done
        textField.delegate = self
        view.addSubview(textField)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipe(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func swipe(_ sender: UIPanGestureRecognizer)
    {
        let loc = sender.location(in: view)
        let trans = sender.translation(in: view)
        if sender.state == .began && gestureState == .NONE
        {
            gestureState = whereStarted(loc: loc)
            return
        }
        if sender.state == .ended
        {
            gestureState = .NONE
            return
        }
        if sender.state == .changed
        {
            if gestureState == .MIDDLE
            {
                textField.frame.origin = CGPoint(x: textField.frame.minX + trans.x, y: textField.frame.minY + trans.y)
            }
            if gestureState == .UPPERLEFT
            {
                if textField.frame.width - trans.x < minFrameLength || textField.frame.height - trans.y < minFrameLength
                {
                    gestureState = .NONE
                }
                else
                {
                    textField.frame = CGRect(x: textField.frame.minX + trans.x, y: textField.frame.minY + trans.y, width: textField.frame.width - trans.x, height: textField.frame.height - trans.y)
                }
            }
            if gestureState == .LOWERLEFT
            {
                if textField.frame.width - trans.x < minFrameLength || textField.frame.height + trans.y < minFrameLength
                {
                    gestureState = .NONE
                }
                else
                {
                    textField.frame = CGRect(x: textField.frame.minX + trans.x, y: textField.frame.minY, width: textField.frame.width - trans.x, height: textField.frame.height + trans.y)
                }
            }
            if gestureState == .UPPERRIGHT
            {
                if textField.frame.width + trans.x < minFrameLength || textField.frame.height - trans.y < minFrameLength
                {
                    gestureState = .NONE
                }
                else
                {
                    textField.frame = CGRect(x: textField.frame.minX, y: textField.frame.minY + trans.y, width: textField.frame.width + trans.x, height: textField.frame.height - trans.y)
                }
            }
            if gestureState == .LOWERRIGHT
            {
                if textField.frame.width + trans.x < minFrameLength || textField.frame.height + trans.y < minFrameLength
                {
                    gestureState = .NONE
                }
                else
                {
                    textField.frame = CGRect(x: textField.frame.minX, y: textField.frame.minY, width: textField.frame.width + trans.x, height: textField.frame.height + trans.y)
                }
            }
            sender.setTranslation(CGPoint.zero, in: view)
            textField.font = .systemFont(ofSize: textField.frame.height)
            return
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let loc = touches.first!.location(in: view)
        gestureState = whereStarted(loc: loc)
    }
    
    private func whereStarted(loc: CGPoint) -> panGestureState
    {
        let frame = textField.frame
        let upperleft = CGPoint(x: frame.minX, y: frame.minY)
        let lowerleft = CGPoint(x: frame.minX, y: frame.maxY)
        let upperright = CGPoint(x: frame.maxX, y: frame.minY)
        let lowerright = CGPoint(x: frame.maxX, y: frame.maxY)
        if distance(a: upperleft, b: loc) < minDist
        {
            return .UPPERLEFT
        }
        if distance(a: lowerleft, b: loc) < minDist
        {
            return .LOWERLEFT
        }
        if distance(a: upperright, b: loc) < minDist
        {
            return .UPPERRIGHT
        }
        if distance(a: lowerright, b: loc) < minDist
        {
            return .LOWERRIGHT
        }
        if frame.contains(loc)
        {
            return .MIDDLE
        }
        return .NONE
    }
    
    private func distance(a: CGPoint, b: CGPoint) -> CGFloat
    {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return sqrt(xDist * xDist + yDist * yDist)
    }
    
    open func stateChanged()
    {
        
    }
}

extension WYCDynamicTextController: UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
