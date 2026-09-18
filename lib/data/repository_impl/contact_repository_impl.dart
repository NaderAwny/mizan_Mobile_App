import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/contact_remote_data_source.dart';
import 'package:mizan/data/mapper/contact_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/request/contact_request.dart';
import 'package:mizan/data/response/contact_responses/contact_responses.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/repository/contact_repository.dart';

@LazySingleton(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource contactRemoteDataSource;
  final NetworkInfo networkInfo;

  ContactRepositoryImpl(this.contactRemoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, Contact>> createContact(
    CreateContactRequest createContactRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await contactRemoteDataSource.createContact(
          createContactRequest,
        );
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ContactsPage>> getContacts(
    GetContactsRequest getContactsRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await contactRemoteDataSource.getContacts(
          getContactsRequest,
        );
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ContactsPage>> getVipContacts(
    GetVipContactsRequest getVipContactsRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await contactRemoteDataSource.getVipContacts(
          getVipContactsRequest,
        );
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Contact>> getContactById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await contactRemoteDataSource.getContactById(id);
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Contact>> toggleVip(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await contactRemoteDataSource.toggleVip(id);
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ContactProfile>> getContactProfile(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final profileFuture = contactRemoteDataSource.getContactProfile(id);
        final contactFuture = contactRemoteDataSource
            .getContactById(id)
            .catchError((_) => ContactResponse());

        final results = await Future.wait([profileFuture, contactFuture]);
        final profileRes = results[0] as ContactProfileResponse;
        final contactRes = results[1] as ContactResponse;

        if (profileRes.success != true && contactRes.success != true) {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              profileRes.message ??
                  contactRes.message ??
                  ResponseMessage.DEAFULT,
            ),
          );
        }

        final domain = profileRes.data.toDomain();
        final contactDomain = contactRes.data?.toDomain();

        final resolvedNotes = domain.notes.trim().isNotEmpty
            ? domain.notes
            : (contactDomain?.notes ?? '');

        final combined = domain.copyWith(
          notes: resolvedNotes,
          contactName: domain.contactName.isNotEmpty
              ? domain.contactName
              : (contactDomain?.name ?? ''),
          phoneNumber: domain.phoneNumber.isNotEmpty
              ? domain.phoneNumber
              : (contactDomain?.phoneNumber ?? ''),
          contactEmail: domain.contactEmail.isNotEmpty
              ? domain.contactEmail
              : (contactDomain?.contactEmail ?? ''),
          isVip: domain.isVip || (contactDomain?.isVip ?? false),
        );

        return Right(combined);
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Contact>> updateContact(
    UpdateContactRequest updateContactRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await contactRemoteDataSource.updateContact(
          updateContactRequest,
        );
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteContact(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await contactRemoteDataSource.deleteContact(id);
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
