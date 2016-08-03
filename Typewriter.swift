//
//  TypeWrite.swift
//  cardhero
//
//  Created by abot on 2015/08/31.
//  Copyright (c) 2015年 abot. All rights reserved.
//

import Foundation
import UIKit
// read icon
//import NVActivityIndicatorView

protocol TypeWriterDelegate {
    func delegateTypeWriterEnd(called_id:Int)
}

class TypeWriter : UIView{
    
    var messages:[String] = []
    var fade_in_time:Double = 0.05
    var fade_out_time = 0.5
    var nl = "¥n"
    var timer_count = 0
    var displaying_char_count = 1
    var timer:NSTimer = NSTimer()
    var stop_message_code = "{stop:$x}" //timer
    var message_count = 0
//    var read_icon = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),type: .BallBeat)
    var labels : [UILabel] = []
    var label_count : Int = 0
    var label_text_count : Int = 0
    var font_size : CGFloat = 12
    var label_size : [CGFloat] = [100,25]
    var label_point : [CGFloat] = [0,0]
    var box_size : [CGFloat] = [100,25]
    var box_point : [CGFloat] = [0,0]
    var label_message:[String] = []
    var delegate: TypeWriterDelegate!
    var called_id = 0
    var row_length = 25
    
    func subInit(messages : [String]? = [""],fade_in_time : Double? = nil ,fade_out_time:Double? = nil) {
        
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        
        //↓ window background image
        //let tip = UIImageView(frame: CGRectMake(0,0,myBoundSize.width, 100))
        //let image = UIImage(named: "Image")
        //tip.image = image
        //self.addSubview(tip)
        
        self.messages = messages!
        self.fade_in_time = fade_in_time != nil ? fade_in_time! : self.fade_in_time
        self.fade_out_time = fade_out_time != nil ? fade_out_time! : self.fade_out_time
    
        label_size[0] = myBoundSize.width
        label_size[1] = 20
        label_point[0] = 0
        label_point[1] = myBoundSize.height - 100
        
        box_size[0] = myBoundSize.width
        box_size[1] = 100
        box_point[0] = 0
        box_point[1] = myBoundSize.height - 100
        
        let frame = CGRect(x: label_point[0]+label_size[0]-30, y: box_size[1]-30, width: 30, height: 30)
//        read_icon = NVActivityIndicatorView(frame: frame, type: .BallBeat,color:UIColor(red: CGFloat(0 / 255.0), green: CGFloat(0 / 255.0), blue: CGFloat(0 / 255.0), alpha: 1),padding: CGFloat(15))
        self.frame = CGRect(x: label_point[0], y: label_point[1], width: label_size[0], height: box_size[1])
        
//        self.addSubview(read_icon)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        subInit()
    }
    
    init(frame: CGRect? = nil,called_id :Int)
    {
        var f = CGRectZero
        if(frame != nil){
            f = frame!
        }
        super.init(frame: f)
        self.called_id = called_id
        subInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func startDisplaying(){
        
        initLabels(self.messages[self.message_count]);
        self.timer_count = 0
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.fade_in_time, target: self, selector: #selector(TypeWriter.readText), userInfo: nil, repeats: true);
        
    }
    
    dynamic func initLabels(message:String){
        self.labels = []
        self.label_text_count = 0
        self.label_count = 0
        let message_ary = message.componentsSeparatedByString("¥n")
        var messages:[String] = []
        
        for ms in message_ary {
            let count = ms.length / row_length
            for x in 0 ... count {
                messages.append( ms[(x*row_length)...((x+1)*row_length-1)] )
            }
        }
        
        for x in 0 ..< messages.count {
            let label:UILabel = UILabel(frame: CGRectMake(0, (CGFloat(x) * label_size[1]), label_size[0], 20))
            label.font = UIFont.MyFont()
            label.layer.masksToBounds = true
            label.textColor = UIColor.blackColor()
            label.text = ""
            labels.append(label)
            self.addSubview(labels[labels.count-1])
            label_message = messages
        }
    }
    
    dynamic func readText(){
        let len = self.labels[self.label_count].text!.characters.count
        if len == self.label_message[self.label_count].characters.count {
            label_text_count = 0
            label_count += 1
        }
        
        if self.labels.count == self.label_count{
            self.timer.invalidate()
            self.readEndIconDisplaying()
            return
        }
    
        let ms = self.labels[self.label_count].text!
        self.labels[self.label_count].text = ms + self.label_message[self.label_count][self.label_text_count...self.label_text_count]
        label_text_count += 1

    }
    
    
    dynamic func readTextAll(){
        self.timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(TypeWriter.readText), userInfo: nil, repeats: true);
    }
    
    dynamic func isActive() -> (Bool){
        if self.timer.valid == true {
            return true
        }else{
            return false
        }
    }
    
    dynamic func dispose(){
        if self.timer.valid == true {
            self.timer.invalidate()
        }
        self.removeFromSuperview()
    }
    
    dynamic func nextMessage(){
        self.message_count += 1
        if(messages.count <= self.message_count){
            self.removeFromSuperview()
            delegate?.delegateTypeWriterEnd(called_id)
        }else{
            for x in 0 ..< self.labels.count {
                self.labels[x].removeFromSuperview()
            }
//            self.read_icon.hidden = true
            self.startDisplaying()
        }
    }
    
    dynamic func readEndIconDisplaying(){
//        self.read_icon.hidden = false
//        self.read_icon.startAnimation()
    }
    
}
