import 'dart:async';
import 'dart:convert';

import 'package:Geo_home/Pages/HomePage.dart';
import 'package:Geo_home/Pages/MainPage.dart';
import 'package:Geo_home/Pages/login.dart';
import 'package:flutter/material.dart';
import 'Pages/UserModel.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var oo = "";
 
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoHomes',
      theme: ThemeData(
        primaryColor: Colors.green,
      
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs  =  SharedPreferences.getInstance();

  inititializer()async{
    SharedPreferences sharedPreferences = await _prefs;
    
    

    var _email = sharedPreferences.getString("email");
    var _password = sharedPreferences.getString("password");
    print( _email);
    print( _password);
   // print(sharedPreferences.getString("userDetails"));
   
    if(_email != null && _password != null){
      //////////////DOING THE AUTOMATIC LOGIN////////
      
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
  
   
 var res =   jsonDecode(response.body);
 print(res);
  if(res["status"]== 1){
   setState(() {
      //hasClicked = false;
      sharedPreferences.setString("userDetails", response.body);
      sharedPreferences.setString("password", _password);
      sharedPreferences.setString("email", _email);

      userModel.setEmail(_email);
      userModel.setUserId(res['cid']);
      userModel.setPhotoUrl(res['picture']);
      userModel.setPassword(_password);
      userModel.setCustomerName(res['customername']);
       userModel.setPhone(res['telephone']);


      Navigator.of(context).push(MaterialPageRoute(builder: (BuilderContext)=>MainPage()));

   });
     }else{
       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>Login()));

    }

    }else{
       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>Login()));

    }
    }else{
       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>Login()));

    }
    
    }


// getUser() async {
//    SharedPreferences preference = await SharedPreferences.getInstance();
//   return preference.getString("email");
// }
    @override
  void initState() {
 
    Timer(Duration(seconds: 2),(){
      
      inititializer();

     // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>Login()));
     

      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    
    return Scaffold(
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
  //           margin: EdgeInsets.symmetric(horizontal:20),
  // decoration: BoxDecoration(
  //   gradient: LinearGradient(
  //     begin: Alignment.centerLeft,
  //     end: Alignment.centerRight,
  //     colors: [Colors.purple, Colors.blue]),
      
  // ),
  child:  Image.asset(appLogo, width: width-2),
)

         

      ],));
  }
}
