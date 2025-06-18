import 'package:flutter/cupertino.dart';

class CustomCupertinoNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomCupertinoNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: const Text('Complaint Form'),
      backgroundColor: CupertinoColors.systemBlue.withOpacity(0.1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);
}
