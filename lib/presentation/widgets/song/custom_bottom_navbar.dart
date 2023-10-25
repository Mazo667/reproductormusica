import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  onItemTapped(BuildContext context, int index) {
    switch (index){
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
        onTap: (value) => onItemTapped(context,value),
        elevation: 0,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled_rounded),label: 'Reproductor'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_play_sharp),label: 'PlayLists'),
        ]);
  }

}
