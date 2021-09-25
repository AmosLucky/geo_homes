import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Geo_home/Pages/Login.dart';
import 'package:Geo_home/Pages/UserModel.dart';
import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences _sharedPreferences;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController businessNameCtr = TextEditingController();
  TextEditingController businessPhoneCtr = TextEditingController();
  TextEditingController businessDescCtr = TextEditingController();
  Map<String, dynamic> formValues = {};
  File _image;
  bool isSelected = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isSelected = true;
        _image = File(pickedFile.path);
        print(_image);
        //_image = _image;
        //isUploaded[i] = true;
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    nameCtr.text = userModel.getCustomerName();
    emailCtr.text = userModel.getEmail();
    loadDetails();
    // TODO: implement initState
    super.initState();
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
  loadDetails() async {
    var url = "http://geohomesgroup.com/admin/process/loadform?pageType" +
        "=members_&mobile=1&user_id=1&id=" +
        userModel.getUserId();

    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(userModel.getUserId());

      print("==" + response.body);
    }
  }

  logOut(BuildContext context) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
    var loginRoute = MaterialPageRoute(builder: (BuildContext) => Login());

    Navigator.pushReplacement(context, loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(userModel.getCustomerName()),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  //alignment: Alignment.center,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          child: ClipOval(
                              // borderRadius: BorderRadius.circular(8.0),

                              child: _image != null
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                      height: 150,
                                      width: 150,
                                    )
                                  : Image.network(
                                      userModel.getPhotoUrl(),
                                      width: 100,
                                    )),
                        ),
                        Icon(Icons.camera_alt)
                      ],
                    ),
                    onTap: () {
                      // print("Camera");
                      getImage();
                    },
                  ),
                ),
                textField(
                    labelText: "Full name",
                    errorText: "Full name is empty",
                    key: "customername",
                    ctr: nameCtr,
                    icon: Icons.person_rounded),
                textField(
                    labelText: "Email",
                    errorText: "Email is empty",
                    key: "email",
                    ctr: emailCtr,
                    icon: Icons.email),
                textField(
                    labelText: "Business name",
                    errorText: "Business name is empty",
                    key: "warehouse",
                    ctr: businessNameCtr,
                    icon: Icons.people),
                textField(
                    labelText: "Business phone number",
                    errorText: "Business phone number is empty",
                    key: "telephone",
                    ctr: businessPhoneCtr,
                    icon: Icons.phone),
                textField(
                    labelText: "Business Description",
                    errorText: "Business Description is empty",
                    key: "others",
                    ctr: businessDescCtr,
                    maxLine: 4),
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      _loginResponse,
                      style: TextStyle(color: Colors.red),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        child: hasClicked
                            ? Image.asset(
                                "assets/images/preloader.gif",
                                width: 40,
                              )
                            : Text("Save"),
                        color: mainColor,
                        textColor: whiteColor,
                        onPressed: () async {
                          setState(() {});

                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            hasClicked = true;
                            setState(() {});

                            print(_image);
                            if (_image == null) {
                              // "+pageType+"&auth="+user_id+"&mobile=1&"+primaryKey+"="+index"
                              Uri url = Uri.parse(
                                  "http://geohomesgroup.com/admin/process/saveform?pageType=users&mobile=1&user_id=1&");

                              var response = await http.post(
                                url,
                                body: formValues,
                              );
                              print(response.body);
                              var res = jsonDecode(response.body);
                              setState(() {
                                _loginResponse = res["message"];

                                hasClicked = false;
                              });
                            } else {
                              Uri url = Uri.parse(
                                  "http://geohomesgroup.com/admin/process/saveform?pageType=users&mobile=1&user_id=1&");

                              saveUser(_image, url);
                              // setState(() {
                              //   hasClicked = false;
                              // });
                            }

                            /// print()
                            //print(nameCtr.text+" "+businessDescCtr.text);

                            // print(formValues);

                          }
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: Text("LogOut"),
                        onPressed: () {
                          showAlertDialog(context);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        logOut(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text("You are about to LogOut from this app"),
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

  Future saveUser(File imageFile, Uri uri) async {
// ignore: deprecated_member_use
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
//var uri = Uri.parse("http://10.0.2.2/foodsystem/uploadg.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("picture", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    formValues.forEach((key, value) => request.fields[key] = value);

// request.fields['productname'] = nameCtr.text;
// request.fields['productprice'] = emailCtr.text;
// request.fields['producttype'] = businessNameCtr.text;
// request.fields['product_owner'] = businessPhoneCtr.text;

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      print(respStr);
      print("Image Uploaded");
      var res = jsonDecode(respStr);
      setState(() {
        _loginResponse = res["message"];
        hasClicked = false;
      });
    } else {
      print(response);
      var res = jsonDecode(respStr);
      print("Upload Failed");
      setState(() {
        _loginResponse = res["message"];
        hasClicked = false;
      });
    }
  }

  Widget textField({
    String labelText,
    String errorText,
    String key,
    var keyBoardType,
    int maxLine,
    TextEditingController ctr,
    IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: ctr,
        maxLines: maxLine,
        keyboardType: keyBoardType,
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            prefixIcon: Icon(icon),
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
}
