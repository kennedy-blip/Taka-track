import 'package:flutter/material.dart';
import '../models/records.dart';
class RoutesScreen extends StatelessWidget {
 const RoutesScreen({super.key,required this.records,required this.onStatus,required this.onAdd});
 final List<Subscriber> records;final void Function(Subscriber,PickupStatus) onStatus;final VoidCallback onAdd;
 @override Widget build(BuildContext context){
  final done=records.where((e)=>e.status==PickupStatus.collected).length;final double pct=records.isEmpty?0.0:done/records.length;
  return ListView(padding:const EdgeInsets.all(18),children:[
   Row(children:[Expanded(child:Text('Today’s collection run',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.bold))),IconButton.filledTonal(onPressed:onAdd,icon:const Icon(Icons.person_add_alt_1))]),
   Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('ROUTE COMPLETION',style:TextStyle(fontSize:11,letterSpacing:1.4,fontWeight:FontWeight.bold,color:Colors.grey)),const SizedBox(height:10),Text('$done of ${records.length} pickups collected',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:12),ClipRRect(borderRadius:BorderRadius.circular(20),child:LinearProgressIndicator(value:pct,minHeight:10)),const SizedBox(height:8),Text('${(pct*100).round()}% complete',style:const TextStyle(color:Colors.grey))]))),
   const SizedBox(height:12),...records.map((s)=>Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Row(children:[Expanded(child:Text(s.name,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:16))),_chip(s.status)]),
    const SizedBox(height:5),Text('${s.zone} • ${s.day} • ${s.id}',style:const TextStyle(color:Colors.grey,fontSize:12)),
    if(s.note.isNotEmpty)Text(s.note,style:const TextStyle(color:Colors.orange)),const SizedBox(height:12),
    Wrap(spacing:7,runSpacing:6,children:[_action('Collected',PickupStatus.collected,s),_action('Gate locked',PickupStatus.skipped,s),_action('Missed',PickupStatus.missed,s)])
   ])))),
  ]);
 }
 Widget _chip(PickupStatus s)=>Chip(label:Text(s.name.toUpperCase(),style:const TextStyle(fontSize:9,fontWeight:FontWeight.bold)),backgroundColor:(s==PickupStatus.collected?Colors.green:s==PickupStatus.missed?Colors.red:s==PickupStatus.skipped?Colors.orange:Colors.grey).withValues(alpha:.16),side:BorderSide.none);
 Widget _action(String label,PickupStatus status,Subscriber s)=>OutlinedButton(onPressed:()=>onStatus(s,status),style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(horizontal:10)),child:Text(label,style:const TextStyle(fontSize:11)));
}
