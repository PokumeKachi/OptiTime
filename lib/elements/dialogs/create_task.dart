import 'package:flutter/material.dart';
// import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/task.dart';
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

import 'shared/action_row.dart' as ActionRow;
import 'shared/text_field.dart';

class Class extends StatefulWidget {
  const Class({super.key, required this.index});

  final int index;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final List<FieldInfo> controllersInfo;

  void _close() {
    FocusScope.of(context).unfocus();
    context.read<DialogIndexProvider>().value = 0;
  }

  void _createTask([String? _]) {
    final title = controllersInfo[0].controller?.text;
    debugPrint('Creating a new task from the dialog');
    debugPrint('Text: $title');
    context.read<TaskListProvider>().addItem(Task(title: title ?? ''));
    _close();
  }

  @override
  void initState() {
    super.initState();
    final deadlineController = TextEditingController();
    controllersInfo = [
      FieldInfo(label: 'Name'),
      FieldInfo(label: 'Description (optional)'),
      // FieldInfo(
      //   label: 'Deadline',
      //   controller: deadlineController,
      //   readOnly: true,
      //   mouseCursor: SystemMouseCursors.click,
      //
      //   onTap: () async {
      //     final initial = DateTime.tryParse(deadlineController.text);
      //
      //     final pickedDate = await showDatePicker(
      //       context: context,
      //       initialDate: initial,
      //       firstDate: DateTime.now(),
      //       lastDate: DateTime(DateTime.now().year + 100),
      //     );
      //
      //     if (pickedDate != null) {
      //       final pickedTime = await showTimePicker(
      //         context: context,
      //         initialTime: TimeOfDay.now(),
      //         cancelText: 'Whole day',
      //         confirmText: 'Set time',
      //       );
      //       if (pickedTime != null) {
      //         setState(
      //           () => deadlineController.text =
      //               '${pickedDate.toLocal().toString().split(' ')[0]} ${pickedTime.format(context)}',
      //         );
      //       }
      //     }
      //   },
      // ),
    ];
  }

  @override
  void dispose() {
    for (final info in controllersInfo) {
      info.controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dialogIndex = context.watch<DialogIndexProvider>();
    final visible = widget.index == dialogIndex.value;

    // controllersInfo[2].suffixIcon =
    //     (controllersInfo[2].controller?.text.isEmpty ?? true)
    //     ? const Icon(Icons.calendar_today)
    //     : IconButton(
    //         icon: const Icon(Icons.clear),
    //         onPressed: () =>
    //             setState(() => controllersInfo[2].controller?.clear()),
    //       );

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          _createTask();
        }
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New Task',
              style: TextStyle(
                fontSize: Config.FONT_SIZE.BIG,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Config.ITEM_PADDING.MEDIUM),
            for (final info in controllersInfo) ...[
              TextField(
                decoration: InputDecoration(
                  labelText: info.label,
                  border: OutlineInputBorder(),
                  suffixIcon: info.suffixIcon,
                ),
                controller: info.controller,
                readOnly: info.readOnly,
                mouseCursor: info.mouseCursor,
                onSubmitted: _createTask,
                onTap: info.onTap,
              ),

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
}
