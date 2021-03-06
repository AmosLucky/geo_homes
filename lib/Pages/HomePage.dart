import 'dart:convert';

import 'package:Geo_home/Pages/MainPage.dart';
import 'package:Geo_home/Pages/ProductDetails.dart';
import 'package:Geo_home/Pages/SearchFilter.dart';
import 'package:Geo_home/Pages/SearchPage.dart';
import 'package:Geo_home/Pages/UserProperties.dart';
import 'package:Geo_home/constants.dart';
import 'package:Geo_home/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

import 'Profile.dart';
import 'SubmitProperty.dart';
// 08162165085
//   246246
//   37469671
//   Odo Ejike Odo

class HomePage extends StatefulWidget {
  String url;
  String jsonKey;
  HomePage({this.url, this.jsonKey});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  bool isSearch = false;
  var selectedButtomNavIndex = 0;
  final numberFormat = new NumberFormat("#,##0.00", "en_US");

  Future fetchProperties() async {
    //String url =;
    var response = await http.get(widget.url);
    if (response.statusCode == 200) {
      response.body;

      setState(() {});
      // return jsonDecode(response.body);
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(widget.jsonKey, response.body);
    }
  }

  Future fetchPropertiesLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return jsonDecode(sharedPreferences.getString(widget.jsonKey));
  }

  Future refresh() async {
    var route = MaterialPageRoute(
        builder: (BuildContext) => MainPage(
              currentIndex: 0,
            ));
    Navigator.of(context).push(route);
  }

  @override
  void initState() {
    fetchProperties();
    // TODO: implement initState
    super.initState();
  }

  SharedPreferences _sharePreference;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // return WillPopScope(
    //   onWillPop: () {
    //     print("back pressed");
    //     _scaffoldKey.currentState.showSnackBar(SnackBar(
    //       content: Row(
    //         children: <Widget>[
    //           Expanded(
    //             child: Text(
    //               "Do you want to Close this App",
    //               style: TextStyle(),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //           RaisedButton(
    //             color: mainColor,
    //             textColor: Colors.white,
    //             child: Text("Close App"),
    //             onPressed: () {
    //               SystemNavigator.pop();
    //             },
    //           )
    //         ],
    //       ),
    //       backgroundColor: Colors.blueGrey,
    //     ));
    //   },
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Container(
          // margin: EdgeInsets.only(top:10),
          child: Image.asset("assets/images/geohomes-logo.png"),
          width: width - 150,
        ),
        // Container(
        //         height: 40,
        //         width: 250,
        //         child: Row(
        //           children: [
        //             Expanded(
        //               child: TextFormField(
        //                   onEditingComplete: () {
        //                     setState(() {
        //                       isSearch = false;
        //                     });
        //                   },
        //                   onFieldSubmitted: (val) {
        //                     setState(() {
        //                       isSearch = false;
        //                     });
        //                   },
        //                   decoration: InputDecoration(
        //                       border: OutlineInputBorder(
        //                           borderRadius: BorderRadius.circular(12)),
        //                       labelText: "Search",
        //                       labelStyle: TextStyle(color: mainColor),
        //                       filled: true,
        //                       fillColor: Colors.white)),
        //             )
        //           ],
        //         ),
        //       ),
        // : Text("Geo Homes"),
        centerTitle: true,
        // actions: <Widget>[
        //   Container(
        //     padding: EdgeInsets.only(right: 20),
        //     child: InkWell(
        //       onTap: () {
        //         setState(() {
        //           isSearch = true;
        //         });
        //       },
        //       child: Icon(Icons.search),
        //     ),
        //   )
        // ],
      ),
      //bottomNavigationBar: bottomAppBarTheme(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Container(
          width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: height / 5,
                    width: width,
                    decoration: BoxDecoration(color: mainColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "What Are you looking for?",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(children: [
                            Expanded(
                              child: MaterialButton(
                                height: width / 8,
                                color: Colors.white,
                                onPressed: () async {
                                  _sharePreference =
                                      await SharedPreferences.getInstance();
                                  _sharePreference.setString(
                                      "searchType", "properties");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext) => SearchPage(
                                            type: "properties",
                                          )));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.search,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Type your search here",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )),
                                    Container(
                                      child: InkWell(
                                        child: Icon(
                                          Icons.tune,
                                          size: 30,
                                          color: mainColor,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext) =>
                                                      SearchFilter()));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                          // child: TextFormField(
                          //   // obscureText: isHidden? true : false,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(12)),
                          //     labelText: "Type your search result here",
                          //     labelStyle: TextStyle(color: Colors.white)
                          //   ),
                          //   onSaved: (value) {
                          //     // _password = value;
                          //   },
                          //   validator: (value) {
                          //     if (value.isEmpty) {
                          //       return "Password is empty";
                          //     }
                          //   },
                          // ),
                        ),
                      ],
                    )),
                FutureBuilder(
                  future: fetchPropertiesLocal(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      Text(
                          "Error fecting json...." + snapshot.error.toString());
                      print(
                          "Error fecting json...." + snapshot.error.toString());
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
                        return noResultWidget();
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
                      return ListOfProperties(list: snapshot.data);
                    } else {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Stack(
                                children: [
                                  //  Center(
                                  //    child: CircularProgressIndicator(
                                  //      backgroundColor: Colors.greenAccent,
                                  //     strokeWidth: 1.0,
                                  //     value: downloadProgress.progress),
                                  //  ),
                                  Container(
                                    margin: EdgeInsets.all(12.0),
                                    width: 400,
                                    height: 400,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          topLeft: Radius.circular(15.0)),
                                    ),
                                    child: Center(
                                      child: gifLoader(),
                                      //     child: Image.asset(
                                      //   "assets/images/geo.png",
                                      //   width: 70,
                                      // )
                                    ),
                                  ),
                                  // Image.asset(
                                  //   "assets/images/geo.png",
                                  //   width: 70,
                                  // )

                                  //  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 100),
                            // ),
                            // gifLoader(),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 10),
                            // ),
                            // Text(
                            //   "Loading Data...",
                            //   style: TextStyle(color: Colors.black),
                            // )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bottomAppBarTheme() {
    return BottomNavigationBar(
      elevation: 0.0,
      selectedItemColor: mainColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedButtomNavIndex,
      items: [
        new BottomNavigationBarItem(
          icon: InkWell(
            child: new Icon(Icons.home),
            onTap: () {
              print("Home");
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext) => HomePage()));
              setState(() {
                selectedButtomNavIndex = 0;
              });
            },
          ),
          title: new Text("Home"),
        ),
        new BottomNavigationBarItem(
          icon: InkWell(
            child: new Icon(Icons.pie_chart_outline_sharp),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext) => UserProperties()));
              print("Properies");
              setState(() {
                selectedButtomNavIndex = 1;
              });
            },
          ),
          title: new Text("Properies"),
        ),
        new BottomNavigationBarItem(
          icon: InkWell(
            child: Card(
                shape: StadiumBorder(),
                color: mainColor,
                child: new Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                )),
            onTap: () {
              print("add");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext) => SubmitProperty()));
              setState(() {
                selectedButtomNavIndex = 2;
              });
            },
          ),
          title: new Text("Add"),
        ),
        new BottomNavigationBarItem(
          icon: new InkWell(
            child: new Icon(Icons.person),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext) => Profile()));
              print("person");
              setState(() {
                selectedButtomNavIndex = 3;
              });
            },
          ),
          title: new Text("profile"),
        ),
        new BottomNavigationBarItem(
          icon: new InkWell(
            child: new Icon(Icons.menu),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext) => MainPage()));
              print("menu");
              setState(() {
                selectedButtomNavIndex = 4;
              });
            },
          ),
          title: new Text("Menu"),
        )
      ],
    );
  }
}

class ListOfProperties extends StatefulWidget {
  Map<String, dynamic> list;
  ListOfProperties({this.list});
  @override
  _ListOfPropertiesState createState() => _ListOfPropertiesState();
}

class _ListOfPropertiesState extends State<ListOfProperties> {
//   final List t = json.decode(response.body);
// final List<PortasAbertas> portasAbertasList =
//      t.map((item) => PortasAbertas.fromJson(item)).toList();
// return portasAbertasList;
  final numberFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width,
      // height: hieght * 1.3,

      padding: EdgeInsets.only(left: 5, right: 5, top: 5),

      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.list['row'] == null ? 0 : widget.list['row'].length,
          itemBuilder: (context, i) {
            final List images = json.decode(widget.list['row'][i]['c'][6]);
            // print("============"+t[0].toString());
            var row = widget.list['row'];
            var id;
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

            row = widget.list['row'];
            id = widget.list['row'][i]['i'];
            // if(id == "162"){
            //     title = row[i]['c'][0];
            //   price = row[i]['c'][1];
            //   category = row[i]['c'][2];
            //   company = row[i]['c'][3];
            //   status = row[i]['c'][4];
            //   postDate = row[i]['c'][5];
            //   type = "";
            //   location = "";
            //   companyName = "";
            //   phoneNumber = "";
            //   priceWithCommer ="";
            //    type2 = "";
            //
            // }else{}
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
            // var name = "amos";
            // print(name.replaceAll(name[0], name[0].toUpperCase()));

            return InkWell(
              onTap: () {
                ///////////////////////////////////DETAILS PAGES////////////

                var details = {
                  "id": id,
                  "title": title,
                  "price": priceWithCommer,
                  "category": category,
                  "company": company,
                  "status": status,
                  "postDate": postDate,
                  "type": type2,
                  "location": location
                };
                ////////////////////////
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) =>
                            ProductDetails(details, images)));
                //////////////////////////////////////
              },
              child: Card(
                //color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 480,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: width,
                            height: hieght / 1.9,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.only(
                            //       topRight: Radius.circular(15.0),
                            //       topLeft: Radius.circular(15.0)),
                            // image: DecorationImage(
                            //   fit: BoxFit.cover,
                            // image: new CachedNetworkImageProvider(
                            //   //////////////IMAGE
                            //   images[0]['src'],

                            // ),
                            //),
                            //  ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              //////////////IMAGE///////////////////
                              imageUrl: images[0]['src'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                height: 100.0,
                                width: 100.0,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      //  Center(
                                      //    child: CircularProgressIndicator(
                                      //      backgroundColor: Colors.greenAccent,
                                      //     strokeWidth: 1.0,
                                      //     value: downloadProgress.progress),
                                      //  ),
                                      Container(
                                        width: 400,
                                        height: 600,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[350],
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15.0),
                                              topLeft: Radius.circular(15.0)),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              strokeWidth: 1.0,
                                              value: downloadProgress.progress),
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/geo.png",
                                        width: 70,
                                      )

                                      //  ),
                                    ],
                                  ),
                                ),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                      decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    topLeft: Radius.circular(15.0)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageProvider,
                                ),
                              )),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),

                          Container(
                            //decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10))),
                            // padding: EdgeInsets.only(right: 10),
                            height: 20,
                            alignment: Alignment.topRight,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(15)),
                              ),
                              ///////////////TYPE///////
                              child: Text(type2),
                              color: mainColor,
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                          //  Container(
                          //    margin: EdgeInsets.only(top:20),

                          // ///title
                          // padding:
                          //     EdgeInsets.only(left: 10, right: 10, top: 10),
                          // ////////////TITLE
                          // child: Text(title,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18))),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,

                                ///title
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, top: 10),
                                ////////////TITLE
                                child: Text(title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))),
                            Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                alignment: Alignment.center,
                                /////////location
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      size: 20,
                                      color: mainColor,
                                    ),
                                    Expanded(
                                        ///////////////LOCATION
                                        child: Text(location,
                                            style: TextStyle(fontSize: 14))),
                                  ],
                                )),
                            ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            left: 0, right: 10, top: 0),
                                        alignment: Alignment.center,
                                        /////////location
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.group,
                                              color: mainColor,
                                            ),
                                            Expanded(

                                                ///////////////LOCATION
                                                child: Text(" " + companyName,
                                                    style: TextStyle(
                                                        fontSize: 16))),
                                          ],
                                        )),
                                  ),
                                  ///////////////
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        // margin: EdgeInsets.only(
                                        //     top: 10,
                                        //     bottom: 5,
                                        //     left: 2.5,
                                        //     right: 10),
                                        // padding: EdgeInsets.only(top: 5, bottom: 5),
                                        // color: mainColor,
                                        // alignment: Alignment.center,

                                        ///price//PRICE
                                        child: Text("??? " + priceWithCommer,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: mainColor))),
                                  ),
                                  InkWell(
                                    child: Card(
                                      color: Colors.grey[200],
                                      shape: StadiumBorder(),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 2,
                                            bottom: 2,
                                            left: 15,
                                            right: 15),
                                        child: Icon(
                                          Icons.phone,
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      launch("tel://" + phoneNumber);
                                      //           //print("jjf");
                                    },
                                  )
                                  // Expanded(child: Container(child:  ,),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       child: InkWell(
                      //         onTap: () {
                      //           launch("tel://" + phoneNumber);
                      //           //print("jjf");
                      //         },
                      //         child: Container(
                      //             margin: EdgeInsets.only(
                      //                 top: 10,
                      //                 bottom: 5,
                      //                 left: 10,
                      //                 right: 2.5),
                      //             padding:
                      //                 EdgeInsets.only(top: 5, bottom: 5),
                      //             color: mainColor,
                      //             alignment: Alignment.center,

                      //             ///price//PRICE
                      //             child: Container(
                      //               alignment: Alignment.center,
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Icon(
                      //                     Icons.phone,
                      //                     color: whiteColor,
                      //                     size: 20,
                      //                   ),
                      //                   SizedBox(width: 5),
                      //                   Text("Call",
                      //                       style: TextStyle(
                      //                           fontSize: 16,
                      //                           color: whiteColor))
                      //                 ],
                      //               ),
                      //             )),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Container(
                      //           margin: EdgeInsets.only(
                      //               top: 10,
                      //               bottom: 5,
                      //               left: 2.5,
                      //               right: 10),
                      //           padding: EdgeInsets.only(top: 5, bottom: 5),
                      //           color: mainColor,
                      //           alignment: Alignment.center,

                      //           ///price//PRICE
                      //           child: Text("??? " + priceWithCommer,
                      //               style: TextStyle(
                      //                   fontSize: 16, color: whiteColor))),
                      //     )
                      //   ],
                      // ),

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
    );
  }
}
//Image.network("http://via.placeholder.com/350x150"),
// child: CachedNetworkImage(
//   imageUrl: "http://via.placeholder.com/350x150",
//   progressIndicatorBuilder:
//       (context, url, downloadProgress) =>
//           CircularProgressIndicator(
//               value: downloadProgress.progress),
//   errorWidget: (context, url, error) =>
//       Icon(Icons.error),
// ),
