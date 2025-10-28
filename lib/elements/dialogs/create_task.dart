import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/task.dart';

import 'shared/action_row.dart' as ActionRow;
import 'shared/autocomplete.dart' as Autocomplete;

class Class extends StatefulWidget {
  final int index;

  const Class({super.key, required this.index});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final _nameController = TextEditingController();
  late TextEditingController _groupController = TextEditingController();

  // bool _groupMatchExists() {
  //   final groupName = _groupController.text.toLowerCase();
  //   final groups = context.read<TaskProvider>().groups;
  //   if (groupName.isEmpty) return groups.isNotEmpty;
  //
  //   print(groupName);
  //   return groups.any((g) => g.name.toLowerCase().contains(groupName));
  // }
  //
  // void _onGroupTextChanged() {
  //   if (_groupMatchExists()) {
  //   print('yuh');
  //     _groupInputAnimationController.forward();
  //   } else {
  //   print('nuh');
  //     _groupInputAnimationController.reverse();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('create task dialog rebuild');

    final colorScheme = Theme.of(context).colorScheme;

    final dialogIndex = context.watch<DialogIndexProvider>();
    final visible = widget.index == dialogIndex.value;
    final taskProvider = context.watch<TaskProvider>();
    final groups = taskProvider.groups;

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final portrait = height > width;

    final formWidgets = [
      TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Config.CORNER.MAX),
          ),
        ),
      ),
      Autocomplete.Class(controller: _groupController),
      // Autocomplete<String>(
      //   key: ValueKey(groups.length),
      //   optionsBuilder: (TextEditingValue textEditingValue) {
      //     if (textEditingValue.text.isEmpty) return groups.map((g) => g.name);
      //     return groups
      //         .map((g) => g.name)
      //         .where(
      //           (name) => name.toLowerCase().contains(
      //             textEditingValue.text.toLowerCase(),
      //           ),
      //         );
      //   },
      //   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
      //     _groupController = controller;
      //
      //     controller
      //       ..removeListener(_onGroupTextChanged)
      //       ..addListener(_onGroupTextChanged);
      //
      //     return AnimatedBuilder(
      //       animation: _inputCornerTween,
      //       builder: (context, child) {
      //         return TextField(
      //           controller: controller,
      //           focusNode: _groupInputFocusNode,
      //           decoration: InputDecoration(
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.vertical(
      //                 top: Radius.circular(Config.CORNER.MAX),
      //                 bottom: Radius.circular(
      //                   _groupInputFocusNode.hasFocus
      //                       ? _inputCornerTween.value
      //                       : Config.CORNER.MAX,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      //   optionsViewBuilder: (context, onSelected, options) {
      //     return FadeTransition(
      //       opacity: _matchFoundCurvedAnimation,
      //       child: ClipRRect(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(Config.CORNER.MIN),
      //           topRight: Radius.circular(Config.CORNER.MIN),
      //           bottomLeft: Radius.circular(Config.CORNER.MAX),
      //           bottomRight: Radius.circular(Config.CORNER.MAX),
      //         ),
      //         child: Material(
      //           color: colorScheme.primary,
      //           elevation: Config.ELEVATION.HIGH,
      //           child: SizedBox(
      //             child: ListView.builder(
      //               shrinkWrap: true,
      //               padding: EdgeInsets.zero,
      //               itemCount: options.length,
      //               itemBuilder: (context, index) {
      //                 final option = options.elementAt(index);
      //                 return ListTile(
      //                   title: Text(
      //                     option,
      //                     style: TextStyle(color: colorScheme.onPrimary),
      //                   ),
      //                   onTap: () => onSelected(option),
      //                 );
      //               },
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    ];

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.enter:
              _createTask();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.escape:
              _close();
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        width: 400,
        padding: Config.MARGIN_PADDING,
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(Config.CORNER.MAX),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // shrink to content
          children: [
            const Text(
              'New Task',
              style: TextStyle(
                fontSize: Config.FONT_SIZE.BIG,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Config.ITEM_PADDING.MEDIUM),

            for (final widget in formWidgets) ...[
              widget,
              const SizedBox(height: Config.ITEM_PADDING.MEDIUM),
            ],

            ActionRow.Class(
              visible: visible,
              buttons: [
                ActionRow.Button(
                  text: 'Cancel',
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: colorScheme.onBackground,
                  ),
                  callback: _close,
                ),
                ActionRow.Button(
                  text: 'Create',
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  callback: _createTask,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();

    // _groupInputAnimationController.dispose();

    super.dispose();
  }

  // late final _groupInputAnimationController = AnimationController(
  //   vsync: this,
  //   duration: Config.ANIMATION.MEDIUM,
  // );
// late final FocusNode _groupInputFocusNode = FocusNode();
//   late final _matchFoundCurvedAnimation = CurvedAnimation(
//     parent: _groupInputAnimationController,
//     curve: Curves.easeInOut,
//   );
//   late final _inputCornerTween =
//       Tween<double>(begin: Config.CORNER.MAX, end: Config.CORNER.MIN).animate(
//         CurvedAnimation(
//           parent: _groupInputAnimationController,
//           curve: Curves.easeInOut,
//         ),
//       );

  @override
  void initState() {
    super.initState();
    // _onGroupTextChanged();
  }

  void _close() {
    FocusScope.of(context).unfocus();
    context.read<DialogIndexProvider>().value = 0;

    _nameController.text = "";
    _groupController.text = "";
  }

  void _createTask([String? _]) {
    final taskProvider = context.read<TaskProvider>();

    final name = _nameController.text;
    final groupName = _groupController.text;
    debugPrint('');
    debugPrint('Creating a new task from the dialog');
    debugPrint('Name: $name');
    debugPrint('Group: $groupName');
    debugPrint('');

    if (name.isEmpty) {
      return;
    }

    final task = Task(name: name ?? '');

    if (groupName.isEmpty) {
      context.read<TaskProvider>().addTask(task);
    } else {
      final group = taskProvider.groups.firstWhere(
        (g) => g.name == groupName,
        orElse: () {
          final group = TaskGroup(name: groupName, tasks: []);
          taskProvider.addGroup(group);
          return group;
        },
      );

      taskProvider.addTaskToGroup(task, group);
    }

    _close();
  }
}
