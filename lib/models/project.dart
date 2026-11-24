import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.techStack,
    required this.year,
    this.externalUrl = '',
    this.githubUrl = '',
    this.image = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String category;
  final String description;
  final String techStack;
  final int year;

  @JsonKey(defaultValue: '')
  final String externalUrl;
  @JsonKey(defaultValue: '')
  final String githubUrl;
  @JsonKey(defaultValue: '')
  final String image;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
