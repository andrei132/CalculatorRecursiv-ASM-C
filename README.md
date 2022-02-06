# Calculator recursiv mutual in asm/C
## Girnet Andrei

## Descriere
---
Este implementat un calculator care foloseste recursivitatea mutuala pentru a calcula o expresie matematica.

## Implementare
Sunt implementate 3 functii:

- `expression(char *p, int *i)`
    - evaluează expresii de tipul `term + term` sau `term - term`
- `term(char *p, int *i)`
    - evaluează expresii de tipul `factor * factor` sau `factor / factor`
- `factor(char *p, int *i)`
    - evaluează expresii de tipul `(expression)` sau `number`, unde număr este o secvenţă de cifre

### Precizări:
- `p` este şirul de caractere
- `i` este poziţia actuală în şirul de caratere (atenţie, acesta va trebui actualizat în funcţii)
- numerele vor fi întregi pozitive, însă în urma operaţiilor pot apărea numere negative
- împărţirile vor fi făcute pe numere întregi
- rezultatele se încadrează pe tipul `int`
- expresiile primite vor fi corecte

## Exemplu de test:

| `test.in `     | `test.out` |
|----------------|------------|
|```15+8*2000``` | ```16015```|

Drepturile de autor asupra conditiei, checker-ului si testelor apartin echipei IOCLA UPB 2021-2022
