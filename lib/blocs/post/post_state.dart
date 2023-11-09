part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {
  @override
  List<Object> get props => [];
}

class PostFailure extends PostState {
  final String message;

  const PostFailure(this.message);
  @override
  List<Object> get props => [message];
}

class CreatePostSuccess extends PostState {
  @override
  List<Object> get props => [];
}

class DeletePostSuccess extends PostState {
  @override
  List<Object> get props => [];
}

class UpdatePostSuccess extends PostState {
  @override
  List<Object> get props => [];
}

class UpdateLikePostSuccess extends PostState {
  @override
  List<Object> get props => [];
}

class PostIsApartmentState extends PostState {
  final bool isApartment;

  const PostIsApartmentState(this.isApartment);

  @override
  List<Object> get props => [isApartment];
}

class FacilitiesSuccessState extends PostState {
  final List<Facilities> facilities;
  final Facilities facility;

  const FacilitiesSuccessState(
      {required this.facilities, required this.facility});

  @override
  List<Object> get props => [facilities, facility];
}

class ViewGridImagesPostSuccess extends PostState {
  final List<File?> files;

  const ViewGridImagesPostSuccess(this.files);

  @override
  List<Object> get props => [files];
}

class WriteCommentPostSuccess extends PostState {
  const WriteCommentPostSuccess();

  @override
  List<Object> get props => [];
}
