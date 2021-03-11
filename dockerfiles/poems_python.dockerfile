# # Run from the main project directory (poetry-poems):
# docker build -t poems-py38 -f dockerfiles/poems_python.dockerfile .
# docker run -it --rm --name poems-py38 poems-py38

FROM python:3.9

RUN pip install poetry==1.0.10 virtualenv

WORKDIR /app

COPY ../dist/ /app/dist
RUN pip install dist/poetry-poems-0.1.0.tar.gz
# RUN pip install -i https://test.pypi.org/simple/ poetry-poems

# # Environments:
# 1) poetry env autogenerated
# 2) virtualenv
# 3) poetry env autogenerated in the project directory
RUN poetry new project1 && cd project1 && poetry install --no-dev --no-root
RUN poetry new project2 && cd project2 && poetry config --local virtualenvs.in-project true && virtualenv .venv
RUN poetry new project3 && cd project3 && poetry config --local virtualenvs.in-project true && poetry install --no-dev --no-root

RUN poems --add /app/project1 && poems --add /app/project2 && poems --add /app/project3

CMD ["bash"]