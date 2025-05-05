import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:getitease/HomeScreen/home_screen.dart';

class ImageSliderScreen extends StatefulWidget {
  late final String urlImage1, urlImage2, urlImage3;
  late final String itemName, userNumber, userName, itemCon, imgPro,description;

  ImageSliderScreen({
    required this.urlImage1,
    required this.urlImage2,
    required this.urlImage3,
    required this.itemName,
    required this.userNumber,
    required this.userName,
    required this.itemCon,
    required this.description,
    required this.imgPro,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  List<Widget> _buildCarouselItems() {
    List<Widget> items = [];
    if (widget.urlImage1.isNotEmpty &&
        (widget.urlImage1.startsWith('http') ||
            widget.urlImage1.startsWith('https'))) {
      items.add(Image.network(
        widget.urlImage1,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error_outline, color: Colors.red));
        },
      ));
    } else {
      items.add(const Center(child: Text('Image 1 not available'))); // Placeholder
    }

    if (widget.urlImage2.isNotEmpty &&
        (widget.urlImage2.startsWith('http') ||
            widget.urlImage2.startsWith('https'))) {
      items.add(Image.network(
        widget.urlImage2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error_outline, color: Colors.red));
        },
      ));
    } else {
      items.add(const Center(child: Text('Image 2 not available'))); // Placeholder
    }

    if (widget.urlImage3.isNotEmpty &&
        (widget.urlImage3.startsWith('http') ||
            widget.urlImage3.startsWith('https'))) {
      items.add(Image.network(
        widget.urlImage3,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error_outline, color: Colors.red));
        },
      ));
    } else {
      items.add(const Center(child: Text('Image 3 not available'))); // Placeholder
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [1.0, 0.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [1.0, 0.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            widget.itemName,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontFamily: 'Quicksand',
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.blueAccent,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 20.0, left: 6.0, right: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontFamily: 'Quicksand',
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.black38,
                    autoScrollDuration: const Duration(seconds: 2),
                    animationPageDuration: const Duration(microseconds: 500),
                    activateIndicatorColor: Colors.black,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.blueGrey,
                    stopAtEnd: false,
                    autoScroll: true,
                    items: _buildCarouselItems(), // Use the function to build items
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Center(
                  child: Text(
                    'Name - ${widget.userName} ',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Center(
                  child: Text(
                    'Contact Details - ${widget.userNumber} : ${widget.itemCon}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}