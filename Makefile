all: out/bin/respnet

.PHONY: out/bin/respnet
out/bin/respnet: src/respnet.act src/respnet/layer.act
	acton src/respnet.act

src/respnet/layer.act: out/bin/respnet_gen
	out/bin/respnet_gen --rts-no-bt

out/bin/respnet_gen: src/respnet_gen.act
	acton src/respnet_gen.act

out/bin/rfcgen: src/rfcgen.act
	acton src/rfcgen.act

.PHONY: clean
clean:
	rm -rf out

