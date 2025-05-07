.PHONY: build
build: src/orchestron/device_meta_config.act
	acton build --dev $(DEP_OVERRIDES)

.PHONY: build-ldep
build-ldep: src/orchestron/device_meta_config.act
	$(MAKE) build DEP_OVERRIDES="--dep yang=../acton-yang"

.PHONY: gen
gen: src/orchestron/device_meta_config.act

.PHONY: gen-ldep
gen-ldep: src/orchestron/device_meta_config.act
	$(MAKE) --always-make gen DEP_OVERRIDES="--dep yang=../acton-yang"

src/orchestron/device_meta_config.act: gen_dmc/out/bin/gen_dmc src/orchestron/yang.act
	gen_dmc/out/bin/gen_dmc

gen_dmc/out/bin/gen_dmc: gen_dmc/src/gen_dmc.act src/orchestron/yang.act
	cp -a src/orchestron/yang.act gen_dmc/src/oyang.act
	cd gen_dmc && acton build --dev $(subst ../,../../,$(DEP_OVERRIDES))

.PHONY: test
test:
	acton test $(DEP_OVERRIDES)

.PHONY: test-ldep
test-ldep:
	$(MAKE) test DEP_OVERRIDES="--dep yang=../acton-yang"