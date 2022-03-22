class TypeOfTree {
  String id;
  String name;
  String information;
  String price;
  String other;
  List<dynamic> images;
  TypeOfTree({required this.id, required this.name, required this.information, required this.price, required this.other, required this.images});

  factory TypeOfTree.init(dynamic data){
    return TypeOfTree(
      id: data['_id'],
      name: data['name'] ?? 'Chưa cập nhật',
      information: data['information'] ?? 'Chưa cập nhật',
      price: data['price'],
      other: data['other'],
      images: data['images']
    );
  }
}