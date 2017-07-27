/* by munjeni @ 2017 */

#ifdef _WIN32
	#define __USE_MINGW_ANSI_STDIO 1
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#ifdef HAS_STDINT_H
	#include <stdint.h>
#endif
#ifdef unix
	#include <unistd.h>
	#include <sys/types.h>
	#include <sys/stat.h>
#else
	#include <direct.h>
	#include <io.h>
#endif

#define MAGIC 0xF97CFF8A

#define S_IFMT	  00170000
#define S_IFSOCK	0140000
#define S_IFLNK		0120000
#define S_IFREG		0100000
#define S_IFBLK		0060000
#define S_IFDIR		0040000
#define S_IFCHR		0020000
#define S_IFIFO		0010000
#define S_ISUID		0004000
#define S_ISGID		0002000
#define S_ISVTX		0001000

#define S_ISLNK(m)	(((m) & S_IFMT) == S_IFLNK)
#define S_ISREG(m)	(((m) & S_IFMT) == S_IFREG)
#define S_ISDIR(m)	(((m) & S_IFMT) == S_IFDIR)
#define S_ISCHR(m)	(((m) & S_IFMT) == S_IFCHR)
#define S_ISBLK(m)	(((m) & S_IFMT) == S_IFBLK)
#define S_ISFIFO(m)	(((m) & S_IFMT) == S_IFIFO)
#define S_ISSOCK(m)	(((m) & S_IFMT) == S_IFSOCK)

char *mode_to_string(unsigned int mode)
{
	if (S_ISBLK(mode))
		return "-b";
	else if (S_ISCHR(mode))
		return "-c";
	else if (S_ISDIR(mode))
		return "-d";
	else if (S_ISFIFO(mode))
		return "-p";
	else if (S_ISLNK(mode))
		return "-l";
	else if (S_ISSOCK(mode))
		return "-s";
	else if (S_ISREG(mode))
		return "--";
	else
		return "";
}

int main(int argc, char *argv[])
{
	unsigned int selinux_vers;
	unsigned int nothing;
	unsigned int i;
	unsigned int steams;
	unsigned int num_of_regex;

	char steam[256];
	char src[512];
	char context[512];

	FILE *fp = NULL;
	FILE *fpout = NULL;

	if (argc != 3) {
		printf("usage: %s BINARY_FILE OUTPUT_TEXT_FILE\n", argv[0]);
		printf("e.g: %s file_contexts.bin file_contexts\n", argv[0]);
		return 1;
	}

	if ((fp = fopen(argv[1], "rb")) == NULL) {
		printf("Unable to open %s : ", argv[1]);
		perror("");
		return 1;
	}
	fread(&nothing, 1, 4, fp);
	if (nothing != MAGIC) {
		printf("%s is not a binary!\n", argv[1]);
		if (fp) fclose(fp);
		return 1;
	}

	fread(&nothing, 1, 4, fp);
  selinux_vers = nothing;
	fread(&nothing, 1, 4, fp);
	fseek(fp, (unsigned int)ftell(fp) + nothing, SEEK_SET);

	fread(&nothing, 1, 4, fp);
	//printf("num of steams: 0x%x\n", nothing);

	for (i=0; i<nothing; ++i) {
		fread(&steams, 1, 4, fp);
  	fread(steam, 1, steams+1, fp);
		//printf("%s\n", steam);
	}

	fread(&num_of_regex, 1, 4, fp);
	//printf("num of regex: 0x%x\n", num_of_regex);

	if ((fpout = fopen(argv[2], "wb")) == NULL) {
		printf("unable to open %s for write!\n", argv[2]);
		if (fp) fclose(fp);
		return 1;
	}

  //printf("selinux version: %d\n", selinux_vers);
  fprintf(fpout, "#context version %d\n", selinux_vers);

	for (i=0; i<num_of_regex; ++i) {
		fread(&nothing, 1, 4, fp);
  	fread(context, 1, nothing, fp);
    fread(&nothing, 1, 4, fp);
    fread(src, 1, nothing, fp);
		//printf("%s %s\n", src, context);
		fread(&nothing, 1, 4, fp);
		fprintf(fpout, "%s\t%s\t%s\n", src, mode_to_string(nothing), context);
  	fseek(fp, (unsigned int)ftell(fp) + 12, SEEK_SET);
		fread(&nothing, 1, 4, fp);
    fseek(fp, (unsigned int)ftell(fp) + nothing, SEEK_SET);
		fread(&nothing, 1 , 4, fp);
    fread(&nothing, 1 , 4, fp);
    fseek(fp, (unsigned int)ftell(fp) + nothing - 4, SEEK_SET);
	}

	if (fp) fclose(fp);
	if (fpout) fclose(fpout);

	return 0;
}
