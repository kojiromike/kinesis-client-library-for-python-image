.PHONY: build

all: build


build:
	docker build -t kojiromike/kclpy context
