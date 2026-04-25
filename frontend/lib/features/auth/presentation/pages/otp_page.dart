import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/constants/app_strings.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class OTPPage extends ConsumerStatefulWidget {
  const OTPPage({super.key}) : super();

  @override
  ConsumerState<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  late PageController _pageController;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void _sendOTP() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.invalidPhone)),
      );
      return;
    }

    ref.read(authProvider.notifier).sendOTP(phone);
    
    // Move to OTP page
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _verifyOTP() {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.invalidOTP)),
      );
      return;
    }

    ref.read(authProvider.notifier).verifyOTP(phone, otp);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // Phone input page
          _buildPhonePage(context, authState),
          
          // OTP verification page
          _buildOTPPage(context, authState),
        ],
      ),
    );
  }

  Widget _buildPhonePage(BuildContext context, AuthState authState) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Text(
              AppStrings.enterPhone,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 16),
            Text(
              'We\'ll send you a verification code',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey600,
              ),
            ),
            SizedBox(height: 32),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: AppStrings.phoneHint,
                prefixIcon: Icon(Icons.phone),
                enabled: !authState.isLoading,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _sendOTP,
                child: authState.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.white),
                        ),
                      )
                    : Text(AppStrings.sendOTP),
              ),
            ),
            if (authState.error case final error?) ...[
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error.message,
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOTPPage(BuildContext context, AuthState authState) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            GestureDetector(
              onTap: () => _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Icon(Icons.arrow_back),
            ),
            SizedBox(height: 24),
            Text(
              AppStrings.verifyOTP,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 16),
            Text(
              'Enter the 6-digit code sent to ${phoneController.text}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey600,
              ),
            ),
            SizedBox(height: 32),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: InputDecoration(
                hintText: '000000',
                enabled: !authState.isLoading,
                counterText: '',
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _verifyOTP,
                child: authState.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.white),
                        ),
                      )
                    : Text(AppStrings.confirm),
              ),
            ),
            if (authState.error case final error?) ...[
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error.message,
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
