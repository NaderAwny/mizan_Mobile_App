import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/domain/model/transaction_model.dart';
import 'package:mizan/domain/repository/transaction_repository.dart';
import 'package:mizan/domain/use_case/create_transaction_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/transactions/transaction_form_cubit/transaction_form_cubit.dart';

class FakeTransactionRepository implements TransactionRepository {
  CreateTransactionRequest? lastRequest;
  bool shouldSucceed = true;

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    CreateTransactionRequest request,
  ) async {
    lastRequest = request;
    if (shouldSucceed) {
      return Right(
        Transaction(
          id: 'test-id',
          contactId: request.contactId ?? '',
          contactName: request.partyName ?? '',
          type: request.type,
          amount: request.amount,
          paymentMethod: request.paymentMethod,
          transactionDate: request.transactionDate,
          isInstallment: request.isInstallment,
          installments: const [],
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
    } else {
      return Left(Failure(400, 'Server error'));
    }
  }

  @override
  Future<Either<Failure, TransactionbyidModel>> getTransactionById(String id) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }
}

void main() {
  late FakeTransactionRepository fakeRepository;
  late CreateTransactionUseCase useCase;
  late TransactionFormCubit cubit;

  setUp(() {
    fakeRepository = FakeTransactionRepository();
    useCase = CreateTransactionUseCase(fakeRepository);
    cubit = TransactionFormCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('TransactionFormCubit Tests (4.1 to 4.6)', () {
    test(
      'Fails validation if both contactId and partyName are missing',
      () async {
        final request = CreateTransactionRequest(
          type: 'Sale',
          amount: 500,
          paymentMethod: 'Cash',
          transactionDate: DateTime.now().toIso8601String(),
        );

        await cubit.submit(request);

        expect(cubit.state.flowState, isA<ErrorState>());
        expect(
          (cubit.state.flowState as ErrorState).message,
          'يجب تحديد عميل/مورد أو كتابة اسم الطرف',
        );
        expect(cubit.state.isActionSuccess, false);
      },
    );

    test('Fails validation if amount <= 0', () async {
      final request = CreateTransactionRequest(
        partyName: 'طرف تجريبي',
        type: 'Sale',
        amount: 0,
        paymentMethod: 'Cash',
        transactionDate: DateTime.now().toIso8601String(),
      );

      await cubit.submit(request);

      expect(cubit.state.flowState, isA<ErrorState>());
      expect(
        (cubit.state.flowState as ErrorState).message,
        'المبلغ يجب أن يكون أكبر من صفر',
      );
    });

    test('4.1 Cash Sale succeeds with valid contact and amount', () async {
      final request = CreateTransactionRequest(
        contactId: 'contact-123',
        type: 'Sale',
        amount: 500,
        paymentMethod: 'Cash',
        transactionDate: DateTime.now().toIso8601String(),
      );

      await cubit.submit(request);

      expect(cubit.state.flowState, isA<ContentState>());
      expect(cubit.state.isActionSuccess, true);
      expect(cubit.state.savedTransaction?.id, 'test-id');
      expect(cubit.state.savedTransaction?.type, 'Sale');
      expect(cubit.state.savedTransaction?.amount, 500);
    });

    test('4.2 Cash Purchase succeeds with partyName', () async {
      final request = CreateTransactionRequest(
        partyName: 'مورد الأمل',
        type: 'Purchase',
        amount: 1500,
        paymentMethod: 'Cash',
        transactionDate: DateTime.now().toIso8601String(),
      );

      await cubit.submit(request);

      expect(cubit.state.flowState, isA<ContentState>());
      expect(cubit.state.isActionSuccess, true);
      expect(cubit.state.savedTransaction?.type, 'Purchase');
      expect(cubit.state.savedTransaction?.contactName, 'مورد الأمل');
    });

    test('4.3 & 4.4 Automatic Installment fails if count <= 0', () async {
      final request = CreateTransactionRequest(
        partyName: 'عميل تقسيط',
        type: 'Sale',
        amount: 3000,
        paymentMethod: 'Installments',
        transactionDate: DateTime.now().toIso8601String(),
        isInstallment: true,
        installmentPlanMode: 'Automatic',
        installmentCount: 0,
        frequency: 'Monthly',
      );

      await cubit.submit(request);

      expect(cubit.state.flowState, isA<ErrorState>());
      expect(
        (cubit.state.flowState as ErrorState).message,
        'عدد الأقساط يجب أن يكون أكبر من صفر',
      );
    });

    test('4.5 & 4.6 Custom Installment fails if sum != amount', () async {
      final request = CreateTransactionRequest(
        partyName: 'عميل تقسيط يدوي',
        type: 'Sale',
        amount: 3000,
        paymentMethod: 'Installments',
        transactionDate: DateTime.now().toIso8601String(),
        isInstallment: true,
        installmentPlanMode: 'Custom',
        customInstallments: [
          CustomInstallmentItem(amount: 1000, dueDate: '2026-10-01'),
          CustomInstallmentItem(amount: 1500, dueDate: '2026-11-01'),
        ], // sum = 2500 != 3000
      );

      await cubit.submit(request);

      expect(cubit.state.flowState, isA<ErrorState>());
      expect(
        (cubit.state.flowState as ErrorState).message,
        contains('لا يساوي المبلغ الإجمالي'),
      );
    });

    test('4.5 & 4.6 Custom Installment succeeds when sum == amount', () async {
      final request = CreateTransactionRequest(
        partyName: 'عميل تقسيط يدوي متطابق',
        type: 'Sale',
        amount: 3000,
        paymentMethod: 'Installments',
        transactionDate: DateTime.now().toIso8601String(),
        isInstallment: true,
        installmentPlanMode: 'Custom',
        customInstallments: [
          CustomInstallmentItem(amount: 1500, dueDate: '2026-10-01'),
          CustomInstallmentItem(amount: 1500, dueDate: '2026-11-01'),
        ], // sum = 3000 == 3000
      );

      await cubit.submit(request);

      expect(cubit.state.flowState, isA<ContentState>());
      expect(cubit.state.isActionSuccess, true);
    });
  });
}
