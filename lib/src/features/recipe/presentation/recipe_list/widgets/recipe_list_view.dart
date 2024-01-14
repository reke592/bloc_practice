import 'package:ale/src/features/recipe/presentation/bloc/recipe_list_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:ale/src/features/recipe/presentation/recipe_list/widgets/bottom_sheet_list_item_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecipeListView extends StatefulWidget {
  const RecipeListView({super.key});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  PersistentBottomSheetController<void>? bottomSheet;

  @override
  void dispose() {
    bottomSheet?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeListBloc, RecipeListState>(
      listener: (context, state) {
        if (state.isSuccess) {
          final scaffold = context.findAncestorStateOfType<ScaffoldState>();
          if (state.selected.isNotEmpty) {
            if (bottomSheet == null) {
              setState(() {
                bottomSheet = scaffold?.showBottomSheet(
                  (context) => const BottomSheetListItemMenu(),
                );
                bottomSheet?.closed.then((value) {
                  final bloc = context.read<RecipeListBloc>();
                  if (bloc.state.selected.isNotEmpty) {
                    bloc.add(ClearSelected());
                  }
                });
              });
            }
          } else {
            bottomSheet?.close();
            bottomSheet = null;
          }
        }
      },
      buildWhen: (_, current) =>
          current.action is NewRecipe ||
          current.action is DeleteSelected ||
          current.action is LoadFoodRecipes ||
          current.action is SelectItem ||
          current.action is ClearSelected ||
          current.action is ReplaceExistingItem,
      builder: (context, state) {
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            final isSelected = state.selected.contains(state.data[index]);
            return ListTile(
              dense: true,
              selected: isSelected,
              selectedTileColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.25),
              title: Text(
                state.data[index].name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                state.data[index].description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: isSelected
                  ? null
                  : () {
                      context.pushNamed(
                        'view Recipe',
                        extra: SetRecipeViewModel(state.data[index]),
                      );
                    },
              onLongPress: () {
                context.read<RecipeListBloc>().add(
                      SelectItem(
                        value: state.data[index],
                        isSelected: !isSelected,
                      ),
                    );
              },
            );
          },
        );
      },
    );
  }
}
