.PHONY: install update test exp-req

install:
	@poetry install
update:
	@poetry update	
test:
	@poetry run pytest -v
exp-req:
	@poetry export -f requirements.txt --without-hashes  > requirements.txt
	@poetry export --dev -f requirements.txt --without-hashes  > dev-requirements.txt
