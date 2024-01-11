import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputServings extends StatefulWidget {
  const InputServings({super.key});

  @override
  State<InputServings> createState() => _InputServingsState();
}

class _InputServingsState extends State<InputServings> {
  late final TextEditingController controller;
  late String _hint;

  @override
  void initState() {
    final bloc = context.read<RecipeViewBloc>();
    _hint = bloc.state.data.serving.toString();
    controller = TextEditingController(
      text: bloc.state.adjustedServing?.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: calculation of ingridient price
    return BlocConsumer<RecipeViewBloc, RecipeViewState>(
      listenWhen: (_, current) =>
          current.action is SetRecipeViewModel ||
          current.action is ChangeRecipeDetails,
      listener: (context, state) {
        if (state.isSuccess) {
          setState(() {
            _hint = state.data.serving.toString();
          });
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Servings',
              hintText: _hint,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            textAlign: TextAlign.center,
            onChanged: (value) {
              context
                  .read<RecipeViewBloc>()
                  .add(AdjustServing(int.tryParse(value)));
            },
          ),
        );
      },
    );
  }
}
