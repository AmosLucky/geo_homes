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

class Products extends StatefulWidget {
  String url;
  String jsonKey;
  String type;
  Products({this.url, this.jsonKey, this.type});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    SharedPreferences _sharePreference;
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
                                      "searchType", widget.type);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext) => SearchPage()));
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
                  MaterialPageRoute(builder: (BuildContext) => Products()));
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
            var id,
                type2,
                title,
                price,
                category,
                company,
                status,
                postDate,
                type,
                location,
                companyName,
                phoneNumber,
                priceWithCommer;
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
            title = title.replaceAll(title[0], title[0].toUpperCase());

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
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 480,

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            //  alignment: Alignment.centerLeft,

                            ///title

                            // padding: EdgeInsets.only(
                            //  left: 1, right: 1, top: 1),

                            child: Container(
                              width: 150,
                              height: hieght / 7,
                              child: CachedNetworkImage(
                                //fit: BoxFit.cover,
                                //////////////IMAGE///////////////////
                                imageUrl: images[0]['src'],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SizedBox(
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
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[350],
                                            borderRadius: BorderRadius.only(
                                                //  topRight: Radius.circular(15.0),
                                                topLeft: Radius.circular(5.0)),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                strokeWidth: 1.0,
                                                value:
                                                    downloadProgress.progress),
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
                                      //topRight: Radius.circular(15.0),
                                      topLeft: Radius.circular(5.0)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: imageProvider,
                                  ),
                                )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),

                            ////////////TITLE
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.topLeft,
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 5),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    category,
                                  ),
                                ),
                                price != ""
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "₦" + price,
                                          style: TextStyle(color: mainColor),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ))
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                                height: 40,
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10),
                                decoration: BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),

                                  //color: Colors.grey, width: 0.5
                                )),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: mainColor,
                                    ),
                                    Text(companyName.length > 8
                                        ? companyName.substring(0, 8) + ".."
                                        : companyName)
                                  ],
                                )),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    right: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                    top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                    // color: Colors.grey, width: 0.4
                                  )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.phone_in_talk,
                                        color: mainColor,
                                      ),
                                    ],
                                  )),
                              onTap: () {
                                launch("tel://" + phoneNumber);
                              },
                            ),
                          )
                        ],
                      )
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
