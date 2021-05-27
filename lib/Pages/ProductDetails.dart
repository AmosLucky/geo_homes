import 'dart:convert';

import 'package:Geo_home/Pages/HomePage.dart';
import 'package:Geo_home/Pages/ShowFullimage.dart';
import 'package:Geo_home/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetails extends StatefulWidget {
  Map<String, dynamic> productDetails;
  List images;
  ProductDetails(this.productDetails, this.images);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  //Center(child: Text(productDetails['location']),),
   final addCommer = new NumberFormat("#,##0.00", "en_US");
  List imagesList = [];
  var currentIndex = 0;
  var productDetails;

  @override
  void initState() {
    productDetails = widget.productDetails;
    for (var i = 0; i < widget.images.length; i++) {
      imagesList.add(widget.images[i]['src']);
      //print(widget.images[i]['src']);
    }
    //imagesList = widget.images;
    // TODO: implement initState
    super.initState();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> results = [];
    for (int i = 0; i < list.length; i++) {
      results.add(handler(i, list[i]));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(context, 2),
        appBar: AppBar(
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(productDetails['title']),
        ),
        body: SingleChildScrollView(
          child: Container(
            
              child: Column(
                children: [
                  Container(child: theCarousel(context)),
                  Container(
                    width: width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              productDetails['title'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color: mainColor,
                            ),
                            Text(
                              "For " + productDetails['type'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Icon(
                                  Icons.place,
                                  color: mainColor,
                                )),
                            Expanded(
                                child: Container(
                                  
                                    child: Text(
                              productDetails['location'],
                              
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 5, left: 20, right: 20),
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                color: mainColor,
                                alignment: Alignment.center,

                                ///price//PRICE
                                child: Text("₦ " + productDetails['price'],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white))),
                          )
                        ])
                      ],
                    ),
                  ),

                  //////////////////////////////////////////////////////////////////////////////////
                  //////////////////////////////LOAD THE REST FROM SERVER////////////////////////////
                  loadFromServer()
                ],
              ),
            ),
          ),
        );
  }

  ////////////////////////LOADE THE PRODUCT DETAILS FROM SERVER

  Widget loadFromServer() {
    Future fetchProperties() async {
      String url =
          "http://geohomesgroup.com/admin/process/loadform?pageType=properties&mobile=1&user_id=1&id=" +
              productDetails['id'];
      var response = await http.get(url);
      if (response.statusCode == 200) {
       // print(response.body);

        return jsonDecode(response.body);
      }
    }

    // ListView.builder(
    //               itemCount: snapshot.data.length,
    //               itemBuilder: (contex, index) {
    //                 return Container(
    //                   color: Colors.indigo,
    //                     height: 600, width: 300,
    //                      child: Text("dddddddddddddddddddddddddddddddd")
    //                      );
    //               }),

    return FutureBuilder(
        future: fetchProperties(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
          //  print("ffff"+snapshot.data[0]['state']);
            return Container(
                width: MediaQuery.of(context).size.width,
               
                child: Column(
                  children: [
                    descriptions(snapshot.data),
                     fetchRelatedProperties(snapshot.data[0]['state']),
                  ],
                ));
          }
          if (snapshot.hasError) {
            return Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "An Error occored \n Please refresh",
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ));
          }
          if (snapshot.hasData) {
            return Container(
                margin: EdgeInsets.only(top: 50),
                child: Center(
                  child: CircularProgressIndicator(),
                ));
          } else {
            return Container(
                margin: EdgeInsets.only(top: 50),
                child: Center(
                  child: gifLoader(),
                ));
          }
        });
  }

  /////////////////////////////////////////DESCRIPTON CONTAINER///////////////
  ///
  Widget descriptions(var data) {
    ///print(data[0]);
    /////////varies////
    var tags = json.decode(data[0]['tags']);
    var tag = null;
    tags.length > 1 ? tag =  tags["Square Feet"]:tag = "";
    
    //print("==="+tag);
    
    var pcategories = data[0]['pcategories'];
    var categories = data[0]['categories'];
    var alternate_vendor = data[0]['alternate_vendor'];

    ////////////varies/////////////
    var vendor_id  = data[0]['vendor_id'];
    var description = data[0]['sales_desc'];
    var state =  data[0]['state'];
    
    return Container(
      child: Column(
        children: [
          
             Container(
              child: Text(
                "Property Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          
          SizedBox(height: 10),
        tag != ""?  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: mainColor,
              ),
              Text("Area - " + tag)
            ],
          ):Center(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: mainColor,
              ),
              Text("Property Category - " +   pcategories.replaceAll(pcategories[0], pcategories[0].toUpperCase()))
            ],
          ),

          
         categories != null ?  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: mainColor,
              ),
             Text("Property Type - " + categories) 
            ],
          ):Center(),

          ////////////////////////////////////////////////////BORDER CONTAINER CALLING///////////
         alternate_vendor != null? borderContainer(alternate_vendor,Icons.phone,"phone"):Center(),
          vendor_id.length > 2? borderContainer(vendor_id,Icons.email,""):Center(),
           ////////////////
           Container(
             margin:  EdgeInsets.symmetric(horizontal:10),
             padding: EdgeInsets.only(top:10,bottom:10),
             child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
               child: Text(description)),),
             SizedBox(height:10),
             Container(
               margin: EdgeInsets.only(bottom:20),
               child: Text("Related Properties",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
               ),
           


          
        ],
      ),
    );
  }



  ///////////////////////////////////BORDERED CONTAINER//////////
  borderContainer(String text,IconData icon,String type){
    return Row(children: [
          Expanded(
            child: InkWell(
              onTap: (){
                if(type == "phone"){
                  launch("tel://"+text);
                  //print(text);
                }
              },
              child: Container(
                  decoration: BoxDecoration(border: Border.all(color: mainColor)),
                  margin:
                      EdgeInsets.only(top:5, left: 20, right: 20),
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  //color: mainColor,
                  alignment: Alignment.center,

                  ///price//PRICE
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: mainColor),
                      Text(text,
                          style: TextStyle(fontSize: 16, color: mainColor)),
                    ],
                  )),
            ),
          )
        ]);
  }
  //////////////////////////////

  ///////////////////////////////////////////////////////THE COUROSEL///////////////////

  Widget theCarousel(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        CarouselSlider(
          items: imagesList.map((imgUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext) =>
                                    ShowFullImage(imgUrl,widget.images)));
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

                  width: width,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2),
                  //color: Colors.red,
                  ///image
                  //child: Image.network(images[0]['src'],width: width),
                );
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

        Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(imagesList, (i, url) {
              return InkWell(
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  child: Image.network(url, fit: BoxFit.fill),
                  decoration: BoxDecoration(
                    border: currentIndex == i
                        ? Border.all(color: mainColor, width: 3)
                        : null,
                  ),
                ),
                onTap: () {
                  setState(() {
                    currentIndex = i;
                  });
                },
              );
            }))
      ],
    );
  }



  /////////////////////////////////////FETCHING RELATED PROPERTIES///////////////////////
  fetchRelatedProperties(String state){
    Future fetchProperties() async {
    String url =
        "http://geohomesgroup.com/admin/process/list?pageType=m-properties&mobile=1&user_id=1&search=&condition=state,"+state;
    var response = await http.get(url);
    if (response.statusCode == 200) {
    // print(response.body);

      return jsonDecode(response.body);
    }else{
      print("erro");
    }
  }

     return FutureBuilder(
                  future: fetchProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(
                         "Erro fecting json....");
                         return Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100),
                            ),
                            Center(
                              child: Text(
                                "Unknown Server error occcoured",
                                style: TextStyle(fontSize: 20,color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    if (snapshot.data.toString() == "[]") {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100),
                            ),
                            Center(
                              child: Text(
                                "No Data",
                                style: TextStyle(fontSize: 25),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data['total'] == 0) {
                        return  noResultWidget();
                      // return Container(
                      //   height: 300,
                      //   margin: EdgeInsets.only(top: 0,left: 10,right: 10),
                      //   alignment: Alignment.center,
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     child: FittedBox(
                      //       child: Image.asset("assets/images/noresult.gif")),),
                      // );
                    }
                     // print(snapshot.data);
                      return ListOfPropertiesSingle(list: snapshot.data,);
                    } else {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100),
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Text(
                              "Loading Data...",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      );
                    }
                  },
                );
  }
  
  //////////////////////////////////////////////////////
}




////////////////////////////////////LIST OF RELATED PROPERTIES//////////////////
///

class ListOfProperties1 extends StatefulWidget {
  
  Map<String, dynamic> list;
  ListOfProperties1({this.list});
  @override
  _ListOfPropertiesState createState() => _ListOfPropertiesState();
}

class _ListOfPropertiesState extends State<ListOfProperties> {
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
//   final List t = json.decode(response.body);
// final List<PortasAbertas> portasAbertasList =
//      t.map((item) => PortasAbertas.fromJson(item)).toList();
// return portasAbertasList;
  @override
  Widget build(BuildContext context) {
    var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
        width: MediaQuery.of(context).size.width,
       // height: hieght - 150,
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: RefreshIndicator(
          onRefresh: (){

          },
          child: ListView.builder(
                          shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount:
                  widget.list['row'] == null ? 0 : widget.list['row'].length,
              itemBuilder: (context, i) {
                final List images = json.decode(widget.list['row'][i]['c'][6]);
                // print("============"+t[0].toString());
                var row = widget.list['row'];
                var id = widget.list['row'][i]['i'];
                var title = row[i]['c'][0];
                
                var price = row[i]['c'][1];
                var category = row[i]['c'][2];
                var company = row[i]['c'][3];
                var status = row[i]['c'][4];
                var postDate = row[i]['c'][5];
                var type = row[i]['c'][7];
                var location = row[i]['c'][8];
                  var priceWithCommer = numberFormat.format(json.decode(price));

                return InkWell(
                  onTap: (){
                    ///////////////////////////////////DETAILS PAGES////////////
                    
                    var details = {"id":id,"title":title,
                                    "price":priceWithCommer,
                                      "category":category,
                                      "company":company,
                                      "status":status,
                                      "postDate":postDate,
                                      "type":type,
                                      "location":location
                                      };
                                      ////////////////////////
                             Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>
                             ProductDetails(
                               details,
                               images


                             )));  
                             //////////////////////////////////////       

                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    //////////////IMAGE
                                    imageUrl: images[0]['src'],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            SizedBox(
                                              height: 100.0,
                                              width: 100.0,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 1.0,
                                                    value: downloadProgress.progress),
                                              ),
                                            ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),

                                width: width,
                                height: 150,
                                //color: Colors.red,
                                ///image
                                //child: Image.network(images[0]['src'],width: width),
                              ),
                              Container(
                                height: 20,
                                alignment: Alignment.topRight,
                                child: FlatButton(
                                  ///////////////TYPE///////
                                  child: Text(type),
                                  color: Colors.grey,
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                          Container(
                            

                              ///title
                              padding:
                                  EdgeInsets.only(left: 50, right: 10, top: 10),
                                  ////////////TITLE
                              child: Text(title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18))),
                          Container(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              alignment: Alignment.center,
                              /////////location
                              child: Row(
                                children: [
                                  Expanded(
                                    ///////////////LOCATION
                                      child: Text(location,
                                          style: TextStyle(fontSize: 16))),
                                ],
                              )),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 5, left: 10, right: 10),
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    color: mainColor,
                                    alignment: Alignment.center,

                                    ///price//PRICE
                                    child: Text("₦ " + priceWithCommer,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white))),
                              )
                            ],
                          ),

                          //  MaterialButton(
                          //    shape: StadiumBorder(),
                          //    onPressed: (){},
                          //    elevation: 5.0,
                          //    color: Colors.white,

                          //   ///////type
                          //   child: Container(child: Text(row[i]['c'][7]))

                          // ),

                          //  Container(
                          //   child: Text(row[i]['c'][2])

                          // ),
                          //  Container(
                          //   child: Text(row[i]['c'][3])

                          // ),
                          //  Container(
                          //   child: Text(row[i]['c'][4])

                          // ),
                          //  Container(
                          //    ///date
                          //   child: Text(row[i]['c'][5])

                          // ),
                          //  Container(
                          //    ////picture array
                          //   child: Text(row[i]['c'][6][0])

                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}