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

PROTO_FILES := \
	app_center/v1/application_filter/application_filter.proto \
	app_center/v1/application_filter/error_reason.proto \
	app_center/v1/oauth_client/oauth_client_provider.proto \
	app_center/v1/oauth_client/oauth_client.proto \
	app_center/v1/oauth_client/error_reason.proto \
	app_center/v1/application_profile_review/application_profile_review.proto \
	app_center/v1/application_profile_review/error_reason.proto \
	app_center/v1/application_profile_revision/application_profile_revision.proto \
	app_center/v1/application_profile_revision/error_reason.proto \
	app_center/v1/catalog/catalog.proto \
	app_center/v1/catalog/error_reason.proto \
	app_center/v1/tester_membership/tester_membership.proto \
	app_center/v1/tester_membership/error_reason.proto \
	app_center/v1/application_publication/application_publication.proto \
	app_center/v1/application_publication/error_reason.proto \
	app_center/v1/tester_join_link/tester_join_link.proto \
	app_center/v1/tester_join_link/error_reason.proto \
	auth_center/v1/identity/identity.proto \
	auth_center/v1/user_profile/user_profile.proto \
	auth_center/v1/authentication/authentication.proto \
	app_center/v1/application/application.proto \
	app_center/v1/application/error_reason.proto \
	app_center/v1/application_review/application_review.proto \
	app_center/v1/application_review/error_reason.proto \
	app_center/v1/application_version/application_version.proto \
	app_center/v1/application_version/error_reason.proto \
	auth_center/v1/developer_status/developer_status.proto \
	auth_center/v1/developer_status/error_reason.proto \
	auth_center/v1/scope_catalog/scope_catalog.proto \
	auth_center/v1/scope_catalog/error_reason.proto \
	auth_center/v1/system_principal/system_principal.proto \
	auth_center/v1/system_principal/error_reason.proto

HTTP_PROTO_FILES := \
	app_center/v1/application_filter/application_filter.proto \
	app_center/v1/application_filter/error_reason.proto \
	app_center/v1/oauth_client/oauth_client.proto \
	app_center/v1/oauth_client/error_reason.proto \
	app_center/v1/application_profile_review/application_profile_review.proto \
	app_center/v1/application_profile_review/error_reason.proto \
	app_center/v1/application_profile_revision/application_profile_revision.proto \
	app_center/v1/application_profile_revision/error_reason.proto \
	app_center/v1/catalog/catalog.proto \
	app_center/v1/catalog/error_reason.proto \
	app_center/v1/tester_membership/tester_membership.proto \
	app_center/v1/tester_membership/error_reason.proto \
	app_center/v1/application_publication/application_publication.proto \
	app_center/v1/application_publication/error_reason.proto \
	app_center/v1/tester_join_link/tester_join_link.proto \
	app_center/v1/tester_join_link/error_reason.proto \
	auth_center/v1/authentication/authentication.proto \
	auth_center/v1/user_profile/user_profile.proto \
	app_center/v1/application/application.proto \
	app_center/v1/application/error_reason.proto \
	app_center/v1/application_review/application_review.proto \
	app_center/v1/application_review/error_reason.proto \
	app_center/v1/application_version/application_version.proto \
	app_center/v1/application_version/error_reason.proto

GENERATED_DIRS := \
	app_center/v1/application_filter \
	app_center/v1/oauth_client \
	app_center/v1/application_profile_review \
	app_center/v1/application_profile_revision \
	app_center/v1/catalog \
	app_center/v1/tester_membership \
	app_center/v1/tester_join_link \
	app_center/v1/application_publication \
	auth_center/v1/identity \
	auth_center/v1/user_profile \
	auth_center/v1/authentication \
	app_center/v1/application \
	app_center/v1/application_review \
	app_center/v1/application_version \
	auth_center/v1/developer_status \
	auth_center/v1/scope_catalog \
	auth_center/v1/system_principal

.PHONY: proto-gen
proto-gen:
	$(PROTOC) -I $(PROTO_ROOT) -I $(THIRD_PARTY) \
		--go_out=paths=source_relative:$(GEN_OUT) \
		--go-grpc_out=paths=source_relative:$(GEN_OUT) \
		$(PROTO_FILES)
	$(PROTOC) -I $(PROTO_ROOT) -I $(THIRD_PARTY) \
		--go-http_out=paths=source_relative:$(GEN_OUT) \
		$(HTTP_PROTO_FILES)

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

# proto-check regenerates the managed Proto files into a throwaway directory with
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
		$(PROTO_FILES) || exit 1; \
	$(PROTOC) -I $(PROTO_ROOT) -I $(THIRD_PARTY) \
		--go-http_out=paths=source_relative:$$tmp \
		$(HTTP_PROTO_FILES) || exit 1; \
	failed=0; \
	for dir in $(GENERATED_DIRS); do \
		if ! diff -ru "$(GEN_OUT)/$$dir" "$$tmp/$$dir"; then failed=1; fi; \
	done; \
	if [ "$$failed" -ne 0 ]; then \
		echo ""; \
		echo "proto-check FAILED: generated code drifted from one or more managed packages."; \
		echo "Run 'make proto-gen' and commit the regenerated files."; \
		exit 1; \
	fi; \
	echo "proto-check OK: managed generated packages match $(PROTO_FILES)"
