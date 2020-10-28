import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/all.dart';

import 'package:klearn/model/app_state.dart';

class SideDrawer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final child = useProvider(currentChild);
    final selectedSideMenu = useProvider(sideMenuSelection);
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Kids Learning - ${child.name}'),
          ),
          ListTile(
            selected: selectedSideMenu.state == 1,
            title: new Text('Dashboard'),
            onTap: () {
              selectedSideMenu.state = 1;
              Get.offAndToNamed('/');
            },
          ),
          ListTile(
            selected: selectedSideMenu.state == 2,
            title: new Text('Arithmetics'),
            onTap: () {
              selectedSideMenu.state = 2;
              Get.offAndToNamed('/arithmetics')
                  .then((value) => selectedSideMenu.state = 1);
            },
          ),
        ],
      ),
    );
  }
}
