sub dev_aud {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 if ($in{cab} || $in{nama}) {
   xml_module::view_table("ho/tb_dev_kts","ss=$in{ss}&cab=$in{cab}&nama=$in{nama}",1); #(script_view.pl, params, table cnt)
 }  
  
 
 style_module::use_calendar();
if (!$in{tgl1}) {
   $in{tgl1}=$tt;$in{tgl2}=$tt;
   $in{tgl3}=$tt;$in{tgl4}=$tt;   
}
 
$strv="ss=$in{ss}&cab=$in{cab}&tgl1=$in{tgl1}&tgl2=$in{tgl2}";
 if (index($rws,'S') ne (-1)) {
   $strv.="&all=Y";
  } 


 
  print qq~
  <table width=1000>
    <tr><td width=100%>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=dev_aud>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=2 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>             
            <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Lokasi</td>
                <td class=hurufcol colspan=2><select name="cab" class="huruf1" id="cab">~;
                $where="isaktif='Y' and store_bagian in ('STORE')";
                if (index($rws,'W') ne (-1)) {
                   $readonly="";
                } else {
                   $readonly="readonly";
                }
                drop_down_1($dbh,'m_cab','store_nama','store_id',$where,'store_nama',$in{cab},'',$readonly);
                print qq~                                       
                </select></td>
               </tr>
            <tr>
                 <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Periode</td>
                 <td class=hurufcol width=40>~;
                 if (index($rws,'W') ne (-1)) {                 
                   style_module::input_calendar('tgl1',$in{tgl1},1);
                 } else {
                   print qq~$in{tgl1}~;
                 } 
                 
                 print qq~</td>
               </tr> 
			 <tr>
                <td align="left" >
              <input type=submit class="button button_grey" name=view value="GO"></td>
            </tr>                       
            </table>
         </td>
      </tr>
	</form>
      
  </table>
~;

  

print qq~

 <script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1000px'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' width=30>Kode Jenis</th>";
	  txt += "<th align='center' width=30>Kode Barang</th>";
      txt += "<th align='center' width=30>Nama Barang</th>";            
      txt += "<th align='center' width=30>Satuan</th>";
      txt += "<th align='center' width=30>Tgl Sebelum</th>";
      txt += "<th align='center' width=30>Saldo Awal</th>";
      txt += "<th align='center' width=30>Masuk</th>";
	  txt += "<th align='center' width=30>Beli</th>";
	  txt += "<th align='center' width=30>Kirim</th>";
	  txt += "<th align='center' width=30>Waste</th>";
      txt += "<th align='center' width=30>Waste WIP</th>";
	  txt += "<th align='center' width=30>Waste FG</th>";
	  txt += "<th align='center' width=30>Retur WIP</th>";
	  txt += "<th align='center' width=30>Retur FG</th>";
	  txt += "<th align='center' width=30>Waste Non Beban</th>";
	  txt += "<th align='center' width=30>Auto Waste</th>";
	  txt += "<th align='center' width=30>Non Sales</th>";
	  txt += "<th align='center' width=30>Jual</th>";
	  txt += "<th align='center' width=30>Saldo Hitung</th>";
	  txt += "<th align='center' width=30>Saldo Komputer</th>";
	  txt += "<th align='center' width=30>Deviasi</th>";
	  txt += "<th align='center' width=30>Hasil SO</th>";
	  txt += "<th align='center' width=30>Dev Akhir</th>";
	  txt += "<th align='center' width=30>Adjusment</th>";
	  txt += "<th align='center' width=30>Dev Asli</th>";~;
      if (index($rws,'W') ne (-1)) {
        print qq~ 
        txt += "<th align='center' width=30>Action</th>";~;
      }
      print qq~
      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";
	  


      
      for (x in data) {
           txt += "<tr class=huruf2><td align=center>&nbsp;"+data[x].c0+"&nbsp;</td>";~;
           if (index($rws,'W') ne (-1)) {
             print qq~            
             txt +="<td align=left>&nbsp;<span onclick=view('id="+data[x].c0+"&pages=tb_dev_aud&jns="+data[x].c8+"') style='cursor:pointer'><u>"+data[x].c1+"</u></span></td>";~;
           } else {
             print qq~            
             txt +="<td align=left>&nbsp;"+data[x].c1+"</td>";~;            
           }
           print qq~
           txt +="<td align=left>&nbsp;"+data[x].c2+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].c3+" / "+data[x].c4+"</td><td align=right>"+data[x].c5+"&nbsp;</td>";
           txt += "<td align=center>&nbsp;"+data[x].c6+"</td><td align=center>"+data[x].c7+"&nbsp;</td>"; 
           ~;
           if (index($rws,'W') ne (-1)) {
             print qq~
              txt += "<td align=center width=50>&nbsp;<input type='image' src='/images/edit.png' onclick=cari('id="+data[x].c0+"&pages=tb_dev_aud')></td>";~;
           }
           print qq~
           txt +="</tr>";     
      }
      txt +="</tbody></table>";        
      document.getElementById("tb-lokasi").innerHTML = txt;               
   }
 </script>  
  
    <div id="tb-lokasi" class="table-scroll tb_800" style='width:1000px; height:70%;font-size:10px'>&nbsp;  
    </div>
    <p>
    <hr width="100" />~.
    $errormsg .
    qq~
</center>
~; 
 
}

1


