# Typewriter
message window like typewriter
#Demo
![Typwwiter](https://github.com/abotkugyu/Typewriter/blob/master/Typewriter.gif)
#Usage
###Need inheritance
    TypeWriterDelegate　
###Start
#####create
    var ms = "Hello World"
    var tw = TypeWriter(called_id:1)
    self.view.addSubview(tw)
    tw.delegate = self
    tw.messages = [ms]
    tw.startDisplaying()
####display touch for next message    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _: AnyObject in touches {
            if tw.isActive() == true {
                tw.readTextAll()
            }else{
                tw.nextMessage()
            }
        }
    }
###Callback
    //delegate
    func delegateTypeWriterEnd(called_id:Int) {
      //case called_id
      if called_id == 1 {
      
      }else if called_id == 2 {
      
      }
    }
