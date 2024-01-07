import 'package:ale/src/commons/constants.dart';
import 'package:ale/src/commons/message_dialog.dart';
import 'package:ale/src/features/recipe/presentation/recipe_list/widgets/fab_create_recipe.dart';
import 'package:ale/src/features/recipe/presentation/recipe_list/widgets/recipe_list_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ale'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              MessageDialog.confirm(
                context,
                message: 'You are about to open an external URL:'
                    '\n$kRepoUrl'
                    '\n\nWould you like to continue?',
              ).then((value) {
                if (value == true) {
                  launchUrlString(kRepoUrl);
                }
              });
            },
            icon: const FaIcon(FontAwesomeIcons.github),
            label: const Text('Repository'),
          ),
        ],
      ),
      floatingActionButton: const FABCreateRecipe(),
      body: const Column(
        children: [
          Expanded(child: RecipeListView()),
        ],
      ),
    );
  }
}
