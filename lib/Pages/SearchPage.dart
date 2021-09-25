import 'dart:convert';

import 'package:Geo_home/Pages/ProductDetails.dart';
import 'package:Geo_home/Pages/SearchDisplay.dart';
import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'SearchFilter.dart';

class SearchPage extends StatefulWidget {
  bool showArrow;
  String type;
  SearchPage({this.showArrow, this.type});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool showFilter = false;
  var _formKey = GlobalKey<FormState>();
  var url = "";
  String keyword = "";
  String sort = "lat";
  String state = "Abia";
  String priceRange = "500000+-+15000000";
  bool showArrow;
  var searchType;

  @override
  void initState() {
    getSharedPreference();
    print(widget.type);
    if (widget.showArrow != null) {
      showArrow = widget.showArrow;
    } else {
      showArrow = true;
    }
    // TODO: implement initState
    super.initState();
  }

  SharedPreferences _sharePreference;
  getSharedPreference() async {
    _sharePreference = await SharedPreferences.getInstance();
    searchType = _sharePreference.getString("searchType");
    print(searchType);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          //  title:   automaticallyImplyLeading: false,
          title: Container(
            // margin: EdgeInsets.only(top:10),
            child: Image.asset("assets/images/logo.jpg"),
            width: width - 150,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage("assets/images/search-bg2.jpg")),
            ),
            child: Column(
              children: [
                Container(
                    height: height / 8,
                    width: width,
                    //decoration: BoxDecoration(color: mainColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    showArrow
                                        ? Container(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Icon(
                                                Icons.arrow_back,
                                                size: 30,
                                                color: mainColor,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            alignment: Alignment.center,
                                            child: Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                autofocus: true,
                                                textInputAction:
                                                    TextInputAction.search,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Type your search here",
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                                validator: (input) {
                                                  if (input.trim().isEmpty) {
                                                    return "";
                                                  }
                                                },
                                                onSaved: (val) {
                                                  keyword = val;
                                                },
                                                onEditingComplete: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();

                                                    if (showArrow) {
                                                      Route route =
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SearchDisplay(
                                                                    keyword:
                                                                        keyword,
                                                                    state: null,
                                                                    lowRange:
                                                                        null,
                                                                    highRange:
                                                                        null,
                                                                    sort: null,
                                                                    type:
                                                                        searchType,
                                                                  ));
                                                      Navigator.push(
                                                          context, route);
                                                    } else {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext) =>
                                                                      SearchDisplay(
                                                                        keyword:
                                                                            keyword,
                                                                      )));
                                                    }

                                                    // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>SearchDisplay(
                                                    //   keyword: keyword,
                                                    // )));

                                                    // Navigator.of(context).push(MaterialPageRoute(builder: Build))

                                                  }
                                                  // searchProducts();
                                                },
                                              ),
                                            ))),
                                    // Container(
                                    //   child: InkWell(
                                    //     child: Icon(
                                    //       Icons.tune,
                                    //       size: 30,
                                    //       color: mainColor,
                                    //     ),
                                    //     onTap: () {
                                    //       setState(() {
                                    //         if (showFilter) {
                                    //           showFilter = false;
                                    //         } else {
                                    //           showFilter = true;
                                    //         }
                                    //       });
                                    //       //showDialog();
                                    //     },
                                    //   ),
                                    // )
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
                Container(
                  child: Column(
                    children: [
                      showFilter ? filterContent() : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  searchProducts() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        url = "http://geohomesgroup.com/admin/process/list?pageType=m-" +
            widget.type +
            "&mobile=1&user_id=1&search" +
            keyword +
            "&state=" +
            state +
            "&price-range=" +
            priceRange +
            "sort=" +
            sort;
      });
      // fetchProperties();
      print(url);
    }
  }

  filterContent() {
    var dropdownValue = "All";
    var spinnerItems = ["Search", "Lands", "Cath", "All", "Abia"];
    return Container(
      margin: const EdgeInsets.only(right: 5, top: 10, left: 5),
      child: Column(
        children: [
          Row(
            children: [
              /////////////////////////////////////////////////////////////////////////////////
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  //padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(
                            5) //                 <--- border radius here
                        ),
                  ),
                  child: Column(children: <Widget>[
                    DropdownButton<String>(
                      hint: Text(" Region"),
                      //value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                      underline: Container(),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValue = data;
                          // print(data);
                          //  print(dropdownValue);
                        });
                      },
                      items: spinnerItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            " " + value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),

                    // Text(dropdownValue,
                    // style: TextStyle
                    //     (fontSize: 22,
                    //     color: Colors.black)),
                  ]),
                ),
              ),
              //////////////////////////////////////////////////////////////

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  //padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(
                            5) //                 <--- border radius here
                        ),
                  ),
                  child: Column(children: <Widget>[
                    DropdownButton<String>(
                      hint: Text(" Relevant"),
                      //value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                      underline: Container(),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValue = data;
                          // print(data);
                          //  print(dropdownValue);
                        });
                      },
                      items: spinnerItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            " " + value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),

                    // Text(dropdownValue,
                    // style: TextStyle
                    //     (fontSize: 22,
                    //     color: Colors.black)),
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 300,
            child: SizedBox.expand(child: filterContent()),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      },
    );
  }

  Widget filterContent2() {
    var dropdownValue = "Lands";
    var spinnerItems = ["Search", "Lands", "Cath"];
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(8) //                 <--- border radius here
                ),
          ),
          child: Column(children: <Widget>[
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.red, fontSize: 18),
              underline: Container(),
              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                  // print(data);
                  //  print(dropdownValue);
                });
              },
              items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    " " + value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),

            // Text(dropdownValue,
            // style: TextStyle
            //     (fontSize: 22,
            //     color: Colors.black)),
          ]),
        ),
      ],
    );
  }
}
