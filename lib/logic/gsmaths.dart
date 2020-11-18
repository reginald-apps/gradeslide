import 'package:gradeslide/logic/course_data.dart';

class GradeSlideMaths {
  static double getWeightBarStartOffset(List<Category> categoriesInCourse, Category categoryStart) {
    double weightsTillStart = 0;
    for (Category category in categoriesInCourse) {
      if (category == categoryStart) {
        break;
      }
      weightsTillStart += category.weight;
    }
    return (weightsTillStart * 100).roundToDouble() / 100;
  }

  static double getWeightRemaining(List<Category> categoriesInCourse, Category categoryStart, double weight) {
    double totalWeights = 0;
    for (Category category in categoriesInCourse) {
      if (category == categoryStart) {
        totalWeights += weight;
      } else {
        totalWeights += category.weight;
      }
    }
    return 1 - totalWeights;
  }

  static double getCourseCompletedGrade(List<double> categoryGrades) {
    double courseGrade = 0;
    for (double categoryGrade in categoryGrades) {
      courseGrade += categoryGrade;
    }
    return courseGrade;
  }

  static double getWorth(List<Work> works, Work work) {
    double totalWorth = 0;
    for (Work work in works) {
      totalWorth += work.pointsMax;
    }

    return work.pointsMax / totalWorth;
  }

  static double balanceWeights(List<Category> categoriesInCourse, Category changingCategory, double weight) {
    double totalWeight = 0;
    for (Category category in categoriesInCourse) {
      if (category == changingCategory) {
        totalWeight += weight;
      } else
        totalWeight += category.weight;
    }
    if (totalWeight > 1.0) {
      return ((weight + (1.0 - totalWeight)) * 100).round() / 100;
    }
    return weight;
  }

  static double getCourseTargetGrade(List<double> categoryTargets) {
    double courseTarget = 0;
    for (double categoryGrade in categoryTargets) {
      courseTarget += categoryGrade;
    }
    return courseTarget;
  }

  static double getCourseMaximumGrade(List<double> categoryMaximums) {
    double courseMaximum = 0;
    for (double categoryGrade in categoryMaximums) {
      courseMaximum += categoryGrade;
    }
    return courseMaximum;
  }

  static double getCategoryCompletedGrade(List<Work> works, bool courseBar) {
    bool allIncomplete = true;
    if (works.isEmpty) {
      return 0.0;
    }
    int totalPointsEarned = 0;
    int totalPointsMax = 0;
    for (Work work in works) {
      if (work.completed) {
        allIncomplete = false;
        totalPointsEarned += work.pointsEarned;
        totalPointsMax += work.pointsMax;
      }
    }
    if (allIncomplete && courseBar) {
      return 1.0;
    }
    if (totalPointsMax == 0) {
      return 0.0;
    }

    return (totalPointsEarned / totalPointsMax);
  }

  static double getCategoryTargetGrade(List<Work> works) {
    if (works.isEmpty) {
      return 0.0;
    }
    int totalPointsEarned = 0;
    int totalPointsMax = 0;
    for (Work work in works) {
      totalPointsEarned += work.pointsEarned;
      totalPointsMax += work.pointsMax;
    }
    if (totalPointsMax == 0) {
      return 0.0;
    }
    return (totalPointsEarned / totalPointsMax);
  }

  static double getCategoryMaximumTargetGrade(List<Work> works) {
    if (works.isEmpty) {
      return 1.0;
    }
    int totalPointsEarned = 0;
    int totalPointsMax = 0;
    for (Work work in works) {
      if (work.completed) {
        totalPointsEarned += work.pointsEarned;
        totalPointsMax += work.pointsMax;
      } else {
        totalPointsEarned += work.pointsMax;
        totalPointsMax += work.pointsMax;
      }
    }
    if (totalPointsMax == 0) {
      return 0.0;
    }
    return (totalPointsEarned / totalPointsMax);
  }

  static double getCategoryMaximumTargetGradePerWork(Work work) {
    int totalPointsEarned = 0;
    int totalPointsMax = 0;
    if (work.completed) {
      totalPointsEarned += work.pointsEarned;
      totalPointsMax += work.pointsMax;
    } else {
      totalPointsEarned += work.pointsMax;
      totalPointsMax += work.pointsMax;
    }
    if (totalPointsMax == 0) {
      return 0.0;
    }
    return (totalPointsEarned / totalPointsMax);
  }
}
