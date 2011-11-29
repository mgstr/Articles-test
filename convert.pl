use strict;
use warnings;

my $fileName = 'data.txt';

open(D, $fileName) or die;
undef $/;
$_ = <D>;

my $id = 0;

s/(the)/article($1)/gei;
print $_;

sub article
{
	my $a = shift;
	my $al = "\L$a";
	++$id;
	return "<span class='empty' id='$id' />";
}