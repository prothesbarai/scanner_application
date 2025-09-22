import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String appBarTitle;
  const CustomAppbar({super.key,required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(appBarTitle,),);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
