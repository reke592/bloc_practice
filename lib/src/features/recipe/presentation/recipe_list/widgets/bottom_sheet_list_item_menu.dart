import 'package:ale/src/features/recipe/presentation/bloc/recipe_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetListItemMenu extends StatelessWidget {
  const BottomSheetListItemMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        return SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('${state.selected.length} selected'),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    context.read<RecipeListBloc>().add(DeleteSelected());
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('delete'),
                ),
                const VerticalDivider(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('export'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
