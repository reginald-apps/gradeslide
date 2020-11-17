// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Semester _$SemesterFromJson(String documentId, Map<String, dynamic> json) {
  return Semester(
    documentId: documentId,
    startDate: json['startDate'] as Timestamp,
    courseList: (json['courseList'] as List)?.map((e) => e == null ? null : Course.fromJson(documentId, e as Map<String, dynamic>))?.toList(),
  );
}

Map<String, dynamic> _$SemesterToJson(Semester instance) => <String, dynamic>{
      'startDate': instance.startDate,
      'courseList': instance.courseList,
    };

Course _$CourseFromJson(String documentId, Map<String, dynamic> json) {
  return Course(
    documentId: documentId,
    prefix: json['prefix'] as String ?? "N/A",
    id: json['id'] as int ?? 101,
    index: json['index'] as int ?? -1,
    title: json['title'] as String ?? "UNTITLED COURSE",
    credits: json['credits'] as int ?? 3,
    totalPoints: json['totalPoints'] as int ?? 1000,
    isShowMore: json['isShowMore'] as bool ?? false,
    sorts: (json['sorts'] as List)
        ?.map((e) => e == null
            ? false
            : e.toString().contains("false")
                ? false
                : true)
        ?.toList(),
    categoryList: (json['categoryList'] as List)?.map((category) => category == null ? null : Category.fromJson(documentId, category as Map<String, dynamic>))?.toList(),
    scale: (json['scale'] as List)?.map((e) => (e as num)?.toDouble())?.toList() ?? GSConstants.defaultScale,
  );
}

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'prefix': instance.prefix,
      'id': instance.id,
      'totalPoints': instance.totalPoints,
      'title': instance.title,
      'credits': instance.credits,
      'sorts': instance.sorts,
      'categoryList': instance.categoryList,
      'scale': instance.scale,
    };

Category _$CategoryFromJson(String documentId, Map<String, dynamic> json) {
  return Category(
    documentId: documentId,
    index: json['index'] as int ?? -1,
    name: json['name'] as String ?? "UNTITLED",
    weight: json['weight'] as double ?? 0.1,
    isShowingMore: json['isShowMore'] as bool ?? false,
    sorts: (json['sorts'] as List)
        ?.map((e) => e == null
            ? false
            : e.toString().contains("false")
                ? false
                : true)
        ?.toList(),
    grades: (json['grades'] as List)?.map((e) => e == null ? null : Work.fromJson(documentId, e as Map<String, dynamic>))?.toList(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'name': instance.name,
      'index': instance.index,
      'weight': instance.weight,
      'sorts': instance.sorts,
      'grades': instance.grades,
    };

Work _$WorkFromJson(String documentId, Map<String, dynamic> json) {
  return Work(
      documentId: documentId,
      index: json['index'] as int ?? 0,
      name: json['name'] as String ?? "UNTITLED",
      pointsMax: json['pointsMax'] as int ?? 10,
      pointsEarned: json['pointsEarned'] as int ?? 10,
      completed: json['completed'] as bool ?? false,
      duedate: json['duedate'] as Timestamp ?? Timestamp.now());
}

Map<String, dynamic> _$WorkToJson(Work instance) => <String, dynamic>{
      'name': instance.name,
      'index': instance.index,
      'pointsMax': instance.pointsMax,
      'pointsEarned': instance.pointsEarned,
      'completed': instance.completed,
    };
