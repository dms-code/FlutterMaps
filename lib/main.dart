import 'package:flutter/material.dart';
import 'package:flutter_maps/src/maps/map_controller.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';

void main() async {
  
  runApp(ChangeNotifierProvider(
    create: (context) => MapController(),
    child: const MyApp()

  ));
}
