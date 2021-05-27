import 'dart:convert';

import 'package:Geo_home/Pages/EditPage.dart';
import 'package:Geo_home/Pages/ProductDetails.dart';
import 'package:Geo_home/Pages/SubmitProperty.dart';
import 'package:Geo_home/Pages/UserModel.dart';
import 'package:Geo_home/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'HomePage.dart';
import 'package:shimmer/shimmer.dart';

class UserProperties extends StatefulWidget{
  @override
  _UserProperties createState() => _UserProperties();


}

class _UserProperties extends State<UserProperties>{
  bool _enabled = true;
  Future fetchProperties() async {
    String url =
        "http://geohomesgroup.com/admin/process/list?pageType=m-properties&mobile=1&user_id="+userModel.getUserId();
    var response = await http.get(url);
    if (response.statusCode == 200) {
     // print(response.body);

      return jsonDecode(response.body);
    }
  }
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
 List selectedItemsIds = [];

  @override
  Widget build(BuildContext context){
     var width = MediaQuery.of(context).size.width;
    var height =  MediaQuery.of(context).size.height;
    return Scaffold(
     // bottomNavigationBar: bottomAppBarTheme(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        centerTitle: true, 
        title: selectedItemsIds.length > 0?
        Row(children: [
          Expanded(child:  selectedItemsIds.length > 1?
          Text("${selectedItemsIds.length} items selected"):
          Text("${selectedItemsIds.length} item selected"),),
          InkWell(child: Icon(Icons.delete),
          onTap: (){
            print(selectedItemsIds);
            String ids = "";
            for(var i = 0; i < selectedItemsIds.length; i++){
             if(i == selectedItemsIds.length - 1){
                ids += selectedItemsIds[i];
             }else{
                ids += selectedItemsIds[i]+",";
             }


            }
            
            showAlertDialog(context,selectedItemsIds.length.toString(),ids);
            setState(() {
              
            });
           
          },
          )
        ],)
        :Text("My Properties")
        ),

        body: Container(
          width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
               
                FutureBuilder(
                  future: fetchProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
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
                        return  noResultWidget();
                      
                    }
                    // print(snapshot.data['total']);
                   // return ListOfProperties(list: snapshot.data);
                  }

                    if (snapshot.hasData) {
                     // print(snapshot.data);
                      return ListOfPropertiesSingle( snapshot.data);
                    } else {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100),
                            ),
                           // shimmer(),
                            
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
                ),
              ],
            ),
          ),
        ),


    );
  }

  shimmer(){
    return Container(
        
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: _enabled,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 6,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _enabled = !_enabled;
                    });
                  },
                  child: Text(
                    _enabled ? 'Stop' : 'Play',
                    style: Theme.of(context).textTheme.button.copyWith(
                        fontSize: 18.0,
                        color: _enabled ? Colors.redAccent : Colors.green),
                  )),
            )
          ],
        ),
      );
  }

  Widget ListOfPropertiesSingle(Map<String, dynamic> list){
    var width = MediaQuery.of(context).size.width;
    var height =  MediaQuery.of(context).size.height;
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
                 list['row'] == null ? 0 : list['row'].length,
              itemBuilder: (context, i) {
                final List images = json.decode(list['row'][i]['c'][6]);
                // print("============"+t[0].toString());
                var row = list['row'];
                var id = list['row'][i]['i'];
                var title = row[i]['c'][0];

                var price = row[i]['c'][1];
                var category = row[i]['c'][2];
                var company = row[i]['c'][3];
                var status = row[i]['c'][4];
                var postDate = row[i]['c'][5];
                var type = row[i]['c'][7];
                var location = row[i]['c'][8];
                var priceWithCommer = numberFormat.format(json.decode(price));
                var phoneNumber = "08012345678";
              // print( "${numberFormat.format(price)}");
              

                return InkWell(
                  onTap: () {
                    if(selectedItemsIds.length > 0){
                      if(selectedItemsIds.contains(id)){
                    selectedItemsIds.remove(id);


                  }else{
                      selectedItemsIds.add(id);
                  }

              }else{

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
                                EditPage(productDetails: details, images: images,isEdit: true,)));
                    //////////////////////////////////////
                print("edit2");




              }
              setState(() {
                
              });

                   
                  },
                  onLongPress: (){
                  if(selectedItemsIds.contains(id)){
                    selectedItemsIds.remove(id);


                  }else{
                      selectedItemsIds.add(id);
                  }
                    setState(() {
                      
                    });
                    print("long press");
                  },
                  child: Card(
                     color: selectedItemsIds.contains(id) ?Colors.greenAccent[100] : whiteColor,
                    elevation: 5,
                    child: Container(
                     
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Column(
                        
                        children: [
                          
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              

                            Container(
                             
                              width: width/3,
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
                                ),),

                                Expanded(child: Container(
                                   margin: EdgeInsets.symmetric(vertical:10,horizontal:10),
                                  
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                 Container(
                                       ///margin: EdgeInsets.only(top:15),
                                   
                                    child: Row(
                                      children: [
                                       
                                        Expanded(child: Text(title)),
                                        selectedItemsIds.contains(id)?
                                         Icon(Icons.check_circle_outlined,color: mainColor,)
                                         :Container(),
                                      ],
                                    ),),


                                     Container(
                                       margin: EdgeInsets.only(top:15),
                                   
                                    child: Row(
                                      children: [
                                        Icon(Icons.place,color: mainColor,),
                                        Expanded(child: Text(location)),
                                      ],
                                    ),),


                                    Container(
                                       margin: EdgeInsets.only(top:5),
                                   
                                    child: Row(
                                      children: [
                                         Expanded(child: Text("₦ "+priceWithCommer,style: TextStyle(color: mainColor),)),
                                        InkWell
                                        (
                                          onTap: (){

                                             ///////////////////////////////////DETAILS PAGES////////////

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext) =>
                                ProductDetails(details, images)));
                    //////////////////////////////////////
                                            print("EYE CLICK");
                                          },
                                          
                                          child: Card(
                                          shape: StadiumBorder(),
                                          
                                          color: Colors.greenAccent[50],
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            child: Icon(Icons.remove_red_eye,color: mainColor,)))
                                        ),
                                       
                                      ],
                                    ),),

                                    

                                ],),),)
                            
                          ],),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
   

  }

  showAlertDialog(BuildContext context,String length,String ids) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),

    onPressed:  () {
print(ids);
Navigator.of(context).pop();
 selectedItemsIds.clear();
 setState(() {
   
 });

    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete"),
    content: Text("You are about to delete "+length.toString()),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      
      return alert;
    },
  );
}

}



//////////////////////////////////////////////



///////////////////////////ABANDONED CLASSSS///////////////////////////////



////////////////////////////////////////


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
                var phoneNumber = "08012345678";
              // print( "${numberFormat.format(price)}");
              

                return InkWell(
                  onTap: () {
                    if(selectedItemsIds.length > 0){
                      if(selectedItemsIds.contains(i)){
                    selectedItemsIds.remove(i);


                  }else{
                      selectedItemsIds.add(i);
                  }

              }else{
                
                 
                print("edit");
                
                
              }
              setState(() {
                
              });

                   
                  },
                  onLongPress: (){
                  if(selectedItemsIds.contains(i)){
                    selectedItemsIds.remove(i);


                  }else{
                      selectedItemsIds.add(i);
                  }
                    setState(() {
                      
                    });
                    print("long press");
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                     
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Column(
                        
                        children: [
                          selectedItemsIds.length > 0 && i == 0?
                          Container(child: Text(""),)
                          :Container(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              

                            Container(
                              width: width/3,
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
                                ),),

                                Expanded(child: Container(
                                   margin: EdgeInsets.symmetric(vertical:10,horizontal:10),
                                  
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                 Container(
                                       ///margin: EdgeInsets.only(top:15),
                                   
                                    child: Row(
                                      children: [
                                       
                                        Expanded(child: Text(title)),
                                         Icon(Icons.check_circle_outlined,color: mainColor,),
                                      ],
                                    ),),


                                     Container(
                                       margin: EdgeInsets.only(top:15),
                                   
                                    child: Row(
                                      children: [
                                        Icon(Icons.place,color: mainColor,),
                                        Expanded(child: Text(location)),
                                      ],
                                    ),),


                                    Container(
                                       margin: EdgeInsets.only(top:5),
                                   
                                    child: Row(
                                      children: [
                                         Expanded(child: Text("₦ "+priceWithCommer,style: TextStyle(color: mainColor),)),
                                        InkWell
                                        (
                                          onTap: (){

                                             ///////////////////////////////////DETAILS PAGES////////////

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext) =>
                                ProductDetails(details, images)));
                    //////////////////////////////////////
                                            print("EYE CLICK");
                                          },
                                          
                                          child: Card(
                                          shape: StadiumBorder(),
                                          
                                          color: Colors.greenAccent[50],
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            child: Icon(Icons.remove_red_eye,color: mainColor,)))
                                        ),
                                       
                                      ],
                                    ),),

                                    

                                ],),),)
                            
                          ],),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  
}