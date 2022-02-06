section .text

global expression
global term
global factor

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        
        mov     ebx, [ebp + 8] ; p
        xor     eax, eax ; raspunsul

        mov     ecx, [ebp + 12] ; i
        mov     ecx, [ecx] ; ecx = *i

        xor     edx, edx
        mov     dl, byte [ebx + ecx] ; primul caracter

        cmp     dl, 40 ; (
        jne     elseIfParanteze

        ; inc i
        push    edx
        inc     ecx
        mov     edx, [ebp + 12] ; i
        mov     [edx], ecx
        pop     edx

        ; call expresion
        push    eax
        push    dword [ebp + 12]
        push    dword [ebp + 8]
        call    expression
        add     esp, 8; pop de 2 ori

        ; adun resultatul meu cu ceea ce era in eax
        add     eax, [esp]
        add     esp, 4; pop

        ; inc i
        push    edx
        inc     ecx
        mov     edx, [ebp + 12] ; i
        mov     [edx], ecx
        pop     edx

        jmp     dupaIfParanteze

elseIfParanteze:
        cmp     dl, 48 ; 0
        jl      dupaIfParanteze
        cmp     dl, 57 ; 9
        jg      dupaIfParanteze

        ; inc i
        push    edx
        inc     ecx
        mov     edx, [ebp + 12] ; i
        mov     [edx], ecx
        pop     edx

        ; formarea numarului dupa formula
        ; numar = numar * 10 + caracterNumar - '0'
        
        ; numar = numar * 10
        push    edx
        xor     edx, edx
        push    ecx
        mov     ecx, 10
        mul     ecx
        pop     ecx
        pop     edx

        add     eax, edx ; numar = numar + caracterNumar
        sub     eax, 48 ; numar = numar - '0'

        xor     edx, edx
        mov     dl, byte [ebx + ecx] ; caracter de pe pozitia i

        jmp     elseIfParanteze

dupaIfParanteze:

        leave
        ret


; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp
        
        mov     ebx, [ebp + 8] ; p


        push    dword [ebp + 12]
        push    ebx
        call    factor
        add     esp, 8 ; pop de 2 ori

        mov     ecx, [ebp + 12] ; i
        mov     ecx, [ecx]

        ; extragere caracter de pe pozitia i
        xor     edx, edx
        mov     dl, byte [ebx + ecx]
        
while2:
        cmp     dl, 42 ; *
        je      continueWhile2
                
        cmp     dl, 47 ; /
        jne     exitWhile2

continueWhile2:

        ; inc i
        push    edx
        inc     ecx
        mov     edx, [ebp + 12] ; i
        mov     [edx], ecx
        pop     edx

        cmp     dl, 42 ; *
        je      prod

dupaIfProd:
        cmp     dl, 47 ; /
        je      divi

dupaIfDiv:
        mov     ecx, [ebp + 12] ; i
        mov     ecx, [ecx]
        mov     dl, byte [ebx + ecx] ; caracter pozitie i
        
        jmp     while2

prod:   
        ; salvez registii
        push    ebx
        push    ecx
        push    edx

        push    eax
        push    dword [ebp + 12] ; i
        push    dword [ebp + 8] ; p
        call    factor
        add     esp, 8 ; pop de 2 ori
        
        xor     edx, edx
        
        imul    eax, dword [esp]
        add     esp, 4
        
        ; introc valorile registrilor 
        push    ebx
        push    ecx
        push    edx
        jmp     dupaIfDiv

divi:   
        ; salvez valoarea anterioara
        push    eax

        ; call factor
        push    dword [ebp + 12] ; i
        push    dword [ebp + 8] ; p
        call    factor
        add     esp, 8 ; pop de 2 ori

        ; extrag raspunsul care se tinea in eax din stiva
        pop     ecx

        ; interschimb eax cu ecx, pentru a face impartirea corect
        push    eax
        push    ecx
        pop     eax
        pop     ecx

        ; impart eax la ecx
        xor     edx,edx
        cdq
        idiv    ecx
        
        jmp     dupaIfDiv

exitWhile2:

        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
        push    ebp
        mov     ebp, esp
        
        mov     ebx, [ebp + 8] ; p

        ; call term
        push    dword [ebp + 12]
        push    ebx
        call    term
        add     esp, 8 ; pop de 2 ori

        mov     ecx, [ebp + 12] ; i
        mov     ecx, [ecx]

        ; extrag caracterul de pe pozitia i
        xor     edx, edx
        mov     dl, byte [ebx + ecx]
        
while1:
        cmp     dl, 43 ; +
        je      continueWhile
                
        cmp     dl, 45 ; -
        jne     exitWhile1

continueWhile:
        ; inc i
        push    edx
        inc     ecx
        mov     edx, [ebp + 12] ; i
        mov     [edx], ecx
        pop     edx

        cmp     dl, 43 ; +
        je      sum

dupaIfSum:
        cmp     dl, 45 ; -
        je      dif

dupaIfDif:
        mov     ecx, [ebp + 12] ; i
        mov     ecx, [ecx]
        mov     dl, byte [ebx + ecx] ; caracter pozitia i
        
        jmp     while1

sum:    

        ; call term
        push    eax
        push    dword [ebp + 12] ; i
        push    dword [ebp + 8] ; p
        call    term
        add     esp, 8 ; pop de 2 ori
        
        ; adunarea
        add     eax, [esp]
        add     esp, 4
        
        jmp     dupaIfDif

dif:

        ; call term
        push    eax
        push    dword [ebp + 12] ; i
        push    dword [ebp + 8] ; p
        call    term
        add     esp, 8 ; pop de 2 ori

        ; salvez in edx, raspunsul la momentul i
        pop     edx

        ; interschimb pentru a face scaderea corect
        push    eax
        push    edx
        pop     eax
        pop     edx

        sub     eax, edx

        jmp     dupaIfDif

exitWhile1:


        leave
        ret
