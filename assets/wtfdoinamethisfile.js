function trimresults()
{
	var input, filter, tr, td, i, j, tds, ths, matched;
    input = document.getElementById("searchpackages");
    filter = input.value.toUpperCase();
    tr = document.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++)
	{
        tds = tr[i].getElementsByTagName("td");
        ths = tr[i].getElementsByTagName("th");
        matched = false;
        if (ths.length > 0)
		{
            matched = true;
        }
        else
		{
            for (j = 0; j < tds.length; j++)
			{
                td = tds[j];
                if (td.innerHTML.toUpperCase().indexOf(filter) > -1)
				{
                    matched = true;
                    break;
                }

            }
        }
        if (matched == true)
		{
            tr[i].style.display = "";
        }
        else
		{
            tr[i].style.display = "none";
        }
	}
}