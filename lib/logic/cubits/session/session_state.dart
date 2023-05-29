part of 'session_cubit.dart';

class SessionState extends Equatable {
  final bool? isAuthenticated;
  final bool? isFirstLaunched;
  final String? id;
  final String? userName;
  final String? email;
  final String? imagePath;
  const SessionState({
    this.isAuthenticated,
    this.isFirstLaunched,
    this.id,
    this.userName,
    this.email,
    this.imagePath,
  });

  // Edit Session
  SessionState copyWith({
    bool? isAuthenticated,
    bool? isFirstLaunched,
    String? id,
    String? userName,
    String? email,
    String? imagePath,
  }) {
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isFirstLaunched: isFirstLaunched ?? this.isFirstLaunched,
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // Convert Session attributes to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isAuthenticated': isAuthenticated,
      'isFirstLaunched': isFirstLaunched,
      'id': id,
      'userName': userName,
      'email': email,
      'imagePath': imagePath,
    };
  }

  // generate Map structure
  factory SessionState.fromMap(Map<String, dynamic> map) {
    return SessionState(
      isAuthenticated: map['isAuthenticated'] != null ? map['isAuthenticated'] as bool : null,
      isFirstLaunched: map['isFirstLaunched'] != null ? map['isFirstLaunched'] as bool : null,
      id: map['id'] != null ? map['id'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
    );
  }

  // Convert from Map to Json
  String toJson() => json.encode(toMap());

  // Decode Json file into Map using fromMap method
  factory SessionState.fromJson(String source) =>
      SessionState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      isAuthenticated,
      isFirstLaunched,
      id,
      userName,
      email,
      imagePath,
    ];
  }
}
