import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi/detail_page.dart';
import 'models/meal_model.dart';

class MealsPage extends StatefulWidget {
  final String category;

  const MealsPage({Key? key, required this.category}) : super(key: key);

  @override
  State<MealsPage> createState() => _HalamanCategoryState();
}

class _HalamanCategoryState extends State<MealsPage> {
  late Future<List<MealModel>> _meals;

  @override
  void initState() {
    super.initState();
    _meals = fetchMeals();
  }

  Future<List<MealModel>> fetchMeals() async {
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?c="
        "${widget.category}"
    ));
    if (response.statusCode == 200) {
      List<MealModel> meals = (json.decode(response.body)['meals'] as List)
          .map((data) => MealModel.fromJson(data))
          .toList();
      return meals;
    } else {
      throw Exception('Load Meals Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.category} Meals"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.075),
        child: FutureBuilder<List<MealModel>>(
          future: _meals,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No meals found.'),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.65,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  MealModel meal = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => DetailPage(id: meal.idMeal)));
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(meal.strMealThumb),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  meal.strMeal,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
