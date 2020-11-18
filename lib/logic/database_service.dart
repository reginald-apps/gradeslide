import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradeslide/login/user.dart';

import 'gsmaths.dart';

class DatabaseService {
  final _coursesCollection = Firestore.instance.collection('courses');
  final _categoriesCollection = Firestore.instance.collection('categories');
  final _worksCollection = Firestore.instance.collection('works');
  //===========================================COURSE============================================//

  Stream<List<Course>> streamCourses(String userId) async* {
    var ref = _coursesCollection.where("userId", isEqualTo: userId);
    yield* ref.snapshots().map((list) => list.documents.map((courseDocument) {
          return Course.fromJson(courseDocument.documentID, courseDocument.data);
        }).toList());
  }

  Future<String> addCourse(User user) async {
    DocumentReference doc = await _coursesCollection.add({
      'userId': user.uid,
      'sorts': [false, true, true]
    });
    return doc.documentID;
  }

  Future<String> addSampleCourse(FirebaseUser user) async {
    DocumentReference courseDocument = await _coursesCollection.add({
      'title': "Chemistry",
      'userId': user.uid,
    });
    String courseKey = courseDocument.documentID;
    await Future.delayed(Duration(milliseconds: 200));
    String examsKey = await addCategory(courseKey, categoryName: "Exams", weight: 0.5);
    addWork(examsKey, "Exam 1", 45, 50);
    addWork(examsKey, "Exam 2", 40, 60);
    await Future.delayed(Duration(milliseconds: 400));
    String quizzesKey = await addCategory(courseKey, categoryName: "Quizzes", weight: 0.2);
    addWork(quizzesKey, "Quiz 1", 10, 10);
    addWork(quizzesKey, "Quiz 2", 5, 10);
    addWork(quizzesKey, "Quiz 3", 9, 10);
    addWork(quizzesKey, "Quiz 4", 10, 10);
    await Future.delayed(Duration(milliseconds: 600));
    String homeworkKey = await addCategory(courseKey, categoryName: "Homework", weight: 0.05);
    addWork(homeworkKey, "Homework 1", 4, 5);
    addWork(homeworkKey, "Homework 2", 0, 5);
    addWork(homeworkKey, "Homework 3", 1, 2);
    addWork(homeworkKey, "Homework 4", 7, 10);
    addWork(homeworkKey, "Homework 5", 10, 10);
    addWork(homeworkKey, "Homework 6", 8, 10);
    String finalKey = await addCategory(courseKey, categoryName: "Final Exam", weight: 0.25);
    addWork(finalKey, "Final Exam", 55, 60);
    return courseDocument.documentID;
  }

  Future<bool> updateCourseSorts(String courseKey, bool isIndicies, bool isAZ, bool isWeights) async {
    await _coursesCollection.document(courseKey).updateData({
      "sorts": [isIndicies, isAZ, isWeights]
    });
    return true;
  }

  Future<List<bool>> getCourseSorts(String courseKey) async {
    List<bool> sorts = [false, false, false];
    var document = await _coursesCollection.document(courseKey).get();
    sorts = [document['sorts'][0], document['sorts'][1], document['sorts'][2]];
    return sorts;
  }

  Future<bool> updateCourseIsShowMore(String courseKey, bool showMore) async {
    await _coursesCollection.document(courseKey).updateData({"isShowMore": showMore});
    return true;
  }

  Future<bool> deleteCourse(String courseKey) async {
    streamCategories(courseKey).forEach((categoriesToDelete) {
      for (Category category in categoriesToDelete) {
        deleteCategory(category.documentId);
      }
    });
    _coursesCollection.document(courseKey).delete();
  }
  //==========================================CATEGORIES===========================================//

  Stream<List<Category>> streamCategories(String courseKey) async* {
    var ref = _categoriesCollection.where("courseKey", isEqualTo: courseKey);
    yield* ref.snapshots().map((list) => list.documents.map((categoryDocument) {
          return Category.fromJson(categoryDocument.documentID, categoryDocument.data);
        }).toList());
  }

  Future<String> addCategory(String courseKey, {String categoryName, double weight}) async {
    DocumentReference doc = await _categoriesCollection.add({'courseKey': courseKey, 'weight': weight, 'name': categoryName, 'isShowMore': true});
    return doc.documentID;
  }

  Future<bool> updateCategorySorts(String categoryKey, bool isIndicies, bool isAZ, bool isWeights) async {
    await _categoriesCollection.document(categoryKey).updateData({
      "sorts": [isIndicies, isAZ, isWeights]
    });
    return true;
  }

  Future<bool> updateCategoryWeight(String categoryKey, double weight) async {
    await _categoriesCollection.document(categoryKey).updateData({"weight": weight});
    return true;
  }

  Future<bool> updateCategoryIsShowMore(String categoryKey, bool showMore) async {
    await _categoriesCollection.document(categoryKey).updateData({"isShowMore": showMore});
    return true;
  }

  void setCategoryIndices(List<Category> categories) {
    int index = 0;
    for (Category category in categories) {
      _categoriesCollection.document(category.documentId).updateData({'index': ++index});
    }
  }

  Future<void> deleteCategory(String categoryKey) async {
    streamWorks(categoryKey).forEach((worksToDelete) {
      for (Work work in worksToDelete) {
        deleteWork(work.documentId);
      }
    });
    await _categoriesCollection.document(categoryKey).delete();
  }

  //============================================WORKS=============================================//
  Stream<List<Work>> streamWorks(String categoryKey) {
    var ref = _worksCollection.where("categoryKey", isEqualTo: categoryKey);
    return ref.snapshots().map((list) => list.documents.map((workDocument) {
          return Work.fromJson(workDocument.documentID, workDocument.data);
        }).toList());
  }

  Future<int> getTotalWorks(String categoryKey) async {
    var numWorks = await _worksCollection.where("categoryKey", isEqualTo: categoryKey).getDocuments();
    return numWorks.documents.length;
  }

  Future<void> addWork(String categoryKey, String name, int pointsEarned, int pointsMax) async {
    await _worksCollection.add({'categoryKey': categoryKey, "pointsEarned": pointsEarned, "pointsMax": pointsMax, 'name': name});
  }

  Future<bool> deleteWork(String workKey) async {
    await _worksCollection.document(workKey).delete();
    return true;
  }

  Future<bool> setWorkIndex(String workKey, int index) async {
    await _worksCollection.document(workKey).updateData({"index": index});
    return true;
  }

  Future<bool> setWorkCompleted(String workKey, bool isCompleted) async {
    await _worksCollection.document(workKey).updateData({"completed": isCompleted});
    return true;
  }

  Future<bool> updateWorkEarned(String workKey, int newPoints) async {
    await _worksCollection.document(workKey).updateData({"pointsEarned": newPoints});
    return true;
  }

  Future<bool> updateWorkMax(String workKey, int newPoints) async {
    await _worksCollection.document(workKey).updateData({"pointsMax": newPoints});
    return true;
  }

  //============================================OTHER=============================================//

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
