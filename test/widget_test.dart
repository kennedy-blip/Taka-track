import 'package:flutter_test/flutter_test.dart';
import 'package:taka_track/models/records.dart';

void main() {
  test('subscriber payment status reflects partial and complete payments', () {
    final subscriber = Subscriber(id:'1',name:'Test Estate',zone:'Central',day:'Monday',phone:'0700000000',fee:1000,paid:400);
    expect(subscriber.paymentStatus, PaymentStatus.partial);
    subscriber.paid = 1000;
    expect(subscriber.paymentStatus, PaymentStatus.paid);
  });
}
