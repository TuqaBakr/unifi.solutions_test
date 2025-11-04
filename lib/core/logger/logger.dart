import 'package:talker/talker.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 100,
    useConsoleLogs: true,
    timeFormat: TimeFormat.yearMonthDayAndTime,
    // colors: {
    //   // needs talker_dio_logger to emit these actual types:
    //   TalkerLogTypes.httpResponse: AnsiPen()..green(bold: true),
    //   TalkerLogTypes.httpRequest:  AnsiPen()..yellow(bold: true),
    //
    //   // use the generic error type (works regardless of integrations)
    //   TalkerLogTypes.error:        AnsiPen()..red(bold: true),
    //
    //   // these require talker_bloc_logger if you want them emitted automatically
    //   TalkerLogTypes.blocClose:      AnsiPen()..magenta(bold: true),
    //   TalkerLogTypes.blocCreate:     AnsiPen()..xterm(50),
    //   TalkerLogTypes.blocTransition: AnsiPen()..yellow(bold: true),
    //
    //   TalkerLogTypes.info:         AnsiPen()..green(bold: true),
    // },
    // titles: {
    //   TalkerLogTypes.httpResponse: "Response",
    //   TalkerLogTypes.httpRequest:  "Request",
    //   TalkerLogTypes.error:        "Error",
    //   TalkerLogTypes.blocClose:      "Bloc Close",
    //   TalkerLogTypes.blocCreate:     "Bloc Create",
    //   TalkerLogTypes.blocTransition: "Bloc Transition",
    //   TalkerLogTypes.route:          "Navigation",
    //   TalkerLogTypes.info:           "Info",
    // },
  ),
);

class Dev {
  Dev._();
  static void logValue(dynamic value) {
    talker.info("The value is : ******  $value  ******");
  }

  static void logError(dynamic value) {
    talker.error(value);
  }

  static void logLine(dynamic value) {
    talker.info(value);
  }

  static void logSuccess(dynamic value) {
    talker.info(value);
  }

  static void logList(List items) {
    talker.info("List size is ${items.length}");
    for (int i = 0; i < items.length; i++) {
      talker.info("Item with index $i ===> ${items[i]}");
    }
  }

  static void logLineWithTag({dynamic tag, dynamic message}) {
    talker.verbose('$tag : $message');
  }

  static void logLineWithTagError({
    dynamic tag,
    dynamic message,
    dynamic error,
  }) {
    talker.error('$tag: $message >>>>> Error => $error');
  }

  static void logDivider({dynamic symbole = '*', dynamic lenght = 50}) {
    talker.info("$symbole" * lenght);
  }

  static void logWithLine({dynamic title}) {
    logDivider();
    talker.info(title);
    logDivider();
  }
}
