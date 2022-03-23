class TypeOfTree {
  String id;
  String name;
  String information;
  String price;
  int amount;
  String other;
  List<dynamic> images;
  TypeOfTree({required this.id, required this.name, required this.information, required this.price, required this.other, required this.images, required this.amount});

  factory TypeOfTree.init(dynamic data){
    int _amount = int.parse(data['price'].split('.')[0]) * 1000;
    return TypeOfTree(
      id: data['_id'],
      name: data['name'] ?? 'Chưa cập nhật',
      information: data['information'] ?? 'Chưa cập nhật',
      price: data['price'],
      amount: _amount,
      other: data['other'],
      images: data['images']
    );
  }
}