import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyCarousel extends StatelessWidget {
  final List<String> carouselImages = [
    "https://cdn.pixabay.com/photo/2017/05/09/03/46/alberta-2297204_960_720.jpg",
    "https://cdn.pixabay.com/photo/2018/10/05/14/39/sunset-3726030_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/05/09/03/46/alberta-2297204_960_720.jpg",
    "https://cdn.pixabay.com/photo/2018/10/05/14/39/sunset-3726030_960_720.jpg",
  ];

  MyCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
    
      children: [
        Container(
          height: 250,
          width: 370,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Your content inside the fixed container
          child: const Center(
            child: Text(
              "Fixed Container Content",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        Positioned.fill(
          
          child: CarouselSlider.builder(
            itemCount: carouselImages.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final imageUrl = carouselImages[index];
              return buildCarouselImage(imageUrl);
            },
            options: CarouselOptions(
              height: 250.0,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCarouselImage(String imageUrl) => Container(
        height: 250,
        width: 370,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl, 
            fit: BoxFit.cover,
          ),
        ),
      );
}
