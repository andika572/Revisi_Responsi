class MealModel {
  final String strMeal;
  final String strMealThumb;
  final String idMeal;

  MealModel({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
      idMeal: json['idMeal'],
    );
  }
}
