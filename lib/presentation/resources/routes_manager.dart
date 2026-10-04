import 'package:flutter/material.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/analytics/analytics_view.dart';
import 'package:mizan/presentation/auth_verification/auth_verification.dart';
import 'package:mizan/presentation/customers/contact_form_view.dart';
import 'package:mizan/presentation/customers/contact_profile_view.dart';
import 'package:mizan/presentation/customers/customers_view.dart';
import 'package:mizan/presentation/home.dart';
import 'package:mizan/presentation/installments/installments_history/installments_history_view.dart';
import 'package:mizan/presentation/installments/installments_view.dart';
import 'package:mizan/presentation/notifications/notifications_view.dart';
import 'package:mizan/presentation/onboarding/onboarding_view.dart';
import 'package:mizan/presentation/operations/quick_collect_view.dart';
import 'package:mizan/presentation/operations/quick_pay_view.dart';
import 'package:mizan/presentation/operations/quick_purchase_view.dart';
import 'package:mizan/presentation/operations/quick_sale_view.dart';
import 'package:mizan/presentation/register/register_view.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/select_user_type/select_user_type_view.dart';
import 'package:mizan/presentation/send_otp/send_otp_view.dart';
import 'package:mizan/presentation/splash/splash_view.dart';
import 'package:mizan/presentation/get_profile/get_profile.dart';
import 'package:mizan/presentation/operations/quick_transaction_args.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/transaction_by_id_view.dart';
import 'package:mizan/presentation/transactions/transactions_view.dart';

import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_view.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_view.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_cubit/get_voice_note_view.dart';

class Routes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String splashRoute = "/";
  static const String onBoardingRoute = "OnBoardingView";
  static const String registerRoute = "/register";
  static const String sendOtpRoute = "/sendOtp";
  static const String authVerificationRoute = "/authVerification";
  // Added: shown after Registration → before Onboarding
  static const String selectUserRoute = "/selectUser";
  static const String homeRoute = "/home";

  // Navigation Tabs & Sub-screens
  static const String customersRoute = "/customers";
  static const String contactFormRoute = "/contactForm";
  static const String contactProfileRoute = "/contactProfile";
  static const String transactionsRoute = "/transactions";
  static const String installmentsRoute = "/installments";
  static const String installmentsHistoryRoute = "/installmentsHistory";
  static const String analyticsRoute = "/analytics";
  static const String notificationsRoute = "/notifications";

  // Financial Operations
  static const String quickSaleRoute = "/quickSale";
  static const String quickPurchaseRoute = "/quickPurchase";
  static const String quickCollectRoute = "/quickCollect";
  static const String quickPayRoute = "/quickPay";
  static const String profileRoute = "/profile";

  // Transaction Details
  static const String transactionDetailsRoute = "/transactionDetails";

  // Voice Notes
  static const String voiceNotesListRoute = "/voiceNotes";
  static const String createVoiceNoteRoute = "/createVoiceNote";
  static const String voiceNoteDetailsRoute = "/voiceNoteDetails";
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthVerificationArgs — carries both the email and the auth source so that
// AuthVerification can navigate to the correct destination on success:
//   isFromRegistration == true  → Select User → Onboarding
//   isFromRegistration == false → Home (or Onboarding for now)
// ─────────────────────────────────────────────────────────────────────────────
class AuthVerificationArgs {
  final String? email;
  final bool isFromRegistration;

  const AuthVerificationArgs({this.email, this.isFromRegistration = false});
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute<void>(builder: (_) => const SplashView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute<void>(builder: (_) => const OnBoardingView());
      case Routes.registerRoute:
        return MaterialPageRoute<void>(builder: (_) => const RegisterView());
      case Routes.sendOtpRoute:
        final String? email = settings.arguments is String
            ? settings.arguments as String
            : null;
        return MaterialPageRoute<void>(builder: (_) => SendOtp(initialEmail: email));
      case Routes.authVerificationRoute:
        // Accept either a plain String (legacy/login path) or AuthVerificationArgs
        final Object? args = settings.arguments;
        final String? email;
        final bool isFromRegistration;
        if (args is AuthVerificationArgs) {
          email = args.email;
          isFromRegistration = args.isFromRegistration;
        } else if (args is String) {
          email = args;
          isFromRegistration = false;
        } else {
          email = null;
          isFromRegistration = false;
        }
        return MaterialPageRoute<void>(
          builder: (_) => AuthVerification(
            initialEmail: email,
            isFromRegistration: isFromRegistration,
          ),
        );
      case Routes.selectUserRoute:
        return MaterialPageRoute<void>(builder: (_) => const SelectUserTypeView());
      case Routes.homeRoute:
        return MaterialPageRoute<void>(builder: (_) => const HomeView());
      case Routes.customersRoute:
        return MaterialPageRoute<void>(builder: (_) => const CustomersView());
      case Routes.contactFormRoute:
        final Contact? contact = settings.arguments is Contact
            ? settings.arguments as Contact
            : null;
        return MaterialPageRoute<void>(
          builder: (_) => ContactFormView(contact: contact),
        );
      case Routes.contactProfileRoute:
        final String contactId = settings.arguments is String
            ? settings.arguments as String
            : "";
        return MaterialPageRoute<void>(
          builder: (_) => ContactProfileView(contactId: contactId),
        );
      case Routes.transactionsRoute:
        return MaterialPageRoute<void>(builder: (_) => const TransactionsView());
      case Routes.installmentsRoute:
        return MaterialPageRoute<void>(builder: (_) => const InstallmentsView());
      case Routes.installmentsHistoryRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const InstallmentsHistoryView(),
        );
      case Routes.analyticsRoute:
        return MaterialPageRoute<void>(builder: (_) => const AnalyticsView());
      case Routes.notificationsRoute:
        return MaterialPageRoute<void>(builder: (_) => const NotificationsView());
      case Routes.quickSaleRoute:
        final QuickTransactionArgs? args =
            settings.arguments is QuickTransactionArgs
            ? settings.arguments as QuickTransactionArgs
            : null;
        return MaterialPageRoute<void>(builder: (_) => QuickSaleView(args: args));
      case Routes.quickPurchaseRoute:
        final QuickTransactionArgs? args =
            settings.arguments is QuickTransactionArgs
            ? settings.arguments as QuickTransactionArgs
            : null;
        return MaterialPageRoute<void>(builder: (_) => QuickPurchaseView(args: args));
      case Routes.quickCollectRoute:
        return MaterialPageRoute<void>(builder: (_) => const QuickCollectView());
      case Routes.quickPayRoute:
        return MaterialPageRoute<void>(builder: (_) => const QuickPayView());
      case Routes.profileRoute:
        return MaterialPageRoute<void>(builder: (_) => const GetProfileView());
      case Routes.transactionDetailsRoute:
        final String transactionId = settings.arguments is String
            ? settings.arguments as String
            : "";
        final String id = settings.arguments is String
            ? settings.arguments as String
            : "";
        return MaterialPageRoute<void>(
          builder: (_) =>
              TransactionDetailsView(transactionId: transactionId, id: id),
        );
      case Routes.voiceNotesListRoute:
        return MaterialPageRoute<void>(builder: (_) => const GetVoiceNoteView());
      case Routes.createVoiceNoteRoute:
        return MaterialPageRoute<void>(builder: (_) => const CreateVoiceNoteView());
      case Routes.voiceNoteDetailsRoute:
        final String id = settings.arguments is String
            ? settings.arguments as String
            : "";
        return MaterialPageRoute<void>(builder: (_) => GetVoiceNoteByIdView(id: id));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.noRouteFound)),
        body: const Center(child: Text(AppStrings.noRouteFound)),
      ),
    );
  }
}
