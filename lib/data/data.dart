import 'package:glance_at/model/categories_model.dart';

List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [];
  CategoriesModel categorieModel = new CategoriesModel();

  categorieModel.imgUrl =
      "https://images.pexels.com/photos/6100565/pexels-photo-6100565.jpeg?cs=srgb&dl=pexels-john-lee-6100565.jpg&fm=jpg";
  categorieModel.categoriesName = "Street Art";
  categories.add(categorieModel);
  categorieModel = new CategoriesModel();

  categorieModel.imgUrl =
      "https://images.pexels.com/photos/6100565/pexels-photo-6100565.jpeg?cs=srgb&dl=pexels-john-lee-6100565.jpg&fm=jpg";
  categorieModel.categoriesName = "Street Art";
  categories.add(categorieModel);
  categorieModel = new CategoriesModel();

  return categories;
}
