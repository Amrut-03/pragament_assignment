import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeDurationProvider =
    StateProvider<int>((ref) => 20); // Active duration in seconds
final breakDurationProvider =
    StateProvider<int>((ref) => 10); // Break duration in seconds
final roundsProvider = StateProvider<int>((ref) => 5); // Number of rounds
final currentRoundProvider = StateProvider<int>((ref) => 1); // Current round
final isRunningProvider =
    StateProvider<bool>((ref) => false); // Timer running state
final isBreakProvider =
    StateProvider<bool>((ref) => true); // Break or active state
final timerProvider = StateProvider<Duration>(
    (ref) => Duration(seconds: 10)); // Current timer duration
