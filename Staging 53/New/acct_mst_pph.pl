sub acct_mst_pph {
&get_access;

require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
xml_module::konfirm();
xml_module::view_table("facc/tb_mst_pph","ss=$in{ss}",1);


if ($in{ubah} eq ADD) {
    $up_menu=$dbfin->do("INSERT INTO M_TARIF_PPH (JENIS_PPH, JNS_BIAYA, JNS_USAHA, JNS_PAJAK, TARIF_NPWP, TARIF_NONPWP, OPR_CREATED) values ('$in{jnspph}', '$in{jnsbiaya}','$in{jnsush}', '$in{jnspjk}', '$in{tarifnpwp}', '$in{tarifnon}', '$in{jnsprint}', '$in{noacc}','$s3s[0]')");

print qq~ INSERT INTO M_TARIF_PPH (JENIS_PPH, JNS_BIAYA, JNS_USAHA, JNS_PAJAK, TARIF_NPWP, TARIF_NONPWP, OPR_CREATED) values ('$in{jnspph}', '$in{jnsbiaya}','$in{jnsush}', '$in{jnspjk}', '$in{tarifnpwp}', '$in{tarifnon}', '$in{jnsprint}', '$in{noacc}','$s3s[0]');~;

}

print qq~
<script type='text/javascript' src='/js/jquery-ui.js'></script>
<link rel="stylesheet" href="/css/jquery-ui.css">
<script type="text/javascript">  
    function button_click(update,id)
    {
          if (update == 'ADD') {
            document.getElementById("ubah").value=update;
          }

          submit();       
    }    
     
   function tab_view1(data) {
        var x, txt=" ";       
        txt += "<table class='main-table mobile-optimised' >";
        txt +="<thead><tr>";
        txt +="<th align='center'>Jenis PPh</th>";
        txt +="<th align='center'>Jenis Biaya</th>";
        txt +="<th align='center'>Jenis Usaha</th>";
        txt +="<th align='center'>Jenis Pajak</th>";
        txt +="<th align='center'>Tarif NPWP</th>";
        txt +="<th align='center'>Tarif NON-NPWP</th>";
        txt +="<th align='center'>Jenis Print</th>";
        txt +="<th align='center'>No ACC</th>"; 
        txt +="<th align='center'>Action</th>"; ~;
        print qq~        
        txt +="</tr></thead>";
        txt +="<tbody>";~;
        print qq~
        txt +="<tr class='huruf2' bgcolor=#f6f7cd>";
        txt +="<td align=left ><input name='jnspph' id='jnspph' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=left ><input name='jnsbiaya' id='jnsbiaya' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=left ><input name='jnsush' id='jnsush' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=left ><input name='jnspjk' id='jnspjk' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=left ><input name='tarifnpwp' id='tarifnpwp' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=left ><input name='tarifnon' id='tarifnon' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=left ><input name='jnsprint' id='jnsprint' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=left ><input name='noacc' id='noacc' style='width: 100%;margin: 0px;border: 1px solid #CCC; '></td>";
        txt +="<td align=center><input type=image src='/images/add.png' onclick=button_click('ADD',0,0)></td>";~;
        print qq~
        for (x in data) {
           if (data[x].isaktif=='N') {
              tutup="style='color:red'";
           } else {
              tutup="";
           }
           txt += "<tr class=huruf2 "+tutup+"><td align=center>&nbsp;"+data[x].jnspph+"</td><td align=left>&nbsp;"+data[x].jnsbiaya+"</td><td align=left>&nbsp;"+data[x].jnsush+"</td><td align=left>&nbsp;"+data[x].jnspjk+"</td><td align=right>&nbsp;"+data[x].tarifnpwp+"</td>";
           txt += "<td align=right>&nbsp;"+data[x].tarifnon+"</td><td align=right>&nbsp;"+data[x].jnsprint+"</td>";
           txt += "<td align=right>&nbsp;"+data[x].noacc+"&nbsp;</td>";
           txt += "<td align=right>&nbsp;"+data[x].action+"&nbsp;</td>";
                     
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
    <form method=POST onsubmit="return warning('Update')">
    <input name="pages" type="hidden" value=acct_mst_pph>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <input id=recid name="recid" type="hidden" value=0>
    <input id=ubah name="ubah" type="hidden" value=''> 
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





