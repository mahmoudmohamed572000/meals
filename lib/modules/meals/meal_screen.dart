import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals/dummy_data.dart';
import 'package:meals/shared/components/components.dart';
import 'package:meals/shared/cubit/cubit.dart';
import 'package:meals/shared/cubit/states.dart';

class MealScreen extends StatelessWidget {
  static const routeName = 'category_meal';

  const MealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealsCubit, MealsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        final mealId = ModalRoute.of(context)!.settings.arguments as String;
        final meal = dummyMeals.firstWhere((meal) => meal.id == mealId);
        var cubit = MealsCubit.get(context);
        return Scaffold(
          appBar: AppBar(title: Text(meal.title)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 300.0,
                  width: double.infinity,
                  child: Hero(
                    tag: mealId,
                    child: InteractiveViewer(
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/photo.png'),
                        image: NetworkImage(meal.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (isLandscape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          buildSectionTitle(context, 'Ingredients'),
                          buildContainer(listSteps(meal, context)),
                        ],
                      ),
                      const SizedBox(width: 20.0),
                      Column(
                        children: [
                          buildSectionTitle(context, 'Steps'),
                          buildContainer(listIngredients(meal)),
                        ],
                      ),
                    ],
                  ),
                if (!isLandscape) buildSectionTitle(context, 'Ingredients'),
                if (!isLandscape) buildContainer(listSteps(meal, context)),
                if (!isLandscape) buildSectionTitle(context, 'Steps'),
                if (!isLandscape) buildContainer(listIngredients(meal)),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              cubit.toggleFavorite(mealId);
            },
            child: Icon(
                cubit.isMealFavorite(mealId) ? Icons.star : Icons.star_border),
          ),
        );
      },
    );
  }

  Widget listSteps(meal, context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Card(
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: Text(
            meal.ingredients[index],
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      itemCount: meal.ingredients.length,
    );
  }

  Widget listIngredients(meal) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('# ${index + 1}'),
            ),
            title: Text(
              meal.steps[index],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          index < meal.steps.length - 1 ? myDivider() : const SizedBox(),
        ],
      ),
      itemCount: meal.steps.length,
    );
  }
}
