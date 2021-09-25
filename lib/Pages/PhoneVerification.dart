import 'dart:async';

import 'package:Geo_home/Pages/Register.dart';
import 'package:Geo_home/Pages/login.dart';
import 'package:Geo_home/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_countdown_timer/countdown.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String msg = "";
  Color color = Colors.white;
  returnMsg() {
    return Text(
      msg,
      style: TextStyle(color: color),
    );
  }

  bool isToResend = false;
  Timer _timer;
  int _start = 90;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;

            if (_start == 0) {
              isToResend = true;
            }
          });
        }
      },
    );
  }

  bool codeSent = false;
  String _phoneNumber;
  String dropdownValue = '+234';
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var codeOne, codeTwo, codeThree, codeFour, codeFive, codeSix;
  FirebaseAuth _firebaseAuth;
  String myverificationId = "";
  String smsCode = "";

  initialization() async {
    _firebaseAuth = await FirebaseAuth.instance;
  }
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _pageController = PageController();

  @override
  void initState() {
    startTimer();
    Firebase.initializeApp();
    initialization();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
       // print("back pressed");
       codeSent = false;
       msg = "";
       setState(() {
         
       });
      },
      child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
              child: Container(
                margin: EdgeInsets.only(top: hieght / 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(appLogo, width: 300),
                    ),
                    codeSent ? CodeVerification() : PhoneNumberVerification()
                  ],
                ),
              ),
            ),
          )),
    );
  }

  PhoneNumberVerification() {
    List<String> spinnerItems = [
      "+93",
      "+355",
      "+213",
      "+1 684",
      "+376",
      "+244",
      "+1 264",
      "+672",
      "+1 268",
      "+54",
      "+374",
      "+297",
      "+61",
      "+43",
      "+994",
      "+1 242",
      "+973",
      "+880",
      "+1 246",
      "+375",
      "+32",
      "+501",
      "+229",
      "+1 441",
      "+975",
      "+591",
      "+387",
      "+267",
      "+55",
      "+246",
      "+1 284",
      "+673",
      "+359",
      "+226",
      "+95",
      "+257",
      "+855",
      "+237",
      "+1",
      "+238",
      "+1 345",
      "+236",
      "+235",
      "+56",
      "+86",
      "+61",
      "+891",
      "+57",
      "+269",
      "+682",
      "+506",
      "+385",
      "+53",
      "+357",
      "+420",
      "+243",
      "+45",
      "+253",
      "+1 767",
      "+1 849",
      "+1 829",
      "+1 809",
      "+593",
      "+20",
      "+503",
      "+240",
      "+291",
      "+372",
      "+251",
      "+500",
      "+298",
      "+679",
      "+358",
      "+33",
      "+689",
      "+241",
      "+220",
      "+970",
      "+995",
      "+49",
      "+233",
      "+350",
      "+30",
      "+299",
      "+1 473",
      "+1 671",
      "+502",
      "+224",
      "+245",
      "+592",
      "+509",
      "+379",
      "+504",
      "+852",
      "+36",
      "+354",
      "+91",
      "+62",
      "+98",
      "+964",
      "+353",
      "+44",
      "+972",
      "+39",
      "+225",
      "+1 876",
      "+81",
      "+44",
      "+962",
      "+7",
      "+254",
      "+686",
      "+381",
      "+965",
      "+996",
      "+856",
      "+371",
      "+961",
      "+266",
      "+231",
      "+218",
      "+423",
      "+370",
      "+352",
      "+853",
      "+389",
      "+261",
      "+265",
      "+60",
      "+960",
      "+223",
      "+356",
      "+692",
      "+222",
      "+230",
      "+262",
      "+52",
      "+691",
      "+373",
      "+377",
      "+976",
      "+382",
      "+1 664",
      "+212",
      "+258",
      "+264",
      "+674",
      "+977",
      "+31",
      "+599",
      "+687",
      "+64",
      "+505",
      "+227",
      "+234",
      "+683",
      "+672",
      "+850",
      "+1 670",
      "+47",
      "+968",
      "+92",
      "+680",
      "+507",
      "+675",
      "+595",
      "+51",
      "+63",
      "+870",
      "+48",
      "+351",
      "+1",
      "+974",
      "+242",
      "+40",
      "+7",
      "+250",
      "+590",
      "+290",
      "+1 869",
      "+1 758",
      "+1 599",
      "+508",
      "+1 784",
      "+685",
      "+378",
      "+239",
      "+966",
      "+221",
      "+381",
      "+248",
      "+232",
      "+65",
      "+421",
      "+386",
      "+677",
      "+252",
      "+27",
      "+82",
      "+34",
      "+94",
      "+249",
      "+597",
      "+268",
      "+46",
      "+41",
      "+963",
      "+886",
      "+992",
      "+255",
      "+66",
      "+670",
      "+228",
      "+690",
      "+676",
      "+1 868",
      "+216",
      "+90",
      "+993",
      "+1 649",
      "+688",
      "+256",
      "+380",
      "+971",
      "+44",
      "+1",
      "+598",
      "+1 340",
      "+998",
      "+678",
      "+58",
      "+84",
      "+681",
      "+970",
      "+967",
      "+260",
      "+263"
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey1,
          child: Container(
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width - 50,
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  children: [
                    ////////////////////////DROP DOWN///////////////

                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(
                                8) //                 <--- border radius here
                            ),
                      ),
                      child: Column(children: <Widget>[
                        DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                          underline: Container(),
                          onChanged: (String data) {
                            setState(() {
                              dropdownValue = data;
                              // print(data);
                              //  print(dropdownValue);
                            });
                          },
                          items: spinnerItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                " " + value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),

                        // Text(dropdownValue,
                        // style: TextStyle
                        //     (fontSize: 22,
                        //     color: Colors.black)),
                      ]),
                    ),

                    /////////////////////END OF DROPWOEN
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          labelText: "Phone number",
                        ),
                        validator: (value) {
                          if (value.trim().length < 8) {
                            return "Invalid number";
                          }
                        },
                        onSaved: (value) {
                          _phoneNumber = value;
                        },
                      ),
                    ),

//////////////////////////////////END OF INPUT////////////////////////
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                        child: MaterialButton(
                            height: 50,
                            shape: StadiumBorder(),
                            textColor: whiteColor,
                            color: mainColor,
                            child: Text("Continue"),
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
                            style: TextStyle(
                                color: mainColor, fontWeight: FontWeight.bold),
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
          ),
        )
      ],
    );
  }

  validate() {
    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();
      print(dropdownValue + _phoneNumber);
      setState(() {
        codeSent = true;
      });
      verifyNumber(dropdownValue + _phoneNumber);
      /////////////////////TO DO CODE SENDING/////
      //_firebaseAuth.

    }
  }

  validate2(String pin) async {
    if (_formKey2.currentState.validate()) {
      _formKey2.currentState.save();

      //var smsCode = codeOne+codeTwo+codeThree+codeFour+codeFive+codeSix;
      print(pin);
      print(myverificationId);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: myverificationId, smsCode: pin);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((error) {
        setState(() {
          color = Colors.redAccent;
          msg = "Incorrect Code";
        });
      });

      if (userCredential.user != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext) => Register(phonNumber: _phoneNumber)));
      } else {}
      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Register()));

      /////////////////////TO DO CODE GENERATION/////
    }
  }

  CodeVerification() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey2,
          child: Container(
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width - 50,
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "Enter the 6 digit code sent to your phone number",
                  style: TextStyle(color: mainColor),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ///////////////CODE 1//////////
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: animatingBorders(),
                      // child: TextFormField(
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 30),
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.zero,
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(12)),
                      //   ),
                      //   validator: (value) {
                      //     if (value.trim().isEmpty || value.trim().length > 6) {
                      //       return "Invalid code";
                      //     }
                      //   },
                      //   onSaved: (value) {
                      //     codeOne = value;
                      //   },
                      // ),
                    ),
                  ),
                ]),

                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [

                //         ///////////////CODE 1//////////
                //         Expanded(
                //           child: TextFormField(

                //       keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.all(0),
                //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

                //   ),
                //   validator: (value){
                //     if(value.trim().isEmpty){
                //       return "Empty";
                //     }

                //   },
                //   onSaved: (value){
                //     codeOne = value;
                //   },
                // ),
                //           ),
                //           SizedBox(width:3),

                //              ///////////////CODE 2//////////
                //         Expanded(
                //           child: TextFormField(
                //       keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //      contentPadding: EdgeInsets.all(0),
                //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

                //   ),
                //    validator: (value){
                //     if(value.trim().isEmpty){
                //       return "Empty";
                //     }

                //   },
                //   onSaved: (value){
                //     codeTwo = value;
                //   },
                // ),

                //           ),
                //            SizedBox(width:3),

                //              ///////////////CODE 3//////////
                //         Expanded(
                //           child: TextFormField(

                //       keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //      contentPadding: EdgeInsets.all(0),
                //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

                //   ),
                //   validator: (value){
                //     if(value.trim().isEmpty){
                //       return "Empty";
                //     }

                //   },
                //   onSaved: (value){
                //     codeThree = value;
                //   },
                // ),
                //           ),
                //            SizedBox(width:3),

                //              ///////////////CODE 5//////////
                //         Expanded(
                //           child: TextFormField(
                //       keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //      contentPadding: EdgeInsets.all(0),
                //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

                //   ),
                //   validator: (value){
                //     if(value.trim().isEmpty){
                //       return "Empty";
                //     }

                //   },
                //   onSaved: (value){
                //     codeFour = value;
                //   },
                // ),
                //           ),
                //           SizedBox(width:3),
                //           ////////////////////////CODE 5/////

                //            Expanded(
                //           child: TextFormField(
                //       keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //      contentPadding: EdgeInsets.all(0),
                //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

                //   ),
                //   validator: (value){
                //     if(value.trim().isEmpty){
                //       return "Empty";
                //     }

                //   },
                //   onSaved: (value){
                //     codeFive = value;
                //   },
                // ),
                //           ),
                //           SizedBox(width:3),

                //           /////////////////////////CODE6/////////////
                //            Expanded(
                //           child: TextFormField(
                //       keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //      contentPadding: EdgeInsets.all(0),
                //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

                //   ),
                //   validator: (value){
                //     if(value.trim().isEmpty){
                //       return "Empty";
                //     }

                //   },
                //   onSaved: (value){
                //     codeSix = value;
                //   },
                // ),
                //           ),

                //     ],),
                SizedBox(height: 15),
                returnMsg(),
                SizedBox(height: 15),

                isToResend
                    ? RaisedButton(
                      color: mainColor,
                        elevation: 5.0,
                        child: Text("Resend Code",style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          verifyNumber(dropdownValue + _phoneNumber);
                          startTimer();
                          setState(() {
                            msg = "";
                            _start = 90;
                            isToResend = false;
                          });
                        },
                      )
                    : Column(
                        children: [
                          SizedBox(height: 20),
                          Text("Resend in $_start seconds"),
                        ],
                      ),

                SizedBox(height: 30),

                // Row(
                //   children: [
                //     Expanded(
                //         child: MaterialButton(
                //             height: 50,
                //             shape: StadiumBorder(),
                //             textColor: whiteColor,
                //             color: mainColor,
                //             child: Text("Verify"),
                //             onPressed: () {
                //               validate2();
                //             }))
                //   ],
                // ),
                // SizedBox(height: 30),

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
                            style: TextStyle(
                                color: mainColor, fontWeight: FontWeight.bold),
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
          ),
        )
      ],
    );
  }

   Widget animatingBorders() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
    return PinPut(
      fieldsCount: 6,
      eachFieldHeight: 40.0,
      eachFieldWidth: 29,
      withCursor: true,
    onSubmit: (String pin) {
      codeOne = pin;
      print(pin);
      validate2(pin);
      setState(() {
        
      });
    },
    onChanged: (String pin){
      if(pin.length < 6){
        setState(() {
          msg = "";
        });
      }

    },
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(20.0),
      ),
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Colors.deepPurpleAccent.withOpacity(.5),
        ),
      ),
    );
  }

  Future<void> verifyNumber(String phone) async {
    //final PhoneVerificationCompleted  verified = (AuthCredentials authResult)
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => Register(phonNumber: phone)));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          setState(() {
            color = Colors.redAccent;
            msg = "The provided phone number is not valid.";
          });
        } else {
          setState(() {
            color = Colors.redAccent;
            msg = "Verification failed you may have requested code many times.";
          });
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        setState(() {
          color = mainColor;
          msg = "Code Sent Succesfuly";
        });
        // print("Sent "+ verificationId);
        // print(resendToken);

        // Update the UI - wait for the user to enter the SMS code
        // String smsCode = 'xxxx';
        setState(() {
          myverificationId = verificationId;
        });

        // Create a PhoneAuthCredential with the code

        // Sign the user in (or link) with the credential
        //await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }
}
