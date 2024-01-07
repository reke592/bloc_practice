import 'package:ale/src/commons/message_dialog.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/edit_cooking_step/widgets/button_add_ingredient.dart';
import 'package:ale/src/features/recipe/presentation/edit_cooking_step/widgets/button_delete_step.dart';
import 'package:ale/src/features/recipe/presentation/edit_cooking_step/widgets/button_save_step.dart';
import 'package:ale/src/features/recipe/presentation/edit_cooking_step/widgets/ingredient_list_view.dart';
import 'package:ale/src/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCookingStepScreen extends StatefulWidget {
  const EditCookingStepScreen({super.key});

  @override
  State<EditCookingStepScreen> createState() => _EditCookingStepScreenState();
}

class _EditCookingStepScreenState extends State<EditCookingStepScreen> {
  late final EditCookingStepBloc bloc;
  late final TextEditingController txtInstruction;
  late final TextEditingController txtHours;
  late final TextEditingController txtMinutes;
  late final TextEditingController txtSeconds;

  @override
  void initState() {
    bloc = context.read<EditCookingStepBloc>();
    final [hours, minutes, seconds] = bloc.state.data.duration
        .toString()
        .split('.')[0]
        .split(':')
        .map(int.parse)
        .toList();
    txtHours = TextEditingController(text: hours.toString());
    txtMinutes = TextEditingController(text: minutes.toString());
    txtSeconds = TextEditingController(text: seconds.toString());
    txtInstruction = TextEditingController(text: bloc.state.data.instructions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditCookingStepBloc, EditCookingStepState>(
      listenWhen: (_, current) =>
          current.action is SaveChanges || current.action is DeleteStep,
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
        } else if (state.isFailure) {
          MessageDialog.showError(context, state.error!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Step'),
          actions: [
            const ButtonDeleteStep(),
            Theme.of(context).gm,
            const ButtonSaveStep(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtHours,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Hours',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        final number = int.tryParse(value);
                        if (number != null) {
                          context
                              .read<EditCookingStepBloc>()
                              .add(ChangeDuration(hours: number));
                        }
                      },
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: TextField(
                      controller: txtMinutes,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        final number = int.tryParse(value);
                        if (number != null) {
                          context
                              .read<EditCookingStepBloc>()
                              .add(ChangeDuration(minutes: number));
                        }
                      },
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: TextField(
                      controller: txtSeconds,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Seconds',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        final number = int.tryParse(value);
                        if (number != null) {
                          context
                              .read<EditCookingStepBloc>()
                              .add(ChangeDuration(seconds: number));
                        }
                      },
                    ),
                  ),
                ],
              ),
              Theme.of(context).gm,
              TextField(
                controller: txtInstruction,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Instruction',
                  hintText: 'enter step details...',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onChanged: (value) {
                  context
                      .read<EditCookingStepBloc>()
                      .add(ChangeInstruction(value));
                },
              ),
              const ButtonAddIngredient(),
              const Expanded(child: IngredientListView()),
            ],
          ),
        ),
      ),
    );
  }
}
