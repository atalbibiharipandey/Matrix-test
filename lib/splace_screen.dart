import 'package:flutter/material.dart';
import 'package:matrix/test.dart';

class SplaceSreenPage extends StatefulWidget {
  const SplaceSreenPage({super.key});
  static const id = "SplaceScreenPage";

  @override
  State<SplaceSreenPage> createState() => _SplaceSreenPageState();
}

class _SplaceSreenPageState extends State<SplaceSreenPage> {
  goToNextScreen() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TestScreenPage()));
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () => goToNextScreen());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: const Center(
            child: Icon(
          Icons.flutter_dash,
          color: Colors.blue,
          size: 100,
        )),
      ),
    );
  }
}
