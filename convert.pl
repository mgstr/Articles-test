use strict;
use warnings;

my $fileName = shift;
my $max = shift;
$max = 999 if !defined $max;

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
	width: 40px;
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
var currentClass = 'empty';
function onLoad()
{
	document.getElementById('1').className = 'current';
}
function onKeyDown(e)
{
	var article = document.getElementById(current);
	if (!article)
		return;

	var evt = e || window.event;
	if (evt.keyCode == 39)
	{
		if (current < max)
		{
			article.className = currentClass;
			article = document.getElementById(++current);
			currentClass = article.className;
			article.className = 'current';
		}
		return;
	}
	else if ((evt.keyCode == 37) || (evt.keyCode == 8))
	{
		if (current > 1)
		{
			article.className = currentClass;
			article = document.getElementById(--current);
			currentClass = article.className;
			article.className = 'current';
		}
		return;
	}
}

function onKeyPress(e)
{
	var article = document.getElementById(current);
	if (!article)
		return;

	var evt = e || window.event;
	var text = null;
	var ch = evt.charCode || evt.keyCode;
	if ((ch == 84) || (ch == 116))
	{
		text = 'the';
	}
	else if ((ch == 65) || (ch == 97))
	{
		text = 'a';
	}
	else if ((ch == 78) || (ch == 110))
	{
		text = 'an';
	}
	else if (ch == 32)
	{
		text = '&nbsp;';
	}
	else if ((ch == 72) || (ch == 104))
	{
		check(document.getElementById('action'));
		return;
	}
	else if ((evt.keyCode == 8) || (evt.keyCode == 37))
	{
		if (current > 1)
		{
			article.className = currentClass;
			article = document.getElementById(--current);
			currentClass = article.className;
			article.className = 'current';
		}
		return;
	}
	else if (evt.keyCode == 39)
	{
		if (current < max)
		{
			article.className = currentClass;
			article = document.getElementById(++current);
			currentClass = article.className;
			article.className = 'current';
		}
		return;
	}

	if (!text)
		return;
	
	var same = article.innerHTML === text;
	article.innerHTML = text;
	if (current < max)
	{
		article.className = same ? currentClass : 'empty';
		article = document.getElementById(++current);
		currentClass = article.className;
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
		
			action.value = 'again';
		}
		else
		{
			results.innerHTML = errors + ' errors';
			results.className = 'error';
		}
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
function setFocus(article)
{
	var old = document.getElementById(current);
	old.className = 'empty';
	article.className = 'current';
	current = article.id;
}
</script>
</head>
<body onload='onLoad()' onkeydown='onKeyDown(event)' onkeypress='onKeyPress(event);return false;'>
<p class='header'>$id articles <input id='action' type='button' value='check' onclick='check(this);' acceskey='h'/> <span id='result'></span></p><p>
$_</p>
</body>
</html>
EOH

sub article
{
	my $a = shift;
	
	return $a if $id >= $max;
	
	my $al = "\L$a";
	++$id;
	$results .= ',' unless $results eq '';
	$results .= "'$al'";
	
	return "<span class='empty' id='$id' onclick='setFocus(this)'>&nbsp;</span>";
}