import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:ale/src/core/injection_container.dart';
import 'package:ale/src/ui/behaviors/app_scroll_behavior.dart';
import 'package:ale/src/ui/observers/app_bloc_observer.dart';
import 'package:ale/src/router.dart';
import 'package:ale/src/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  initStandardUsecases();
  runApp(MyApp(
    router: AppRouter(initialLocation: '/recipe'),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter router;
  const MyApp({
    super.key,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider<FoodRecipeRepository>(
          create: (context) => inject<FoodRecipeRepository>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Ale',
        theme: AppTheme().theme,
        routerConfig: router.config,
        scrollBehavior: AppScrollBehavior(),
      ),
    );
  }
}
