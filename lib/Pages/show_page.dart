// ignore_for_file: prefer_const_constructors, unused_import, missing_required_param, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_second/Pages/home_page.dart';
import 'package:project_second/Pages/tour_request_page.dart';
import 'package:project_second/helper/ShowSnackBar.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleProperty extends StatefulWidget {
  final Map<String, dynamic> data;

  const SingleProperty({Key? key, this.data = const {}}) : super(key: key);

  @override
  State<SingleProperty> createState() => _CCState();
}

GlobalKey<ScaffoldState> ss = GlobalKey();
final rentController = TextEditingController();
final nameController = TextEditingController();
final mailController = TextEditingController();
final numberController = TextEditingController();

class _CCState extends State<SingleProperty> {
  void launchWhatsapp({@required number, @required message}) async {
    String whatsAppURL = "whatsapp://send?+2001211406202";
    launchUrl(Uri.parse(whatsAppURL));
  }

  launchPhoneDialer(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ss,
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromRGBO(118, 165, 209, 1),
          // Adjust the size as needed
        ),
        //  backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment:MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                '${widget.data['image']}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  CollectionReference collRef =
                      FirebaseFirestore.instance.collection('favourites');
                  await collRef.add({
                    "id": FirebaseAuth.instance.currentUser!.uid,
                    'image': '${widget.data['image']}',
                    'propertyType': '${widget.data['propertyType']}',
                    'latitude': '${widget.data['latitude']}',
                    'longitude': '${widget.data['latitude']}',
                    'address': '${widget.data['propertyAdress']}',
                    'oldphoneNumber': '${widget.data['phoneNumber']}',
                    'propertyDetails': '${widget.data['propertyDetails']}',
                    'propertyPrice': '${widget.data['propertyPrice']}',
                    'propertyRentDuration':
                        '${widget.data['propertyRentDuration']}',
                    'propertyStatus': '${widget.data['propertyStatus']}',
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Data Added Successfuly'),
                    ),
                  );
                } catch (e) {
                  print('Error adding data to Firestore: $e');
                }
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 40, top: 16),
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "A ${widget.data['propertyType']} for ${widget.data['propertyStatus']} in ${widget.data['propertyAdress']} with an area  \n of 300 square meters consisting of : \n ${widget.data['propertyDetails']} \n the ${widget.data['propertyStatus']} price is: ${widget.data['propertyPrice']} \$ \n is empty for ${widget.data['propertyRentDuration']} Months ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: '${widget.data['propertyAdress']}',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 15,
                    ),
                    onPrimary: Colors.black,
                    side: BorderSide(width: 0, color: Colors.white),
                    backgroundColor: Color.fromRGBO(118, 165, 209, 1),
                  ),
                  onPressed: () {
                    ss.currentState!.showBottomSheet(
                      (context) => SizedBox(
                        height: 600,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                "Make Offer",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: .1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Color(0xffEEF1F6),
                                      ),
                                      height: 40,
                                      width: 125,
                                      child: Center(
                                        child: Text(
                                          " -5%",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: .1,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xffEEF1F6),
                                    ),
                                    height: 40,
                                    width: 125,
                                    child: Center(
                                      child: Text(
                                        "-10%",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: .1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Color(0xffEEF1F6),
                                      ),
                                      height: 40,
                                      width: 125,
                                      child: Center(
                                        child: Text(
                                          " -15%",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your rent",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            /////////////////////////////

                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: rentController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your Name",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your Email",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: mailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your number",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: numberController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        CollectionReference collRef =
                                            FirebaseFirestore.instance
                                                .collection('offers');
                                        await collRef.add({
                                          "id": FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'rent': rentController.text,
                                          'name': nameController.text,
                                          'mail': mailController.text,
                                          'new phoneNumber':
                                              numberController.text,
                                          'image': '${widget.data['image']}',
                                          'propertyType':
                                              '${widget.data['propertyType']}',
                                          'latitude':
                                              '${widget.data['latitude']}',
                                          'longitude':
                                              '${widget.data['latitude']}',
                                          'address':
                                              '${widget.data['propertyAdress']}',
                                          'oldphoneNumber':
                                              '${widget.data['phoneNumber']}',
                                          'propertyDetails':
                                              '${widget.data['propertyDetails']}',
                                          'propertyPrice':
                                              '${widget.data['propertyPrice']}',
                                          'propertyRentDuration':
                                              '${widget.data['propertyRentDuration']}',
                                          'propertyStatus':
                                              '${widget.data['propertyStatus']}',
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content:
                                                Text('Data Added Successfuly'),
                                          ),
                                        );
                                      } catch (e) {
                                        print(
                                            'Error adding data to Firestore: $e');
                                      }
                                    },
                                    child: Text(
                                      "make offer",
                                      style: TextStyle(fontSize: 20),
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.local_offer_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    "Make Offer ",
                  ),
                ),
                OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 15,
                    ),
                    onPrimary: Colors.black,
                    side: BorderSide(width: 0, color: Colors.white),
                    backgroundColor: Color.fromRGBO(118, 165, 209, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TourRequestPage(),
                        ));
                  },
                  icon: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    " Tour Request ",
                  ),
                ),
              ],
            ),
            SizedBox(height: 19),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    launchWhatsapp();
                  },
                  child: Image.asset(
                    'Assets/whatsapp.jpg',
                    height: 70,
                    width: 70,
                  ),
                ),
                InkWell(
                  onTap: () {
                    launchPhoneDialer("+201211406202");
                  },
                  child: Image.asset(
                    'Assets/44.jpg',
                    height: 50,
                    width: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //   ),
      // ),
    );
  }
}

void ShowSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.green, // Set the background color here
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
