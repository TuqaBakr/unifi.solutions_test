import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/local_keys.dart';
import '../data/data_sources/local.dart';
import '../helpers/dimensions_helper.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, this.onProfileFirst, this.onAvailabilityTap, this.onManagePostsTap,});
  final VoidCallback? onProfileFirst;
  final VoidCallback? onAvailabilityTap;
  final VoidCallback? onManagePostsTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/provider-logo_without_background.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
         // SizedBox(height: 10,),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile', ),
            onTap: (){
              context.push('/auth/profile');
            },
          ),



         // SizedBox(height: 60),
          Divider(height:DimensionsHelper.heightPercentage(context, 5),),
          ListTile(
            leading: Icon(Icons.logout_sharp),
            title: Text('Log Out'),
            onTap: () async{
              debugPrint('Profile icon pressed! Initiating Logout...');
              await LocalStorage.delete(LocalKeys.token);
              debugPrint('Local storage cleared successfully.');
              debugPrint('Navigated to Login Screen.');
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}