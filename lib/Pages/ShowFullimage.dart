import 'dart:math';

import 'package:Geo_home/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
//import 'package:zoomable_image/zoomable_image.dart';

class ShowFullImage extends StatefulWidget {
  String imageUrl;
  List images;

  ShowFullImage(this.imageUrl,this.images);
  

  @override
  _ShowFullImageState createState() => _ShowFullImageState();
}

class _ShowFullImageState extends State<ShowFullImage> {
  var currentIndex = 1;
  List imagesList = [];

  
   List<T> map<T>(List list, Function handler) {
    List<T> results = [];
    for (int i = 0; i < list.length; i++) {
      results.add(handler(i, list[i]));
    }
    return results;
  }
  @override
  void initState() {
      for (var i = 0; i < widget.images.length; i++) {
        if(i == 0){
          imagesList.add(widget.imageUrl);

        }else if(widget.images[i]['src'] == widget.imageUrl){

        }
        else{
           imagesList.add(widget.images[i]['src']);
        }
     
      //print(widget.images[i]['src']);
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              
           
                
               CarouselSlider(
                 height: height/1.8,
                 
          items: imagesList.map((imgUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  
                     width: width,
                 // height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0),
                   
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext) =>
                        //             ShowFullImage(imgUrl)));
                      },
                      child: CachedNetworkImage(
                        //////////////IMAGE///////////////////
                        imageUrl: imgUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                value: downloadProgress.progress),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),

                
                  //color: Colors.red,
                  ///image
                  //child: Image.network(images[0]['src'],width: width),
                );
              },
            );
          }).toList(),
          aspectRatio: 16 / 9,
         // pauseAutoPlayOnTouch: Duration(microseconds: 2000),
          viewportFraction: 0.90,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          
          
          autoPlayInterval: Duration(seconds: 100),
          autoPlayAnimationDuration: Duration(milliseconds: 8000),
          //autoPlayCurve: Curves.fastOutSlowIn,
          
          enlargeCenterPage: true,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          scrollDirection: Axis.horizontal,
        ),
                      
                    

                     Container(
                       child: IconButton(
                  icon:  Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: width / 7,
                  ),
                  onPressed: (){
                  //  print("nnnfvfv");
                    Navigator.of(context).pop();
                  },
                  
              ),
                     ),
            
           
              
          ],
        ),
     // ),
    );
  }

  
  ///////////////////////////////////////////////////////THE COUROSEL///////////////////

  Widget theCarousel(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        CarouselSlider(
          items: imagesList.map((imgUrl) {
            return Builder(
              builder: (BuildContext context) {
                  
                return Container(
                   height: height / 1,
                     width: width,
                 // height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2),
                   
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext) =>
                        //             ShowFullImage(imgUrl)));
                      },
                      
                     
                      ),
                    ),
                  );

                
                  //color: Colors.red,
                  ///image
                  //child: Image.network(images[0]['src'],width: width),
               
              },
            );
          }).toList(),
          aspectRatio: 16 / 9,
          pauseAutoPlayOnTouch: Duration(microseconds: 2000),
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          scrollDirection: Axis.horizontal,
        ),

        /// SizedBox(height: 3,),

      ],
    );
  }
}
// PhotoViewGallery.builder(
//       scrollPhysics: const BouncingScrollPhysics(),
//       builder: (BuildContext context, int index) {
//         return PhotoViewGalleryPageOptions(
//           imageProvider: AssetImage(imagesList[index].image),
//           initialScale: PhotoViewComputedScale.contained * 0.8,
//           heroAttributes: PhotoViewHeroAttributes(tag: imagesList[index].id),
//         );
//       },
//       itemCount: imagesList.length,
//       loadingBuilder: (context, event) => Center(
//         child: Container(
//           width: 20.0,
//           height: 20.0,
//           child: CircularProgressIndicator(
//             value: event == null
//                 ? 0
//                 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
//           ),
//         ),
//       ),
//       //backgroundDecoration: widget.backgroundDecoration,
//       //pageController: widget.pageController,
//       //onPageChanged: onPageChanged,
//     );