import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saveme/screens/add_post_from_doctor/add_post_from_doctor.dart';
import 'package:saveme/screens/maps/maps_nearby_places_screen.dart';
import 'package:saveme/screens/maps/maps_shortest_path.dart';
import 'package:saveme/widgets/mywidgets.dart';

import 'provider/permissions_provider.dart';

class DrawePage extends StatelessWidget {
  const DrawePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PermissionsProvider permissionsProvider =
        Provider.of<PermissionsProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              width: 100.0,
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage("assets/icon/icon.png"), fit: BoxFit.contain),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.radio_button_on,
              color: Colors.red,
            ),
            title: Text(
              'طلب الإسعاف',
            ),
            onTap: () {
              // go to the shortest path
              Navigator.pushNamed(context, MapsPageShortestPath.id);
            },
          ),
          Visibility(
            visible: permissionsProvider.showAddDoctor,
            child: ListTile(
              leading: Icon(
                Icons.add_box,
                color: Colors.red,
              ),
              title: Text(
                'إضافة عيادة طبيب',
              ),
              onTap: () {
                // to add post from doctors
                Navigator.pushNamed(context, AddPostsFromDoctor.id);
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.archive_rounded,
              color: Colors.red,
            ),
            title: Text('الوصول إلى أقرب مشفى'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapsNearByPlacesScreen(
                            placetoSearch: "hospital",
                            typetoSearch: "hospital",
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.emergency, color: Colors.red),
            title: Text('الوصول إلى أقرب عيادة طبيب'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapsNearByPlacesScreen(
                            placetoSearch: "doctor",
                            typetoSearch: "doctor",
                          )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.local_pharmacy,
              color: Colors.red,
            ),
            title: Text('الوصول إلى أقرب صيدلية'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapsNearByPlacesScreen(
                            placetoSearch: "pharmacy",
                            typetoSearch: "pharmacy",
                          )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Colors.red,
            ),
            title: Text('حول'),
            onTap: () {
              //   Navigator.pushNamed(context, Voluntaries.id);
              MyWidgets mywidget = new MyWidgets();
              mywidget.displaySnackMessage('الهلال الأحمر العربي السوري', context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text('خروج'),
            onTap: () {
              // exit out of the program
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
