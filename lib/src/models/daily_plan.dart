import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'daily_plan.freezed.dart';
part 'daily_plan.g.dart';

/// Daily plan model for LifeManager
@freezed
class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    required String id, // Document ID (yyyy-mm-dd format)
    required DateTime date,
    @Default(0) int plannedMinutes,
    @Default(0) int availableMinutes,
    @Default(0) int overflowMinutes,
    @Default(0.0) double realisticnessScore,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, int>? goalPlannedMinutes, // goalId -> planned minutes
    Map<String, int>? projectPlannedMinutes, // projectId -> planned minutes
  }) = _DailyPlan;

  factory DailyPlan.fromJson(Map<String, dynamic> json) => _$DailyPlanFromJson(json);

  /// Create DailyPlan from Firestore DocumentSnapshot
  factory DailyPlan.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Document data is null');
      }

      // Convert Firestore Timestamp to DateTime
      final Map<String, dynamic> processedData = Map.from(data);
      
      if (data['date'] is Timestamp) {
        processedData['date'] = (data['date'] as Timestamp).toDate();
      }
      
      if (data['createdAt'] is Timestamp) {
        processedData['createdAt'] = (data['createdAt'] as Timestamp).toDate();
      }
      
      if (data['updatedAt'] is Timestamp) {
        processedData['updatedAt'] = (data['updatedAt'] as Timestamp).toDate();
      }

      return DailyPlan.fromJson({
        ...processedData,
        'id': doc.id,
      });
    } catch (e) {
      throw Exception('Failed to parse DailyPlan from Firestore: $e');
    }
  }

  /// Convert DailyPlan to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Remove ID as it's handled by Firestore
    
    // Convert DateTime to Timestamp for Firestore
    if (json['date'] != null) {
      json['date'] = Timestamp.fromDate(DateTime.parse(json['date']));
    }
    if (json['createdAt'] != null) {
      json['createdAt'] = Timestamp.fromDate(DateTime.parse(json['createdAt']));
    }
    if (json['updatedAt'] != null) {
      json['updatedAt'] = Timestamp.fromDate(DateTime.parse(json['updatedAt']));
    }
    
    return json;
  }
}