import 'package:image_picker/image_picker.dart';

import '../repositories/market_reviews_repository.dart';

class SubmitMarketReview {
  const SubmitMarketReview(this._repository);

  final MarketReviewsRepository _repository;

  Future<void> call({
    required String name,
    required String date,
    required String text,
    required int rating,
    List<String> photos = const [],
  }) => _repository.submitReview(
    name: name,
    date: date,
    text: text,
    rating: rating,
    photos: photos,
  );

  Future<String> uploadPhoto(XFile photo) => _repository.uploadPhoto(photo);
}
