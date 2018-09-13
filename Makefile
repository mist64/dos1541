all:
	ca65 -g dos.s
	ld65 -C dos.cfg -o dos.bin dos.o -Ln dos.lbl -m dos.map

clean:
	rm dos.o dos.bin
