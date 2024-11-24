


src/orchestron/device_meta_config.act: gen_dmc/out/bin/gen_dmc src/orchestron/yang.act
	gen_dmc/out/bin/gen_dmc

gen_dmc/out/bin/gen_dmc: gen_dmc/src/gen_dmc.act src/orchestron/yang.act
	cp -a src/orchestron/yang.act gen_dmc/src/oyang.act
	cd gen_dmc && acton build
