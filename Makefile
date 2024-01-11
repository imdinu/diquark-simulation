IMAGE_NAME := pythia-delphes
IMAGE_TAG := 8.310_3.5.0
USER_NAME := "ioandinu"

# Build the Docker image
build:
	DOCKER_BUILDKIT=1 docker build --target=runtime . -t $(IMAGE_NAME):$(IMAGE_TAG)
	docker compose create
.PHONY: build

# Push the Docker image to Docker Hub
push:
    # Tag with the specific version
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(USER_NAME)/$(IMAGE_NAME):$(IMAGE_TAG)
    # Tag with the 'latest' tag
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(USER_NAME)/$(IMAGE_NAME):latest
    # Push both tags
	docker push $(USER_NAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(USER_NAME)/$(IMAGE_NAME):latest
.PHONY: push

# Pull the Docker image from Docker Hub
pull:
	docker pull ${USER_NAME}/$(IMAGE_NAME):latest
.PHONY: pull

# Run the full simulation
run: pull
	docker compose up
.PHONY: run

# Clean containers but keep images and volumes
clean:
	docker compose down
	@CONTAINERS=$$(docker ps -aq); \
	if [ -n "$$CONTAINERS" ]; then \
		docker rm $$CONTAINERS; \
	fi
.PHONY: clean

# clean everything
clean-all: clean
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)
	docker rmi $(USER_NAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker rmi $(USER_NAME)/$(IMAGE_NAME):latest
.PHONY: clean-all