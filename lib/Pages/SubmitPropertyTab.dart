import 'package:Geo_home/Pages/SubmitProduct.dart';
import 'package:Geo_home/Pages/SubmitProperty.dart';
import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';

import 'SubmitService.dart';

class SubmitPropertiesTab extends StatefulWidget {
  //const SubmitPropertiesTab({ Key? key }) : super(key: key);

  @override
  _SubmitPropertiesTabState createState() => _SubmitPropertiesTabState();
}

class _SubmitPropertiesTabState extends State<SubmitPropertiesTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            toolbarHeight: 100,
            // automaticallyImplyLeading: t,
            // automaticallyImplyLeading: false,
            // backgroundColor: mainColor,
            // centerTitle: true,
            // title: Text("Submit Property"),
            bottom: TabBar(
              tabs: [
                Tab(text: "Real Estate", icon: Icon(Icons.home)),
                Tab(text: "Services", icon: Icon(Icons.fact_check)),
                Tab(
                    text: "Products",
                    icon: Icon(
                      Icons.table_chart,
                    ))
              ],
            ),
          ),
          body: TabBarView(
            children: [SubmitProperty(), SubmitService(), SubmitProduct()],
          )),
    );
  }
}
