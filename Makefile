# Reproducible Proto generation for the independent API repository.
#
# Toolchain the committed code was generated with (also embedded in every
# generated header, so a version mismatch makes `proto-check` fail):
#   protoc             3.21.12
#   protoc-gen-go      v1.36.10
#   protoc-gen-go-grpc v1.6.0
#   protoc-gen-go-http v2.9.2
#
# Generated files are committed next to their inputs: never hand-edit anything
# under gen/. The service repository consumes gen/ through a pinned submodule
# revision (ADR-006).

PROTOC ?= protoc
PROTOC_GEN_GO ?= protoc-gen-go
PROTOC_GEN_GO_GRPC ?= protoc-gen-go-grpc
PROTOC_GEN_GO_HTTP ?= protoc-gen-go-http

PROTO_ROOT := .
THIRD_PARTY := third_party
GEN_OUT := gen/go

PKG_DIR := app_center/v1/application
GENERATED_DIR := $(GEN_OUT)/$(PKG_DIR)

PROTO_FILES := \
	app_center/v1/application/application.proto \
	app_center/v1/application/error_reason.proto

.PHONY: proto-gen
proto-gen:
	$(PROTOC) -I $(PROTO_ROOT) -I $(THIRD_PARTY) \
		--go_out=paths=source_relative:$(GEN_OUT) \
		--go-grpc_out=paths=source_relative:$(GEN_OUT) \
		--go-http_out=paths=source_relative:$(GEN_OUT) \
		$(PROTO_FILES)

.PHONY: proto-tools
proto-tools:
	@command -v $(PROTOC) >/dev/null || { echo "missing $(PROTOC)"; exit 1; }
	@command -v $(PROTOC_GEN_GO) >/dev/null || { echo "missing $(PROTOC_GEN_GO)"; exit 1; }
	@command -v $(PROTOC_GEN_GO_GRPC) >/dev/null || { echo "missing $(PROTOC_GEN_GO_GRPC)"; exit 1; }
	@command -v $(PROTOC_GEN_GO_HTTP) >/dev/null || { echo "missing $(PROTOC_GEN_GO_HTTP)"; exit 1; }
	@echo "protoc:              $$($(PROTOC) --version)"
	@echo "protoc-gen-go:       $$($(PROTOC_GEN_GO) --version)"
	@echo "protoc-gen-go-grpc:  $$($(PROTOC_GEN_GO_GRPC) --version)"
	@echo "protoc-gen-go-http:  $$($(PROTOC_GEN_GO_HTTP) --version)"

# proto-check regenerates the two Proto files into a throwaway directory with
# the same arguments as proto-gen and requires the committed output to match
# byte-for-byte. Because generated headers embed the protoc/plugin versions,
# this also fails when the installed toolchain differs from the committed one.
# It never writes into the repository.
.PHONY: proto-check
proto-check: proto-tools
	@tmp=$$(mktemp -d); \
	trap 'rm -rf "$$tmp"' EXIT; \
	$(PROTOC) -I $(PROTO_ROOT) -I $(THIRD_PARTY) \
		--go_out=paths=source_relative:$$tmp \
		--go-grpc_out=paths=source_relative:$$tmp \
		--go-http_out=paths=source_relative:$$tmp \
		$(PROTO_FILES) || exit 1; \
	if ! diff -ru "$(GENERATED_DIR)" "$$tmp/$(PKG_DIR)"; then \
		echo ""; \
		echo "proto-check FAILED: generated code drifted from $(GENERATED_DIR)."; \
		echo "Run 'make proto-gen' and commit the regenerated files."; \
		exit 1; \
	fi; \
	echo "proto-check OK: $(PKG_DIR) matches $(PROTO_FILES)"
