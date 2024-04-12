import 'package:flutter/material.dart';
import 'dart:async';

class AutoInfiniteImageSlider extends StatefulWidget {
  @override
  _AutoInfiniteImageSliderState createState() =>
      _AutoInfiniteImageSliderState();
}

class _AutoInfiniteImageSliderState extends State<AutoInfiniteImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  List<String> _imageUrls = [
    "https://img.freepik.com/free-psd/3d-mega-sale-logo-with-50-percent-discount-offer-3d-rendering-design-template_106176-1530.jpg?size=626&ext=jpg&ga=GA1.1.1700460183.1712016000&semt=ais",
    "https://www.google.com/imgres?imgurl=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fpreviews%2F023%2F213%2F973%2Foriginal%2F50-percent-discount-offer-banner-design-template-vector.jpg&tbnid=ivfmx3iewV7U8M&vet=10CAIQxiAoAGoXChMIoM6Itdy9hQMVAAAAAB0AAAAAEA0..i&imgrefurl=https%3A%2F%2Ftratenor.es%2F%3Fo%3D50-percent-discount-offer-banner-design-template-23213973-vector-xx-dj5VxZhx&docid=w0YePZRmlvLe7M&w=1920&h=1920&itg=1&q=banner%20of%2050%25%20off&client=firefox-b-d&ved=0CAIQxiAoAGoXChMIoM6Itdy9hQMVAAAAAB0AAAAAEA0",
    "https://www.google.com/imgres?imgurl=https%3A%2F%2Fstatic2.bigstockphoto.com%2F2%2F3%2F3%2Flarge2%2F332641807.jpg&tbnid=IJD-98hOdOpjwM&vet=10CBkQxiAoCmoXChMIoM6Itdy9hQMVAAAAAB0AAAAAEA0..i&imgrefurl=https%3A%2F%2Fwww.bigstockphoto.com%2Fimage-332641807%2Fstock-vector-sale-banner-template-design%252C-big-sale-special-up-to-50%2525-off-super-sale%252C-end-of-season-special-offer&docid=DzNMzN00QK7fZM&w=450&h=470&itg=1&q=banner%20of%2050%25%20off&client=firefox-b-d&ved=0CBkQxiAoCmoXChMIoM6Itdy9hQMVAAAAAB0AAAAAEA0",
    // Add more image URLs as needed
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _imageUrls.length * 1000,
    );
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _imageUrls.length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust the height as needed
      child: PageView.builder(
        controller: _pageController,
        itemCount: _imageUrls.length * 10000, // Make it virtually infinite
        onPageChanged: (index) {
          setState(() {
            _currentPage = index % _imageUrls.length;
          });
        },
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(
                  _imageUrls[index % _imageUrls.length],
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
