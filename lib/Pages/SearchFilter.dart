import 'package:Geo_home/Pages/SearchDisplay.dart';
import 'package:Geo_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class SearchFilter extends StatefulWidget {
  String keyword;
  SearchFilter({this.keyword});

  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  double _lowerValue = 500000;
  double _upperValue = 16000000;
  var state = "All"; //listOfStates[0];

  var sort = "Latest";
  var sortValue = "l2h";

  var listOfSorts = ["High To Low", "Low To High", "Latest", "Popular"];
  var listOfSortsValues = ["h2l", "l2h", "lat", "pop"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            child: Icon(
              Icons.arrow_back,
              color: mainColor,
            ),
            onTap: () {
              Navigator.of(context).pop(context);
            },
          ),
          elevation: 6.0,
          title: Text(
            "Filter results",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
          actions: [
            InkWell(
              child: Container(
                margin: EdgeInsets.only(top: 15, right: 15),
                child: Text(
                  "Clear",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        /////////////////////////////////////////////////////////////////////////////////
                        Expanded(
                          child: Container(
                            //padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5) //                 <--- border radius here
                                  ),
                            ),

                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(" Region"),
                              value: state,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.red, fontSize: 18),
                              underline: Container(),
                              onChanged: (String data) {
                                setState(() {
                                  state = data;
                                  // print(data);
                                  //  print(dropdownValue);
                                });
                              },
                              items: listOfStates.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      alignment: Alignment.centerLeft,
                      child: FlutterSlider(
                        // rangeSlider: true,

                        key: Key('3343'),
                        values: [_lowerValue, _upperValue],
                        rangeSlider: true,
                        tooltip: FlutterSliderTooltip(
                            alwaysShowTooltip: true,
                            rightPrefix: Text(
                              "₦",
                              style: TextStyle(color: Colors.grey),
                            ),
                            leftPrefix: Text(
                              "₦",
                              style: TextStyle(color: Colors.grey),
                            )),

                        max: 16000000,
                        min: 500000,
                        step: FlutterSliderStep(step: 2000),
                        jump: true,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _lowerValue = lowerValue;
                          _upperValue = upperValue;
                          //  print(lowerValue);
                          setState(() {});
                        },
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 80,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 29,
                            margin: EdgeInsets.only(top: 23),
                            height: 50,
                            //padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5) //                 <--- border radius here
                                  ),
                            ),

                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(" Sort by"),
                              value: sort,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.red, fontSize: 18),
                              underline: Container(),
                              onChanged: (String data) {
                                setState(() {
                                  sort = data;
                                  sortValue = listOfSortsValues[
                                      listOfSorts.indexOf(sort)];

                                  //print(listOfSorts.indexOf(data));
                                  //  print(dropdownValue);
                                });
                              },
                              items: listOfSorts.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 40,
                          child: Container(
                              color: Colors.white, child: Text('Sort by')),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: mainColor,
                        textColor: Colors.white,
                        child: Text("Filter"),
                        onPressed: () {
                          var range = _lowerValue.toString() +
                              "+-+" +
                              _upperValue.toString();

                          var keyword;
                          if (widget.keyword == null) {
                            keyword = "";
                          } else {
                            keyword = widget.keyword;
                          }
                          var stateValue;
                          if (state == "All") {
                            stateValue = null;
                          } else {
                            stateValue =
                                state.toLowerCase().replaceAll(" ", "-");
                          }

                          // print(stateValue +
                          //     " " +
                          //     sortValue +
                          //     " " +
                          //     range +
                          //     " " +
                          //     keyword);

                          Route route = MaterialPageRoute(
                              builder: (context) => SearchDisplay(
                                    keyword: keyword,
                                    state: stateValue,
                                    lowRange: _lowerValue.toString(),
                                    highRange: _upperValue.toString(),
                                    sort: sortValue,
                                  ));
                          Navigator.pushReplacement(context, route);

                          //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext()));
                        },
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ));
  }

  var listOfStates = [
    "All",
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "Abuja",
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
    "Zamfara"
  ];
}
// Container(
//   margin: EdgeInsets.only(top: 23),
//   child: Row(
//     children: [
//       /////////////////////////////////////////////////////////////////////////////////
//       Expanded(
//         child: Container(
//           //padding: const EdgeInsets.all(3.0),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.all(Radius.circular(
//                     5) //                 <--- border radius here
//                 ),
//           ),

//           child: DropdownButton<String>(
//             isExpanded: true,
//             hint: Text(" Sort by"),
//             value: sort,
//             icon: Icon(Icons.arrow_drop_down),
//             iconSize: 24,
//             elevation: 16,
//             style:
//                 TextStyle(color: Colors.red, fontSize: 18),
//             underline: Container(),
//             onChanged: (String data) {
//               setState(() {
//                 sort = data;
//                 sortValue = listOfSortsValues[
//                     listOfSorts.indexOf(sort)];

//                 print(listOfSorts.indexOf(data));
//                 //  print(dropdownValue);
//               });
//             },
//             items: listOfSorts
//                 .map<DropdownMenuItem<String>>(
//                     (String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(
//                   " " + value,
//                   style: TextStyle(color: Colors.black),
//                 ),
//               );
//             }).toList(),
//           ),

//           // Text(dropdownValue,
//           // style: TextStyle
//           //     (fontSize: 22,
//           //     color: Colors.black)),
//         ),
//       ),
//     ],
//   ),
// ),
