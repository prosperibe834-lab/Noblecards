import re
from pathlib import Path

root = Path(r'C:\Users\USER PC\noble_cards')
files = [
    'lib/screens/analytics_screen.dart',
    'lib/screens/deposit_payment_screen.dart',
    'lib/screens/deposit_screen.dart',
    'lib/screens/deposit_success_screen.dart',
    'lib/screens/favorite_currencies_screen.dart',
    'lib/screens/transaction_details_screen.dart',
    'lib/screens/transaction_history_screen.dart',
    'lib/screens/wallet_screen.dart',
    'lib/screens/withdraw_screen.dart',
    'lib/widgets/biometric_auth_widget.dart',
    'lib/widgets/custom_app_bar.dart',
    'lib/widgets/custom_back_button.dart',
    'lib/widgets/custom_button.dart',
    'lib/widgets/custom_loader.dart',
    'lib/widgets/empty_state_widget.dart',
    'lib/widgets/loading_shimmer.dart',
    'lib/widgets/network_error_widget.dart',
    'lib/widgets/pin_input_widget.dart',
    'lib/widgets/wallet_action_button.dart',
    'lib/widgets/wallet_balance_card.dart',
    'lib/widgets/wallet_transaction_tile.dart'
]

for rel in files:
    path = root / rel
    text = path.read_text(encoding='utf-8')
    needs_colors = bool(re.search(r'\bAppColors\b', text)) and not re.search(r'import\s+["\"][^"\"]*app_colors\.dart["\"]', text)
    needs_spacing = bool(re.search(r'\bAppSpacing\b', text)) and not re.search(r'import\s+["\"][^"\"]*app_spacing\.dart["\"]', text)
    if needs_colors or needs_spacing:
        lines = text.splitlines()
        insert_index = 0
        for i, line in enumerate(lines):
            if line.startswith('import '):
                insert_index = i + 1
                continue
            if line.strip() == '' or line.strip().startswith('//'):
                continue
            if insert_index > 0:
                break
        new_lines = lines[:insert_index]
        if needs_colors:
            if new_lines and new_lines[-1].strip() != '':
                new_lines.append('')
            new_lines.append("import '../theme/app_colors.dart';")
        if needs_spacing:
            if new_lines and new_lines[-1].strip() != '':
                new_lines.append('')
            new_lines.append("import '../theme/app_spacing.dart';")
        new_lines.extend(lines[insert_index:])
        path.write_text('\n'.join(new_lines) + '\n', encoding='utf-8')
        print(f'Patched {rel}')
    else:
        print(f'No patch needed for {rel}')
