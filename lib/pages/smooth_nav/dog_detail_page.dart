import 'package:flutter/material.dart';
import 'package:ui_playground_134/pages/smooth_nav/dog_data.dart';

class DogDetailPage extends StatelessWidget {
  final DogData dogData;
  const DogDetailPage({super.key, required this.dogData});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: w,
                      height: w,
                      child: dogData.image,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 8.0),
                      child: Column(
                        children: [
                          Text(
                            dogData.name,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 24,
                              ),
                              Text(
                                dogData.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(dogData.description,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              )),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 3,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
