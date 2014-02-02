---
layout: post
title: Login com curl
meta_description: Fazendo login com curl.
meta_keywords: curl, web, login, cookie
category: Programming
tags: [Curl, Programming, Web]
---

As vezes queremos acessar uma aplicação web para procurar falhas, ou fazer alguma tipo de investigação minuciosa.

Uma ferramenta de linha de comando que pode ser usada para fazer isso é o [curl](http://curl.haxx.se/ "Site do curl"). O uso mais básico do curl é fazer uma requisição em uma determinada URL.

{% highlight bash lineos %}
    curl www.example.com

    <!doctype html>
    ...
{% endhighlight %}

O resultado desse comando não mostra nenhuma informação muito útil, apenas o HTML da resposta. Uma das formas de visualisar os dados no cabeçalho [HTTP](http://www.w3.org/Protocols/rfc2616/rfc2616.html "Especificação do HTTP/1.1") é usando a opção ``-v``.

{% highlight bash lineos %}
    curl -v www.example.com

    * About to connect() to www.example.com port 80 (#0)
    *   Trying 93.184.216.119...
    * Connected to www.example.com (93.184.216.119) port 80 (#0)
    > GET / HTTP/1.1
    > User-Agent: curl/7.29.0
    > Host: www.example.com
    > Accept: */*
    > 
    < HTTP/1.1 200 OK
    < Accept-Ranges: bytes
    < Cache-Control: max-age=604800
    < Content-Type: text/html
    < Date: Sat, 01 Feb 2014 22:37:35 GMT
    < Etag: "359670651"
    < Expires: Sat, 08 Feb 2014 22:37:35 GMT
    < Last-Modified: Fri, 09 Aug 2013 23:54:35 GMT
    < Server: ECS (fll/0761)
    < X-Cache: HIT
    < x-ec-custom-error: 1
    < Content-Length: 1270
    < 
    <!doctype html>
    ...
{% endhighlight %}

Com a opção ``-v`` são adicionadas no topo da saída do comando, informações sobre o que o ``curl`` está fazendo, precedidas de um "**\***"; o cabeçalho da requisição, precedidas de um "**>**" e o cabeçalho da resposta, precedias de um "**<**". Se forem feitas várias requisições, como quando há um redirecionamento, apareceram todas as operações de requisição e resposta. Isso pode ajudar na hora de procurar um bug em sua aplicação.

A forma mais comum do fazer um login nos dias atuais é com um formulário HTML usando o método POST e, caso tenha sucesso identificando o usuário, salvando um cookie no browser do usuário.

Para fazer uma requisição usando o método [POST](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.5 "Texto da especificação do HTTP/1.1 sobre o método POST") com ``curl`` basta indicar os dados que você deseja postar com a opção ``--data``, e o ``curl`` infere qual método será usado. Para demostrar isso vou usar uma [aplicação de teste](limitless-harbor-1705.herokuapp.com "Aplicação de teste") que tenho on [Heroku](https://www.heroku.com/ "Site do Heroku.").

{% highlight bash lineos %}
    curl -v --data \
        'email=denis@mail.com&password=123456' \
        http://limitless-harbor-1705.herokuapp.com/

    * About to connect() to limitless-harbor-1705...
    *   Trying 184.73.211.6...
    * Connected to limitless-harbor-1705.herokuapp...
    > POST / HTTP/1.1
    > User-Agent: curl/7.29.0
    > Host: limitless-harbor-1705.herokuapp.com
    > Accept: */*
    > Content-Length: 45
    > Content-Type: application/x-www-form-urlencoded
    > 
    * upload completely sent off: 45 out of 45 bytes
    < HTTP/1.1 302 FOUND
    < Content-Type: text/html; charset=utf-8
    < Date: Sat, 01 Feb 2014 22:16:52 GMT
    < Location: http://limitless-harbor-1705.herokuapp.com/monkeys/
    < Server: gunicorn/18.0
    < Set-Cookie: session=HNAXNoQ9wwt3ISmlQ; HttpOnly; Path=/
    < Content-Length: 225
    < Connection: keep-alive
    < 
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
    ...
{% endhighlight %}

É possível ver que a aplicação identificou corretamente o usuário e salvou um cookie no browser. Isso pode ser confirmado pelo campo **Set-Cookie** no cabeçalho da resposta.

A aplicação de teste que eu usei, depois do login com sucesso redireciona o usuário para uma listagem de todos os usuários do site. Por padrão o ``curl`` não segue para as páginas seguintes quando recebe um status code 302, de redirecionamento. Para que ele faça isso você deve passar a opção -L.

{% highlight bash lineos %}
    curl -v --data \
        'email=denis@mail.com&password=123456' \
        http://limitless-harbor-1705.herokuapp.com/

    * About to connect() to limitless-harbor-1705.herokuapp.com port 80 (#0)
    *   Trying 184.72.241.146...
    * Connected to limitless-harbor-1705.herokuapp.com (184.72.241.146)...
    > POST / HTTP/1.1
    > User-Agent: curl/7.29.0
    > Host: limitless-harbor-1705.herokuapp.com
    > Accept: */*
    > Content-Length: 45
    > Content-Type: application/x-www-form-urlencoded
    > 
    * upload completely sent off: 45 out of 45 bytes
    < HTTP/1.1 302 FOUND
    < Content-Type: text/html; charset=utf-8
    < Date: Sat, 01 Feb 2014 22:38:45 GMT
    < Location: http://limitless-harbor-1705.herokuapp.com/monkeys/
    < Server: gunicorn/18.0
    < Set-Cookie: session=HNAXNoQ9wwt3ISmlQ...; HttpOnly; Path=/
    < Content-Length: 225
    < Connection: keep-alive
    < 
    * Ignoring the response-body
    * Connection #0 to host limitless-harbor-1705.herokuapp.com left intact
    * Issue another request to this URL: 'http://limitless-harbor-1705...
    * Violate RFC 2616/10.3.3 and switch from POST to GET
    * Found bundle for host limitless-harbor-1705.herokuapp.com: 0x8f84fa0
    * Re-using existing connection! (#0) with host limitless-harbor-1705...
    * Connected to limitless-harbor-1705.herokuapp.com (184.72.241.146)...
    > GET /monkeys/ HTTP/1.1
    > User-Agent: curl/7.29.0
    > Host: limitless-harbor-1705.herokuapp.com
    > Accept: */*
    > 
    < HTTP/1.1 401 UNAUTHORIZED
    < Content-Type: text/html; charset=utf-8
    < Date: Sat, 01 Feb 2014 22:38:45 GMT
    < Server: gunicorn/18.0
    < Content-Length: 2483
    < Connection: keep-alive
    < 
    <!DOCTYPE html>
    ...
{% endhighlight %}

É possível ver que o último status code é 401, que significa "Não autorizado". Mas como isso pode acontecer se acabamos de logar e um cookie foi enviado para o ``curl``? Isso acontece por que, diferente dos browser, o ``curl`` não salva essas informações para enviar para o servidor posteriormente. Você precisa fazer isso manualmente.

O sintaxe básica para fazer uma requisição com cookie é:

{% highlight bash lineos %}
    curl --cookie "chave=valor" www.example.com
{% endhighlight %}

Isso pode ser um pouco chato, pois você tem que pegar os valores que quer na resposta, com o grep talvez, salvar em uma variável para poder usar em uma requisição posterior.

Uma forma mais fácil de fazer isso é salvado o cabeçalho em um arquivo e reutilizando esse informação. O ``curl`` já tem uma opção que salva essas informações em um arquivo. E a opção --cookie também aceita um arquivo como parâmetro.

{% highlight bash lineos %}
    curl -v --dump-header arquivo-com-o-header --data \
        'email=denis@mail.com&password=123456' \
        http://limitless-harbor-1705.herokuapp.com/

    curl -v --cookie  arquivo-com-o-header \
        http://limitless-harbor-1705.herokuapp.com/monkeys/

    * About to connect() to limitless-harbor-1705.herokuapp...
    *   Trying 54.225.205.142...
    * Connected to limitless-harbor-1705.herokuapp...
    > GET /monkeys/ HTTP/1.1
    > User-Agent: curl/7.29.0
    > Host: limitless-harbor-1705.herokuapp.com
    > Accept: */*
    > Cookie: session=HNAXNoQ9wwt3ISmlQ...;
    > 
    < HTTP/1.1 200 OK
    < Content-Type: text/html; charset=utf-8
    < Date: Sun, 02 Feb 2014 00:13:33 GMT
    < Server: gunicorn/18.0
    * Added cookie session="HNAXNoQ9wwt3ISmlQ...;" for domain...
    < Set-Cookie: session=HNAXNoQ9wwt3ISmlQ...;; HttpOnly; Path=/
    < Content-Length: 7132
    < Connection: keep-alive
    < 
    <!DOCTYPE html>
    ...
{% endhighlight %}

Com base nisso é possível fazer login em qualquer site.
