import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String text;
  const SecondPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade300,
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
            const SizedBox(height: 100),
            Text(text,
                style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 50,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
