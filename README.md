# Meu blog

Pra rodar o blog você precisa do rvm:

    curl -sSL https://get.rvm.io | bash -s stable

Reinicie o terminal, e instale a versão 2.0 do Ruby:

    rvm install 2.0.0

Inicie o interpratador do ruby:

    rvm use 2.0.0

Instale o bundle:

    gem install bundle

Instale as dependências do blog:

    bundle install

Pra rodar o blog basta rodar:

    jekyll -w serve

Aí basta acessar localhost:4000 no browser
