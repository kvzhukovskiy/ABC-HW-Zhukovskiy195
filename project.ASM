format PE console
entry start

include 'win32a.inc'
 
section '.data' data readable writeable

        message    db  '������ ���', 0
        s          db  '�', 0
        output     db  'Index = %d', 0
        wrong      db  'Substring isnt in string', 0
        i          dd  ?


section '.code' code readable executable

start:
       mov esi, message       ;��� ������
       mov edi, s             ;��� ������
       call pos               ;�������� ������� ������
                              ;��� ������ � ��� ����� �������, � �������� ���������� ���������� ������
       invoke ExitProcess,0   ;��� ����� ����������� ������ �� ��������� ��� �����
       ret

; ���� ������� ������ ������� ���������
proc pos
       xor eax,eax   ;������� ��������, � �������� ����� �������� ��� ������ - ��� �������� �������
       xor ecx,ecx   ;��� �������� ���-�� ���������� �������� � ��������� - ����� ��������� �� �����
       xor ebx,ebx   ;� ��� ���������, ���� ����� ��������� ������������ ������

       mov edx,edi   ;EDX ��� ����������� ��� ��������� � ������ ��������, ��� ������������ �������� � ������

       cmp byte [esi],0       ;���� ����� �������� ������
       je exit                ;�������
       cmp byte [edi],0       ;���� ����� ������� ������
       je exit                ;���� �������

;����� ������ ���� ������
for:
       inc eax                ;�������� ������� �������, �� ������� ���������� ������
       mov bl,byte [esi]      ;������� ��������� ������������ ������
       cmp bl,[edi]           ;� ������� ��� � �������� � ������� ������
       jne no                 ;���� ������� �� ����� ������������� �� ��������� � �������� ������ � ����������� ��������� �����
       inc ecx                ;����� �������� ������� ����� ��������
       inc edi                ;���������� �� ��������� ������ � ������� ������
       cmp byte [edi],0       ;� ������ �� ����� �� ��������
       je exitproc            ;���� ����� - ������ �������. �������.
       jmp nextiter           ;����� ������ �� ��������� �������� ����� ������
no:
       sub esi,ecx            ;��������� ������������ ���� ���� ��� �������
       ;����� ������ ��������� ��� ���������� ������������ �� ��� ������, � �������� �� ������.
       ;����������� ��� ������������ ��������� �������� � ������� � ������� ������� � ���������
       xor ecx,ecx            ;����� �� ������� �������� � ���� ���-�� ��������� ��������, ��� ��� �� �������
       mov edi,edx            ;� ������������� � ������ ������� ������ ��� ������ � ���������� �������
       cmp byte [esi],0       ;���� ����� �������� ������, ������ ��������� �� ������
       je exit                ;�������
nextiter:
       inc esi                ;��� ������ �������� ����� ������������� � ������� �� ������ � �������� ������
       jmp for                ;� ������� �� ��������� ��� �����
exitproc:
       sub eax,ecx            ;��������� � ��� ��� ����� ��������� �� ������� ���������� ������� ��������,
       ;�������� ������ �� ���� ����� ��������, ���� �������� ������� ������������ � ����
       mov [i], eax           ;������ ���������� ������ � ����������
       push [i]               ;� ������� �����
       push output
       call [printf]
       call [getch]
       ret
exit:
       push wrong             ;������ ��������� � �������
       call [printf]
       call [getch]
       ret
endp;

section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'
include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
