.data
mensagem: .asciiz "\nDigite um valor: "
resp: .asciiz " é a posição do array.\n"
array: .word 7    # especifica o tamanho do array
      .align 2    # alinhamento do array para evitar problemas de memória

.text
.globl main

get_mid_pos:
	## Calula a posição do meio do array, no qual os limites estão em t8 e t9
    addi $t1, $zero, 2      # Divisor para calcular a posição central do array
    add $t0, $t8, $t9       # Soma dos extremos
    div $t0, $t1            # Calculo da média dos extremos
    mul $t0, $t0, 4         # Multiplicação por 4 
    jr $ra

add_numbers:
    addi $t8, $zero, 0      # Início do array
    addi $t9, $zero, 6      # Fim do array
    
    # Valores do array que serão adicionados
    addi $s0, $zero, 0
    addi $s1, $zero, 2
    addi $s2, $zero, 4
    addi $s3, $zero, 6
    addi $s4, $zero, 8
    addi $s5, $zero, 10
    addi $s6, $zero, 12
    jr $ra

load_numbers: 
    ## carrego os valores definidos em add_numbers que estão em s0-s6 no espaço alocado para o array
    addi $t0, $zero, 0
    sw $s0, array($t0)
    addi $t0, $t0, 4
    sw $s1, array($t0)
    addi $t0, $t0, 4
    sw $s2, array($t0)
    addi $t0, $t0, 4
    sw $s3, array($t0)
    addi $t0, $t0, 4
    sw $s4, array($t0)
    addi $t0, $t0, 4
    sw $s5, array($t0)
    addi $t0, $t0, 4
    sw $s6, array($t0)
    jr $ra

main:
    jal add_numbers
    jal load_numbers
    
    ## Printando na tela a interação
    addi $v0, $zero, 4
    la $a0, mensagem
    syscall
    
    ## Pedindo o inteiro ao usuário
    addi $v0, $zero, 5
    syscall
    ## Colocando o valor digitado (chave) pelo usuário em s7
    add $s7, $zero, $v0
    
    jal bbinaria
    
falso:
	## divide o valor de t0 por 4, para encontrar a posição sem a multiplicação de 4 bytes
    div $t0, $t0, 4
    ## coparam se o valor encontrado na posição central é menor que a chave
    slt $t6, $t7, $s7
    ## caso t6 seja 1, vai para label chave_menor
    beq $t6, 1, chave_menor
    ## atualiza os extremos do array
    sub $t9, $t0, 1
    ## chama recursivamente a busca binária novamente
    jal bbinaria
    ## recarrega o endereço de retorno para a volta da busca
    lw $ra, 0($sp)
    ## soma novamente a pilha para retornar ao endereço
    addi $sp, $sp, 4
    jr $ra

chave_menor:
	## atualiza os extremos do array
    add $t8, $t0, 1
    ## chama recursivamente a busca binária
    jal bbinaria
    ## recarrega o endereço de retorno para a volta da busca
    lw $ra, 0($sp)
    ## soma novamente a pilha para retornar ao endereço
    addi $sp, $sp, 4
    jr $ra

bbinaria:
	## aloco na pilha o valor de 1 variável - 4 bytes (ra)
    sub $sp, $sp, 4         
    ## salvando as variáveis utilizadas
    sw $ra, 0($sp)
    
    jal get_mid_pos
    
    ## carrega o valor do array na posição central
    lw $t7, array($t0)
    
    ## verificação de condição da recursão
    bne $t7, $s7, falso
    
    ## Quando encontra o valor
    ## printa o valor na tela
    add $a0, $zero, $t0
    div $a0, $a0, 4
    addi $v0, $zero, 1
    syscall
    ## printa uma resposta na tela
    addi $v0, $zero, 4
    la $a0, resp
    syscall
    ## finaliza o programa
    addi $v0, $zero, 10
    syscall