#!/usr/bin/perl
use strict; use warnings;

use File::Basename;
use File::Spec;
use Cwd;

my $dotfilesDir = dirname(Cwd::abs_path($0));
my $targetDir = $ENV{"HOME"};

print "# run the output of this file into a sh if you are happy with the commands, e.g. ./install.pl | sh\n"

while (<$dotfilesDir/.* $dotfilesDir/*>) {
	my $fileName = basename($_);
	if ($fileName eq "install.pl" || ! -f $fileName) {
	}
	else {
		my $sourceFile = File::Spec->catfile($dotfilesDir, $fileName);
		my $targetFile = File::Spec->catfile($targetDir, $fileName);
		my $execStr = "ln -s '$sourceFile' '$targetFile'";
		if (-e $targetFile) {
			$execStr = "# " . $execStr . " # file exists" 
		}
		print $execStr . "\n";
	}
}




