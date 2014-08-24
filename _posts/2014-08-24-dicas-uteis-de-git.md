---
layout: post
title: Dicas úteis de git
meta_description: Falando sobre dicas para melhorar o uso do git no dia-a-dia.
meta_keywords: programação, git
category: Programming
tags: [Programação, Git]
---

Neste artigo vou falar de algumas dicas para ajudar no seu aprendizado sobre
git e também para melhorar o seu wokflow com git no dia-a-dia.

### Pro Git em português

Um bom começo para os iniciantes em git é o livro
[Pro Git](http://www.amazon.com/gp/product/1430218339?ie=UTF8&camp=1789&creative=9325&creativeASIN=1430218339&linkCode=as2&tag=git-sfconservancy-20
"Pro Git na Amazon") escrito por
Scott Chacon. Algumas pessoas não sabem, mas esse livro é distribuído sob
Licença Creative Commons. E foi totalmente
[traduzido para o português](http://git-scm.com/book/pt-br
"Livro Pro Git online em português.") pela
comunidade.

### Alterar o comportamento do mv e do rm

Umas das coisas mais chatas que acontece comigo quando quero remover um arquivo
de um projeto pela linha de comando, e digito ``mv`` ao invés de ``git mv``.

Quando isso acontece vc tem que fazer dois passos a mais.

{% highlight bash %}
mv file dir/file
git rm file
git add dir/file
{% endhighlight %}

O que fiz foi alterar o comportamento do rm do sistema colocando no meu
``.bashrc`` a seguinte função:

{% highlight bash linenos=table %}
function mv_git {
    mv_path=$(which mv)
    git mv $* 2> /dev/null || $mv_path $*
}
{% endhighlight %}

E um alias:

{% highlight bash %}
alias mv='mv_git'
{% endhighlight %}

Agora ao mover um arquivo, a função primeiro tenta remover usando ``git mv``
se não der certo ela executa simplesmente ``mv``. Para adicionar o mesmo
comportamento ao  ``rm``, adicione também a função abaixo no seu ``.bashrc``.

{% highlight bash linenos=table %}
function rm_git {
    rm_path=$(which rm)
    git rm $* 2> /dev/null || $rm_path $*
}
{% endhighlight %}

Com a respectiva alias:

{% highlight bash %}
alias rm='rm_git'
{% endhighlight %}

### Git log mais bonito

A saída do ``git log`` padrão, grande parte das vezes, não ajuda muito. Por
isso usei a
[dica do Fred Schott](http://fredkschott.com/post/2014/02/git-log-is-so-2005/
"Git log is *so* 2005.") e adicionei essa alias ao meu ``.gitconfig``.

### Usando Git hooks para tarefas repetitivas

Caso você tenha alguma tarefa que precisa ser executada a cada commit, ou toda
vez que você faz um ``push`` uma boa forma de resolver esse problema é com
``Git hooks``.

Eu, por exemplo, adicionei um hook para analisar o código que vou "commitar".
Caso o código tenha algum problema, eu não consigo fazer o ``commit`` até
consertá-lo.

Saber quais hooks existem pode ajudar quando você se deparar com uma situação
como a que descrevi. [Esse site](http://githooks.com/ "Site sobre Git hooks")
reúne artigos informações e projetos relacionados aos hooks dos Git.

### Gitignore global

Para quem programa em Python, é praticamente certo que não se quer arquivos
compilados (com extensão .pyc) no seu repositório. Mesmo assim não é raro você
encontrar esse tipo de arquivo em algum repositório.

Para resolver esse problema eu criei um arquivo .gitignore_global (mas pode ser
qualquer nome) com todos as extensões que eu sei que sempre vou querer ignorar
e adicionei isso ao meu .gitconfig com o seguinte comando:

{% highlight bash %}
git config --global core.excludesfile ~/.gitignore_global
{% endhighlight %}

Eu espero que as dicas sejam úteis no dia-a-dia de vocês também.

Abraço
