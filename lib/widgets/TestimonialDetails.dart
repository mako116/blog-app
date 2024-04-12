import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TestimonialDetails extends StatefulWidget {
  @override
  _TestimonialSliderState createState() => _TestimonialSliderState();
}

class _TestimonialSliderState extends State<TestimonialDetails> {
  final List<Map<String, dynamic>> testimonials = [
    {
      'name': 'emmanuel',
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'icon': Icons.person,
      'bookmarked': false, // Add bookmarked field
      'rating': 4, // Add rating field
    },
    {
      'name': 'Jane oluchi',
      'text':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'icon': Icons.person,
      'bookmarked': true,
      'rating': 5,
    },
    {
      'name': ' oluchi',
      'text':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'icon': Icons.person,
      'bookmarked': false,
      'rating': 3,
    },
    {
      'name': 'Janey simly',
      'text':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'icon': Icons.person,
      'bookmarked': true,
      'rating': 4,
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
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        testimonials[index]['icon'],
                        size: 40,
                      ),
                      IconButton(
                        icon: Icon(
                          testimonials[index]['bookmarked']
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            testimonials[index]['bookmarked'] =
                                !testimonials[index]['bookmarked'];
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    testimonials[index]['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    testimonials[index]['text'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      testimonials[index]['rating'],
                      (index) => Icon(Icons.star, color: Colors.yellow),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: testimonials.map((testimonial) {
            int index = testimonials.indexOf(testimonial);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
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

// Use this TestimonialSlider widget in your main screen or any other screen
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Testimonial Slider'),
        ),
        body: Center(
          child: TestimonialDetails(),
        ),
      ),
    );
  }
}
