import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/records.dart';
class LocalStore {
 static const _subKey='taka_subscribers_v1',_batchKey='taka_batches_v1',_roleKey='taka_role_v1',_themeKey='taka_theme_v1';
 Future<List<Subscriber>> loadSubscribers() async {final p=await SharedPreferences.getInstance();final raw=p.getString(_subKey);if(raw==null)return _samples();try{return (jsonDecode(raw) as List).map((e)=>Subscriber.fromJson(Map<String,dynamic>.from(e))).toList();}catch(_){return _samples();}}
 Future<void> saveSubscribers(List<Subscriber> v) async {final p=await SharedPreferences.getInstance();await p.setString(_subKey,jsonEncode(v.map((e)=>e.toJson()).toList()));}
 Future<List<RecyclingBatch>> loadBatches() async {final p=await SharedPreferences.getInstance();final raw=p.getString(_batchKey);if(raw==null)return [];try{return (jsonDecode(raw) as List).map((e)=>RecyclingBatch.fromJson(Map<String,dynamic>.from(e))).toList();}catch(_){return [];}}
 Future<void> saveBatches(List<RecyclingBatch> v) async {final p=await SharedPreferences.getInstance();await p.setString(_batchKey,jsonEncode(v.map((e)=>e.toJson()).toList()));}
 Future<UserRole> loadRole() async {final p=await SharedPreferences.getInstance();return UserRole.values.firstWhere((e)=>e.name==p.getString(_roleKey),orElse:()=>UserRole.manager);}
 Future<void> saveRole(UserRole v) async {final p=await SharedPreferences.getInstance();await p.setString(_roleKey,v.name);}
 Future<AppThemeMode> loadTheme() async {final p=await SharedPreferences.getInstance();return AppThemeMode.values.firstWhere((e)=>e.name==p.getString(_themeKey),orElse:()=>AppThemeMode.eco);}
 Future<void> saveTheme(AppThemeMode v) async {final p=await SharedPreferences.getInstance();await p.setString(_themeKey,v.name);}
 List<Subscriber> _samples()=>[
 Subscriber(id:'TT-001',name:'Greenview Apartments',zone:'Kilimani',day:'Monday',phone:'0712 000 111',fee:2500,status:PickupStatus.collected,paid:2500),
 Subscriber(id:'TT-002',name:'Sunrise Court',zone:'Westlands',day:'Monday',phone:'0722 000 222',fee:1800,paid:900),
 Subscriber(id:'TT-003',name:'Oak Residency',zone:'Kileleshwa',day:'Tuesday',phone:'0733 000 333',fee:2200,status:PickupStatus.missed),
 Subscriber(id:'TT-004',name:'Market Square Shops',zone:'CBD',day:'Wednesday',phone:'0700 000 444',fee:3500,status:PickupStatus.skipped),
 Subscriber(id:'TT-005',name:'Palm Estate',zone:'Kilimani',day:'Thursday',phone:'0711 000 555',fee:2000,paid:2000)];
}
