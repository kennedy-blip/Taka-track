import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/records.dart';
class BillingScreen extends StatefulWidget {
 const BillingScreen({super.key,required this.records,required this.onPayment,required this.isAdmin,required this.onRate});
 final List<Subscriber> records;final void Function(Subscriber,double) onPayment;final bool isAdmin;final void Function(Subscriber,double) onRate;
 @override State<BillingScreen>createState()=>_BillingScreenState();
}
class _BillingScreenState extends State<BillingScreen>{
 String query='',zone='All';
 @override Widget build(BuildContext context){
  final zones=['All',...{...widget.records.map((e)=>e.zone)}];final filtered=widget.records.where((s)=>(zone=='All'||zone==s.zone)&&('${s.name} ${s.zone} ${s.id}'.toLowerCase().contains(query.toLowerCase()))).toList();
  final due=widget.records.fold<double>(0,(a,s)=>a+(s.fee-s.paid).clamp(0,double.infinity));final paid=widget.records.fold<double>(0,(a,s)=>a+s.paid);
  return ListView(padding:const EdgeInsets.all(18),children:[
   Text('Subscriber ledger',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.bold)),const SizedBox(height:12),
   Card(child:Padding(padding:const EdgeInsets.all(16),child:Row(children:[Expanded(child:_metric('OUTSTANDING','KES ${NumberFormat('#,##0').format(due)}',Colors.orange)),Expanded(child:_metric('COLLECTED','KES ${NumberFormat('#,##0').format(paid)}',Colors.green))]))),
   const SizedBox(height:12),TextField(decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search subscriber or zone'),onChanged:(v)=>setState(()=>query=v)),const SizedBox(height:8),
   DropdownButtonFormField<String>(value:zone,decoration:const InputDecoration(labelText:'Filter by zone'),items:zones.map((z)=>DropdownMenuItem(value:z,child:Text(z))).toList(),onChanged:(v)=>setState(()=>zone=v??'All')),
   const SizedBox(height:8),...filtered.map((s)=>Card(child:ListTile(contentPadding:const EdgeInsets.all(14),title:Text(s.name,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${s.zone} • ${s.phone}\nFee KES ${s.fee.toStringAsFixed(0)} | Paid ${s.paid.toStringAsFixed(0)}',style:const TextStyle(height:1.7)),isThreeLine:true,trailing:Column(mainAxisAlignment:MainAxisAlignment.center,children:[_pill(s.paymentStatus),IconButton(onPressed:()=>_payment(context,s),icon:const Icon(Icons.add_card))]),onTap:widget.isAdmin?()=>_editRate(context,s):null))),
  ]);
 }
 Widget _metric(String label,String value,Color color)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:9,color:Colors.grey,letterSpacing:1)),const SizedBox(height:6),Text(value,style:TextStyle(fontWeight:FontWeight.bold,color:color,fontSize:16))]);
 Widget _pill(PaymentStatus s)=>Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:5),decoration:BoxDecoration(color:(s==PaymentStatus.paid?Colors.green:s==PaymentStatus.partial?Colors.orange:Colors.red).withValues(alpha:.16),borderRadius:BorderRadius.circular(20)),child:Text(s.name.toUpperCase(),style:const TextStyle(fontSize:9,fontWeight:FontWeight.bold)));
 Future<void>_payment(BuildContext c,Subscriber s)async{final ctrl=TextEditingController();final v=await showDialog<double>(context:c,builder:(d)=>AlertDialog(title:Text('Record payment · ${s.name}'),content:TextField(controller:ctrl,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'Amount received (KES)')),actions:[TextButton(onPressed:()=>Navigator.pop(d),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(d,double.tryParse(ctrl.text)),child:const Text('Save payment'))]));if(v!=null&&v>0)widget.onPayment(s,v);}
 Future<void>_editRate(BuildContext c,Subscriber s)async{final ctrl=TextEditingController(text:s.fee.toStringAsFixed(0));final v=await showDialog<double>(context:c,builder:(d)=>AlertDialog(title:Text('Monthly fee · ${s.name}'),content:TextField(controller:ctrl,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'KES per month')),actions:[TextButton(onPressed:()=>Navigator.pop(d),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(d,double.tryParse(ctrl.text)),child:const Text('Update'))]));if(v!=null&&v>0)widget.onRate(s,v);}
}
