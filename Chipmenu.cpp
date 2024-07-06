#include <ctype.h>
#include <fstream.h>
#include <conio.h>
#include <iostream.h>
#include <process.h>
#include <string.h>


typedef unsigned char byte;

void main(int args, char* argv[])
	{
	ifstream infile;
	ofstream outfile;

	char spelnamn[11][9];
	byte antal_spel = args-1;
	byte byteread;

	unsigned long filebytes = 0;


	int i,j,k,bytes;
	long l;
	int spawn_result;

	clrscr();
	textmode(C80);
	textbackground(RED);
	textcolor(WHITE);
	cprintf("                 ");
	cprintf("CHIP8 Multicart composer for GB/CHIP8 emulator");	//46chars
	cprintf("                 \n");
	textbackground(BLACK);
	textcolor(WHITE);

	cprintf("Number of games to load: ");

	textcolor(RED);
	if(args > 11 )
		{
		cprintf ("Failed: Too many games specified...\r\n");
		exit(1);
		}
	else if(args < 2)
		{
		cprintf ("Failed: No filename(s) specified...\r\n");
		exit(1);
		}
	else
		{
		textcolor(LIGHTGRAY);
		cprintf("%d\r\n",(int) antal_spel);
		}

	textcolor(WHITE);
	cprintf ("Writing menu program.");
	outfile.open("GBCHIP8.GB",ios::binary|ios::out);
	if(outfile.fail())
		{
		textcolor(RED);
		cprintf(" Failed: Couldn't create file 'GBCHIP8M.GB'\r\n");
		exit(1);
		}
	infile.open("GBCHIP8.DAT",ios::binary|ios::in);
	if(infile.fail())
		{
		textcolor(RED);
		cprintf(" Failed: Couldn't open 'GBCHIP8.DAT'\r\n");
		outfile.close();
		exit(1);
		}

	for(l=0;l<32768;l++)
		{
		infile.get(byteread);
		if(infile.fail())
			{
			textcolor(RED);
			cprintf(" Failed: Error when reading 'GBCHIP8.DAT'\r\n");
			exit(1);
			}
		outfile.put(byteread);
		filebytes++;
		}
	infile.close();
	textcolor(GREEN);
	cprintf(" Done\r\n");

	textcolor(WHITE);
	cprintf ("Preparing header... ");


	outfile << "CHIP8";			//identifier
	outfile << antal_spel;		//nr. of games
	filebytes+=6;

	for(i=0;i<11;i++)
		{
		if(i<antal_spel)	strncpy(spelnamn[i],argv[i+1],8);

		else					strncpy(spelnamn[i],"        ",8);

		for(j=0;j<8;j++)
			{
			spelnamn[i][j] = toupper(spelnamn[i][j]);
			outfile.put(spelnamn[i][j]);
			filebytes++;
			}
		spelnamn[i][8] = NULL;		//terminate string
		}
	for(i=0;i<4002;i++)
		{
		outfile.put(0);
		filebytes++;
		}
	textcolor(GREEN);
	cprintf("  Done\r\n");

	for(i=0;i<antal_spel;i++)
		{
		textcolor(WHITE);
		cprintf("Writing '%s'...",spelnamn[i]);
		infile.open(spelnamn[i],ios::binary,ios::in);
		if(infile.fail())
			{
			textcolor(RED);
			if( strlen(spelnamn[i]) != 8)
				for(k=0;k<(8-strlen(spelnamn[i]));k++)	cprintf(" ");
			cprintf(" Failed: Couldn't open '%s'\r\n",spelnamn[i]);
			infile.close();
			exit(1);
			}

		bytes=0;
		infile.get(byteread);
		while(!infile.fail())
			{
			bytes++;
			if(bytes > 4096)
				{
				textcolor(RED);
				if( strlen(spelnamn[i]) != 8)
					for(k=0;k<(8-strlen(spelnamn[i]));k++)	cprintf(" ");
				cprintf(" Failed: Not a valid CHIP8 game...\r\n");
				exit(1);
				}
			outfile.put(byteread);
			filebytes++;
			infile.get(byteread);
			}
		infile.close();

		for(j=0;j<4096-bytes;j++)
			{
			outfile.put(0);
			filebytes++;
			}

		textcolor(GREEN);
		if( strlen(spelnamn[i]) != 8)
			for(k=0;k<(8-strlen(spelnamn[i]));k++)	cprintf(" ");

		cprintf(" Done ");
		textcolor(LIGHTGRAY);
		cprintf("(%i bytes)\r\n",bytes);
		}

	if(filebytes<65536)
		{
		textcolor(WHITE);
		cprintf("Padding file to 64Kb ");
		while(filebytes<65536)
			{
			outfile.put(0);
			filebytes++;
			}
		textcolor(GREEN);
		cprintf(" Done\r\n");
		}
	else if (filebytes<131072)
		{
		textcolor(WHITE);
		cprintf("Padding file to 128Kb ");
		while(filebytes<131072)
			{
			outfile.put(0);
			filebytes++;
			}
		textcolor(GREEN);
		cprintf("Done\r\n");
		}
	outfile.close();

	textcolor(WHITE);
	cprintf("Running RGBFIX...     ");
	textcolor(LIGHTGRAY);

	spawn_result = spawnlp(P_WAIT, "RGBFIX.EXE", "-p" ,"-v", "GBCHIP8.GB" ,NULL);
	if (spawn_result == -1)
		{
		textcolor(RED);
		cprintf("Failed: Couldn't find RGBFIX\r\n\r\n");
		cprintf("WARNING: ");
		textcolor(LIGHTGRAY);
		cprintf("You might need to run ");
		textcolor(WHITE);
		cprintf("RGBFIX ");
		textcolor(LIGHTGRAY);
		cprintf("to fix the checksum if you want to run this on a real gameboy!\r\n");
		}
	cprintf("\r\n");


	textcolor(WHITE);
	cprintf("GBCHIP8.GB written OK!\r\n");
	}
