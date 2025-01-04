SHELL		 = /bin/bash

VENDOR		?= asylum
LIBRARY 	?= soc
NAME		?= OB8_GPIO
VERSION		?= 1.1.0
VLNV		?= $(VENDOR):$(LIBRARY):$(NAME):$(VERSION)

PATH_BUILD	?= $(CURDIR)/build
PATH_CACHE	 = /home/user/.cache/fusesoc

TARGETS  	:=
TARGETS  	+= sim_asm_identity
TARGETS  	+= sim_c_identity
TARGETS  	+= ng_medium_c_identity

TARGET		:= ng_medium_c_identity

#========================================================
# Rules
#========================================================

#--------------------------------------------------------
# Display list of target
help :
#--------------------------------------------------------
	@echo ""
	@echo ">>>>>>>  Makefile Help"
	@echo ""
	@echo "=======| Variables"
	@echo "VLNV   : Vendor/Library/Name/Version"
	@echo "         $(VLNV)"
	@echo "TARGET : Specific Target for Fusesoc"
	@echo "         $(TARGET)"
	@echo ""
	@echo "=======| Target"
	@echo "help   : Display this message"
	@echo "info   : Display library list and cores list"
	@echo "nonreg : Run pre-defined target list"
	@echo "         $(TARGETS)"
	@echo "clean  : Remove build directory"
	@echo "         $(PATH_BUILD)"
	@echo "purge  : Remove fusesoc cache directory"
	@echo "         $(PATH_CACHE)"
	@echo "setup  : Execute Setup stage of fusesoc flow for specific target"
	@echo "build  : Execute Build stage of fusesoc flow for specific target"
	@echo "run    : Execute Run   stage of fusesoc flow for specific target"
	@echo "*      : Run command"
	@echo ""
	@echo ">>>>>>>  Core Information"
	@echo ""
	@fusesoc core-info $(VLNV)

.PHONY : help

#--------------------------------------------------------
# Display library list and cores list
info :
#--------------------------------------------------------
	@fusesoc library list
	@fusesoc list-cores

.PHONY : info


#--------------------------------------------------------
setup build run :
#--------------------------------------------------------
	fusesoc run --build-root $(PATH_BUILD) --$@ --target $(TARGET) $(VLNV)

.PHONY : setup build run

#--------------------------------------------------------
% :
#--------------------------------------------------------
	@fusesoc run --build-root $(PATH_BUILD) --target $* $(VLNV)

#--------------------------------------------------------
nonreg : \
	$(TARGETS)
#--------------------------------------------------------
# nothing

.PHONY : nonreg


#--------------------------------------------------------
purge : \
	clean
#--------------------------------------------------------
	rm -fr $(PATH_CACHE)

.PHONY : purge

#--------------------------------------------------------
clean :
#--------------------------------------------------------
	rm -fr $(PATH_BUILD)

.PHONY : clean
