import 'dart:convert';

import 'package:Geo_home/Pages/MainPage.dart';
import 'package:Geo_home/Pages/SearchPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'Pages/HomePage.dart';
import 'Pages/ProductDetails.dart';
import 'Pages/UserProperties.dart';

//const  mainColor = Color(0xFF43A047);
const mainColor = Color(0xFF388E3C);
const whiteColor = Colors.white;
var appLogo = "assets/images/geohomes-logo2.png";

bottomNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    onTap: (newIndex) {
      switch (newIndex) {
        case 0:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => MainPage(
                    currentIndex: 0,
                  )));
          break;
        case 1:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => MainPage(
                    currentIndex: 1,
                  )));
          print("Real Estate");
          break;
        case 2:
          print("add");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => MainPage(
                    currentIndex: 2,
                  )));
          break;
        case 3:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => MainPage(
                    currentIndex: 3,
                  )));
          print("person");
          break;
        case 4:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => MainPage(
                    currentIndex: 4,
                  )));
          print("menu");
          break;
      }
    },
    elevation: 0.0,
    selectedItemColor: mainColor,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.shifting,
    currentIndex: currentIndex,
    items: [
      new BottomNavigationBarItem(
        icon: InkWell(
          child: new Icon(Icons.home),
        ),
        title: new Text("Real Estate"),
      ),
      new BottomNavigationBarItem(
        icon: InkWell(
          child: new Icon(Icons.fact_check),
        ),
        title: new Text("Services"),
      ),
      // new BottomNavigationBarItem(
      //   icon: InkWell(
      //     child: Card(
      //         shape: StadiumBorder(),
      //         color: mainColor,
      //         child: new Icon(
      //           Icons.add,
      //           size: 40,
      //           color: Colors.white,
      //         )),
      //   ),
      //   title: new Text("Add"),
      // ),
      new BottomNavigationBarItem(
        icon: new InkWell(
          child: new Icon(Icons.table_chart),
        ),
        title: new Text("Products"),
      ),
      new BottomNavigationBarItem(
        icon: new InkWell(
          child: new Icon(Icons.person),
          onTap: () {
            print("add");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext) => MainPage(
                      currentIndex: 2,
                    )));
          },
        ),
        title: new Text("profile"),
      ),
    ],
  );
}

noResultWidget() {
  return Container(
    height: 300,
    margin: EdgeInsets.only(top: 0, left: 10, right: 10),
    alignment: Alignment.center,
    child: Container(
      alignment: Alignment.center,
      child: FittedBox(child: Image.asset("assets/images/noresult.gif")),
    ),
  );
}

class ListOfPropertiesSingle extends StatefulWidget {
  Map<String, dynamic> list;
  ListOfPropertiesSingle({this.list});
  @override
  _ListOfPropertiesSingleState createState() => _ListOfPropertiesSingleState();
}

class _ListOfPropertiesSingleState extends State<ListOfPropertiesSingle> {
//   final List t = json.decode(response.body);
// final List<PortasAbertas> portasAbertasList =
//      t.map((item) => PortasAbertas.fromJson(item)).toList();
// return portasAbertasList;
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
  List selectedItemsIds = [];

  @override
  Widget build(BuildContext context) {
    var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
        width: MediaQuery.of(context).size.width,
        // height: hieght * 1.3,

        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: RefreshIndicator(
          onRefresh: () {},
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  widget.list['row'] == null ? 0 : widget.list['row'].length,
              itemBuilder: (context, i) {
                final List images = json.decode(widget.list['row'][i]['c'][6]);
                var id;
                var row = widget.list['row'];
                var title;
                var price;
                var category;
                var company;
                var status;
                var postDate;
                var type;
                var location;
                var companyName;
                var phoneNumber;
                var priceWithCommer;
                var type2;
                // print("============"+t[0].toString());
                title = checkForNull(row[i]['c'][0]);
                price = checkForNull(row[i]['c'][1]);
                category = checkForNull(row[i]['c'][2]);
                company = checkForNull(row[i]['c'][3]);
                status = checkForNull(row[i]['c'][4]);
                postDate = checkForNull(row[i]['c'][5]);
                type = checkForNull(row[i]['c'][7]);
                location = checkForNull(row[i]['c'][8]);
                companyName = checkForNull(row[i]['c'][9]);
                phoneNumber = checkForNull(row[i]['c'][10]);
                if (price.length > 2) {
                  priceWithCommer = numberFormat.format(json.decode(price));
                } else {
                  priceWithCommer = price;
                }

                if (type.length > 2) {
                  type2 = type.replaceAll(type[0], type[0].toUpperCase());
                } else {
                  type2 = type;
                }
                // print( "${numberFormat.format(price)}");

                return InkWell(
                  onTap: () {
                    var details = {
                      "id": id,
                      "title": title,
                      "price": priceWithCommer,
                      "category": category,
                      "company": company,
                      "status": status,
                      "postDate": postDate,
                      "type": type,
                      "location": location
                    };
                    ////////////////////////
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext) =>
                                ProductDetails(details, images)));
                    //////////////////////////////////////
                    if (selectedItemsIds.length > 0) {
                      if (selectedItemsIds.contains(i)) {
                        // selectedItemsIds.remove(i);

                      } else {
                        // selectedItemsIds.add(i);
                      }
                    } else {
                      print("edit");
                    }
                    setState(() {});
                  },
                  onLongPress: () {
                    if (selectedItemsIds.contains(i)) {
                      //  selectedItemsIds.remove(i);

                    } else {
                      // selectedItemsIds.add(i);
                    }
                    setState(() {});
                    print("long press");
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Column(
                        children: [
                          selectedItemsIds.length > 0 && i == 0
                              ? Container(
                                  child: Text(""),
                                )
                              : Container(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width / 3,
                                height: 120,
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
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        ///margin: EdgeInsets.only(top:15),

                                        child: Row(
                                          children: [
                                            Expanded(child: Text(title)),
                                            // Icon(Icons.check_circle_outlined,color: mainColor,),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              color: mainColor,
                                            ),
                                            Expanded(child: Text(location)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              "₦ " + priceWithCommer,
                                              style:
                                                  TextStyle(color: mainColor),
                                            )),
                                            //                     InkWell
                                            //                     (
                                            //                       onTap: (){

                                            //                          ///////////////////////////////////DETAILS PAGES////////////

                                            // var details = {
                                            //   "id": id,
                                            //   "title": title,
                                            //   "price": priceWithCommer,
                                            //   "category": category,
                                            //   "company": company,
                                            //   "status": status,
                                            //   "postDate": postDate,
                                            //   "type": type,
                                            //   "location": location
                                            // };
                                            // ////////////////////////
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (BuildContext) =>
                                            //             ProductDetails(details, images)));
                                            // //////////////////////////////////////
                                            //                         print("EYE CLICK");
                                            //                       },

                                            //                       child: Card(
                                            //                       shape: StadiumBorder(),

                                            //                       color: Colors.greenAccent[50],
                                            //                       child: Container(
                                            //                         padding: EdgeInsets.all(3),
                                            //                         child: Icon(Icons.remove_red_eye,color: mainColor,)))
                                            //                     ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}

checkForNull(var data) {
  if (data == null) {
    return "";
  }
  return data;
}

gifLoader() {
  return Image.asset("assets/images/loader.gif");
}

Future fetchProperties(String url) async {
  String url =
      "https://geohomesgroup.com/admin/process/list?pageType=m-properties&mobile=1&user_id=1&condition=status,1|master_stock_id,1";
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  }
}

////////////////CUVE 1///////////////////
//  Stack(
//                             children: [
//                               Container(

//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: new CachedNetworkImageProvider(

//                                           //////////////IMAGE
//                                           images[0]['src'],
//                                           // errorListener:
//                                           //     (context, url, downloadProgress) =>
//                                           //         SizedBox(
//                                           //   height: 100.0,
//                                           //   width: 100.0,
//                                           //   child: Center(
//                                           //     child:gifLoader(),
//                                           //     // child: CircularProgressIndicator(
//                                           //     //     strokeWidth: 1.0,
//                                           //     //     value: downloadProgress.progress),
//                                           //   ),
//                                           // ),
//                                           // errorWidget: (context, url, error) =>
//                                           //     Icon(Icons.error),
//                                         ),
//                                       ),
//                                     ),
//                                 //  ),
//                               //  ),

//                                 width: width,
//                                 height: 340,
//                                 //color: Colors.red,
//                                 ///image
//                                 //child: Image.network(images[0]['src'],width: width),
//                               ),
//                               Container(
//                                // decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight:Radius.circular(1000.0))),
//                                 padding: EdgeInsets.only(right:10),
//                                 height: 20,
//                                 alignment: Alignment.topRight,
//                                 child: FlatButton(
//                                   ///////////////TYPE///////
//                                   child: Text(type2),
//                                   color: Colors.grey,
//                                   textColor: Colors.white,
//                                   onPressed: () {},
//                                 ),
//                               )
//                             ],
//                           ),
///
////////////////
///CURV 2
// Stack(
//                           children: [
//                             Container(

//                               child: FittedBox(
//                                 fit: BoxFit.fill,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(41.0),topRight:  Radius.circular(41.0)),
//                                   child: CachedNetworkImage(

//                                     //////////////IMAGE
//                                     imageUrl: images[0]['src'],
//                                     progressIndicatorBuilder:
//                                         (context, url, downloadProgress) =>
//                                             SizedBox(
//                                       height: 100.0,
//                                       width: 100.0,
//                                       child: Center(
//                                         child:gifLoader(),
//                                         // child: CircularProgressIndicator(
//                                         //     strokeWidth: 1.0,
//                                         //     value: downloadProgress.progress),
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) =>
//                                         Icon(Icons.error),
//                                   ),
//                                 ),
//                               ),

//                               width: width,
//                               height: 340,
//                               //color: Colors.red,
//                               ///image
//                               //child: Image.network(images[0]['src'],width: width),
//                             ),
//                             Container(
//                              // decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight:Radius.circular(1000.0))),
//                               padding: EdgeInsets.only(right:20),
//                               height: 20,
//                               alignment: Alignment.topRight,
//                               child: FlatButton(
//                                 ///////////////TYPE///////
//                                 child: Text(type2),
//                                 color: Colors.grey,
//                                 textColor: Colors.white,
//                                 onPressed: () {},
//                               ),
//                             )
//                           ],
//                         ),
