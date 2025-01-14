import 'id_name_model.dart';

final class TraderDataValidationModel implements Exception {
  final int? id;
  final String? store;
  final String? mapUrl;
  final int? isSpecialStore;
  final List<IdNameModel>? categories;
  final String? registrationNumber;
  final String? licenseNumber;
  final String? idNumber;
  final String? image;
  final String? message;

  const TraderDataValidationModel({
    this.id,
    this.store,
    this.mapUrl,
    this.isSpecialStore,
    this.categories,
    this.registrationNumber,
    this.licenseNumber,
    this.idNumber,
    this.image,
    this.message,
  });

  factory TraderDataValidationModel.errorsFromMap(
    Map<String, List> map,
    String message,
  ) {
    return TraderDataValidationModel(
      store: map['store.name']?.join('\n'),
      mapUrl: map['store.map_url']?.join('\n'),
      registrationNumber: map['store.registration_number']?.join('\n'),
      licenseNumber: map['store.facility_number']?.join('\n'),
      idNumber: map['store.id_number']?.join('\n'),
      message: message,
    );
  }

  factory TraderDataValidationModel.fromMap(Map<String, dynamic> map) {
    final isSpecialties = map['special_store'];
    return TraderDataValidationModel(
      id: map['id'],
      store: map['name'],
      mapUrl: map['map_url'],
      isSpecialStore: isSpecialties,
      categories: isSpecialties == 1
          ? List<Map<String, dynamic>>.from(map['categories'])
              .map(IdNameModel.fromMap)
              .toList()
          : null,
      registrationNumber: map['registration_number'],
      licenseNumber: map['facility_number'],
      idNumber: map['id_number'],
      image: map['image'],
    );
  }

  Map<String, String> toAuthMap() {
    return {
      'store[name]': store!,
      'store[map_url]': mapUrl!,
      'store[special_store]': '$isSpecialStore',
      for (int i = 0; i < categories!.length; i++)
        'category[$i]': '${categories![i].id}',
      'store[registration_number]': registrationNumber!,
      'store[facility_number]': licenseNumber!,
      'store[id_number]': idNumber!,
    };
  }

  Map<String, String> toStoreMap() {
    return {
      'name': store!,
      'map_url': mapUrl!,
      'special_store': '$isSpecialStore',
      for (int i = 0; i < categories!.length; i++)
        'category[$i]': '${categories![i].id}',
      'registration_number': registrationNumber!,
      'facility_number': licenseNumber!,
      'id_number': idNumber!,
    };
  }
}
