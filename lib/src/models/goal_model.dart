import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

/// Priority levels for goals
enum GoalPriority {
  low,
  medium,
  high,
  critical,
}

/// Status of a goal
enum GoalStatus {
  notStarted,
  inProgress,
  completed,
  onHold,
  cancelled,
}

/// Recurrence patterns for goals
enum GoalRecurrence {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  none,
}

/// Goal model for LifeManager
@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String title,
    required double plannedHoursPerDay,
    @Default(GoalPriority.medium) GoalPriority priority,
    @Default(GoalRecurrence.none) GoalRecurrence recurrence,
    @Default('#2196F3') String color, // Default blue color
    @Default(GoalStatus.notStarted) GoalStatus status,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? targetDate,
    @Default(0.0) double progress, // 0.0 to 1.0
    @Default(false) bool isArchived,
    @Default(0) int totalTimeSpent, // in minutes
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  /// Create Goal from Firestore DocumentSnapshot
  factory Goal.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Document data is null');
      }

      // Convert Firestore Timestamp to DateTime
      final Map<String, dynamic> processedData = Map.from(data);
      
      if (data['createdAt'] is Timestamp) {
        processedData['createdAt'] = (data['createdAt'] as Timestamp).toDate();
      }
      
      if (data['updatedAt'] is Timestamp) {
        processedData['updatedAt'] = (data['updatedAt'] as Timestamp).toDate();
      }
      
      if (data['targetDate'] is Timestamp) {
        processedData['targetDate'] = (data['targetDate'] as Timestamp).toDate();
      }

      return Goal.fromJson({
        ...processedData,
        'id': doc.id,
      });
    } catch (e) {
      throw Exception('Failed to parse Goal from Firestore: $e');
    }
  }

  /// Convert Goal to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Remove ID as it's handled by Firestore
    
    // Convert DateTime to Timestamp for Firestore
    if (json['createdAt'] != null) {
      json['createdAt'] = Timestamp.fromDate(DateTime.parse(json['createdAt']));
    }
    if (json['updatedAt'] != null) {
      json['updatedAt'] = Timestamp.fromDate(DateTime.parse(json['updatedAt']));
    }
    if (json['targetDate'] != null) {
      json['targetDate'] = Timestamp.fromDate(DateTime.parse(json['targetDate']));
    }
    
    return json;
  }
}