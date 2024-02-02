import 'package:hive/hive.dart';

class Productmodel {
  String? id;
  String? title;
  String? category;
  String? description;
  String? image;
  String? date;
  int? price;
  int quantity;

  Productmodel({
    this.id,
    this.title,
    this.category,
    this.description,
    this.image,
    this.date,
    this.quantity = 0,
    this.price,
  });

  factory Productmodel.fromJson(Map<String, dynamic> obj) => Productmodel(
        id: obj['_id'],
        title: obj['title'],
        category: obj['category'],
        description: obj['description'],
        image: obj['image'],
        date: obj['date'],
        price: obj['price'],
      );

  // Add toJson method if needed
  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'category': category,
        'description': description,
        'image': image,
        'date': date,
        'price': price,
      };
}

class ProductmodelAdapter extends TypeAdapter<Productmodel> {
  @override
  final typeId = 0; // Unique type id for your model

  @override
  Productmodel read(BinaryReader reader) {
    // Implement how to read the object from binary
    // You can use reader methods like readString, readInt, etc.
    return Productmodel(
      id: reader.read(),
      title: reader.read(),
      category: reader.read(),
      description: reader.read(),
      image: reader.read(),
      date: reader.read(),
      quantity: reader.read(),
      price: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Productmodel obj) {
    // Implement how to write the object to binary
    // You can use writer methods like writeString, writeInt, etc.
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.category);
    writer.write(obj.description);
    writer.write(obj.image);
    writer.write(obj.date);
    writer.write(obj.quantity);
    writer.write(obj.price);
  }
}
