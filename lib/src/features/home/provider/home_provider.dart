import 'package:dasturnomi/src/features/home/repository/home_repository.dart';
import 'package:material_ui/material_ui.dart';

enum HomeStatus { loading, success, error }

class HomeProvider extends ChangeNotifier {
  HomeStatus status = HomeStatus.loading;
  List data = [];
  String deletingID = "";
  Future<void> getLaptops() async {
    try {
      final result = await HomeRepository.GetSamsa();
      status = HomeStatus.success;
      data = result;
      notifyListeners();
    } catch (e) {
      status = HomeStatus.error;
      notifyListeners();
    }
  }

  Future<void> qoshish(
    String gpu,
    String image,
    String brand,
    String model,
  ) async {
    isLoading.value = true;
    try {
      isLoading.value = false;
      getLaptops();
    } catch (e) {
      isLoading.value = false;
      print('Error keldi');
    }
  }

  Future<void> ochirish(String id) async {
    deletingID = id;
    isDeleting.value = true;
    try {
      await HomeRepository.SamsaDelete(id);
      isDeleting.value = false;
      getLaptops();
    } catch (e) {
      print('Error on deleting $e');
      isDeleting.value = false;
    }
  }
}

ValueNotifier<bool> isLoading = ValueNotifier(false);
ValueNotifier<bool> isDeleting = ValueNotifier(false);
