import 'dart:async';

import 'package:Geo_home/Pages/HomePage.dart';
import 'package:Geo_home/Pages/Products.dart';
import 'package:Geo_home/Pages/Profile.dart';
import 'package:Geo_home/Pages/SearchPage.dart';
import 'package:Geo_home/Pages/SubmitProperty.dart';
import 'package:Geo_home/Pages/UserProperties.dart';
import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  int currentIndex;
  MainPage({this.currentIndex});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedButtomNavIndex = 0;

  PageController _controller = PageController(
    initialPage: 0,
  );

  int exit = 0;

  @override
  void initState() {
    if (widget.currentIndex != null) {
      selectedButtomNavIndex = widget.currentIndex;
      //_controller.jumpToPage(1);
      _controller = PageController(
        initialPage: widget.currentIndex,
      );
    } else {
      _controller = PageController(
        initialPage: 0,
      );
    }

    exit = 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("back pressed");

        if (exit < 1) {
          exit++;

          Fluttertoast.showToast(msg: "Tap again to exit");
        } else {
          SystemNavigator.pop();
          exit = 0;
        }

        Timer(Duration(seconds: 2), () {
          exit = 0;
          setState(() {});
        });

        setState(() {});

        // _scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Row(
        //     children: <Widget>[
        //       Expanded(
        //         child: Text(
        //           "Do you want to Close this App",
        //           style: TextStyle(),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       RaisedButton(
        //         color: mainColor,
        //         textColor: Colors.white,
        //         child: Text("Close App"),
        //         onPressed: () {
        //           SystemNavigator.pop();
        //         },
        //       )
        //     ],
        //   ),
        //   backgroundColor: Colors.blueGrey,
        // ));
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: PageView(
          onPageChanged: (i) {
            selectedButtomNavIndex = i;
            setState(() {});
          },
          controller: _controller,
          children: [
            HomePage(
                url:
                    "https://geohomesgroup.com/admin/process/list?pageType=m-properties&mobile=1&user_id=1&condition=status,1",
                jsonKey: "real-estate"),
            Products(
              url:
                  "https://geohomesgroup.com/admin/process/list?pageType=m-services&mobile=1&user_id=1&condition=status,1",
              jsonKey: "services",
              type: "services",
            ),
            Products(
              url:
                  "https://geohomesgroup.com/admin/process/list?pageType=m-products&mobile=1&user_id=1&condition=status,1",
              jsonKey: "building",
              type: "products",
            ),
            // UserProperties(),
            // SubmitProperty(isEdit: false,),
            // Profile(),
            // SearchPage(showArrow: false,)
            UserProperties(),
          ],
        ),
        bottomNavigationBar: bottomAppBarTheme(),
      ),
    );
  }

  bottomAppBarTheme() {
    return BottomNavigationBar(
      onTap: (newIndex) {
        print(newIndex);
        setState(() {
          selectedButtomNavIndex = newIndex;
          _controller.jumpToPage(newIndex);
        });
      },
      elevation: 0.0,
      selectedItemColor: mainColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.shifting,
      showUnselectedLabels: true,
      currentIndex: selectedButtomNavIndex,
      items: [
        new BottomNavigationBarItem(
          icon: InkWell(
            child: new Icon(Icons.home),
            // onTap: () {
            //   print("Home");
            //     // Navigator.of(context).push(
            //     //   MaterialPageRoute(builder: (BuildContext) => HomePage()));
            //   setState(() {
            //     selectedButtomNavIndex = 0;
            //    _controller.jumpToPage(0);
            //   });
            // },
          ),
          title: new Text("Real Estate"),
        ),
        new BottomNavigationBarItem(
          icon: InkWell(
            child: new Icon(Icons.fact_check),

            // onTap: () {
            //   //  Navigator.of(context).push(
            //   //     MaterialPageRoute(builder: (BuildContext) => UserProperties()));
            //   print("Properies");
            //   _controller.jumpToPage(1);
            //   setState(() {
            //     selectedButtomNavIndex = 1;
            //   });

            // },
          ),
          title: new Text("Services"),
        ),
        new BottomNavigationBarItem(
          icon: InkWell(
            child: new Icon(Icons.table_chart),
            // child: Card(
            //     shape: StadiumBorder(),
            //     color: mainColor,
            //     child: new Icon(
            //       Icons.add,
            //       size: 40,
            //       color: Colors.white,
            //     )),
            onTap: () {
              print("add");
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (BuildContext) => SubmitProperty()));
              _controller.jumpToPage(2);
              setState(() {
                selectedButtomNavIndex = 2;
              });
            },
          ),
          title: new Text("Products"),
        ),
        new BottomNavigationBarItem(
          icon: new InkWell(
            child: new Icon(Icons.person),
            // onTap: () {
            //   //  Navigator.of(context).push(
            //   //     MaterialPageRoute(builder: (BuildContext) => Profile()));
            //   print("person");
            //   setState(() {
            //     _controller.jumpToPage(3);
            //     selectedButtomNavIndex = 3;
            //   });
            //  },
          ),
          title: new Text("Profile"),
        ),
        // new BottomNavigationBarItem(
        //   icon: new InkWell(
        //     child: new Icon(Icons.search),
        //     // onTap: () {
        //     //   // Navigator.of(context).push(
        //     //   //     MaterialPageRoute(builder: (BuildContext) => MainPage()));
        //     //   print("menu");
        //     //   setState(() {
        //     //     _controller.jumpToPage(4);
        //     //     selectedButtomNavIndex = 4;
        //     //   });
        //     // },
        //   ),
        //   title: new Text("Search"),
        // )
      ],
    );
  }
}
