function onTextChanged(newText)
{
	document.getElementById("the").innerHTML = newText.match(/\bthe\b/ig).length;
	document.getElementById("a").innerHTML = newText.match(/\ba[n]?\b/ig).length;
}
function init()
{
	var textarea = document.getElementById ("text");

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
function action()
{
	var root = document.getElementById('root');
	var text = document.getElementById("text").value;
	if (root.hasChildNodes())
	{
		while (root.childNodes.length >= 1)
		{
			root.removeChild(root.firstChild);
		} 
	}
	var t = text.replace(/[\r\n]+/g, "<p>");
	var prev = '';
	var i = 1;
	while (t != prev)
	{
		prev = t;
		t = t.replace(/\b(the|a|an)\b/, i++);
	}
	root.innerHTML = t;
}
