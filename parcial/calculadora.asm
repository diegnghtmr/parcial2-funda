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

    ; Verificar si es potencia
    cmp al, '*'
    jne .check_other_ops
    mov al, byte [operation + 1]
    cmp al, '*'
    je .power

.check_other_ops:
    ; Realizar operación
    mov eax, dword [num1]
    mov ebx, dword [num2]
    
    mov cl, byte [operation]
    cmp cl, '+'
    je .add
    cmp cl, '-'
    je .sub
    cmp cl, '*'
    je .mul
    cmp cl, '/'
    je .div
    cmp cl, '%'
    je .mod

    ; Al entrar acá, la operación es inválida
    mov rdi, invalid_op
    xor rax, rax
    call printf
    jmp .loop

.add:
    add eax, ebx
    jmp .print_result
    
.sub:
    sub eax, ebx
    jmp .print_result
    
.mul:
    imul eax, ebx
    jmp .print_result
    
.div:
    cmp ebx, 0
    je .div_zero
    cdq
    idiv ebx
    jmp .print_result

.mod:
    cmp ebx, 0
    je .div_zero
    cdq
    idiv ebx
    mov eax, edx
    jmp .print_result

.power:
    mov eax, dword [num1]
    mov ecx, dword [num2]
    
    ; Si el exponente es 0, resultado es 1
    cmp ecx, 0
    je .power_zero
    
    ; Si el exponente es 1, resultado es la base
    cmp ecx, 1
    je .print_result
    
    ; Si el exponente es negativo, resultado es 0 en división entera
    cmp ecx, 0
    jl .power_zero
    
    ; Calcular potencia
    mov edx, eax
    dec ecx
    
.power_loop:
    test ecx, ecx
    jz .print_result
    imul eax, edx
    dec ecx
    jmp .power_loop

.power_zero:
    mov eax, 1
    jmp .print_result

.div_zero:
    mov rdi, error_div_zero
    xor rax, rax
    call printf
    jmp .loop
    
.print_result:
    mov rdi, result_msg
    mov rsi, rax
    xor rax, rax
    call printf
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