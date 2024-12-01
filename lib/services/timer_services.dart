import 'dart:async';

class TimerServices{

  Timer? _timer;
  int _seconds = 0;
  close(){
    if(_timer !=null){
      _timer!.cancel();
    }
  }

  startTimer(){
    const oneSec = const Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer) {
      if(_seconds<0){
        _timer!.cancel();
      }else{
        _seconds+=1;
      }

    });

  }
  getCurrentTime(){
    return _seconds;
  }
}