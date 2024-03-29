# A Makefile (Microsoft NMAKE) for building PFS subroutine
# libraries CallCfast.dll, CallFds.dll, CallOptimist.dll,
# CallOzone.dll and Statistics.dll

# Compiler and linker

FC=ifort
LD=link

# Compiler and linker options

FCFLAGS=-compile_only -nologo -warn:nofileopt \
				-optimize:4 -integer_size:32 -traceback
LDFLAGS=kernel32.lib -nologo -incremental:no \
				-pdb:$*.pdb -machine:I386 -dll

# Rules

all: CallCfast.dll CallFDS.dll CallOptimist.dll \
	CallOzone.dll Statistics.dll
	@echo 'All done'

CallCfast.dll: $*.obj
	$(LD) $(LDFLAGS) $*.obj

CallCfast.obj: $*.f90
	$(FC) $(FCFLAGS) $*.f90

CallFds.dll: $*.obj
	$(LD) $(LDFLAGS) $*.obj

CallFds.obj: $*.f90
	$(FC) $(FCFLAGS) $*.f90

# CallOptimist.dll requires IMSL numerical libraries

CallOptimist.dll: $*.obj modules.obj temperatures.obj vent.obj
	$(LD) $(LDFLAGS) -imsl  $*.obj

CallOptimist.obj: $*.f90 modules.for temperatures.for vent.for
	$(FC) $(FCFLAGS) $*.f90 $?

CallOzone.dll: $*.obj
	$(LD) $(LDFLAGS) $*.obj

CallOzone.obj: $*.f90
	$(FC) $(FCFLAGS) $*.f90

# Statistics.dll requires IMSL numerical libraries

Statistics.dll: $*.obj ranmar.obj spear.obj genprm.obj dcdflib_all.obj
	$(LD) $(LDFLAGS) -imsl $*.obj

Statistics.obj: $*.f90 ranmar.for spear.for genprm.for dcdflib_all.for
	$(FC) $(FCFLAGS) $*.f90 $?

clean:
	del CallCfast.dll CallFds.dll CallOptimist.dll CallOzone.dll Statistics.dll
	del CallCfast.obj CallFds.obj CallOptimist.obj CallOzone.obj Statistics.obj
	del CallCfast.exp CallFds.exp CallOptimist.exp CallOzone.exp Statistics.exp
	del CallCfast.lib CallFds.lib CallOptimist.lib CallOzone.lib Statistics.lib
	del comm.mod discharge.mod drops.mod stats.mod temps.mod vent.mod
	del modules.obj temperatures.obj vent.obj
	@echo 'Clean done'
