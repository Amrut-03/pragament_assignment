import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pragament_assignment/constant.dart';
import 'package:pragament_assignment/provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;

  void startTimer() {
    ref.read(isRunningProvider.notifier).state = true;
    _startTimer();
  }

  void _startTimer() {
    final activeDuration = ref.read(activeDurationProvider);
    final breakDuration = ref.read(breakDurationProvider);
    final rounds = ref.read(roundsProvider);
    final isBreak = ref.read(isBreakProvider);
    final currentRound = ref.read(currentRoundProvider);

    if (isBreak) {
      Duration(seconds: breakDuration);
      ref.read(timerProvider.notifier).state = Duration(seconds: breakDuration);
    } else {
      Duration(seconds: activeDuration);
      ref.read(timerProvider.notifier).state =
          Duration(seconds: activeDuration);
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final isRunning = ref.read(isRunningProvider);
      if (!isRunning) {
        timer.cancel();
        return;
      }

      final timerValue = ref.read(timerProvider);
      if (timerValue.inSeconds > 0) {
        ref.read(timerProvider.notifier).state =
            Duration(seconds: timerValue.inSeconds - 1);
      } else {
        if (isBreak) {
          ref.read(isBreakProvider.notifier).state = false;
          ref.read(timerProvider.notifier).state =
              Duration(seconds: activeDuration);
          _startTimer();
        } else {
          if (currentRound < rounds) {
            ref.read(currentRoundProvider.notifier).state++;
            ref.read(isBreakProvider.notifier).state = true;
            ref.read(timerProvider.notifier).state =
                Duration(seconds: breakDuration);
            _startTimer();
          } else {
            ref.read(isRunningProvider.notifier).state = false;
            timer.cancel();
          }
        }
      }
    });
  }

  void restartTimer() {
    _timer?.cancel();
    ref.read(currentRoundProvider.notifier).state = 1;
    ref.read(isBreakProvider.notifier).state = true;
    ref.read(timerProvider.notifier).state =
        Duration(seconds: ref.read(breakDurationProvider));
    ref.read(isRunningProvider.notifier).state = false;
  }

  String formatDuration(Duration duration) {
    // int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  void incrementDuration(StateProvider<int> provider) {
    ref.read(provider.notifier).update((state) => state + 1);
  }

  void decrementDuration(StateProvider<int> provider) {
    ref
        .read(provider.notifier)
        .update((state) => state > 1 ? state - 1 : state);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeDuration = ref.watch(activeDurationProvider);
    final breakDuration = ref.watch(breakDurationProvider);
    final rounds = ref.watch(roundsProvider);
    final currentRound = ref.watch(currentRoundProvider);
    final isRunning = ref.watch(isRunningProvider);
    final isBreak = ref.watch(isBreakProvider);
    final timer = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTemplate.otherClr,
        centerTitle: true,
        title: const Txt(
            txt: "Timer App",
            fontClr: AppTemplate.textClr,
            fontSz: 30,
            fontWt: FontWeight.w500),
      ),
      backgroundColor: isBreak ? Colors.green[300] : Colors.red[300],
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Txt(
                txt: isBreak ? 'Break' : 'Active',
                fontClr: AppTemplate.otherClr,
                fontSz: 50,
                fontWt: FontWeight.w500),
            Txt(
                txt:
                    "${timer.inMinutes.toString().padLeft(2, '0')} : ${(timer.inSeconds % 60).toString().padLeft(2, '0')}",
                fontClr: AppTemplate.otherClr,
                fontSz: 100,
                fontWt: FontWeight.w500),
            Txt(
                txt: "Round $currentRound/$rounds",
                fontClr: AppTemplate.otherClr,
                fontSz: 30,
                fontWt: FontWeight.w500),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Bttn(
                  onClick: () {
                    if (isRunning) {
                      ref.read(isRunningProvider.notifier).state = false;
                    } else {
                      ref.read(isRunningProvider.notifier).state = true;
                      startTimer();
                    }
                  },
                  txt: isRunning ? "Pause" : "Start",
                  fontClr: AppTemplate.textClr,
                  fontSz: 20,
                  fontWt: FontWeight.w500,
                ),
                Bttn(
                  onClick: () {
                    restartTimer();
                  },
                  txt: "Restart",
                  fontClr: AppTemplate.textClr,
                  fontSz: 20,
                  fontWt: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Txt(
                txt: "Active Duration",
                fontClr: AppTemplate.textClr,
                fontSz: 20,
                fontWt: FontWeight.w500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconBttn(
                  onClick: () {
                    decrementDuration(activeDurationProvider);
                  },
                  icon: Icons.remove,
                ),
                Txt(
                    txt: formatDuration(Duration(seconds: activeDuration)),
                    fontClr: AppTemplate.textClr,
                    fontSz: 20,
                    fontWt: FontWeight.w500),
                IconBttn(
                  onClick: () {
                    incrementDuration(activeDurationProvider);
                  },
                  icon: Icons.add,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Txt(
              txt: "Break Duration",
              fontClr: AppTemplate.textClr,
              fontSz: 20,
              fontWt: FontWeight.w500,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconBttn(
                  onClick: () {
                    decrementDuration(breakDurationProvider);
                  },
                  icon: Icons.remove,
                ),
                Txt(
                    txt: formatDuration(Duration(seconds: breakDuration)),
                    fontClr: AppTemplate.textClr,
                    fontSz: 20,
                    fontWt: FontWeight.w500),
                IconBttn(
                  onClick: () {
                    incrementDuration(breakDurationProvider);
                  },
                  icon: Icons.add,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Txt(
                txt: "Rounds",
                fontClr: AppTemplate.textClr,
                fontSz: 20,
                fontWt: FontWeight.w500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconBttn(
                  onClick: () {
                    ref.read(roundsProvider.notifier).state--;
                  },
                  icon: Icons.remove,
                ),
                Txt(
                    txt: rounds.toString(),
                    fontClr: AppTemplate.textClr,
                    fontSz: 20,
                    fontWt: FontWeight.w500),
                IconBttn(
                  onClick: () {
                    ref.read(roundsProvider.notifier).state++;
                  },
                  icon: Icons.add,
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
