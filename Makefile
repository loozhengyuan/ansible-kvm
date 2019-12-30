ROLE_NAME = kvm

init:
	chmod -R +x .githooks
	git config core.hooksPath .githooks

install:
	pip install --upgrade \
        pip \
        setuptools \
        wheel
	pip install -r requirements.txt

requirements:
	test ! -d venv || rm -rf venv
	python3 -m venv venv
	venv/bin/python -m pip install --upgrade \
		pip \
		setuptools \
		wheel
	venv/bin/python -m pip install --upgrade \
		ansible
	venv/bin/python -m pip freeze | grep -v "pkg-resources" > requirements.txt

create:
	command -v ansible-galaxy || pip install --upgrade \
        ansible
	ansible-galaxy init ${ROLE_NAME}
	command -v molecule || pip install --upgrade \
        molecule \
        docker
	molecule init scenario
	mv ${ROLE_NAME}/* .
	mv ${ROLE_NAME}/.travis.yml .
	rm -d ${ROLE_NAME}

lint:
	command -v molecule || pip install --upgrade \
        molecule \
        docker
	molecule lint

test:
	command -v molecule || pip install --upgrade \
        molecule \
        docker
	molecule test
