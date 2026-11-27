import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'models/records.dart';
import 'storage/local_store.dart';
import 'theme/app_theme.dart';
import 'screens/routes_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/recycling_screen.dart';
import 'screens/settings_screen.dart';

void main()=>runApp(const TakaTrackApp());

class TakaTrackApp extends StatefulWidget {
 const TakaTrackApp({super.key});
 @override State<TakaTrackApp> createState()=>_TakaTrackAppState();
}
class _TakaTrackAppState extends State<TakaTrackApp> {
 final store=LocalStore();
 List<Subscriber> subscribers=[];
 List<RecyclingBatch> batches=[];
 UserRole role=UserRole.manager;
 AppThemeMode theme=AppThemeMode.eco;
 bool ready=false;
 int tab=0;
 @override void initState(){super.initState();_load();}
 Future<void> _load() async {
  subscribers=await store.loadSubscribers();
  batches=await store.loadBatches();
  role=await store.loadRole();
  theme=await store.loadTheme();
  if(mounted)setState(()=>ready=true);
 }
 Future<void> _save() async {await store.saveSubscribers(subscribers);await store.saveBatches(batches);}
 void _status(Subscriber s,PickupStatus v){setState(()=>s.status=v);_save();}
 void _payment(Subscriber s,double amount){setState(()=>s.paid=(s.paid+amount).clamp(0,s.fee).toDouble());_save();}
 void _rate(Subscriber s,double amount){if(role!=UserRole.manager)return;setState(()=>s.fee=amount);_save();}
 Future<void> _addSubscriber() async {
  final name=TextEditingController(),zone=TextEditingController(),fee=TextEditingController(text:'2000');
  final ok=await showDialog<bool>(context:context,builder:(c)=>AlertDialog(title:const Text('Add subscriber'),content:Column(mainAxisSize:MainAxisSize.min,children:[
   TextField(controller:name,decoration:const InputDecoration(labelText:'Estate / client name')),
   TextField(controller:zone,decoration:const InputDecoration(labelText:'Zone')),
   TextField(controller:fee,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Monthly fee (KES)')),
  ]),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('Add'))]));
  if(ok==true&&name.text.trim().isNotEmpty){setState(()=>subscribers.add(Subscriber(id:'TT-${DateTime.now().millisecondsSinceEpoch}',name:name.text.trim(),zone:zone.text.trim().isEmpty?'Unassigned':zone.text.trim(),day:'Monday',phone:'—',fee:double.tryParse(fee.text)??2000)));_save();}
 }
 Future<void> _addBatch() async {
  final kg=TextEditingController(),rate=TextEditingController(text:'30'),buyer=TextEditingController();
  String material='PET Plastic';
  final ok=await showDialog<bool>(context:context,builder:(c)=>StatefulBuilder(builder:(c,setD)=>AlertDialog(title:const Text('Record recycling batch'),content:Column(mainAxisSize:MainAxisSize.min,children:[
   DropdownButtonFormField<String>(value:material,decoration:const InputDecoration(labelText:'Material'),items:['PET Plastic','Cardboard','Scrap Metal','Glass'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setD(()=>material=v!)),
   TextField(controller:kg,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'Weight (kg)')),
   TextField(controller:rate,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'Buyer rate (KES/kg)')),
   TextField(controller:buyer,decoration:const InputDecoration(labelText:'Buyer / destination')),
  ]),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('Save batch'))])));
  final weight=double.tryParse(kg.text)??0;
  if(ok==true&&weight>0){setState(()=>batches.insert(0,RecyclingBatch(id:'RB-${DateTime.now().millisecondsSinceEpoch}',material:material,kg:weight,rate:double.tryParse(rate.text)??0,buyer:buyer.text.isEmpty?'Unassigned':buyer.text,date:DateTime.now().toIso8601String().substring(0,10))));_save();}
 }
 Future<void> _export() async {
  final rows=['id,name,zone,monthly_fee,paid,balance,pickup_status,payment_status',...subscribers.map((s)=>'${s.id},"${s.name.replaceAll('"','""')}",${s.zone},${s.fee},${s.paid},${(s.fee-s.paid).clamp(0,double.infinity)},${s.status.name},${s.paymentStatus.name}')];
  await Share.share(rows.join('\n'),subject:'TakaTrack subscriber ledger CSV');
 }
 @override Widget build(BuildContext context)=>MaterialApp(
  debugShowCheckedModeBanner:false,title:'TakaTrack',theme:AppTheme.build(theme),
  home:!ready?const Scaffold(body:Center(child:CircularProgressIndicator())):LayoutBuilder(builder:(context,box){
   final wide=box.maxWidth>=850;
   final pages=[
    RoutesScreen(records:subscribers,onStatus:_status,onAdd:_addSubscriber),
    BillingScreen(records:subscribers,onPayment:_payment,isAdmin:role==UserRole.manager,onRate:_rate),
    RecyclingScreen(batches:batches,isAdmin:role==UserRole.manager,onAdd:_addBatch,onDelete:(b){setState(()=>batches.remove(b));_save();}),
    SettingsScreen(role:role,themeMode:theme,onRole:(v){setState(()=>role=v);store.saveRole(v);},onTheme:(v){setState(()=>theme=v);store.saveTheme(v);},count:subscribers.length,onExport:_export)
   ];
   return Scaffold(
    appBar:AppBar(title:Row(children:[
     Container(width:34,height:34,decoration:BoxDecoration(color:Theme.of(context).colorScheme.primary.withValues(alpha:.18),borderRadius:BorderRadius.circular(10)),child:const Icon(Icons.recycling)),
     const SizedBox(width:10),const Text('TakaTrack',style:TextStyle(fontWeight:FontWeight.w800)),const SizedBox(width:8),
     const Chip(label:Text('FIELD OPS',style:TextStyle(fontSize:9)))
    ]),actions:[if(wide)Padding(padding:const EdgeInsets.only(right:18),child:DropdownButton<UserRole>(value:role,underline:const SizedBox(),items:UserRole.values.map((r)=>DropdownMenuItem(value:r,child:Text(r==UserRole.manager?'Manager':'Crew'))).toList(),onChanged:(v){if(v!=null){setState(()=>role=v);store.saveRole(v);}}))]),
    body:wide?Row(children:[
     NavigationRail(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),labelType:NavigationRailLabelType.all,destinations:const [
      NavigationRailDestination(icon:Icon(Icons.route),label:Text('Routes')),
      NavigationRailDestination(icon:Icon(Icons.receipt_long),label:Text('Billing')),
      NavigationRailDestination(icon:Icon(Icons.recycling),label:Text('Recycling')),
      NavigationRailDestination(icon:Icon(Icons.settings),label:Text('Settings'))
     ]),const VerticalDivider(width:1),Expanded(child:pages[tab])
    ]):pages[tab],
    bottomNavigationBar:wide?null:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [
     NavigationDestination(icon:Icon(Icons.route),label:'Routes'),
     NavigationDestination(icon:Icon(Icons.receipt_long),label:'Billing'),
     NavigationDestination(icon:Icon(Icons.recycling),label:'Recycling'),
     NavigationDestination(icon:Icon(Icons.settings),label:'Settings')
    ])
   );
  })
 );
}
