COMMITS=$(shell git log --oneline | wc -l)
MIN_COMMITS=12

JAVA_SRC=encode_utf8.j 
MIPS_SRC=

all: test_java_code test_mips_code

test_java_code: $(JAVA_SRC)
	java_subroutine encode_utf8 0x0920
	java_subroutine encode_utf8 0x0042
	java_subroutine encode_utf8 0x5555
	java_subroutine decode_utf8 < 5D.txt
	java_subroutine decode_utf8 < E9A3B1.txt
	java_subroutine decode_utf8 < 85.txt
	java_subroutine decode_utf8 < D1B2.txt



test_mips_code: $(MIPS_SRC)

validate: $(JAVA_SRC) $(MIPS_SRC) tags number_commits
	-make -k  all > validation.output 2>&1
	-git add validation.output
	-git commit -m 'Auto adding validation step' validation.output
	@echo Validation File has been committed if there were changes


# Currently, the number of commits does not work on the server side
# the log file only shows the most recent entry -- 
# not sure why or what the work around is.
number_commits:
	@-test ! $(COMMITS) -lt $(MIN_COMMITS) || \
	  { echo "Not enough commits" && false ; } 

tags:


clean:
	-rm -f test_java_code
	-rm -f test_mips_code


