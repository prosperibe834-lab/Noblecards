import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import 'biometric_setup_screen.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;

  void _onKeyPress(String val) {
    if (_isConfirming) {
      if (_confirmPin.length < 4) {
        setState(() => _confirmPin += val);
      }
    } else {
      if (_pin.length < 4) {
        setState(() => _pin += val);
        if (_pin.length == 4) {
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() => _isConfirming = true);
          });
        }
      }
    }
  }

  void _onDelete() {
    if (_isConfirming) {
      if (_confirmPin.isNotEmpty) {
        setState(() => _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1));
      } else {
        setState(() => _isConfirming = false);
      }
    } else {
      if (_pin.isNotEmpty) {
        setState(() => _pin = _pin.substring(0, _pin.length - 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currentPin = _isConfirming ? _confirmPin : _pin;
    final isMatch = _isConfirming && _pin == _confirmPin && _confirmPin.length == 4;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              Text('Protect Your Account', style: textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Before using NobleCards, create your secure 4-digit transaction PIN.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                _isConfirming ? 'Confirm PIN' : 'Create PIN',
                style: textTheme.titleLarge,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Circle Indicator Row: ● ● ● ○
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < currentPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: isFilled ? AppColors.primary : AppColors.lightSubText,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isFilled ? '●' : '○',
                        style: TextStyle(
                          fontSize: 10,
                          color: isFilled ? Colors.white : AppColors.lightSubText,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(),

              if (isMatch) ...[
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BiometricSetupScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Numeric Keypad
              _buildKeypad(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(children: [_keyButton('1'), _keyButton('2'), _keyButton('3')]),
        const SizedBox(height: AppSpacing.md),
        Row(children: [_keyButton('4'), _keyButton('5'), _keyButton('6')]),
        const SizedBox(height: AppSpacing.md),
        Row(children: [_keyButton('7'), _keyButton('8'), _keyButton('9')]),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Expanded(child: SizedBox()),
            _keyButton('0'),
            Expanded(
              child: IconButton(
                onPressed: _onDelete,
                icon: const Icon(Boxicons.bx_left_arrow_alt, size: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _keyButton(String val) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyPress(val),
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          child: Text(
            val,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}