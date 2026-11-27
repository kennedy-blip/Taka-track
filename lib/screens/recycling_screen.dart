import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/records.dart';
class RecyclingScreen extends StatelessWidget{
 const RecyclingScreen({super.key,required this.batches,required this.isAdmin,required this.onAdd,required this.onDelete});
 final List<RecyclingBatch>batches;final bool isAdmin;final VoidCallback onAdd;final void Function(RecyclingBatch)onDelete;
 @override Widget build(BuildContext context){final kg=batches.fold<double>(0,(a,b)=>a+b.kg),value=batches.fold<double>(0,(a,b)=>a+b.value);return ListView(padding:const EdgeInsets.all(18),children:[
  Row(children:[Expanded(child:Text('Recovery yard',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.bold))),FilledButton.icon(onPressed:onAdd,icon:const Icon(Icons.scale,size:18),label:const Text('Weigh in'))]),const SizedBox(height:12),
  Row(children:[Expanded(child:_summary('TOTAL RECOVERED','${kg.toStringAsFixed(1)} kg',Icons.recycling)),const SizedBox(width:10),Expanded(child:_summary('EST. VALUE','KES ${NumberFormat('#,##0').format(value)}',Icons.payments_outlined))]),const SizedBox(height:14),
  ...batches.map((b)=>Card(child:ListTile(leading:CircleAvatar(child:Icon(_icon(b.material))),title:Text(b.material,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${b.kg.toStringAsFixed(1)} kg × KES ${b.rate.toStringAsFixed(0)} • ${b.buyer}\n${b.date}'),isThreeLine:true,trailing:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text('KES ${b.value.toStringAsFixed(0)}',style:const TextStyle(fontWeight:FontWeight.bold,color:Colors.green)),if(isAdmin)IconButton(onPressed:()=>onDelete(b),icon:const Icon(Icons.delete_outline,size:18))])))),
  if(batches.isEmpty)const Padding(padding:EdgeInsets.all(28),child:Center(child:Text('No recycling batches recorded yet.'))),
 ]);}
 Widget _summary(String label,String value,IconData icon)=>Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,color:Colors.green),const SizedBox(height:10),Text(label,style:const TextStyle(fontSize:9,color:Colors.grey)),Text(value,style:const TextStyle(fontSize:16,fontWeight:FontWeight.bold))])));
 IconData _icon(String s)=>s=='PET Plastic'?Icons.local_drink:s=='Cardboard'?Icons.inventory_2:s=='Scrap Metal'?Icons.hardware:Icons.wine_bar;
}
