import 'package:get/get.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';

class GetCourses extends GetxController {
  var courses = List<Course>().obs;
  final String _userId;

  GetCourses(this._userId);

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  void fetchCourses() async {
    final DatabaseService db = DatabaseService();
    courses.value = await db.streamCourses(_userId).first;
  }
}
