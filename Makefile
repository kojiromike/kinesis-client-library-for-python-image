.PHONY: build

all: build


build:
	docker build -t kojiromike/kcl context
