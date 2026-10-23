# sistema-clinica-veterinaria-sdm
Projeto A3 de Sistemas Distribuídos e Mobile - Gestão de Clínica Veterinária.

## Tecnologias escolhidas

| Parte | Tecnologia |
|---|---|
| Linguagem | Python 3 |
| Framework web / API | Flask |
| Banco de dados | SQLite (um arquivo `.db`, não precisa instalar nada) |
| Front-end | Páginas HTML com Jinja (templates do Flask) + Bootstrap |
| API do governo (simulada) | Um segundo app Flask, rodando em outra porta |

Por que essa escolha: é simples de ler e de rodar, tudo fica em uma só linguagem e a
comunicação entre a API da clínica e a API do governo (via HTTP) mostra a parte
"distribuída" da disciplina.

## Estrutura de pastas

```
clinica/        -> sistema da clínica (API privada + páginas web), porta 5000
api_governo/    -> API do governo simulada, porta 5001
```

## Como rodar

```bash
pip install -r requirements.txt

# terminal 1 - sistema da clínica
python clinica/app.py

# terminal 2 - API do governo
python api_governo/app.py
```

Depois abra http://localhost:5000 no navegador.

## Regra da vacina antirrábica

Toda vacina contra raiva é enviada para a API do governo. Se o envio falhar, a vacina
fica salva com `status_envio = 'pendente'` e pode ser reenviada pelo botão
"Tentar novamente".

## Modelagem do banco

O diagrama ER e a explicação de cada tabela estão em [`docs/modelagem.md`](docs/modelagem.md).
O SQL que cria as tabelas está em `clinica/banco.sql` e `api_governo/banco.sql`.
