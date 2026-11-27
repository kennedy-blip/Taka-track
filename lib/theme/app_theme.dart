import 'package:flutter/material.dart';
import '../models/records.dart';
class AppTheme {
 static ThemeData build(AppThemeMode mode){
  final dark=mode!=AppThemeMode.daylight;
  final bg=mode==AppThemeMode.eco?const Color(0xFF071713):mode==AppThemeMode.truck?const Color(0xFF101820):const Color(0xFFF2F7F3);
  final accent=mode==AppThemeMode.truck?const Color(0xFFFFC247):const Color(0xFF39D98A);
  return ThemeData(useMaterial3:true,brightness:dark?Brightness.dark:Brightness.light,scaffoldBackgroundColor:bg,colorScheme:ColorScheme.fromSeed(seedColor:accent,brightness:dark?Brightness.dark:Brightness.light),
   appBarTheme:AppBarTheme(backgroundColor:bg,foregroundColor:dark?Colors.white:const Color(0xFF163328),elevation:0),
   cardTheme:CardThemeData(color:dark?const Color(0xCC1A3028):Colors.white.withValues(alpha:.94),elevation:0,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20),side:BorderSide(color:accent.withValues(alpha:.2)))),
   inputDecorationTheme:InputDecorationTheme(filled:true,fillColor:dark?Colors.white.withValues(alpha:.06):const Color(0xFFF3F7F4),border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide.none)),
   navigationBarTheme:NavigationBarThemeData(backgroundColor:dark?const Color(0xFF10221B):Colors.white,indicatorColor:accent.withValues(alpha:.2)));
 }
}
