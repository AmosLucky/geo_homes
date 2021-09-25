import 'dart:async';
import 'dart:convert';

import 'package:Geo_home/Pages/HomePage.dart';
import 'package:Geo_home/Pages/MainPage.dart';
import 'package:Geo_home/Pages/PhoneVerification.dart';
import 'package:Geo_home/Pages/Register.dart';
import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bottom_loader/bottom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UserModel.dart';
import 'Login.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  
 // UserModel userModel = UserModel();
   BottomLoader bl;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   String url = "https://geohomesgroup.com/admin/process/login";


   ///////////////////////SHAREDPREFRENCE
   ///
   SharedPreferences sharedPreferences;

  // inititializer()async{
  //   sharedPreferences = await SharedPreferences.getInstance();
  // }
/////////////////////////


  //////////////HIDE AND SHOW PASSWORD//////////
  
  bool isHidden = true;
  passwordSwitch(){
    if(isHidden){
      setState(() {
        isHidden = false;
      });
    }else{
      setState(() {
        isHidden = true;
      });
    }

  }
//////////////////END/////////////////////
login(email,password) async {
  String url = "https://geohomesgroup.com/admin/process/login";

  var response =  await http.post(url,body: {
    "email": email,
    "password": _password


  });

  
  if (response.statusCode == 200) {
   
  return  jsonDecode(response.body);
  }else{
    _loginResponse = "Please check your network connection";
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
@override
  void initState() {
    //inititializer();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
     var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: (){
        print("back pressed");
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Do you want to Close this App",
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton(
                color: mainColor,
                textColor: Colors.white,
                child: Text("Close App"),
                onPressed: () {
                  SystemNavigator.pop();
                },
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
        ));
      },
      child: Scaffold(
        key: _scaffoldKey,
        body:SingleChildScrollView(
          child: Container(
            child:  Container(
              margin: EdgeInsets.only(top:hieght / 5),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    child: Image.asset(appLogo,width:300),
             ),
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(_loginResponse,style: TextStyle(color: Colors.redAccent),),
                      hasClicked ? Image.asset("assets/images/preloader.gif",height:50):Container(),
                  
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.only(top:50),
                        width: MediaQuery.of(context).size.width-50,
                        alignment: Alignment.center,
                        child: Column(children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

                     // SizedBox(height:20),

                      //  TextFormField(
                      //     obscureText: isHidden? true : false,
                      //   decoration: InputDecoration(
                      //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      //     labelText: "Password",
                      //     prefixIcon: InkWell(
                      //                   onTap: (){
                      //                     passwordSwitch();
                      //                   },
                      //                   child: Icon(
                      //                     isHidden? Icons.remove_red_eye : Icons.visibility_off,
                      //                       ),
                      //                 ),
                      //   ),
                      //   onSaved: (value){
                      //     _password = value;
                      //   },
                      //   validator: (value){
                      //     if(value.isEmpty){
                      //       return "Password is empty";
                      //     }

                      //   },
                      // ),
                    

                     

                      SizedBox(height:30),

                   Row(children: [
                       Expanded(
                         child: MaterialButton(
                           height: 50,
                           shape: StadiumBorder(),
                        textColor: whiteColor,
                        color: mainColor,
                        child: Text("Recover"),
                        onPressed: () async {
                         // print(await sharedPreferences.getString("email"));
                         Fluttertoast.showToast(msg: "Failed To Send");
                         
                         // validate();
                        }
                        ))
                   ],),
                      SizedBox(height:30),

                   Row(children: [
                       Expanded(child:  FlatButton(
                         child: Row(
                          
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                           Text("Don't have an account "),
                           Text("Register",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),),

                         ],),
                         onPressed: (){
                           Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>PhoneVerification()));
                         },
                         ))
                   ],),
                     //SizedBox(height:),

                   Row(children: [
                       Expanded(child:  FlatButton(
                         child: Row(
                          
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                           //Text("Forget Password "),
                           Text("Login",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),),

                         ],),
                         onPressed: (){
                           Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Login()));
                         },
                         ))
                   ],)


                        ],),

                      ),
                    )

          ],
          ),
                ],
              ),
            ),
          ),
        )
        
      ),
    );
  }
  validate() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
     // print(_email+_password);
      setState(() {
        hasClicked = true;
         clearPreloader();
          });

     String url = "https://geohomesgroup.com/admin/process/controllers";
   

  var response =  await http.post(url,body: {
    "email": _email,
    "password": _password,
    "case": '1.6',
    "pageType": 'login',
    "formName": 'loginMembers'
    


  });

  
  if (response.statusCode == 200) {
    sharedPreferences = await SharedPreferences.getInstance();

   // sharedPreferences.setString("email", "");
  
   
 var res =   jsonDecode(response.body);
 print(res);
  if(res["status"]== 1){
     await sharedPreferences.setString("userDetails",response.body);
      await sharedPreferences.setString("password", _password);
      await sharedPreferences.setString("email", _email);
      userModel.setEmail(_email);
      userModel.setUserId(res['cid']);
      userModel.setPhotoUrl(res['picture']);
      userModel.setPassword(_password);
      userModel.setCustomerName(res['customername']);
      
      userModel.setPhone(res['telephone']);
      

   setState(()  {
      hasClicked = false;
     
      

      Navigator.of(context).push(MaterialPageRoute(builder: (BuilderContext)=>MainPage()));

   });
     }else{
       setState(() {
         _loginResponse = res["message"];
         hasClicked = false;
       });
     }
  }else{
    
    setState(() {
      
      _loginResponse = "Please check your network connection";
      hasClicked = false;
    });
  }
  

   
    

      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>HomePage()));
    }
  }
}