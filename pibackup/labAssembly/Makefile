parts=$(wildcard part*.s)
partsTgts=$(parts:%.s=%)

all: $(partsTgts)
	@echo "All parts compiled!"
	
part%: part%.s
	  @echo "Making $@"
	  gcc -g -Wall $^ helper.s -lblinkt -o $@
	  @echo ""

clean:
	$(RM) $(RF) $(partsTgts)
