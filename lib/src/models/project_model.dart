import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

/// Priority levels for projects
enum ProjectPriority {
  low,
  medium,
  high,
  critical,
}

/// Status of a project
enum ProjectStatus {
  notStarted,
  inProgress,
  onHold,
  completed,
  cancelled,
}

/// Recurrence patterns for projects
enum ProjectRecurrence {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  none,
}

/// Project model for LifeManager
@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String title,
    required double plannedHoursPerDay,
    @Default(ProjectPriority.medium) ProjectPriority priority,
    @Default(ProjectRecurrence.none) ProjectRecurrence recurrence,
    @Default('#4CAF50') String color, // Default green color
    @Default(ProjectStatus.notStarted) ProjectStatus status,
    String? goalId, // Nullable to support projects without immediate goal link
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? targetDate,
    @Default(0.0) double progress, // 0.0 to 1.0
    @Default(false) bool isArchived,
    @Default(0) int totalTimeSpent, // in minutes
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  /// Create Project from Firestore DocumentSnapshot
  factory Project.fromFirestore(DocumentSnapshot doc) {
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
      
      if (data['startDate'] is Timestamp) {
        processedData['startDate'] = (data['startDate'] as Timestamp).toDate();
      }
      
      if (data['targetDate'] is Timestamp) {
        processedData['targetDate'] = (data['targetDate'] as Timestamp).toDate();
      }

      return Project.fromJson({
        ...processedData,
        'id': doc.id,
      });
    } catch (e) {
      throw Exception('Failed to parse Project from Firestore: $e');
    }
  }

  /// Convert Project to Firestore-compatible map
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
    if (json['startDate'] != null) {
      json['startDate'] = Timestamp.fromDate(DateTime.parse(json['startDate']));
    }
    if (json['targetDate'] != null) {
      json['targetDate'] = Timestamp.fromDate(DateTime.parse(json['targetDate']));
    }
    
    return json;
  }
}