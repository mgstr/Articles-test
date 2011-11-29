use strict;
use warnings;

my $fileName = 'data.txt';

open(D, $fileName) or die;
undef $/;
$_ = <D>;

my $id = 0;

s/\b(the)\b/article($1)/gei;
s![\r\n]+$!!;
s![\r\n]+!</p><p>!g;

print <<EOH;
<html>
<head>
<style type="text/css">
.header {
	background-color:grey;
}
</style>
</head>
<body>
<p class='header'>Found $id articles</p><p>
$_</p>
</body>
</html>
EOH

sub article
{
	my $a = shift;
	my $al = "\L$a";
	++$id;
	return "<span class='empty' id='$id' />";
}