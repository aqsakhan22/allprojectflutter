class Graph{
bool? success;
String? message;
List<GraphData>? graphData;
String? period;
Graph({this.success,this.message,this.graphData});


factory Graph.fromJson(Map<String,dynamic> json) => Graph(
  success: json['success'],
  message: json['message'],
  graphData:List<GraphData>.from(json["data"].map((x) => GraphData.fromJson(x)))

);

Map<String, dynamic> toJson() => {
  "period": period,
};
}
class GraphData{
  DateTime? datetime;
  double? price;
  int? qty;
  GraphData({this.datetime,this.price,this.qty});
  factory GraphData.fromJson(Map<String,dynamic> json) => GraphData(
    datetime: DateTime.parse(json["datetime"]),
    price: json["price"]?.toDouble(),
    qty: json["qty"],
  );
  Map<String, dynamic> toJson() => {
     'datetime':datetime,
      'price':price,
       'qty':qty
  };


}