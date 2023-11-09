part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class CreatePostEvent extends PostEvent {
  final String title;
  final String content;
  final List<Facilities> facilities;
  final String area;
  final String bathrooms;
  final bool isApartment;
  final String phone;
  final String price;
  final String rooms;
  final List<File?> gridImages;
  final String lat;
  final String long;

  const CreatePostEvent({
    required this.title,
    required this.content,
    required this.facilities,
    required this.area,
    required this.bathrooms,
    required this.isApartment,
    required this.phone,
    required this.price,
    required this.rooms,
    required this.gridImages,
    required this.lat,
    required this.long,
  });

  @override
  List<Object?> get props => [
        title,
        content,
        area,
        bathrooms,
        isApartment,
        phone,
        price,
        rooms,
        gridImages,
        facilities,
        lat,
        long,
      ];
}

class PostIsApartmentEvent extends PostEvent {
  final bool isApartment;
  const PostIsApartmentEvent(this.isApartment);

  @override
  List<Object?> get props => [isApartment];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  final List<String> postImages;
  const DeletePostEvent(this.postId, this.postImages);

  @override
  List<Object?> get props => [postId, postImages];
}

class UpdatePostEvent extends PostEvent {
  final String postId;
  final String title;
  final String content;
  final List<Facilities> facilities;
  final String area;
  final String bathrooms;
  final bool isApartment;
  final String phone;
  final String price;
  final String rooms;
  final List<File?> gridImages;
  final List<String>? imagesUri;
  final List<String> isLiked;
  final String lat;
  final String long;

  const UpdatePostEvent({
    required this.title,
    required this.isLiked,
    required this.content,
    required this.facilities,
    required this.area,
    required this.bathrooms,
    required this.isApartment,
    required this.phone,
    required this.price,
    required this.rooms,
    required this.postId,
    required this.gridImages,
    required this.imagesUri,
    required this.lat,
    required this.long,
  });

  @override
  List<Object?> get props => [
        title,
        content,
        area,
        bathrooms,
        isApartment,
        phone,
        price,
        rooms,
        postId,
        gridImages,
        facilities,
        imagesUri,
        isLiked,
        lat,
        long,
      ];
}

class UpdateLikePostEvent extends PostEvent {
  final String postId;
  final String title;
  final String content;
  final List<Facilities> facilities;
  final String area;
  final String bathrooms;
  final bool isApartment;
  final List<String> isLiked;
  final String userName;
  final String phone;
  final String price;
  final String rooms;
  final List<String> gridImages;
  final String lat;
  final String long;
  final String email;
  final String userId;

  const UpdateLikePostEvent(
      {required this.userName,
      required this.title,
      required this.content,
      required this.facilities,
      required this.area,
      required this.bathrooms,
      required this.isApartment,
      required this.isLiked,
      required this.phone,
      required this.price,
      required this.rooms,
      required this.postId,
      required this.gridImages,
      required this.lat,
      required this.long,
      required this.userId,
      required this.email});

  @override
  List<Object?> get props => [
        title,
        content,
        area,
        bathrooms,
        isApartment,
        isLiked,
        phone,
        price,
        rooms,
        postId,
        gridImages,
        facilities,
        lat,
        long,
        userName,
        email,
        userId
      ];
}

class ViewGridImagesPostEvent extends PostEvent {
  final List<File?> files;
  const ViewGridImagesPostEvent(this.files);

  @override
  List<Object?> get props => [files];
}

class FacilitiesPostEvent extends PostEvent {
  final List<Facilities> facilities;
  final Facilities facility;
  const FacilitiesPostEvent({required this.facilities, required this.facility});

  @override
  List<Object?> get props => [facilities, facility];
}

class WriteCommentPostEvent extends PostEvent {
  final String postId;
  final String message;
  final List<Message> old;
  const WriteCommentPostEvent(this.postId, this.message, this.old);

  @override
  List<Object?> get props => [postId, message, old];
}
