object=driver.o
stem=$(basename $(object))

all: prove

%.o:%.adb %.ads $(stem).gpr
		gnatmake  $*.adb

.Phony: prove

prove: $(object)
		gnatprove -P $(stem).gpr --timeout=2000 --report=statistics # --proof=progressive 

clean:
		rm -rf gnatprove/ *.ali *.o driver
