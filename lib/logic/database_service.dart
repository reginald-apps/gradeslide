import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/login/user.dart';

class DatabaseService {
  final _coursesCollection = Firestore.instance.collection('courses');
  final _categoriesCollection = Firestore.instance.collection('categories');
  final _worksCollection = Firestore.instance.collection('works');
  final bool isProUser = true;

  //===========================================COURSE============================================//

  Stream<List<Course>> streamCourses(String userId) async* {
    await Future.delayed(Duration(milliseconds: 700));
    var ref = _coursesCollection.where("userId", isEqualTo: userId);
    yield* ref.snapshots().map((list) => list.documents.map((courseDocument) {
          return Course.fromJson(courseDocument.documentID, courseDocument.data);
        }).toList());
  }

  Future<DocumentSnapshot> getCourse(String courseKey) {
    DocumentReference doc = _coursesCollection.document(courseKey);
    return doc.get();
  }

  Future<String> addCourse(User user) async {
    DocumentReference doc = await _coursesCollection.add({
      'userId': user.uid,
      'sorts': [false, true, true]
    });
    return doc.documentID;
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

  Future<void> deleteCourse(String courseKey) async {
    var ref = _worksCollection.where("courseKey", isEqualTo: courseKey);
    ref.snapshots().map((list) => list.documents.map((categoryDocument) async {
          print('Deleting..');
          await deleteCategory(categoryDocument.documentID);
          return Category.fromJson(categoryDocument.documentID, categoryDocument.data);
        }).toList());
    _coursesCollection.document(courseKey).delete();
  }
  //==========================================CATEGORIES===========================================//

  Stream<List<Category>> streamCategories(String courseKey) async* {
    var ref = _categoriesCollection.where("courseKey", isEqualTo: courseKey);
    yield* ref.snapshots().map((list) => list.documents.map((categoryDocument) {
          return Category.fromJson(categoryDocument.documentID, categoryDocument.data);
        }).toList());
  }

  Future<void> addCategory(String courseKey) async {
    await _categoriesCollection.add({'courseKey': courseKey, 'weight': 0.1});
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

  Future<bool> updateisShowMore(String categoryKey, bool showMore) async {
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

  Future<void> addWork(String categoryKey, String categoryName) async {
    await _worksCollection.add({'categoryKey': categoryKey, "pointsEarned": 10, 'name': categoryName});
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

  Future<bool> deleteWorks(List<Work> works) async {
    for (Work work in works) {
      await deleteWork(work.documentId);
    }
    return true;
  }

  //============================================OTHER=============================================//

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
