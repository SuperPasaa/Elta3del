import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_second/Pages/favourite_page.dart';
import 'package:project_second/Pages/show_page.dart';

class ShowResdential extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ShowResdential> {
  List<Map<String, dynamic>> comm = [];
  int currentIndex = 0; // Add a default value

  getData() async {
    try {
      setState(() {
        isloading = true;
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("favourites")
          .get();

      setState(() {
        comm = querySnapshot.docs.map((doc) {
          Map<String, dynamic> propertyData =
              doc.data() as Map<String, dynamic>;

          String image = propertyData['image'] ?? '';
          String propertyStatus = propertyData['propertyStatus'] ?? '';
          String propertyPrice = propertyData['propertyPrice'] ?? '';

          return {
            'image': image,
            'propertyStatus': propertyStatus,
            'propertyPrice': propertyPrice,
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  bool isloading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  // Dummy _changeItem method, replace it with your logic
  void _changeItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 20.0, left: 8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Color.fromRGBO(118, 165, 209, 1),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      icon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: comm.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SingleProperty(data: comm[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Image.network(
                                    '${comm[index]['image']}',
                                    height: 225,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(
                                          '${comm[index]['propertyStatus']} ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(
                                            '${comm[index]['propertyPrice']} \$',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Spacer(
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(
      label: 'Favourite',
      icon: Icon(Icons.favorite_outline_rounded),
      activeIcon: Icon(Icons.favorite),
    ),
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
  ],
  currentIndex: currentIndex,
  selectedItemColor: Color.fromRGBO(118, 165, 209, 1),
  unselectedItemColor: Color.fromRGBO(65, 73, 106, 1),
  onTap: (index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      
      Navigator.push(context, MaterialPageRoute(builder: (context) =>Favorites() ,));
    } else if (index == 1) {
      
    }
  },
),

    );
  }
}
