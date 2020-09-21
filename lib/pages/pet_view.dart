import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/mock_data.dart';
import 'package:flutter_app/pages/pet_card_load.dart';

class PetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         margin: EdgeInsets.only(top: 40),
         child: PetCardLoad(),
      ),
    );
  }
}



