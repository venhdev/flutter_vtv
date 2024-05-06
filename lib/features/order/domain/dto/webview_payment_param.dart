import 'dart:convert';

class WebViewPaymentExtra {
  final List<String> orderIds;
  final String uri;

  WebViewPaymentExtra(this.orderIds, this.uri);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderIds': orderIds,
      'uri': uri,
    };
  }

  factory WebViewPaymentExtra.fromMap(Map<String, dynamic> map) {
    return WebViewPaymentExtra(
      List<String>.from(map['orderIds'] as List<String>),
      map['uri'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WebViewPaymentExtra.fromJson(String source) =>
      WebViewPaymentExtra.fromMap(json.decode(source) as Map<String, dynamic>);
}
