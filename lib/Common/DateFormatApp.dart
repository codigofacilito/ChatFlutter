import 'package:intl/intl.dart';

class DateFormatApp{

  static getDateFormat(time){
    return DateFormat('kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(time)));
  }
}