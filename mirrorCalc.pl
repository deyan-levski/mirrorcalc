#!/usr/bin/perl -w
#
#|---------------------------------------|
#| Calculate Current Mirrors Quickly ROT |
#|---------------------------------------|
#| Version P1A, Deyan Levski, 06.06.2018 |
#|---------------------------------------|
#|-+-|
#
#
use Math::Complex;

print " \n";
print "|--------------------------------------------------------------------------|\n";
print "|---------------Rule-of-Thumb Current Mirror Size Calculator---------------|\n";
print "|--------------------------------------------------------------------------|\n";
print "|                                                                          |\n";
print "|----------------------------Used Rules Per Se-----------------------------|\n";
print "| Area-driven mismatch: 20mV/sqrt(W*L), keeps sigma = 1                    |\n";
print "|                                                                          |\n";
print "| Vdsat of 200 mV reached with 1 uA/sq for NFET; 3 uA/sq for PFET          |\n";
print "|                                                                          |\n";
print "| Rout to be kept sufficiently high, current mirror calcs for DC bandwidth |\n";
print "|--------------------------------------------------------------------------|\n";
print "|                                                                          |\n";
print "|                  I1  --------                 I2                         |\n";
print "|                      |      |                     |                      |\n";
print "|                      |--|   |                  |--|                      |\n";
print "|                         ||--|-----------------||                         |\n";
print "|                      |<-|                      |->|                      |\n";
print "|                      |     M1              M2     |                      |\n";
print "|                  ------------------------------------                    |\n";
print "|                                                                          |\n";
print "|--------------------------------------------------------------------------|\n";

# Fixed params
my $vthmm = 20;

# Input parameters
print "Input current [uA]: ";
my $inputCurrent = <STDIN>;
print "Output current [uA]: ";
my $outputCurrent = <STDIN>;
print "Unit width [um]: ";
my $unitWidth = <STDIN>;
print "Target density [uA/sq]: ";
my $density = <STDIN>;
print "------------------------\n";

# Copy ratio
my $copyRatio = $outputCurrent/$inputCurrent;
print "Copy ratio [x]: $copyRatio \n";
print " \n";
# Unit length to start with
my $unitLength = 2; # unit length to start with

# Core current density calculations
my $wl = $unitWidth/$unitLength;
my $iDens = $inputCurrent/$wl;

# Iterate
#
my $width = $unitWidth;

for (my $i=0; $i <= 15; $i++) {

	if ($iDens > $density){
		$width = $width+$unitWidth;
		$wl = $width/$unitLength;
		$iDens = $inputCurrent/$wl;
	} elsif ($iDens < $density){
		$width = $width-$unitWidth;
		$wl = $width/$unitLength;
		$iDens = $inputCurrent/$wl;
	}

}
print "---------- DIODE DEVICE M1 ----------\n";
$mFactorM1 = $width/$unitWidth;
$wlM1 = ($unitWidth*$mFactorM1)/$unitLength;
$iDensM1 = $inputCurrent/$wlM1;

print "M1 current density [uA/sq]: $iDensM1\n";
print "M1 width [um]: $unitWidth";
print "M1 length [um]: $unitLength\n";
print "M1 m-factor [m]: $mFactorM1\n";
print "\n";

print "---------- BIAS DEVICE M2 -----------\n";
$mFactorM2 = $mFactorM1*$copyRatio;
$wlM2 = ($unitWidth*$mFactorM2)/$unitLength;
$iDensM2 = $outputCurrent/$wlM2;

print "M2 current density [uA/sq]: $iDensM2\n";
print "M2 width [um]: $unitWidth";
print "M2 length [um]: $unitLength\n";
print "M2 m-factor [m]: $mFactorM2\n";
print "\n";

print "----------- MIRROR STATS ------------\n";
$sigmaM1=$vthmm/sqrt($wlM1);
$varM1=$sigmaM1**2;
$sigmaM2=$vthmm/sqrt($wlM2);
$varM2=$sigmaM2**2;

print "Sigma M1, [mV]: $sigmaM1 \n";
print "Var   M1, [mV]: $varM1 \n";
print "Sigma M2, [mV]: $sigmaM1 \n";
print "Var   M2, [mV]: $varM2 \n";
print "Vth mismatch, [mV]: $vthmm \n";
print "\n";

