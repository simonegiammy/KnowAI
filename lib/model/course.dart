class Course {
  String? id;
  String? category;
  String? title;
  String? level;
  String? description;
  String? createdAt;
  List<String>? tags;
  int? numberLessons;
  String? imageUrl;

  Course(
      {this.id,
      this.category,
      this.title,
      this.level,
      this.description,
      this.createdAt,
      this.tags,
      this.imageUrl,
      this.numberLessons});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    level = json['level'];
    imageUrl = json['imageURL'];
    description = json['description'];
    createdAt = json['createdAt'];
    /*
    if (json['tags'] ?? [].isNotEmpty) {
      tags = json['tags'].cast<String>();
    }*/
    numberLessons = json['numberLessons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['imageURL'] = imageUrl;
    data['title'] = title;
    data['level'] = level;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['tags'] = tags;
    data['numberLessons'] = numberLessons;
    return data;
  }
}
