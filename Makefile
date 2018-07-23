all:
	gcc -Wall -Wpedantic -o ping ping.c

clean:
	rm -rf *.o *.s *.i
	rm -rf test ping
