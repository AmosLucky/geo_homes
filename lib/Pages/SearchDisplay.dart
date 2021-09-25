import 'dart:convert';

import 'package:Geo_home/Pages/HomePage.dart';
import 'package:Geo_home/Pages/SearchFilter.dart';
import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchDisplay extends StatefulWidget {
  var keyword;
  var state;
  var lowRange;
  var highRange;
  var sort;
  var type;
  SearchDisplay(
      {this.keyword,
      this.state,
      this.lowRange,
      this.highRange,
      this.sort,
      this.type});

  @override
  _SearchDisplayState createState() => _SearchDisplayState();
}

class _SearchDisplayState extends State<SearchDisplay> {
  var keyword;
  var state;
  var lowRange;
  var highRange;
  var sort;

  @override
  void initState() {
    getSearchType();
    keyword = widget.keyword;
    state = widget.state;
    lowRange = widget.lowRange;
    highRange = widget.highRange;
    sort = widget.sort;
    //print("llll"+widget.state)  ;
    // print("llll"+widget.lowRange)  ;
    /// print("llll"+widget.highRange)  ;

    searchCtr.text = widget.keyword;

    // TODO: implement initState
    super.initState();
  }

  var searchType;
  SharedPreferences _sharePreference;
  getSearchType() async {
    if (widget.type == null) {
      widget.type = "properties";
    }
    _sharePreference = await SharedPreferences.getInstance();
    searchType = _sharePreference.getString("searchType");
    print(searchType);
  }

  Future fetchProperties() async {
    String url = "http://geohomesgroup.com/admin/process/list?" +
        "pageType=m-" +
        widget.type +
        "&mobile=1&user_id=1&condition=status,1&combine=and&search=" +
        keyword +
        "&condition=";
    if (state != null && lowRange != null && highRange != null) {
      url = url +
          "state," +
          state +
          "|price1," +
          lowRange +
          ",greater|price1," +
          highRange +
          ",less";
    } else if (lowRange != null && highRange != null) {
      url =
          url + "price1," + lowRange + ",greater|price1," + highRange + ",less";
    } else if (state != null) {
      url = url + "state," + state;
    }

    print(url);

    // if(state != null){
    //  url = url+ "state,"+state;

    // }

    // if(lowRange != null && highRange != null){
    // url =  url + "|price1," +
    // lowRange +
    // ",greater|price1," +
    // highRange+ ",less|";

    // }

    //  if(sort != ""){

    // }

    setState(() {});
    //print("===============" + url);

    var response = await http.get(url);
    if (response.statusCode == 200) {
      // print(response.body);

      return jsonDecode(response.body);
    }
  }

  var _formKey = GlobalKey<FormState>();
  TextEditingController searchCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Container(
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
              ),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.center,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          textInputAction: TextInputAction.search,
                          autofocus: true,
                          controller: searchCtr,
                          decoration: InputDecoration(
                            hintText: "Type your search here",
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
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
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              Route route = MaterialPageRoute(
                                  builder: (context) => SearchDisplay(
                                        keyword: keyword,
                                        state: null,
                                        lowRange: null,
                                        highRange: null,
                                        sort: null,
                                        type: widget.type,
                                      ));
                              Navigator.pushReplacement(context, route);

                              // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>SearchDisplay()));

                              // Navigator.of(context).push(MaterialPageRoute(builder: Build))

                            }
                            // searchProducts();
                          },
                        ),
                      ))),
              Container(
                child: InkWell(
                  child: Icon(
                    Icons.tune,
                    size: 30,
                    color: mainColor,
                  ),
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (BuildContext) => SearchFilter(
                              keyword: keyword,
                            ));
                    Navigator.of(context).pushReplacement(route);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              FutureBuilder(
                future: fetchProperties(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error fecting json...." + snapshot.error.toString());
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
                      return Container(
                        height: 300,
                        margin: EdgeInsets.only(top: 100, left: 10, right: 10),
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          child: FittedBox(
                              child: Image.asset("assets/images/noresult.gif")),
                        ),
                      );
                    }

                    // print(snapshot.data['total']);
                    //return ListOfProperties(list: snapshot.data);
                    return ListOfPropertiesSingle(list: snapshot.data);
                  } else {
                    return Center(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100),
                            ),
                            // CircularProgressIndicator(
                            //   backgroundColor: Colors.white,
                            // ),
                            gifLoader(),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Text(
                              "Loading Data...",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
