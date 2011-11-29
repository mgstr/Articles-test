use strict;
use warnings;

my $fileName = 'data.txt';

open(D, $fileName) or die;
undef $/;
$_ = <D>;

my $id = 0;
my $results = '';

s/\b(the|a|an)\b/article($1)/gei;
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
.error {
	background-color: red;
}
.ok {
	background-color: LightGreen;
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
function check(action)
{
	if (action.value == 'check')
	{
		var results = ['dummy', $results];
		var errors = 0;
		
		for (var i = 1; i <= max; ++i)
		{
			var article = document.getElementById(i);
			if (article.innerHTML == results[i])
			{
				article.className = 'ok';
			}
			else
			{
				article.className = 'error';
				++errors;
			}
		}
		
		var results = document.getElementById('result');
		if (!errors)
		{
			results.innerHTML = 'OK';
			results.className = 'ok';
		}
		else
		{
			results.innerHTML = errors + ' errors';
			results.className = 'error';
		}
		
		action.value = 'again';
	}
	else
	{
		for (var i = max; i > 0; --i)
		{
			var article = document.getElementById(i);
			article.innerHTML = '&nbsp;';
			article.className = 'empty';
		}
		article.className = 'current';
		
		action.value = 'check';
		var results = document.getElementById('result');
		results.innerHTML = '';
		results.className = 'ok';
	}
}
</script>
</head>
<body onload='onLoad()' onkeydown='return false;' onkeypress='onKeyPress(event);return false;'>
<p class='header'>$id articles <input id='action' type='button' value='check' onclick='check(this)'/> <span id='result'></span></p><p>
$_</p>
</body>
</html>
EOH

sub article
{
	my $a = shift;
	my $al = "\L$a";
	++$id;
	$results .= ',' unless $results eq '';
	$results .= "'$al'";
	
	return "<span class='empty' id='$id'>&nbsp;</span>";
}