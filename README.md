# DropZone Chauffeur

Private chauffeur app for airport & business transport in the UAE.

## Sprint 1
- Modern UI shell
- Booking flow skeleton
- Riverpod state management baseline
- go_router navigation
- EN/AR localization (RTL-ready)

## Getting Started
```bash
fvm flutter pub get
fvm flutter gen-l10n
fvm flutter run
```

## Lint/Test
```bash
fvm flutter analyze
fvm flutter test
```

## Pre-commit
```bash
./tool/pre-commit.sh
```

## Architecture
```
lib/
  presentation/
  domain/
  data/
  core/
```

## Branching
- main (production)
- develop (integration)
- release/sprint-N
- feature/sprint-N/short-name
- hotfix/issue
