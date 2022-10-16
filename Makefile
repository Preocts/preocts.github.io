.PHONEY: install
install:
	python -m pip install -r requirements.txt
	python -m pip install pre-commit
	pre-commit install

.PHONEY: update
update:
	python -m pip install pip-tools
	pip-compile
	python -m pip install -r requirements.txt
	pre-commit autoupdate
