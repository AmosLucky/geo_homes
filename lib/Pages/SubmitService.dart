import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart';

import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import "package:async/async.dart";
import 'package:http/http.dart' as http;

import 'UserModel.dart';

class SubmitService extends StatefulWidget {
  Map<String, dynamic> productDetails;
  List images;
  bool isEdit = false;
  SubmitService({this.productDetails, this.images, this.isEdit});
  @override
  _SubmitServiceState createState() => _SubmitServiceState();
}

class _SubmitServiceState extends State<SubmitService> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _tagKey = GlobalKey<FormState>();
  var mainTags = {};

  final Map<dynamic, dynamic> formValues = {};
  var selectedValue1;
  var selectedValue2;
  var selectedValue3;
  var tagCounter = 0;

  List<bool> isUploaded = [];
  List<File> imagesList = [];
  List<bool> imagesCLick = [false, false, false, false];
  var pictures = [];

  List<Widget> layouts = [];
  int layoutIndex = 0;
  Map<dynamic, dynamic> tags = {};
  File _image;
  final picker = ImagePicker();
  var msgColor = Colors.greenAccent;
  TextEditingController _controller = new TextEditingController();

  Future getImage(int i) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    //setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});

      /////////RESIZE IMAGE///////
      imagesList[i] = _image;
      isUploaded[i] = true;

      /////////RESIZE AND CONVERT TO BASE64///
      //   var  imageResized = await FlutterNativeImage.compressImage(_image.path,
      // quality: 100, targetWidth: 120, targetHeight: 120);

      //   List<int> imageBytes = imageResized.readAsBytesSync();
      final bytes = _image.readAsBytesSync();
      var img64 = base64Encode(bytes);
      String imageName = basename(_image.path);
      var _imageBase64 = img64; //base64Encode(imageBytes);
      var jsonOfImage = {"type": "picture", "title": "Preview"};

      jsonOfImage['src'] = _image.path;
      jsonOfImage['desc'] = imageName;
      jsonOfImage['image_data'] = _imageBase64;
      pictures.add(i);

      pictures[i] = jsonOfImage;
    } else {
      imagesCLick[i] = false;
      print('No image selected.');
    }
    //});
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
    if (widget.isEdit) {
      String url =
          "http://geohomesgroup.com/admin/process/list?pageType=m-services&mobile=1&user_id=" +
              widget.productDetails['id'];
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // print(response.body);

        var res = jsonDecode(response.body);
        print(res["row"]);
        var row = res;
        var title = row['c'][0];

        var price = row['c'][1];
        var category = row['c'][2];
        var company = row['c'][3];
        var status = row['c'][4];
        var postDate = row['c'][5];
        var type = row['c'][7];
        var location = row['c'][8];

        setState(() {});
      }
    }
  }

  @override
  void initState() {
    fetchPropertiesEdit();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var hiegth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text("Submit Product"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: 100,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/hero-banner.jpg"),
                  fit: BoxFit.fill,
                )),
              ),

              /////////////////////////////////MAIN CONTENT CONTAINER/////////////////
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: width,
                color: whiteColor,
                child: Column(
                  children: [
                    // Container(
                    //   height: 30,
                    //   child: bottomNavigationBar(context, 2)
                    // ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          headText("Service Details"),
                          textField(
                              labelText: "Name of Service",
                              errorText: "Name is empty",
                              key: "description",
                              controller: _controller),
                          //////////////////SELECTS/////////////

                          selectField1(
                              items: [
                                "Well Drillers",
                                "Welder",
                                "Tiler",
                                "Solar Installler",
                                "Safety Manager",
                                "Roofing",
                                "POP Installer",
                                "Plumber",
                                "Pipe Filter",
                                "Painter",
                                "Landscaper",
                                "Joiners",
                                "Interior Designer",
                                "Horticulturist/ Florist",
                                "Glaziers",
                                "Fumigator/Pest Controller",
                                "Fabricator",
                                "Engineer",
                                "Electrician",
                                "Electric/wire Fencing",
                                "Concrete Caster",
                                "Cleaning Technician",
                                "CCTV Installer",
                                "Carpenter",
                                "Brick Mason",
                                "Borehole Drillers",
                                "Air Condition Technician"
                              ],
                              hint: "Service Type",
                              widgetNumber: 1,
                              key: "pcategories"),
                          // selectField2(
                          //     items: ["For Rent", "For Sale"],
                          //     hint: "Select Lease Type",
                          //     widgetNumber: 1,
                          //     key: "unit"),
                          selectField3(
                              items: listOfStates,
                              hint: "Select State",
                              widgetNumber: 1,
                              key: "state"),

                          /////////////////

                          textField(
                              labelText: "What City",
                              errorText: "City is empty",
                              key: "city"),

                          //////////////
                          // textField(
                          //     labelText: "Location Address",
                          //     errorText: "Location is empty",
                          //     key: "warehouse"),

                          //////////////
                          // textField(
                          //     labelText: "Total price",
                          //     errorText: "Price is empty",
                          //     key: "price1",
                          //     keyBoardType: TextInputType.number),

                          //////////////
                          textField(
                              labelText: "Write the main content here",
                              errorText: "content is empty",
                              key: "sales_desc",
                              maxLine: 10),
                          //////////////////////
                          ///IMAGE WIDGET????
                          ///
                          imageGrid(),
                          SizedBox(height: 20),

                          headText("Property Tags"),
                          propertyTags(),
                          SizedBox(height: 20),
                          Text(
                            _loginResponse,
                            style: TextStyle(color: msgColor),
                          ),

                          SizedBox(height: 5),

                          Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  child: hasClicked
                                      ? Image.asset(
                                          "assets/images/preloader.gif",
                                          width: 40,
                                        )
                                      : Text("Submit"),
                                  color: mainColor,
                                  textColor: whiteColor,
                                  onPressed: () {
                                    // layouts.setAll(2,headText("nndnlld"));
                                    setState(() {});
                                    // return;
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if (imagesList[0] == null &&
                                          imagesList[1] == null &&
                                          imagesList[2] == null &&
                                          imagesList[3] == null) {
                                        toast(
                                            "Please select at leats one image");
                                        return;
                                      } else if (selectedValue1 == null) {
                                        toast("Please select Property Type");
                                        return;
                                      }
                                      // else if (selectedValue2 == null) {
                                      //   toast("Please select Lease type");
                                      //   return;
                                      // }
                                      else if (selectedValue3 == null) {
                                        toast("Please select State");
                                        return;
                                      }
                                      setState(() {
                                        hasClicked = true;
                                        _loginResponse = "";
                                      });

///////////////////////////////////////////////entering the tags////////////////////////
                                      ///
                                      mainTags.clear();

                                      tags.forEach((key, value) {
                                        if (value != null && value != "") {
                                          mainTags[key] = value;
                                        }
                                        // print(key);
                                      });

                                      /////////////////////CALING THE METHOD THAT SAVES PROPERTY
                                      formValues['case'] = "1.7";
                                      formValues['formName'] = "properties";
                                      formValues['updated_by'] =
                                          userModel.getUserId();
                                      formValues['created_by'] =
                                          userModel.getUserId();
                                      formValues['vendor_id'] =
                                          userModel.getCustomerName();
                                      formValues['alternate_vendor'] =
                                          userModel.getPhone();
                                      formValues['itemid'] = "3a0979";
                                      formValues['asset_type'] = "client";
                                      formValues['status'] = "0";

                                      //formValues['sales_desc'] = "xxxxxx";
                                      formValues['validation'] = "strict";
                                      formValues['tags'] =
                                          json.encode(mainTags);
                                      formValues['picture'] =
                                          json.encode(pictures);

                                      // print(userModel.getPhone());

                                      //  print(formValues);

                                      postProperty();
                                      /////////////////////CALING THE METHOD THAT SAVES PROPERTY

                                      // if(_tagKey.currentState.validate()){

                                      //   _tagKey.currentState.save();
                                      //   print(formValues);

                                      // }

                                      // print(imagesList);

                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  postProperty() async {
    Uri url = Uri.parse("http://geohomesgroup.com/admin/process/controllers");
    var response = await http.post(
      url,
      body: formValues,
    );

    if (response.statusCode == 200) {
      print(response.body);
      var res = jsonDecode(response.body);
      if (res["status"] == 1 || res["status"] == "1") {
        _controller.clear();
      }
      setState(() {
        _loginResponse = res["message"];
        hasClicked = false;
      });
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
                  onChanged: (val) {
                    // tags.add(val);
                    if (val != null) {
                      tags[index.toString()] = val;
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3.0),
                child: InkWell(
                  child: Icon(Icons.close),
                  onTap: () {
                    tags[index.toString()] = "";
                    layouts[index] = Container();
                    //  layouts.removeAt(index);
                    print(index);
                    setState(() {});
                  },
                ),
              )
            ],
          ));
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(3)),
      child: Container(
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
                            labelText: "Tag", border: OutlineInputBorder()),
                        // onFieldSubmitted: (val){
                        //   tags.add(val);

                        // },
                        onChanged: (val) {
                          //  tags.add(val);
                          if (val != null) {
                            tags["Square Feet"] = val;
                          }
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
                          layouts.add(row(layoutIndex));
                          tags[layoutIndex.toString()] = "";
                        });
                        layoutIndex++;
                      },
                      child: Icon(Icons.add),
                    )),
              ],
            ),
            Container(
              child: Column(
                children: layouts,
              ),
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
              imagesList.add(file);
              return InkWell(
                onTap: () {
                  setState(() {});
                  if (index == 0) {
                    imagesCLick[index] = true;
                    getImage(index);
                  } else if (imagesCLick[index - 1]) {
                    imagesCLick[index] = true;
                    getImage(index);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please upload image " + '${index}');
                  }

                  /// print(index);
                },
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
                                    child: isUploaded[index]
                                        ? Image.file(
                                            imagesList[index],
                                            fit: BoxFit.fill,
                                            width: 240,
                                            height: 250,
                                          )
                                        : Image.asset(
                                            "assets/images/image-icon.png")),
                              ),
                            ],
                          )),
                    ),
                  ],
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
                if (value == "For Sale") {
                  mainValue = "sale";
                } else {
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
