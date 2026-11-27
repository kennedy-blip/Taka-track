enum PickupStatus { pending, collected, skipped, missed }
enum PaymentStatus { paid, partial, overdue }
enum UserRole { manager, crew }
enum AppThemeMode { eco, daylight, truck }

class Subscriber {
  Subscriber({required this.id, required this.name, required this.zone, required this.day, required this.phone, required this.fee, this.paid = 0, this.status = PickupStatus.pending, this.note = ''});
  final String id, name, zone, day, phone;
  double fee, paid;
  PickupStatus status;
  String note;
  PaymentStatus get paymentStatus => paid >= fee ? PaymentStatus.paid : paid > 0 ? PaymentStatus.partial : PaymentStatus.overdue;
  Map<String, dynamic> toJson() => {'id':id,'name':name,'zone':zone,'day':day,'phone':phone,'fee':fee,'paid':paid,'status':status.name,'note':note};
  factory Subscriber.fromJson(Map<String,dynamic> j) => Subscriber(id:j['id'],name:j['name'],zone:j['zone'],day:j['day'],phone:j['phone'],fee:(j['fee'] as num).toDouble(),paid:(j['paid'] as num).toDouble(),status:PickupStatus.values.firstWhere((e)=>e.name==j['status'],orElse:()=>PickupStatus.pending),note:j['note']??'');
}

class RecyclingBatch {
  RecyclingBatch({required this.id,required this.material,required this.kg,required this.rate,required this.buyer,required this.date});
  final String id, material, buyer, date;
  double kg, rate;
  double get value => kg * rate;
  Map<String,dynamic> toJson()=>{'id':id,'material':material,'kg':kg,'rate':rate,'buyer':buyer,'date':date};
  factory RecyclingBatch.fromJson(Map<String,dynamic> j)=>RecyclingBatch(id:j['id'],material:j['material'],kg:(j['kg'] as num).toDouble(),rate:(j['rate'] as num).toDouble(),buyer:j['buyer'],date:j['date']);
}
