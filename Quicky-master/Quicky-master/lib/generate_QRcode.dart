import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratorQR extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'générer le QRcode',
      home: InitQR(),
    );
  }
}

class InitQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QrImage(
          data: "cJraGzuF74OHyrTfykeg", // message source du QRcode
          size: 200.0,
          errorStateBuilder: (cxt, err) {
            return Container(
              child: Center(
                child: Text(
                  "Error lors de la génération du QRcode"
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}