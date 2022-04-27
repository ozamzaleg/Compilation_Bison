build:
	flex tennis.lex
	bison -d tennis.y
	gcc -o tennis lex.yy.c tennis.tab.c

clean:
	rm -rf *.c *.h tennis

