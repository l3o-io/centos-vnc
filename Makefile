CONTEXT = quay.io/l3o
IMAGE_NAME = centos-xfce-vnc
TARGET = stream9

PODMAN = podman
CPP = cpp

ifeq ($(TARGET),rockylinux8)
	DFILE := Containerfile.$(TARGET)
else ifeq ($(TARGET),rockylinux9)
	DFILE := Containerfile.$(TARGET)
else ifeq ($(TARGET),stream8)
	DFILE := Containerfile.stream8
else
	DFILE := Containerfile.stream9
endif

all: build

Containerfile.stream8:
	$(CPP) -E Containerfile.stream8.in $@

Containerfile.stream9:
	$(CPP) -E Containerfile.stream9.in $@

Containerfile.rockylinux8:
	$(CPP) -E Containerfile.rockylinux8.in $@

Containerfile.rockylinux9:
	$(CPP) -E Containerfile.rockylinux9.in $@

Containerfile:
	$(CPP) -E $(DFILE).in $(DFILE)

build: $(DFILE)
	$(PODMAN) build -t $(CONTEXT)/$(IMAGE_NAME):$(TARGET) -f $(DFILE) .

run:
	$(PODMAN) container runlabel run $(CONTEXT)/$(IMAGE_NAME):$(TARGET)

clean:
	rm -f Containerfile.stream8 Containerfile.stream9 Containerfile.rockylinux8 Containerfile.rockylinux9
