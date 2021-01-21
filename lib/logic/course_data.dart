import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradeslide/logic/gsconstants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course_data.g.dart';

@JsonSerializable()
class Semester {
  String documentId;
  Timestamp startDate;
  List<Course> courseList;

  Semester({this.documentId, this.startDate, this.courseList});

  factory Semester.fromJson(String documentId, Map<String, dynamic> json) => _$SemesterFromJson(documentId, json);

  Map<String, dynamic> toJson() => _$SemesterToJson(this);
}

class Course {
  String documentId;
  String prefix;
  int id;
  int index;
  int totalPoints;
  String title;
  double current;
  double goal;
  double max;
  bool isShowMore;
  int credits;
  List<bool> sorts;
  List<Category> categoryList; //TODO
  List<double> scale; //TODO

  Course(
      {this.documentId = "",
      this.prefix = "",
      this.id,
      this.index,
      this.title = "",
      this.credits = 3,
      this.current = 0,
      this.goal = 0,
      this.max = 0,
      this.totalPoints = 1000,
      this.sorts,
      this.categoryList,
      this.scale,
      this.isShowMore});

  factory Course.fromJson(String documentId, Map<String, dynamic> json) => _$CourseFromJson(documentId, json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

@JsonSerializable()
class Category {
  String documentId;
  int points;
  int index;
  String name;
  double weight;
  bool isShowingMore;
  List<bool> sorts;
  List<Work> grades; //TODO

  Category({this.documentId, this.index, this.name, this.weight, this.points, this.sorts, this.grades, this.isShowingMore});

  factory Category.fromJson(String documentId, Map<String, dynamic> json) => _$CategoryFromJson(documentId, json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "$name";
  }
}

@JsonSerializable()
class Work {
  String documentId;
  String name;
  int pointsMax;
  int pointsEarned;
  bool completed;
  int index;
  Timestamp duedate;

  Work({this.documentId, this.index, this.name, this.pointsMax, this.pointsEarned, this.completed, this.duedate});

  factory Work.fromJson(String documentId, Map<String, dynamic> json) => _$WorkFromJson(documentId, json);

  Map<String, dynamic> toJson() => _$WorkToJson(this);

  @override
  String toString() {
    return ("($completed").toString();
  }
}
