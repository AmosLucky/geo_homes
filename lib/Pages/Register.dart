import 'dart:async';
import 'dart:convert';

import 'package:Geo_home/Pages/HomePage.dart';
import 'package:Geo_home/Pages/login.dart';
import 'package:Geo_home/constants.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'MainPage.dart';
import 'UserModel.dart';


class Register extends StatefulWidget {
  String phonNumber;
  Register({this.phonNumber});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  SharedPreferences sharedPreferences;
  BottomLoader bl;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phoneNumber;
  String _confirmPassword;
  String _name;
  String _email;
  String _contactAddress;
  String _password;

  /////////////HIDE AND SHOW PASSWORD//////////

  bool isHidden = true;
  passwordSwitch() {
    if (isHidden) {
      setState(() {
        isHidden = false;
      });
    } else {
      setState(() {
        isHidden = true;
      });
    }
  }

//////////////////END/////////////////////
///////////////////////////CANCEl LOADER
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
    
  }
  //////////////////////////////
  @override
  Widget build(BuildContext context) {
     var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Container(
          margin: EdgeInsets.only(top: hieght/10),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  "assets/images/logo.jpg",
                  width:200,
                ),
              ),

             
                  
                     Text(_loginResponse,style: TextStyle(color: Colors.redAccent),),
                      hasClicked ? Image.asset("assets/images/preloader.gif",height:50):Container(),
              
              
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: hieght/120),
                      width: MediaQuery.of(context).size.width - 50,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Name",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Name is Empty";
                              }
                            },
                            onSaved: (value) {
                              _name = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              bool validEmail = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                              if (value.length < 3 || !validEmail) {
                                return "Invalid email";
                              }
                            },
                            onSaved: (value) {
                              _email = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                        
                            maxLines: 3,
                          
                            decoration: InputDecoration(
                          
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Contact Address",
                              prefixIcon: Icon(Icons.home),
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Address is empty";
                              }
                            },
                            onSaved: (value) {
                              _contactAddress = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            obscureText: isHidden ? true : false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Password",
                              prefixIcon: InkWell(
                                onTap: () {
                                  passwordSwitch();
                                },
                                child: Icon(
                                  isHidden
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.trim().length < 6) {
                                return "Password must be greater than 6 charachers";
                              }
                            },
                            
                            onSaved: (value) {
                              _phoneNumber = value;
                            },
                            onChanged: (value){
                              _password = value;

                            },
                          ),


                    ////   Confirm   //////////////////////////
                     SizedBox(height: 20),
                          TextFormField(
                            obscureText: isHidden ? true : false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Confirm Password",
                              prefixIcon: InkWell(
                                onTap: () {
                                  passwordSwitch();
                                },
                                child: Icon(
                                  isHidden
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != _password) {
                                return "Password does not match Confirm password";
                              }
                            },
                            onSaved: (value) {
                              _phoneNumber = value;
                            },
                          ),
                    ///
                    ///
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                  child: MaterialButton(
                                      height: 50,
                                      shape: StadiumBorder(),
                                      textColor: whiteColor,
                                      color: mainColor,
                                      child: Text("Register"),
                                      onPressed: () {
                                       
                                        validate();
                                      }))
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                  child: FlatButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already have an account "),
                                    Text(
                                      "Login",
                                      style: TextStyle(color: mainColor),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext) => Login()));
                                },
                              ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
  validate() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
     print(_name+_email+_contactAddress+_password);

      setState(() {
        hasClicked = true;
       clearPreloader();
      });

     String url = "https://geohomesgroup.com/admin/process/controllers";
    var response =  await http.post(url,body: {
      "telephone": widget.phonNumber,
    "email": _email,
    "password": _password,
    "address":_contactAddress,
    "customerName": _name,
    "case": "1.7",
    "formName": 'loginMembers'


  });

  
  if (response.statusCode == 200) {
      sharedPreferences = await SharedPreferences.getInstance();
   
 var res =   jsonDecode(response.body);
 print(res);
  if(res["status"]== 1){
    await sharedPreferences.setString("userDetails",response.body);
      await sharedPreferences.setString("password", _password);

     userModel.setEmail(_email);
      userModel.setUserId(res['cid']);
      userModel.setPhotoUrl(res['picture']);
      userModel.setPassword(_password);
      userModel.setCustomerName(res['customername']);
      
   setState(() {
      hasClicked = false;
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>MainPage()));

   });
     }else{
       setState(() {
         _loginResponse = res["message"];
         hasClicked = false;
       });
     }
  }else{
    print("pppppp");
    
    setState(() {
      
      _loginResponse = "Please check your network connection";
      hasClicked = false;
    });
  }
     ///Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>HomePage()));


    }
  }
}
