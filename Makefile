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
		ansible \
        molecule \
        docker
	venv/bin/python -m pip freeze | grep -v "pkg-resources" > requirements.txt

create:
	ansible-galaxy init ${ROLE_NAME}
	molecule init scenario
	mv ${ROLE_NAME}/* .
	mv ${ROLE_NAME}/.travis.yml .
	rm -d ${ROLE_NAME}

lint: install
	command -v ansible-lint || pip install --upgrade \
        ansible-lint
	# command -v ansible-lint || pip install --upgrade \
    #     ansible-lint
	molecule lint

test: install
	molecule test
