# Ciência de dados no futebol

Slides do minicurso apresentado na XIV Semana da Estatística (USP e UFSCar, São Carlos, outubro de 2026).

## Arquivos

- `draft.txt`: rascunho das ideias.
- `slides.qmd`: a apresentação, em Quarto (reveal.js).
- `custom.scss`: tema visual.
- `_quarto.yml`: configuração do projeto. A saída vai para `docs/`.

## Como renderizar

```sh
quarto render
```

Para editar com atualização automática no navegador:

```sh
quarto preview slides.qmd
```

O arquivo final fica em `docs/slides.html`.

Para gerar um único arquivo HTML, sem a pasta de recursos:

```sh
quarto render slides.qmd -M embed-resources:true
```
