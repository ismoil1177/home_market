import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_market/models/facilities_model.dart';
import 'package:home_market/models/message_model.dart';
import 'package:home_market/services/firebase/db_service.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<CreatePostEvent>(_createPost);
    on<DeletePostEvent>(_deletePost);
    on<UpdatePostEvent>(_updatePost);
    on<WriteCommentPostEvent>(_writeComment);
    on<ViewGridImagesPostEvent>(_viewGridImages);
    on<PostIsApartmentEvent>(_changeIsApartment);
    on<FacilitiesPostEvent>(_facilities);
    on<UpdateLikePostEvent>(_updateLikePost);
  }

  void _changeIsApartment(PostIsApartmentEvent event, Emitter emit) {
    emit(PostIsApartmentState(event.isApartment));
  }

  void _facilities(FacilitiesPostEvent event, Emitter emit) {
    emit(PostLoading());
    if (!event.facilities.contains(event.facility)) {
      event.facilities.add(event.facility);
    } else {
      event.facilities.remove(event.facility);
    }
    emit(FacilitiesSuccessState(
        facilities: event.facilities, facility: event.facility));
  }

  void _createPost(CreatePostEvent event, Emitter emit) async {
    emit(PostLoading());
    final result = await DBService.storePost(
      gridImages: event.gridImages,
      title: event.title,
      content: event.content,
      facilities: event.facilities,
      area: event.area,
      bathrooms: event.bathrooms,
      isApartment: event.isApartment,
      phone: event.phone,
      price: event.price,
      rooms: event.rooms,
      lat: event.lat,
      long: event.long,
    );
    if (result) {
      emit(CreatePostSuccess());
    } else {
      emit(const PostFailure("Something error, tyr again later!!!"));
    }
  }

  void _viewGridImages(ViewGridImagesPostEvent event, Emitter emit) {
    emit(ViewGridImagesPostSuccess(event.files));
  }

  void _deletePost(DeletePostEvent event, Emitter emit) async {
    emit(PostLoading());
    final result = await DBService.deletePost(event.postId, event.postImages);

    if (result) {
      emit(DeletePostSuccess());
    } else {
      emit(const PostFailure("Something error"));
    }
  }

  void _updatePost(UpdatePostEvent event, Emitter emit) async {
    emit(PostLoading());
    final result = await DBService.updatePost(
      isLiked: event.isLiked,
      imagesUri: event.imagesUri,
      gridImages: event.gridImages,
      postId: event.postId,
      title: event.title,
      content: event.content,
      facilities: event.facilities,
      area: event.area,
      bathrooms: event.bathrooms,
      isApartment: event.isApartment,
      phone: event.phone,
      price: event.price,
      rooms: event.rooms,
      lat: event.lat,
      long: event.long,
    );
    if (result) {
      emit(UpdatePostSuccess());
    } else {
      emit(const PostFailure("Something error, tyr again later!!!"));
    }
  }

  void _updateLikePost(UpdateLikePostEvent event, Emitter emit) async {
    emit(PostLoading());
    final result = await DBService.updateLikePost(
      userId: event.userId,
      email: event.email,
      userName: event.userName,
      gridImages: event.gridImages,
      postId: event.postId,
      title: event.title,
      content: event.content,
      facilities: event.facilities,
      area: event.area,
      bathrooms: event.bathrooms,
      isApartment: event.isApartment,
      isLiked: event.isLiked,
      phone: event.phone,
      price: event.price,
      rooms: event.rooms,
      lat: event.lat,
      long: event.long,
    );
    if (result) {
      emit(UpdateLikePostSuccess());
    } else {
      emit(const PostFailure("Something error, tyr again later!!!"));
    }
  }

  void _writeComment(WriteCommentPostEvent event, Emitter emit) async {
    emit(PostLoading());
    final result =
        await DBService.writeMessage(event.postId, event.message, event.old);
    if (result) {
      emit(const WriteCommentPostSuccess());
    } else {
      emit(const PostFailure("Something error, tyr again later!!!"));
    }
  }
}
