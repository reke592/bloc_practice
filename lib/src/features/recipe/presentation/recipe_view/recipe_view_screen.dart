import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/fab_add_cooking_step.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/ingredient_list_view.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/input_servings.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/introduction_recipe.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/step_list_view.dart';
import 'package:flutter/material.dart';

class RecipeViewScreen extends StatelessWidget {
  const RecipeViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: const FABAddCookingStep(),
      body: const Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntroductionRecipe(),
                  Divider(thickness: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ingredients:'),
                      InputServings(),
                    ],
                  ),
                  Divider(thickness: 0),
                  IngredientListView(),
                  Divider(),
                ],
              ),
              StepListView(),
              SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
