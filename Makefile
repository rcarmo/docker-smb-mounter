export IMAGE_NAME=rcarmo/smb-mounter
export RW_SHARES?=//server/share1 //server/share2
export RO_SHARES?=//server/share3
export VCS_REF=`git rev-parse --short HEAD`
export VCS_URL=https://github.com/rcarmo/docker-smb-mounter
export BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
export DATA_FOLDER?=${CURDIR}/data
export TEMP_FOLDER?=${CURDIR}/tmp
include .env
export $(shell sed 's/=.*//' envfile)
build:
	docker build \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		-t $(IMAGE_NAME) .

run:
	-mkdir -p $(DATA_FOLDER)
	-mkdir -p $(TEMP_FOLDER)
	docker run \
		-v $(DATA_FOLDER):/mnt \
		-v $(TEMP_FOLDER):/tmp \
		--security-opt apparmor:unconfined \
		--cap-add SYS_ADMIN \
		--cap-add DAC_READ_SEARCH \
		--env RO_SHARES="$(RO_SHARES)" \
		--env RO_USERNAME=$(RO_USERNAME) \
		--env RO_PASSWORD=$(RO_PASSWORD) \
		--env RW_SHARES="$(RW_SHARES)" \
		--env RW_USERNAME=$(RW_USERNAME) \
		--env RW_PASSWORD=$(RW_PASSWORD) \
		--net=host -it $(IMAGE_NAME)
