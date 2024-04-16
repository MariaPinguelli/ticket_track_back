# README

## Instalação do ambiente
- Ruby
  - Windows: https://rubyinstaller.org/downloads/
  - Linux: `sudo apt install ruby-full`
- Rails
  - `gem install rails -v 7.1.3`
- PostgreSQL
  - Windows: https://www.postgresql.org/download/windows/
  - Linux: https://www.postgresql.org/download/linux/

Após instalar tudo, execute os seguintes comandos dentro da pasta do projeto:
- `bundle install`
- `rails db:migrate`

## Rotas
Para listar todas no terminal use:
`rails routes`

Listas existentes:
| Método | Rota | Resposta |
|---|---|---|
| GET    | /users | Todos os usuários cadastrados |
| GET    | /users/id | Um usuário |
| POST   | /users | Usuário cadastrado |
| PUT    | /users/id | Usuário atualizado |
| DELETE | /users/id | Confirmação de deleção |
---