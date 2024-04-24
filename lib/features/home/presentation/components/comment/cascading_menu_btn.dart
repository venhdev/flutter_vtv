import 'package:flutter/material.dart';

enum MenuEntry {
  deleteComment('Xóa bình luận');

  const MenuEntry(this.label);
  final String label;
}

class CascadingMenuBtn extends StatefulWidget {
  const CascadingMenuBtn({
    super.key,
    required this.activate,
  });

  final void Function(MenuEntry selection) activate;

  @override
  State<CascadingMenuBtn> createState() => _CascadingMenuBtnState();
}

class _CascadingMenuBtnState extends State<CascadingMenuBtn> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      style: MenuStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
      ),
      menuChildren: <Widget>[
        MenuItemButton(
          style: MenuItemButton.styleFrom(
            backgroundColor: Colors.red.shade200,
          ),
          // onPressed: () => _activate(MenuEntry.deleteComment),
          onPressed: () => widget.activate(MenuEntry.deleteComment),
          child: Text(MenuEntry.deleteComment.label),
        ),
      ],
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  }
}
