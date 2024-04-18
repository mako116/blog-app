import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TestimonialSlider extends StatefulWidget {
  const TestimonialSlider({super.key});

  @override
  _TestimonialSliderState createState() => _TestimonialSliderState();
}

class _TestimonialSliderState extends State<TestimonialSlider> {
  final List<Map<String, dynamic>> testimonials = [
    {
      'name': 'emmanuel',
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'icon': Icons.person,
    },
    {
      'name': 'Jane oluchi',
      'text':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'icon': Icons.person,
    },
    {
      'name': ' oluchi',
      'text':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'icon': Icons.person,
    },
    {
      'name': 'Janey simly',
      'text':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'icon': Icons.person,
    },
    // Add more testimonials as needed
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: testimonials.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(testimonials[index]['icon'], size: 40),
                  const SizedBox(height: 20),
                  Text(
                    testimonials[index]['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    testimonials[index]['text'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: testimonials.map((testimonial) {
            int index = testimonials.indexOf(testimonial);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
