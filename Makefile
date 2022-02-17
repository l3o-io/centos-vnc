CONTEXT = quay.io/l3o
IMAGE_NAME = centos-xfce-vnc
TARGET = stream8

PODMAN = podman
CPP = cpp

ifeq ($(TARGET),rockylinux8)
	DFILE := Containerfile.$(TARGET)
else
	DFILE := Containerfile.stream8
endif

all: build

Containerfile.stream8:
	$(CPP) -E Containerfile.stream8.in $@

Containerfile.rockylinux8:
	$(CPP) -E Containerfile.rockylinux8.in $@

Containerfile:
	$(CPP) -E $(DFILE).in $(DFILE)

build: $(DFILE)
	$(PODMAN) build -t $(CONTEXT)/$(IMAGE_NAME):$(TARGET) -f $(DFILE) .

run:
	$(PODMAN) container runlabel run $(CONTEXT)/$(IMAGE_NAME):$(TARGET)

clean:
	rm -f Containerfile.stream8 Containerfile.rockylinux8
