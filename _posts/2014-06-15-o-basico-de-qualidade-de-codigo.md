---
layout: post
title: O básico de qualidade de código
meta_description: Falando sobre princípios básicos da qualidade de código.
meta_keywords: programação, python
category: Programming
tags: [Programação, Python]
---

Qualidade de código não é algo opcional (pelo menos não deveria ser). Isso
deveria ser um requisito obrigatório em qualquer projeto. Mas por que tem
tanto código ruim no mercado? A resposta é simples: É muito difícil escrever
código bem feito. Leva-se tempo para aprender a se escrever um bom código. É
preciso errar, e sofrer com seus erros para melhorar.

E quando se fala em qualidade de código, estamos falando de um coisa bem
ampla. Podemos falar sobre grau de acoplamento, taxa de cobertura de teste e
muitas outras coisas. Todas essas podem ser consideradas medidas de qualidade.

Apesar de esse ser um assunto bem vasto, vou abordar uma das partes mais
simples, mas que está diretamente ligada à qualidade e que às vezes é
esquecida por boa parte dos programadores: A formatação de código. Usar
indentação corretamente não faz o seu código menos acoplado ou mais coeso. Mas
se você não se atentar a esses pequenos detalhes, o seu código pode virar uma
grande bola de neve.

A aparência dos seu código fala muito sobre você como programador. Então neste
post vou falar algumas regras simples que uso no dia-a-dia como guia em todos
os meus projetos.

### 1 - Use uma ferramenta de analise estática

Eu particularmente não vejo nenhuma boa razão para não usar ferramentas de
análise estática de código em todos os seus projetos. Existem ferramentas
open-source para fazer esse tipo de análise em praticamente todas as
linguagens mais usadas. [flake8](http://flake8.readthedocs.org/ "Link para
documentação do flake8.") para Python, [jshint](http://jshint.com/
"Link para documentação do jshint.") para Javascript,
[shellcheck](http://www.shellcheck.net/ "Link para site do shellcheck.") para
shell script, [csslint](http://csslint.net/ "Site do csslint.") para CSS e
muitos outras.

Existem também serviços que fazem analise estática e geram ótimos relatórios
sobre o seu projeto. Serviços como o [Landscape](https://landscape.io/
"Site do Landscape.") para Python e o [Code Climate](https://codeclimate.com/
"Site do Code Climate.") para Ruby e Javascript (mas eles estão prestes a
lançar suporte a PHP e pretendem suportar em breve Coffe Script e Python).
Ambos são gratuitos para projetos com repositório público.

Um ponto importante de padrões de formatação de código que são externos à
sua equipe, como os feitos por essas ferramentas e serviços, é que eles acabam
discussões inúteis de como dever ser formatado o código. Em Python, por
exemplo, é abraçar as convenções PEP8 e ser feliz.

### 2 - Evite linhas longas

Muitos programadores (eu inclusive) não gostam dos limites de tamanho de linha
que grande parte das ferramentas de lint impõe. Então é muito comum
desabilitar essa verificação.

Mas isso não é motivo para se ter código com 220 caracteres por linhas (já
vi isso!). Aí você precisar rolar o editor de texto para o lado para poder ler
o código. Isso é inadmissível. Deixe o bom senso ser seu guia, mas defina um
tamanho máximo para você e/ou para a sua equipe.

Como eu disse, não gosto muito do limite padrão da maioria das convenções,
que é de 79 (ou 80) linhas. Eu acho muito pouco. Então, normalmente uso 119
caracteres como limite de caracteres.

Em python, quando você tem imports longos, como o exemplo abaixo, você você
pode agrupá-los, usando parenteses, e assim quebrar as linhas.

{% highlight python linenos=table %}
from django.template import Context, RequestContext, loader, Template, TemplateDoesNotExist
{% endhighlight  %}

Agrupando os imports.

{% highlight python linenos=table %}
from django.template import (
    Context, RequestContext,
    loader, Template, TemplateDoesNotExist
)
{% endhighlight  %}

Você ainda pode usar uma formatação diferente (que por sinal é a [formatação
original](
https://github.com/django/django/blob/master/django/views/defaults.py#L2)
desse código) dependendo da sua preferência e contexto. Mas recomendo que
escolha um e mantenha-o.

Esse talvez seja a dica mais simples de seguir. Para ajudar a visualizar os
limites de colunas nas linhas, você pode configurar sua IDE/Editor de texto
para traçar uma linha mostrando esse limite.

### 3 - Evite escapar o caractere de fim de linha

O problema anterior pode ser resolvido simplesmente quebrando a linha e
escapando o caractere de fim de linha. Mas antes de falar sobre isso, responda
a seguinte pergunta: Qual a diferença dos dois códigos a baixo?

{% highlight python linenos=table %}
from django.template import Context, RequestContext, \ 
                            loader, Template, TemplateDoesNotExist
{% endhighlight  %}

{% highlight python linenos=table %}
from django.template import Context, RequestContext, \
                            loader, Template, TemplateDoesNotExist
{% endhighlight  %}

Nenhuma, aparentemente. Mas a maior diferença é que o primeiro código acusa
erro de sintaxe e o segundo executa normalmente.

Olhando para os dois código não é possível perceber nenhuma diferença, mas o
primeiro tem um espaço depois do escape. Assim, caractere de fim de linha
não é mais escapado. Para o interpretador a segunda linhas é um statement
novo (e inválido). Por isso recebemos um erro de sintaxe. Um bug chato de achar
por que o caractere que causa problema, o espaço, não é visível.

Esse isso deve ser evitado em qualquer linguagem.

Eu sei que você pode configurar seu editor de texto para retirar os espaços
no fim das linhas ao salvar o texto. Mas mesmo assim prefiro evitar que esse
tipo de coisa aconteça, evitando quebrar linhas assim.

### 4 - Não misture aspas simples e duplas

Algumas linguagens, como Javascript e Python, aceitam aspas simple e duplas
para delimitar strings. Não use essa "feature"!

Eu, particularmente, uso aspas simples sempre que possível (Javascript, Python)
e duplas quando necessário (C/C++, Java). Escolha uma e mantenha o padrão
em toda a sua base de código.

### 5 - Evite código desnecessário

Essa regra é bem simples: Quando um código não precisar ser escrito, não o
escreva. Vejamos o código abaixo:

{% highlight python lineos=table %}
def anything(some):
    if some == something_else:
        return True
    else:
        return False
{% endhighlight%}

Não existe a necessidade de escrever aquele else. Pois se o código do if for
executado, a função retorna e nada mais ali dentro é executado. Sempre que você
tiver uma situação assim, escreva dessa forma:

{% highlight python lineos=table %}
def anything(some):
    if some == something_else:
        return True
    return False
{% endhighlight%}

Essa regra pode ser resumida em: "sem else depois de return."

Mas esse código ainda não está legal. Eu estou fazendo uma verificação
booleana para então retornar um booleano. Esse código pode ser melhorado e
ficar assim:

{% highlight python lineos=table %}
def anything(some):
    return some == something_else:
{% endhighlight%}

Essas pequenas melhorias, variam de caso para caso, mas mantenha na sua cabeça
o mantra: "código que não precisa ser escrito, não deve ser escrito".

### 6 - Seja consistente nos retornos das funções

Algumas linguagens dinâmicas, não obrigam o programador a declarar o tipo do
retorno das funções. Então, a mesma função pode retornar um array, uma string,
ou ainda um float. Evite isso e tenta manter a consistência da API que você
está desenvolvendo.

Nos casos de comportamento errôneo é melhor lançar uma exceção. Para informar
explícitamente, que aquele comportamento da função não é o caso esperado.

O único caso (que lembrei enquanto escrevia o post) que isso pode ser usado
como uma boa solução acho que pode fugir você esteja implementando um método
de busca, você pode retorna nulo (None, null, nil, etc. Dependendo da
linguagem) para o caso de não achar nenhum elemento durante a busca.

### 7 - Escreva as regras

Uma coisa que realmente ajuda na manutenção dessas regras é você ter um
documento que agregue todas as regras. A Plataformatec tem publicado um
belíssimo [guideline](http://guidelines.plataformatec.com.br/ "Guide lines da
Plataformatec"). Recomendo a todos que leiam.

### Conclusões

Essas regras são apenas o início do que vem a ser um código bem escrito. Mas
elas não precisam ser seguidas de maneira cega. Use o bom senso. Crie
e compartilhe as suas, comente as minhas.

O desenvolvimento de software é uma coisa viva e orgânica, suas premissas e
regras também devem ser. Sendo assim eu atualizarei esse post caso me lembre
de outra regra.

Abraços
