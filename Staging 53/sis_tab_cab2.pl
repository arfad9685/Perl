sub sis_tab_cab2 { 
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
  require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
  
if (($in{aktif} eq 'Y')  || (!$in{aktif})) {
   $in{aktif}='Y'; 
   $aktif="checked";
}  else {
   $aktif="";
}
 
xml_module::view_table("ho/tb_cabang2","ss=$in{ss}&aktif=$in{aktif}",1);
xml_module::edit_table("800 px", "70%","/cgi-bin/colorbox.cgi?ss=$in{ss}&lok_prg=$in{lok_prg}&pages=sis_tab_cabe");

#<---- VIEW Start Here 
print qq~
<script type="text/javascript">
   function chk_all () {
       var aktif = document.getElementById("all").checked;
       if (aktif==true) {
          document.getElementById("aktif").value='Y';
       } else {
          document.getElementById("aktif").value='_';        
       }
       form_str.submit();
   }
   
   function tab_view1(data) {
        var x, txt=" ";       
        txt += "<table class='main-table mobile-optimised'>";
        txt +="<thead><tr>";
        txt +="<th align='center'>Kode</th>";
        txt +="<th align='center'>Nama</th>";
        txt +="<th align='center'>Brand</th>";
        txt +="<th align='center'>Bagian</th>";
        txt +="<th align='center'>Area Mgr</th>";~;
        if (index($rws,'W') ne (-1)) {
          print qq~ 
          txt += "<th align='center' width=30>Action</th>";~;
        }
        print qq~        
        txt +="</tr></thead>";
        txt +="<tbody>";
        
        for (x in data) {
           if (data[x].isaktif=='N') {
              tutup="style='color:red'";
           } else {
              tutup="";
           }
           txt += "<tr class=huruf2 "+tutup+"><td align=left>&nbsp;"+data[x].kode+"</td><td align=left>&nbsp;"+data[x].nama+"</td><td align=left>&nbsp;"+data[x].brand+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].bagian+"</td><td align=left>&nbsp;"+data[x].areamgr+"</td>";
           ~;
           if (index($rws,'W') ne (-1)) {
             print qq~
              txt += "<td align=center width=50>&nbsp;<i class='far fa-edit' style='cursor:pointer;font-size:1.7em' onclick=edit('id="+data[x].kode+"')></i></td>";~;
           }
           print qq~           
           txt += "</tr>";
        }
        txt +="</tbody></table>";        
        document.getElementById("cabang").innerHTML = txt;               
   }
 </script> 
 
    <p><br><p><p><p>~;
   if (index($rws,'W') ne (-1)) {
    print qq~
    <form method=post action="/cgi-bin/store.cgi" id="form_str">
    <input name="pages" type="hidden" value=sis_tab_cab>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <input name="aktif" id="aktif" type="hidden" value="$in{aktif}">
    <table width=700><tr><td colspan=6 class=hurufcol style='text-align:left'><input type=checkbox name="all" id="all" $aktif onClick="chk_all()">&nbsp;Active Store Only</td></tr></table>
    </form>~;
   }
   print qq~
    <div id="cabang" class="table-scroll tb_800" style='width:900px;height:85vh'>
    </div>    
    <hr width="100" />
</center>
~;
}

#-- End VIEW --->
1


