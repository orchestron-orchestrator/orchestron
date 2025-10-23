.PHONY: build
build: src/orchestron/device_meta_config.act
	acton build $(DEP_OVERRIDES)

.PHONY: build-ldep
build-ldep: src/orchestron/device_meta_config.act
	$(MAKE) build DEP_OVERRIDES="--dep yang=../acton-yang --dep netconf=../netconf"

.PHONY: gen
gen: src/orchestron/device_meta_config.act

.PHONY: gen-ldep
gen-ldep: src/orchestron/device_meta_config.act
	$(MAKE) --always-make gen DEP_OVERRIDES="--dep yang=../acton-yang"

src/orchestron/device_meta_config.act: gen_dmc/out/bin/gen_dmc src/orchestron/yang.act
	gen_dmc/out/bin/gen_dmc

gen_dmc/out/bin/gen_dmc: gen_dmc/src/gen_dmc.act src/orchestron/yang.act
	cp -a src/orchestron/yang.act gen_dmc/src/oyang.act
	cd gen_dmc && acton build $(subst ../,../../,$(DEP_OVERRIDES))

.PHONY: test
test:
	acton test $(DEP_OVERRIDES)

.PHONY: test-ldep
test-ldep:
	$(MAKE) test DEP_OVERRIDES="--dep yang=../acton-yang"

.PHONY: pkg-upgrade
pkg-upgrade:
	acton pkg upgrade
	cd gen_dmc && acton pkg upgrade
	cd minisys && acton pkg upgrade
	cd minisys/gen && acton pkg upgrade

.PHONY: check-dep-consistency
check-dep-consistency:
	@python3 scripts/check_dep_consistency.py

.PHONY: test-mini
test-mini: check-mini-is-up-to-date
	$(MAKE) build-mini

.PHONY: check-mini-is-up-to-date
check-mini-is-up-to-date:
	cd minisys/gen && acton build && out/bin/gen
	git diff --exit-code

.PHONY: build-mini
build-mini:
	cd minisys && acton build
