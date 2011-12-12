var max = 0;
var current = 1;
var currentClass = 'empty';
var results = ["dummy"];

function $(e)
{
	return document.getElementById(e);
}
function matches(text, regex)
{
	var temp = text.match(regex);
	return temp ? temp.length : "none";
}
function onTextChanged(newText)
{
	$("the").innerHTML = matches(newText, /\bthe\b/ig);
	$("a").innerHTML = matches(newText, /\ba[n]?\b/ig);
}
function onLoad()
{
	var textarea = $("text");

	if (textarea.addEventListener) {    // all browsers except IE before version 9
		textarea.addEventListener ("input", OnInput, false);
			// Google Chrome and  Safari
		textarea.addEventListener ("textInput", OnTextInput, false);
			// Internet Explorer from version 9
		textarea.addEventListener ("textinput", OnTextInput, false);
	}
	
	if (textarea.attachEvent) { // Internet Explorer and Opera
		textarea.attachEvent ("onpropertychange", OnPropChanged);   // Internet Explorer
	}
	
	onTextChanged(textarea.value);
}
// Google Chrome, Safari and Internet Explorer from version 9
function OnTextInput(event)
{
	onTextChanged(event.data);
}
// Firefox, Google Chrome, Opera, Safari from version 5, Internet Explorer from version 9
function OnInput(event)
{
	onTextChanged(event.target.value);
}
// Internet Explorer
function OnPropChanged (event)
{
	if (event.propertyName.toLowerCase () == "value")
	{
		onTextChanged(event.srcElement.value);
	}
}
function startTest()
{
	$("edit").style.display="none";
	$("test").style.display="block";
	var text = $("text").value;
	var t = text.replace(/[\r\n]+/g, "<p>");
	var p = '';
	var id = 0;
	while (t != p)
	{
		p = t;
		++id;
		var s = "<span class='empty' id='" + id + "' onclick='setFocus(this)'>___</span>";
		var m = t.match(/\b(the|a|an)\b/);
		if (m != null)
		{
			results.push(m[0]);
		}
		t = t.replace(/\b(the|a|an)\b/, s);
	}
	max = id - 1;
	$("testText").innerHTML = t;
	$('1').className = 'current';
	
	$('body').onkeydown = onKeyDown;
	$('body').onkeypress = onKeyPress;
}
function onKeyDown(e)
{
	var article = $(current);
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
	var article = $(current);
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
		text = '___';
	}
	else if ((ch == 67) || (ch == 99))
	{
		check($('action'));
		return;
	}
	else if ((evt.keyCode == 8) || (evt.keyCode == 37))
	{
		if (current > 1)
		{
			article.className = currentClass;
			article = $(--current);
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
			article = $(++current);
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
		article = $(++current);
		currentClass = article.className;
		article.className = 'current';
	}
}
function setFocus(article)
{
	var old = $(current);
	old.className = 'empty';
	article.className = 'current';
	current = article.id;
}
function check(action)
{
	if (action.value == 'check')
	{
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
		
		var resultsText = document.getElementById('result');
		if (!errors)
		{
			resultsText.innerHTML = 'OK';
			resultsText.className = 'ok';
		
			action.value = 'again';
		}
		else
		{
			resultsText.innerHTML = errors + ' errors';
			resultsText.className = 'error';
		}
	}
	else
	{
		for (var i = max; i > 0; --i)
		{
			var article = document.getElementById(i);
			article.innerHTML = '___';
			article.className = 'empty';
		}
		article.className = 'current';
		
		action.value = 'check';
		var resultsText = document.getElementById('result');
		resultsText.innerHTML = '';
		resultsText.className = 'ok';
	}
}
