class CourseModel {
  String title, desc, instructorName, courseImg, instructorImg, id;
  List<dynamic> lectures = [];

  CourseModel(
    this.title,
    this.desc,
    this.instructorName,
    this.instructorImg,
    this.courseImg,
    this.lectures,
    this.id,
  );

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      json['title'],
      json['desc'],
      json['instructorName'],
      json['instructorImg'],
      json['courseImg'],
      json['lectures'],
      json['id'],
    );
  }

  Map<String, dynamic> toJSON() => {
        'title': title,
        'desc': desc,
        'instructorName': instructorName,
        'instructorImg': instructorImg,
        'courseImg': courseImg,
        'lectures': lectures,
        'id': id,
      };
}
