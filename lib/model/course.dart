class Course {
  String? category;
  String? title;
  String? level;
  String? description;
  String? createdAt;
  List<String>? tags;
  int? numberLessons;
  String? imageUrl;

  Course(
      {this.category,
      this.title,
      this.level,
      this.description,
      this.createdAt,
      this.tags,
      this.imageUrl,
      this.numberLessons});

  Course.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    title = json['title'];
    level = json['level'];
    imageUrl = json['imageURL'];
    description = json['description'];
    createdAt = json['createdAt'];
    tags = json['tags'].cast<String>();
    numberLessons = json['numberLessons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
