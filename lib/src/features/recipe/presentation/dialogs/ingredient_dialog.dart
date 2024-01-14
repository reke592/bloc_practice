import 'package:ale/src/commons/message_dialog.dart';
import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class IngredientDialogResult {
  IngredientDialogResult({required this.value});
  final Ingredient value;
}

class IngredientDialog extends StatelessWidget {
  const IngredientDialog({super.key, this.value});
  final Ingredient? value;

  @override
  Widget build(BuildContext context) {
    final txtName = TextEditingController(text: value?.name);
    final txtUnit = TextEditingController(text: value?.unit);
    final txtAmount = TextEditingController(text: value?.amount.toString());
    return AlertDialog(
      title: const Text('Edit'),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(txtAmount.text);
            if (amount == null) {
              return MessageDialog.showError(context, 'Invalid amount');
            }
            Navigator.pop(
              context,
              IngredientDialogResult(
                value: IngredientModel(
                  name: txtName.text,
                  amount: double.parse(txtAmount.text),
                  unit: txtUnit.text,
                ),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: txtName,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          Theme.of(context).gm,
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: txtAmount,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
              ),
              Theme.of(context).gm,
              Expanded(
                child: TextField(
                  controller: txtUnit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
