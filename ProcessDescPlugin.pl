use strict;
use Bio::SeqIO;

my $s;
my $in;
my $st;

sub input {
   #my $inputfile;
   #my $fin;
   #open(my $inputfile, '<:encoding(UTF-8)', @_[0])
   #  or die "Could not open file '@_[0]' $!";
   #$fin = <$inputfile>;
   #$s = <$inputfile>;
   #chomp($fin);
   #chomp($s);
   $in = Bio::SeqIO->newFh(-file => "<@_[0]", -format => 'fasta');
   return;
}

sub run {
   return;
}

sub output {
open(FH, '>', @_[0]) or die $!;
my $seq;
my $count = 0;
while ($seq = <$in>) { # read the next sequence
    $count++;
    my $d = $seq->desc();
    my $s = $seq->seq();

    my $domain = "";
    if ($d =~ "archae") {
	$domain = "Arch ";
    } elsif ($d =~ "prokaryote") {
	$domain = "? ";
    } else {
	$domain = "B ";
    }
    my $genus = "-";
    my $species = "-";
    my $strain = "-";
    my $gid = "-";
    # print "$d\n";
    my @DA = split(/;/, $d);
    if ($#DA >= 2) {
	$strain = $DA[1];
	$strain =~ s/ //g; # Do I really need this?
	$gid = $DA[$#DA];
	my @parts = split(/ /, $DA[0]);
	if ($#parts == 0) {
	    print FH "=====>|$d|\n";
	} else {
	    if (($parts[0] ne "uncultured") && ($parts[0] ne "unidentified")) {
		$genus = $parts[0];
		$species = $parts[1];
	    } elsif (($parts[1] ne "bacterium") && ($parts[1] ne "archaeon") &&
		     ($parts[1] ne "eubacterium") && ($parts[1] ne "prokaryote")) {
		$genus = $parts[1];
	    }
	}
	#if ($debug == 1) {
	    print FH "$domain\t$genus\t$species\t$strain\t$gid\t$d\n";
	#} else {
	#    print "$domain\t$genus\t$species\t$strain\t$gid\n";
	#}
    } elsif ($#DA == 1) {
	$gid = $DA[1];
	my @parts = split(/ /, $DA[0]);
	if ($#parts >= 0) {
	    if (($parts[0] ne "uncultured") && ($parts[0] ne "unidentified")) {
		$genus = $parts[0];
		if ($#parts >= 1) {
		    if (($parts[1] ne "sp.") && ($parts[1] ne "str.")
			&& ($parts[1] ne "bacterium")) {
			$species = $parts[1];
			if ($#parts >= 2) {
			    $strain = $parts[2]; # what if there is more
			    if ($#parts >= 3) {
				$strain = $strain.$parts[3];
			    }
			}
		    } else {
			if ($#parts >= 2) {
			    $strain = $parts[2]; # what if there is more
			    if ($#parts >= 3) {
				$strain = $strain.$parts[3];
			    }
			}
		    }			
		}
	    } elsif (($parts[1] ne "bacterium") && ($parts[1] ne "archaeon") &&
		     ($parts[1] ne "eubacterium") && ($parts[1] ne "prokaryote")) {
		$genus = $parts[1];
		if ($#parts >= 2) {
		    if ($parts[2] ne "bacterium") {
			$strain = $parts[2]; # what if there is more
		    } elsif ($#parts >= 3) {
			$strain = $parts[3]; # what if there is more
		    }
		}
	    }
	}
	#if ($debug == 1) {
	    print FH "$domain\t$genus\t$species\t$strain\t$gid\t$d\n";
	#} else {
	#    print FH "$domain\t$genus\t$species\t$strain\t$gid\n";
	#}
    } else {
	if (($DA[0] ne "uncultured") && ($DA[0] ne "unidentified")) {
	    $genus = $DA[0];
	}
	#if ($debug == 1) {
	    print FH "$domain\t$genus\t$species\t$strain\t$gid\t$d\n";
	#} else {
	#    print FH "$domain\t$genus\t$species\t$strain\t$gid\n";
	#}
    }
}

   close(FH);

   return;
}



