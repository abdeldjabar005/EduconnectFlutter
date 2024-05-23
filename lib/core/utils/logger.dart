import 'package:logger/logger.dart';

final prettyLog = Logger(
  printer: PrettyPrinter(
    methodCount: 1, 
    errorMethodCount: 8, 
    lineLength: 120, 
    colors: true, 
    printEmojis: true,
    printTime: false, 
  ),
  //printer: PrefixPrinter(PrettyPrinter(colors: false))
);

final wLog = prettyLog.w;
final vLog = prettyLog.v;
final dLog = prettyLog.d;
final iLog = prettyLog.i;
final eLog = prettyLog.e;
final wtfLog = prettyLog.wtf;