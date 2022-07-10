import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saveme/widgets/mywidgets.dart';

class DrawePage extends StatelessWidget {
  const DrawePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              width: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/logo/logo.jpeg"), fit: BoxFit.contain),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('إضافة منشور'),
            onTap: () {
              //Navigator.pushNamed(context, AddPost.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.app_registration),
            title: Text('التسجيل على معونة'),
            onTap: () {
              //  Navigator.pushNamed(context, HelperKits.id);
            },
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
              //  Navigator.pushNamed(context, EmergencyPage.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.archive_rounded),
            title: Text('باب التطوع'),
            onTap: () {
              //   Navigator.pushNamed(context, Voluntaries.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('حول'),
            onTap: () {
              //   Navigator.pushNamed(context, Voluntaries.id);
              MyWidgets mywidget = new MyWidgets();
              mywidget.displaySnackMessage('الهلال الأحمر العربي السوري', context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
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
