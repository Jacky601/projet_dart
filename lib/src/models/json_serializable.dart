/// Interface implémentée par tout objet convertible en JSON.
abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}
