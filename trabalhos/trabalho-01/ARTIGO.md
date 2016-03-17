#Apache Groovy

![Groovy](https://uploaddeimagens.com.br/images/000/585/360/full/groovy.png?1458175765)

Este artigo dará uma breve introdução ao apache groove, uma linguagem de programação que oferece diversos recursos, como facilidade de escrita e leitura, expressividade (comparada ao Java, por exemplo), promação funcional e metaprogramação, e promete uma curva de aprendizado baixa para programadores Java.  


##Introdução
DIZER QUE É QUASE COMPATíVEL COM JAVA  
Groovy é executado em uma JVM (Java Virtual Machine)


## Pontos interessantes
A seguir serão listados algumas características da linguagem que chamam a atenção inicialmente:
* **Ponto e vírgula facultativo:** Em Groovy, o uso do ponto e vírgula é facultativo. Dessa forma, programadores que são acostumados a escrever com ponto e vírgula não vão ter de ficar prestando atenção para não digitar o caracter no final das linhas (migrantes de C para Python, por exemplo, sofrem com esse detalhe). Além disso, diminuímos a quantidade de caracteres, deixando o código mais limpo, e nunca teremos o problema de erros gerados pelo esquecimento de um ponto e vírgula, o que já ajuda bastante na escrita de um script.
* **Métodos short-form ou forma reduzida:** Alguns métodos apresentam uma forma reduzida no groovy, facilitando o uso rotineiro.  
* **Parênteses não necessários:** Algumas chamadas de métodos dispensam o uso de parênteses, dimininuindo a poluição visual de um código. Entretanto isso pode ser um pouco confuso para algumas chamadas, portanto deve-se sempre ter isso em mente.
* **Tipagem dinâmica:** Ao contrário do que acontece no Java, não se faz necessária a tipagem da váriavel. Em outras palavras, pode-se declarar uma variável inteira da seguinte forma:  
 ```groovy
  i = 20

  ``` 
  Da maneira acima, a variável é definida de forma dinâmica, portanto podemos fazer o seguinte tipo de atribuição sem problemas:  
 ```groovy
  i = 20
  i = "vinte"
  ``` 
  Como dito na introdução deste artigo, groovy aceita a maioria dos comandos Java. O mesmo vale para declaração de variáveis de tipos primitivos:
  ```groovy
  int i = 20
  ``` 
  Entretanto, utilizando um tipo explícito (int), não colheremos os benefícios da tipagem dinâmica. O trecho de código abaixo resultaria em erro:
  ```groovy
  int i = 20
  i = "vinte"
  ```   
* **Facilidade no tratamento de Strings:** Muitas pessoas comentam sobre a facilidade do uso de strings no php. Para programadores php, a mudança (nesse sentido) para o groovy ocorre de maneira quase que instantânea. Se quiséssemos definir uma string contendo a variável “i” declarada anteriormente concatenando-a com um outra string, bastaria o seguinte:   
  ```groovy
  novaString = i + “ outra string”
  ```   
  Veja a semelhança com o php (houve apenas uma mudança sintática):  
  ```php
  $novaString = $i.“ outra string”;
  ```   
  Também podemos fazer isso de outra maneira, através do operador de acesso $ (aqui a semelhança de escrita com php fica clara):
  Groovy:  
  ```groovy
  novaString = “$i outra string”
  ```  
  php:
  ```php
  $novaString = “$i outra string”;
  ```     
  Assim como no php, o caracter de aspas duplas é diferente do caracter de aspas simples. 
  O caracter de aspas duplas permite que o operador $ funcione de fato, trazendo o conteúdo de outras variáveis para string. O caracter de aspas simples, entretanto, gera a string da forma como foi escrita. Vejamos abaixo o uso das aspas. Note que a variável $i foi definida anteriormente no artigo.  
  ```groovy
  novaString = “$i”  
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

##Bug
Todo programados Java sabe que um atributo __private__ não pode pode ser acessado de uma classe externa. Afinal essa é a utilizadade desse modificador. Entretanto em Groovy simplesmente esse operador não funciona dessa forma. No início da linguagem foi até mesmo discutido se isso era um recurso da linguagem ainda não documentado, ou se era um bug. Com o passar do tempo isso foi de fato identificado como bug, mas nenhuma intenção de correção foi identificada. Há até mesmo autores que defendem esse bug:

## Conclusão

## Bibliografia
* Site da linguagem: http://www.groovy-lang.org/

