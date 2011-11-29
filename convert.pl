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
	var article = document.getElementById(current);
	if (!article)
		return;

	var evt = e || window.event;
	var text = null;
	if ((evt.charCode == 84) || (evt.charCode == 116))
	{
		text = 'the';
	}
	else if ((evt.charCode == 65) || (evt.charCode == 97))
	{
		text = 'a';
	}
	else if ((evt.charCode == 78) || (evt.charCode == 110))
	{
		text = 'an';
	}
	else if (evt.charCode == 32)
	{
		text = '&nbsp;';
	}
	else if (evt.keyCode == 8)
	{
		if (current > 1)
		{
			article.className = 'empty';
			article = document.getElementById(--current);
			article.className = 'current';
		}
		return;
	}

	if (!text)
		return;
	
	article.innerHTML = text;
	if (current < max)
	{
		article.className = 'empty';
		article = document.getElementById(++current);
		article.className = 'current';
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