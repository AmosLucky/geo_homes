import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Geo_home/Pages/MainPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart';

import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import "package:async/async.dart";
import 'package:http/http.dart' as http;

import 'UserModel.dart';



class EditPage extends StatefulWidget {
  Map<String, dynamic> productDetails;
  List images;
  bool isEdit = false;
  EditPage({this.productDetails, this.images,this.isEdit});
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController titleCtr = new TextEditingController();
  TextEditingController cityCtr = new TextEditingController();
  TextEditingController locationCtr = new TextEditingController();
  TextEditingController priceCtr = new TextEditingController();
  TextEditingController contentCtr = new TextEditingController();
  bool isSet = false;




  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _tagKey = GlobalKey<FormState>();

  final Map<String, dynamic> formValues = {};
  var selectedValue1;
  var selectedValue2;
  var selectedValue3;
  var tagCounter = 0;
  var mainTags = {};
  var msgColor = Colors.greenAccent;

  var pictures = [];
  var picturesToUpload = {};

  List<bool> isUploaded = [];
  Map<int , dynamic> imagesList = {};
  List networkImage = [];
   List<String> tags = [];
  File _image;
  final picker = ImagePicker();

  Future getImage(int i,String oldLink) async {
    print(oldLink);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //picturesToUpload

    if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          
        });

         /////////RESIZE IMAGE///////
        imagesList[i] = _image;
        isUploaded[i] = true;

        ////////////////////////////
        final bytes =  _image.readAsBytesSync(); 
       var img64 = base64Encode(bytes);
      String imageName = basename(_image.path);
     var  _imageBase64 = img64;//base64Encode(imageBytes);
     Map<String, dynamic> jsonOfImage = {"type":"picture","title":"Preview","oldLink":oldLink};
          
          jsonOfImage['src'] = _image.path;
           jsonOfImage['desc'] = imageName;
            jsonOfImage['isOriginal'] = false;
           jsonOfImage['image_data'] = _imageBase64;
          
           pictures.add(i);

          picturesToUpload[i] = jsonOfImage;

    }else{
       /// imagesCLick[i] = false;
        print('No image selected.');
    }


  }

  ////////////////////////CANCEl LOADER
  ///
  bool hasClicked = false;
  var _loginResponse = "";
  clearPreloader() {
    _loginResponse = "";
    Timer(Duration(seconds: 30), () {
      ///showAlertDialog(context, "Error", "please Check your internet connection");

      if (hasClicked) {
        setState(() {
          _loginResponse = "Error: please Check your internet connection";
          hasClicked = false;
        });
      }
    });
    //}
  }
  //////////////////////////////
  Future fetchPropertiesEdit() async {
    print(widget.productDetails['id']);
   if(widget.isEdit){
      String url =
         "http://geohomesgroup.com/admin/process/loadform?pageType=properties&mobile=1&user_id=1&id=" +
              widget.productDetails['id'];
              print(widget.productDetails['id']);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      

     var res =  jsonDecode(response.body);
     
     print(res);
     var row = res[0];
     
                var title = row['description'];
                var price = row['price1'];
                var category = row['categories'];
                var state  = row['state'];
               // var company = row['p'];
                var status = row['status'];
               //var postDate = row[5];
               var unit = row["unit"];
                var type = row['pcategories'];
                var location = row['warehouse'];
                var description = row['sales_desc'];
                var city = row['city'];
                priceCtr.text = price;
                locationCtr.text = location;
                titleCtr.text = title;
                contentCtr.text = description;
                cityCtr.text = city;
                selectedValue1 = type.replaceAll(type[0], type[0].toUpperCase()).replaceAll("-"," ");
                 selectedValue2 = "For "+unit.replaceAll(unit[0], unit[0].toUpperCase()).replaceAll("-"," ");
                  selectedValue3 = state.replaceAll(state[0], state[0].toUpperCase()).replaceAll("-"," ");
                  print(type.replaceAll(type[0], type[0].toUpperCase()));
                  print(state.replaceAll(state[0], state[0].toUpperCase()));
                  var pictures = jsonDecode(row['picture']);
                  print(pictures[0]['src']);
                  for(int i = 0; i < pictures.length; i++){
                    networkImage.add(pictures[i]['src']);
                  var obj = pictures[i];
                  obj["isOriginal"] = true;
                 
                    picturesToUpload[i] = obj;
                    

                  }
                  
                  isSet = true;
                  

                  res[0].forEach((key, value){
                    if( value == null || value == "")
                    formValues[key]= "null";
                    else
                    formValues[key]=  value;

                  });
                  



                setState(() {
                
                });
     
    }
   }
  }
  @override
  void initState() {
    fetchPropertiesEdit();
    // TODO: implement initState
    super.initState();
  }
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var hiegth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: (){
        var route = MaterialPageRoute(builder: (BuildContext) =>MainPage(currentIndex: 1));
        Navigator.of(context).pushReplacement(route);
      },
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar(context,2),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text("Edit Property"),
        ),
        body: isSet ?SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/hero-banner.jpg"),
                    fit: BoxFit.fill,
                  )),
                ),

                /////////////////////////////////MAIN CONTENT CONTAINER/////////////////
                Container(
                  margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  width: width,
                  color: whiteColor,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        headText("Property Details"),
                        textField(
                            labelText: "Title of Property",
                            errorText: "Title is empty",
                            key: "description",
                            controller: titleCtr),
                        //////////////////SELECTS/////////////

                        selectField1(
                            items: ["Residential buildings", "Commercial buildings","Lands","Estates"],
                            hint: "Property Type",
                            widgetNumber: 1,
                            key: "pcategories"),
                        selectField2(
                            items: ["For Rent", "For Sale"],
                            hint: "Select Lease Type",
                            widgetNumber: 1,
                            key: "unit"),
                        selectField3(
                            items:  listOfStates,
                            hint: "Select State",
                            widgetNumber: 1,
                            key: "state"),

                        /////////////////

                        textField(
                            labelText: "What City",
                            errorText: "City is empty",
                            key: "city",
                            controller: cityCtr),

                        //////////////
                        textField(
                            labelText: "Location Address",
                            errorText: "Location is empty",
                            key: "warehouse",
                            controller: locationCtr),

                        //////////////
                        textField(
                            labelText: "Total price",
                            errorText: "Price is empty",
                            key: "price1",
                            keyBoardType: TextInputType.number,
                            controller: priceCtr),

                        //////////////
                        textField(
                            labelText: "Write the main content here",
                            errorText: "content is empty",
                            key: "sales_desc",
                            maxLine: 10,
                            controller: contentCtr),
                        //////////////////////
                        ///IMAGE WIDGET????
                        ///
                        imageGrid(),
                        SizedBox(height: 20),

                        headText("Property Tags"),
                        propertyTags(),
                        SizedBox(height: 20),
                        Text(_loginResponse,style: TextStyle(color: msgColor),),

                         SizedBox(height: 5),

                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                child: hasClicked? Image.asset(
                                  "assets/images/preloader.gif",
                                  width: 40,
                                ):Text("Submit"),
                                color: mainColor,
                                textColor: whiteColor,
                                onPressed: () {
                                  // layouts.setAll(2,headText("nndnlld"));
                                  setState(() {});
                                  // return;
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    // if (imagesList[0] == null &&
                                    //     imagesList[1] == null &&
                                    //     imagesList[2] == null &&
                                    //     imagesList[3] == null) {
                                    //       toast("Please select at leats one image");
                                    //       return;
                                    //     }else 
                                        if(selectedValue1 == null){
                                           toast("Please select Property Type");
                                           return;

                                        }else if(selectedValue2 == null){
                                           toast("Please select Lease type");
                                           return;
                                        

                                        }else if(selectedValue3 == null){
                                           toast("Please select State");
                                           return;
                                        

                                        }
                                        setState(() {
                                          hasClicked = true;
                                          _loginResponse = "";
                                        });

                                        /////////////add images to its array///////
                                        pictures.clear();
                                        picturesToUpload.forEach((key, value) { 
                                          pictures.add(value);
                                        });


                                         /////////////////////CALING THE METHOD THAT SAVES PROPERTY
                                    formValues['case'] = "1.7";
                                    formValues['formName'] = "properties";
                                    formValues['updated_by'] = userModel.getUserId();
                                     formValues['created_by'] = userModel.getUserId();
                                     formValues['vendor_id'] = userModel.getCustomerName();
                                     formValues['alternate_vendor'] = userModel.getPhone();
                                     formValues['itemid'] = "3a0979";
                                     formValues['asset_type'] = "client";
                                     formValues['status'] = "0";
                                      // formValues["transcid"] = "transcid";
                                      // formValues['purchase_desc'] = "purchase_desc";
                                      //   formValues["upc"] = "upc";
                                      //   formValues["categories"] = "categories ";
                                      //    formValues["sunit"] = "sunit";
                                      //    formValues["threshold"] = "threshold";
                                      //      formValues["taxable"] = "taxable";
                                      //      formValues["commission"] = "commission";
                                      //       formValues["costing_method"] = "costing_method";
                                       formValues['validation'] = "strict";
                                        formValues['tags'] = json.encode(mainTags);
                                        formValues['picture'] = json.encode(pictures);
                                         print(formValues);
                                        
                                       // print(pictures);
                                       // print(picturesToUpload);

                                        /////////////////////CALING THE METHOD THAT SAVES PROPERTY

                                       postProperty();
                                        /////////////////////CALING THE METHOD THAT SAVES PROPERTY

                                        // if(_tagKey.currentState.validate()){

                                        //   _tagKey.currentState.save();
                                          

                                        // }
                                       


                                        // print(imagesList);
                                        // print(tags);

                                        // print(formValues);
                                        

                                       
                                           
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : Container(child: Center(child: CircularProgressIndicator(),),),
      ),
    );
  }
  postProperty() async {
    formValues['location'] = locationCtr.text;
     Uri url = Uri.parse( "http://geohomesgroup.com/admin/process/controllers");
    var response = await  http.post(
      url,
      body:formValues,
    
    );

     if (response.statusCode == 200) {
      print(response.body);
       var res = jsonDecode(response.body);
     if(res['status']==1){
       cityCtr.clear();
       locationCtr.clear();
       priceCtr.clear();
       titleCtr.clear();

        setState(() {
          msgColor = Colors.greenAccent;
        _loginResponse = res["message"];
        hasClicked = false;
      });

     }else{

        setState(() {
          msgColor = Colors.redAccent;
        _loginResponse = res["message"];
        hasClicked = false;
      });

     }
    } else {
      //print(response);
     // var res = jsonDecode(response.body);
      
      setState(() {
        msgColor = Colors.redAccent;
        _loginResponse = "Failed: An issue occoured";
        hasClicked = false;
      });
    }


 

  }

  Widget toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      //timeInSecForIos: 1
    );
  }

  List<Widget> layouts = [];

  Widget headText(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  Widget textField(
      {String labelText,
      String errorText,
      String key,
      var keyBoardType,
      int maxLine,
      TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLine,
        keyboardType: keyBoardType,
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            labelStyle: TextStyle()),
        onSaved: (value) {
          formValues[key] = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return errorText;
          }
        },
      ),
    );
  }

  Widget propertyTags() {
    var l = 1 + layouts.length;

    return Form(
      key: _tagKey,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3)),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: l,
              itemBuilder: (ctx, i) {
                row(int index) {
                  return Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Tag", border: OutlineInputBorder()),
                                   onFieldSubmitted: (val){
                                          tags.add(val);

                                        },
                                  
                                  onChanged: (val){
                                     // tags.add(val);
                                  },
                                  onSaved: (val){
                                    tags.add(val);

                                  },
                                  
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 3.0),
                            child: InkWell(
                              child: Icon(Icons.close),
                              onTap: () {
                                layouts.removeAt(index);
                                print(index);
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ));
                }

                if (i == 0) {
                  return Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "Tag",
                                        border: OutlineInputBorder()),
                                        onFieldSubmitted: (val){
                                          tags.add(val);

                                        },
                                        onChanged: (val){
                                    //  tags.add(val);
                                  },
                                        onSaved: (val){
                                    tags.add(val);

                                  },
                                        
                                  )),
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 10, top: 10),
                                alignment: Alignment.topRight,
                                child: FloatingActionButton(
                                  mini: true,
                                  onPressed: () {
                                    setState(() {
                                      layouts.add(row(i));
                                    });
                                  },
                                  child: Icon(Icons.add),
                                )),
                          ],
                        )
                      ],
                    ),
                  );
                }
                return Container(
                  child: Column(
                    children: [
                      //Text("${i}"),
                      layouts[i - 1],
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget imageGrid() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            children: new List<Widget>.generate(4, (index) {
              File file;
              isUploaded.add(false);
              //imagesList.add(file);
              return InkWell(
                onTap: () {
                  setState(() {
                   
                  });
                 // print(networkImage.length+index);
                  if(networkImage.length > index){
                     getImage(index,networkImage[index]);

                  }else{
                    getImage(index,null);

                  }

                  /// print(index);
                },
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              //color: Colors.greenAccent,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: 
                                      isUploaded[index]
                                          ? Image.file(
                                              imagesList[index],
                                              fit: BoxFit.fill,
                                              width: 240,
                                              height: 250,
                                            ):
                                            networkImage.length > index?
                                             CachedNetworkImage(
                                               fit: BoxFit.fill,
                                               width: 240,
                                              height: 250,
                                      //////////////IMAGE
                                     imageUrl: networkImage[index],
                                    )
                                  
                                      
                                          : Image.asset("assets/images/image-icon.png")),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              );
            })));
  }

  Widget selectField1(
      {List<String> items, String hint, int widgetNumber, String key}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3)),
            child: DropdownButton<String>(
              hint: Text("   " + hint),
              value: selectedValue1,
              isExpanded: true,
              underline: Container(),
              items: items.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text("   " + value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  print(value);
                  selectedValue1 = value;
                  formValues[key] = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////2
  Widget selectField2(
      {List<String> items, String hint, int widgetNumber, String key}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3)),
            child: DropdownButton<String>(
              hint: Text("   " + hint),
              value: selectedValue2,
              isExpanded: true,
              underline: Container(),
              items: items.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text("   " + value),
                );
              }).toList(),
              onChanged: (value) {
                var mainValue;
                if(value == "For Sale"){
                  mainValue = "sale";
                  
                

                }else{
                    mainValue = "rent";

                }
                setState(() {
                   
                  print(mainValue);
                  selectedValue2 = value;
                  formValues[key] = mainValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

//////////////////////////////////////
  Widget selectField3(
      {List<String> items, String hint, int widgetNumber, String key}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3)),
            child: DropdownButton<String>(
              hint: Text("   " + hint),
              value: selectedValue3,
              isExpanded: true,
              underline: Container(),
              items: items.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text("   " + value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  print(value);
                  selectedValue3 = value;

                  formValues[key] = value.replaceAll(" ", "-").toLowerCase();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
   var listOfStates = [
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross river",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara",
    "Abuja"
  ];
}
