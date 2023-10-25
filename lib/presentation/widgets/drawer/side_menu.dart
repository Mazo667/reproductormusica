import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int navDrawerIndex = 0;
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    return NavigationDrawer(
        children: [Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch ? 0 : 10,16, 10),
          child: const Text('Opciones Secundarias'),
        ),
    ]
    );
  }
}
