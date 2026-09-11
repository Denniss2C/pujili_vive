# Makefile — Pujilí Vive
# Atajos de desarrollo. Requiere Flutter en el PATH.
# Con flavors activos, run/build SIEMPRE llevan --flavor (dev|prod).

.DEFAULT_GOAL := help
FLUTTER := flutter

.PHONY: help setup format format-check analyze test coverage check \
        run-dev run-prod apk-dev apk-prod aab-prod web clean

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-14s\033[0m %s\n",$$1,$$2}'

setup: ## flutter pub get
	$(FLUTTER) pub get

format: ## Formatea lib/ y test/
	dart format lib test

format-check: ## Verifica formato (falla si hay diff) — como el CI
	dart format --set-exit-if-changed lib test

analyze: ## Análisis estático (como el CI)
	$(FLUTTER) analyze --no-fatal-infos

test: ## Corre los tests
	$(FLUTTER) test

coverage: ## Tests con cobertura (genera coverage/lcov.info)
	$(FLUTTER) test --coverage

check: format-check analyze test ## Todo lo que valida el CI

run-dev: ## Corre la app (flavor dev)
	$(FLUTTER) run --flavor dev -t lib/main_dev.dart

run-prod: ## Corre la app (flavor prod)
	$(FLUTTER) run --flavor prod -t lib/main_prod.dart

apk-dev: ## APK debug (dev)
	$(FLUTTER) build apk --flavor dev -t lib/main_dev.dart --debug

apk-prod: ## APK release (prod)
	$(FLUTTER) build apk --flavor prod -t lib/main_prod.dart --release

aab-prod: ## App Bundle release (prod) para Play Store
	$(FLUTTER) build appbundle --flavor prod -t lib/main_prod.dart --release

web: ## Build web
	$(FLUTTER) build web

clean: ## Limpia artefactos de build
	$(FLUTTER) clean

