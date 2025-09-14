import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'fixed_commitment.freezed.dart';
part 'fixed_commitment.g.dart';

/// Days of the week for fixed commitments
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Type of fixed commitment
enum CommitmentType {
  sleep,
  family,
  work,
  commute,
  exercise,
  meals,
  personal,
  other,
}

/// Fixed commitment model for LifeManager
@freezed
class FixedCommitment with _$FixedCommitment {
  const factory FixedCommitment({
    required String id,
    required String name,
    required String title, // Display title for the commitment
    required DateTime startTime, // Time of day (use DateTime for consistency)
    required DateTime endTime,   // Time of day (use DateTime for consistency)
    required List<DayOfWeek> daysOfWeek, // Which days this commitment applies
    @Default(CommitmentType.other) CommitmentType type,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(true) bool isActive,
    @Default('#9E9E9E') String color, // Default gray color
  }) = _FixedCommitment;

  factory FixedCommitment.fromJson(Map<String, dynamic> json) => _$FixedCommitmentFromJson(json);

  /// Create FixedCommitment from Firestore DocumentSnapshot
  factory FixedCommitment.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Document data is null');
      }

      // Convert Firestore Timestamp to DateTime
      final Map<String, dynamic> processedData = Map.from(data);
      
      if (data['startTime'] is Timestamp) {
        processedData['startTime'] = (data['startTime'] as Timestamp).toDate();
      }
      
      if (data['endTime'] is Timestamp) {
        processedData['endTime'] = (data['endTime'] as Timestamp).toDate();
      }
      
      if (data['createdAt'] is Timestamp) {
        processedData['createdAt'] = (data['createdAt'] as Timestamp).toDate();
      }
      
      if (data['updatedAt'] is Timestamp) {
        processedData['updatedAt'] = (data['updatedAt'] as Timestamp).toDate();
      }

      return FixedCommitment.fromJson({
        ...processedData,
        'id': doc.id,
      });
    } catch (e) {
      throw Exception('Failed to parse FixedCommitment from Firestore: $e');
    }
  }

  /// Convert FixedCommitment to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Remove ID as it's handled by Firestore
    
    // Convert DateTime to Timestamp for Firestore
    if (json['startTime'] != null) {
      json['startTime'] = Timestamp.fromDate(DateTime.parse(json['startTime']));
    }
    if (json['endTime'] != null) {
      json['endTime'] = Timestamp.fromDate(DateTime.parse(json['endTime']));
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