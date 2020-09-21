import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:date_format/date_format.dart' as dateFormat;

class DatePickerPage extends StatefulWidget {
  DatePickerPage({Key key}) : super(key: key);

  @override
  _DatePickerPageState createState() {
    return _DatePickerPageState();
  }
}

class _DatePickerPageState extends State<DatePickerPage> {
  var _nowDate = DateTime.now();

  _timePickerWidget() {
    DatePicker.showDatePicker(context,
        //配置语言
        locale: DateTimePickerLocale.zh_cn,
        //日期样式
        pickerTheme: DateTimePickerTheme(
          confirm: Text("确定",style: TextStyle(fontSize: 20),),
          cancel: Text("取消",style: TextStyle(fontSize: 20),),
        ),
        //最小日期限制
        minDateTime: DateTime.parse("1965-01-01"),
        //最大日期限制
        maxDateTime: DateTime.parse("2100-01-01"),
        //初试日期
        initialDateTime: DateTime.now(),
        dateFormat: "yyyy-MM-dd EEE,H时:m分",
        pickerMode: DateTimePickerMode.datetime,//show datetime 配置为datetime格式的时候 dateFormat必须要加上时分的格式
        //在日期发生改变的时候实时更改日期
        onChange: (date, List<int> index) {
          setState(() {
            _nowDate = date;
          });
        }, //点击确认后才更改日期
        onConfirm: (date, List<int> index) {
          setState(() {
            _nowDate = date;
          });
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CupertinoDatePickerPage"),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: _timePickerWidget,
            child: Row(
              children: <Widget>[
                Text(dateFormat.formatDate(_nowDate, [dateFormat.yyyy, '年', dateFormat.mm, '月', dateFormat.dd, '日',dateFormat.HH,'时',dateFormat.n,'分'])),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
          )
        ],
      ),
    );
  }
}