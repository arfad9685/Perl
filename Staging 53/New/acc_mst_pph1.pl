sub acct_mst_pph {
    &get_access;
    #style_module::use_warning()
    require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
    require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
    #&con_fin0;
    #&con_fin1;
#
    xml_module::view_table("facc/tb_mst_pph","ss=$in{ss}",1);

print qq~
<script type="text/javascript">
     
   function tab_view1(data) {
        var x, txt=" ";       
        txt += "<table class='main-table mobile-optimised' >";
        txt +="<thead><tr>";
        txt +="<th align='center'>Jenis Biaya</th>";
        txt +="<th align='center'>Jenis Usaha</th>";
        txt +="<th align='center'>Tarif NPWP</th>";
        txt +="<th align='center'>Tarif NON-NPWP</th>";
        txt +="<th align='center'>Jenis Print</th>";
        txt +="<th align='center'>No ACC</th>"; ~;
        
        print qq~        
        txt +="</tr></thead>";
        txt +="<tbody>";
        
        for (x in data) {
           if (data[x].isaktif=='N') {
              tutup="style='color:red'";
           } else {
              tutup="";
           }
           txt += "<tr class=huruf2 "+tutup+"><td align=left>&nbsp;"+data[x].jnsbiaya+"</td><td align=left>&nbsp;"+data[x].jnsush+"</td><td align=left>&nbsp;"+data[x].tarifnpwp+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].tarifnon+"</td><td align=left>&nbsp;"+data[x].jnsprint+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].noacc+"&nbsp;</td>";
           ~;
           
           print qq~           
           txt += "</tr>";
        }
        txt +="</tbody></table>";        
        document.getElementById("pph").innerHTML = txt;               
   }
 </script> 
 
    <p><br><p><p><p>~;
   if (index($rws,'W') ne (-1)) {
    print qq~
    <form method=post action="/cgi-bin/store.cgi" id="form_str">
    <input name="pages" type="hidden" value=acct_mst_pph>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <input name="aktif" id="aktif" type="hidden" value="$in{aktif}">
    <table width=1000><tr><td colspan=6 class=hurufcol style='text-align:left'><input type=checkbox name="all" id="all" $aktif onClick="chk_all()">&nbsp;Active Store Only</td></tr></table>
    </form>~;
   }
   print qq~
    <div id="pph" class="table-scroll tb_1000" style='width:1000px;height:85vh'>
    </div>    
    <hr width="100" />
</center>
~;
}


1





