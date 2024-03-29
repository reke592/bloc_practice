import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class RecipeDescriptionDialogResult {
  const RecipeDescriptionDialogResult({
    required this.name,
    required this.description,
    required this.servings,
  });
  final String name;
  final String description;
  final int servings;
}

class RecipeDescriptionDialog extends StatelessWidget {
  const RecipeDescriptionDialog({
    super.key,
    this.data,
  });
  final FoodRecipe? data;

  @override
  Widget build(BuildContext context) {
    final txtName = TextEditingController(
      text: data?.name ?? 'Untitled Recipe',
    );
    final txtDescription = TextEditingController(text: data?.description);
    final txtServings = TextEditingController(
      text: (data?.serving ?? 1).toString(),
    );
    return AlertDialog(
      title: const Text('Recipe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(labelText: 'Recipe name'),
            ),
            Theme.of(context).gm,
            TextField(
              keyboardType: TextInputType.number,
              controller: txtServings,
              decoration: const InputDecoration(labelText: 'Servings'),
            ),
            Theme.of(context).gm,
            TextField(
              controller: txtDescription,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            RecipeDescriptionDialogResult(
              name: txtName.text,
              description: txtDescription.text,
              servings: int.parse(txtServings.text),
            ),
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
