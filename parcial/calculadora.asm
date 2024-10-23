section .data
    prompt1 db "Ingrese el valor 1 (sumando, minuendo, multiplicando, dividendo, dividendo, radical, base): ", 0
    prompt2 db "Ingrese el valor 2 (sumando, sustraendo, multiplicador, divisor, divisor, radicando, exponente): ", 0
    prompt3 db "Ingrese la operación que desea realizar (+, -, , /, %, r, *, exit): ", 0
    exit_msg db "Saliendo de la calculadora.", 10, 0
    error_div_zero db "Error: División por cero no permitida.", 10, 0
    error_root db "Error: No se puede calcular esta raíz.", 10, 0
    invalid_op db "Operación no válida. Intente nuevamente.", 10, 0
    result_msg db "Resultado: %d", 10, 0
    fmt_integer db "%d", 0
    fmt_char db " %c%c", 0    

section .bss
    num1 resd 1
    num2 resd 1
    operation resb 2      

section .text
    extern printf, scanf
    global main

main:
    push rbp
    mov rbp, rsp
    
.loop:
    ; Solicitar primer número
    mov rdi, prompt1
    xor rax, rax
    call printf
    
    ; Leer primer número
    mov rdi, fmt_integer
    mov rsi, num1
    xor rax, rax
    call scanf
    
    ; Solicitar segundo número
    mov rdi, prompt2
    xor rax, rax
    call printf
    
    ; Leer segundo número
    mov rdi, fmt_integer
    mov rsi, num2
    xor rax, rax
    call scanf
    
    ; Solicitar operación
    mov rdi, prompt3
    xor rax, rax
    call printf
    
    ; Leer operación
    mov rdi, fmt_char
    mov rsi, operation
    mov rdx, operation
    inc rdx
    xor rax, rax
    call scanf
    
    ; Verificar si es 'exit'
    mov al, byte [operation]
    cmp al, 'e'
    je .exit

    ; Aún no se han agregado las operaciones, se vuelve a solicitar
    jmp .loop

.exit:
    ; Mensaje de salida
    mov rdi, exit_msg
    xor rax, rax
    call printf
    
    ; Restaurar pila y finalizar
    mov rsp, rbp
    pop rbp
    xor eax, eax
    ret