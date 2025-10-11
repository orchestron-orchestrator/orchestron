PROJECT_DIR:=$(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../../)
# Set this env var to empty string if you have local cRPD, XRd container images
export IMAGE_PATH?=ghcr.io/orchestron-orchestrator/

ifeq (true,$(REMOTE_CONTAINERS))
CLAB_BIN:=containerlab
else ifeq (true,$(CODESPACES))
CLAB_BIN:=containerlab
else

CLAB_VERSION?=0.69.3
CLAB_CONTAINER_IMAGE?=ghcr.io/srl-labs/clab:$(CLAB_VERSION)
CLAB_BIN:=docker run --rm $(INTERACTIVE) --privileged \
    --network host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/run/netns:/var/run/netns \
    -v /etc/hosts:/etc/hosts \
    -v /var/lib/docker/containers:/var/lib/docker/containers \
	-v ${HOME}/.docker:/root/.docker \
    --pid="host" \
    -v $(PROJECT_DIR):$(PROJECT_DIR) \
    -e IMAGE_PATH=$(IMAGE_PATH) \
    -w $(CURDIR) \
    $(CLAB_CONTAINER_IMAGE) containerlab
endif
