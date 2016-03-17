#Apache Groovy

![Groovy](https://uploaddeimagens.com.br/images/000/585/360/full/groovy.png?1458175765)

Este artigo dará uma breve introdução ao apache Groovy, uma linguagem de programação que oferece diversos recursos, como facilidade de escrita e leitura, expressividade (comparada ao Java, por exemplo), programação funcional e metaprogramação, e promete uma curva de aprendizado baixa para programadores Java.  

##História e Influências
A linguagem Groovy foi idealizada por James Strachan em 2003. Ele mesmo deixa claro as linguagens que influenciaram o Groovy, assim como seu principal objetivo.
>“minha ideia inicial é fazer uma pequena linguagem dinâmica, que seja compilada diretamente em classes Java e que tenha toda a produtividade elegante encontrada em Ruby e Python, mas que permita reusar, estender, implementar e testar código Java já existente”.

##Sobre a linguagem
A linguagem Groovy pode ser classificada destas maneiras:  
* **Permite tipagem estática e dinâmica:** O programador tem a liberdade de utilizar recursos da tipagem estática e/ou dinâmica quando bem entender.
  Ao contrário do que acontece no Java, pode-se declarar uma variável inteira da seguinte forma:  
 ```groovy
  i = 20

  ``` 
  Da maneira acima, a variável é definida de forma dinâmica, portanto podemos fazer o seguinte tipo de atribuição sem problemas:  
 ```groovy
  i = 20
  i = "vinte"
  ``` 
  Como dito na introdução deste artigo, o Groovy aceita a maioria dos comandos Java. O mesmo vale para declaração de variáveis de tipos primitivos:
  ```groovy
  int i = 20
  ``` 
  Entretanto, utilizando um tipo explícito (int), não colheremos os benefícios da tipagem dinâmica. O trecho de código abaixo resultaria em erro:
  ```groovy
  int i = 20
  i = "vinte"
  ```   
* **Orientada a objetos:** A linguagem Groovy é baseada no Java e apresenta grande compatibilidade com ele. O recurso da orientação a objetos, portanto, faz parte do Groovy.
*  **Funcional:** Groovy oferece todo o recurso de programação funcional, ao contrário do Java.
*  **Imperativa:** Podemos utilizar quaisquer recursos que uma linguagem imperativa oferece, como loops.
*  **de Script:** Por ser uma linguagem de script, podemos, por exemplo, utilizar o código Groovy nas aplicações Java já existentes. Isso abre o leque de utilizações da linguagem, permitindo que aplicações Java utilizem o seu script Groovy quando o mesmo valer a pena, pois geralmente o Groovy perde em performance em relação ao Java.

##Expressividade em relação ao Java
A linguagem Groovy oferece uma série de benefícios para programadores Java. A maioria dos comandos em Java são reconhecidos pelo Groovy, e mesmo os que são alterados são facilmente convertidos, como a declaração de um vetor de inteiros. Veja a seguir o código em Java:  
```java
int[] vetorInteiros = {1,2,3,4};
```  
Groovy:  
```groovy
int[] vetorInteiros = [1,2,3,4];
```  
Entretando, o Groovy oferece mais recursos que o Java, como o uso de closures. Por isso, o Groovy pode ser considerado mais expressivo.


## Pontos interessantes
A seguir serão listados algumas características da linguagem que chamam a atenção inicialmente:
* **Ponto e vírgula facultativo:** Em Groovy, o uso do ponto e vírgula é facultativo. Dessa forma, programadores que são acostumados a escrever com ponto e vírgula não vão ter de ficar prestando atenção para não digitar o caracter no final das linhas (migrantes de C para Python, por exemplo, sofrem com esse detalhe). Além disso, diminuímos a quantidade de caracteres, deixando o código mais limpo, e nunca teremos o problema de erros gerados pelo esquecimento de um ponto e vírgula, o que já ajuda bastante na escrita de um script.
* **Métodos short-form ou forma reduzida:** Alguns métodos apresentam uma forma reduzida no groovy, facilitando o uso rotineiro. Um exemplo é o _System.out.println_ que ser somente _println_
* **Parênteses não necessários:** Algumas chamadas de métodos dispensam o uso de parênteses, dimininuindo a poluição visual de um código. Isso pode ser um pouco confuso para algumas chamadas, portanto deve-se sempre ter isso em mente.

* **Facilidade no tratamento de Strings:** Muitas pessoas comentam sobre a facilidade do uso de strings no php. Para programadores php, a mudança (nesse sentido) para o groovy ocorre de maneira quase que instantânea. Se quiséssemos definir uma string contendo a variável _i_, declarada anteriormente, concatenando-a com um outra string, bastaria o seguinte:   
  ```groovy
  novaString = i + " outra string"
  ```   
  Veja a semelhança com o php (houve apenas uma mudança sintática):  
  ```php
  $novaString = $i." outra string";
  ```   
  Também podemos fazer isso de outra maneira, através do operador de acesso _$_ (aqui a semelhança de escrita com php fica clara):
  Groovy:  
  ```groovy
  novaString = "$i outra string"
  ```  
  php:
  ```php
  $novaString = "$i outra string";
  ```     
  Assim como no php, o caracter de aspas duplas é diferente do caracter de aspas simples. 
  O caracter de aspas duplas permite que o operador $ funcione de fato, trazendo o conteúdo de outras variáveis para string. O caracter de aspas simples, entretanto, gera a string da forma como foi escrita. Vejamos abaixo o uso das aspas. Note que a variável $i foi definida anteriormente no artigo.  
  ```groovy
  novaString = "$i"  
  novaString = '$i' 
  ```   
  A primeira linha do código acima atribuiria o valor _20_ para a variável _novaString_, enquanto que a segunda linha atribuiria o valor _$i_.

## Exemplo comparativo entre Java e Groovy

###Hello World
Com esses poucos recursos da linguagem já podemos ver uma grande difereça de um simples "Hello World" entre Java e Groovy.  
Java: 
```java
public class HelloWorld {
  public static void main(String[] args){   
	String nome = "World"; 
	System.out.println("Hello " + nome);
  }
}  
```  
Groovy: 
```groovy
x = "World"
println "Hello, $x"
```
Observando o exemplos, sem dúvidas o Groovy oferece mais facilidades de escrita e de leitura.

###Expressões Regulares
**Objetivo do programa:** Dada uma string qualquer, identificar quantas substrings “grovy” estão contidas nela. Neste programa podem ser aceitas quaisquer substrings que atendam esta expressão regular: (G|g)oov(Y|y). Ou seja, para o nosso programa: Groovy = groovy = groovY = GroovY. Primeiramente é apresentado o código Java:  
```java
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ExpressaoRegular{
  private static final String REGEX = "(G|g)roov(Y|y)";
  private static final String INPUT = " Groovy is groovy ";
  
  public static void main(String[] args){
 	   
       Pattern p = Pattern.compile(REGEX);
       Matcher m = p.matcher(INPUT); 

       int count = 0;
       while(m.find()) {
         count++;
      }
    
    System.out.println(count);
    
  }
}
```  
Groovy:  
```groovy
m = "Groovy is groovy" =~ /(G|g)roov(Y|y)/
println m.size()
```  
Mais uma vez podemos exemplificar a facilidade de escrita da linguagem.

## Conclusão
O Groovy cumpre seus objetivos iniciais, oferencendo várias facilidades para desenvolvedores, mas apresenta alguns problemas de performance. Por conta disso, deve-se analisar com cuidado como e onde ele será usado.

## Bibliografia e Links
* Site da linguagem: http://www.groovy-lang.org/
* Compilador online utilizado: https://groovy-playground.appspot.com/
* Verbete no Wikipédia: https://pt.wikipedia.org/wiki/Groovy
* Um pequeno tutorial dividido em 3 partes: https://www.timroes.de/2015/06/27/groovy-tutorial-for-java-developers/
* Uso de Arrays no Groovy e no Java: http://mrhaki.blogspot.com.br/2009/09/groovy-goodness-working-with-arrays.html
* Artigo: "Um pouco sobre Groovy": http://www.devmedia.com.br/java-magazine-69-um-pouco-de-groovy-uma-linguagem-de-scripts-100-compativel-com-java/12542
* Discução sobre desempenho do Groovy: http://www.grailsbrasil.com.br/post/show/2360

