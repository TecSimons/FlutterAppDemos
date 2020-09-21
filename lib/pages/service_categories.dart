import 'package:flutter/material.dart';
import 'package:flutter_app/Item/service_item.dart';
import 'package:flutter_app/data/mock_data.dart';



class ServiceCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      physics: new NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 0),
      children: serviceList.map((item) => ServiceItem(data: item)).toList(),
    );
  }
}
