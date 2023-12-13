import 'package:flutter/material.dart';


class AppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  const AppBarComponent(
      {super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 200,
      width: MediaQuery.of(context).size.width,
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Row(
        children: <Widget>[
          Expanded(child: Text("Diary")
          ),
        ],
      ),
    );
  }
}
