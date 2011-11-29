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
	background-color: grey;
}
.empty {
	background-color: LightGray;
}
.current {
	background-color: yellow;
}
</style>
<script type="text/javascript">
var max = $id;
var current = 1;
function onLoad()
{
	document.getElementById('1').className = 'current';
}
function onKeyPress(e)
{
	var evt = e || window.event;
	if ((evt.charCode == 84) || (evt.charCode == 116))
	{
		document.getElementById(current).innerHTML='the';
	}
}
</script>
</head>
<body onload='onLoad()' onkeydown='return false;' onkeypress='onKeyPress(event);return false;'>
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
	return "<span class='empty' id='$id'>&nbsp;</span>";
}