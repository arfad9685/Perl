sub dev_aud {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 
 style_module::use_warning();
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/control/tab_deviasi.pl"; 
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 &con_inv0;
&con_inv2;
 
 if ($in{cab} ) {
 # print $in{cab}.$in{nama};
   xml_module::view_table("ho/tb_dev_kts","ss=$in{ss}&cab=$in{cab}&tgl1=$in{tgl1}",1); #(script_view.pl, params, table cnt)
 }  
  
 
 style_module::use_calendar();
if (!$in{tgl1}) {
   $in{tgl1}=$tt;
   }
#if (!$in{tgl2}) {
 #  $in{tgl2}=$tt;}

#if ($in{jenis}) {
 #  $str=$str."&jenis=$in{jenis}";
#}

if ($in{save}) {
	
	for ($a=0;$a<=$in{baris};$a++) {
		 $recc=$in{"rc$a"};
   $adjustt=$in{"adj$a"};
   if ($adjustt) {
    print $adjustt.$recc.'<br>';
    $errormsg = update_audit_dev ($recc,$adjustt) ; 	 
   }
   
   
		 
     }     
}
 

 
$strv="ss=$in{ss}&cab=$in{cab}&all=$in{all}&tgl1=$in{tgl1}";
 if (index($rws,'S') ne (-1)) {
   $strv.="&all=Y";
  } 
 
  print qq~
  <table width=1200 border=1 style="border-collapse: collapse;">
    <tr><td width=100%>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=dev_aud>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
			 <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=4 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>
			 <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=75>&nbsp;Periode</td>
             <td align="left" class="huruf1" width=150>~;
               style_module::input_calendar('tgl1',$in{tgl1},1);
               print qq~</td>                             
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
             <td align="left" >
              <input type=submit class="button button_grey" name=view value="GO"></td>
            </tr>                       
            </table>
         </td>
      </tr>
	</form>
      
  </table>

 <script type='text/javascript' src='/js/jquery-ui.js'></script>
<link rel="stylesheet" href="/css/jquery-ui.css">
<script type="text/javascript">
 function chkmax (i)
  {var devaskhir = document.getElementById("devaskhir"+i).value;
     var adjust = document.getElementById("adjust"+i).value;
	 if (adjust==devaskhir)
     {
       max = adjust+devaskhir;
       document.getElementById("adjust"+i).value=max;       
       alert('Max :'+max);       
     }
  }
 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1300px'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' width=130>Kode Jenis</th>";
	  txt += "<th align='center' width=30>Kode Barang</th>";
      txt += "<th align='center' width=150>Nama</th>";           
      txt += "<th align='center' width=30>Satuan</th>";
      txt += "<th align='center' width=30>Tgl Opname</th>";
	  txt += "<th align='center' width=30>Tgl Opname Sebelum</th>";
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
	  txt += "<th align='center' width=30>Hasil SO</th>";
	  txt += "<th align='center' width=30>Dev Akhir</th>";
	  txt += "<th align='center' >Adjust</th>";
	  txt += "<th align='center' width=30>Dev Asli</th>";~;
      #if (index($rws,'W') ne (-1)) {
       # print qq~ 
       # txt += "<th align='center' width=30>Action</th>";~;
      #}
      print qq~
      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";
	  
      
      for (x in data) {
           txt += "<tr class=huruf2><td align=left>"+data[x].group_nama+"</td>";
           txt +="<td align=left>&nbsp;"+data[x].brg_id+"</td>";
           txt += "<td align=left>"+data[x].brg_nama+"</td><td align=left>&nbsp;"+data[x].satuan+"</td>";
		   txt += "<td align=center>&nbsp;"+data[x].opn_date+"</td><td align=right>"+data[x].tglopnawal+"&nbsp;</td>";
		   txt += "<td align=center>&nbsp;"+data[x].awal+"</td>";
		   txt += "<td align=right>&nbsp;"+data[x].masuk+"</td><td align=right>"+data[x].beli+"&nbsp;</td>";
		   txt += "<td align=right>&nbsp;"+data[x].kirim+"</td><td align=right>"+data[x].waste+"&nbsp;</td>";	
		   txt += "<td align=right>&nbsp;"+data[x].wasteWIP+"</td><td align=right>"+data[x].wasteFG+"&nbsp;</td>";
		   txt += "<td align=right>&nbsp;"+data[x].returWIP+"</td><td align=right>"+data[x].returFG+"&nbsp;</td>";
		   txt += "<td align=right>&nbsp;"+data[x].wastenon+"</td><td align=right>"+data[x].autowaste+"&nbsp;</td>";
		   txt += "<td align=right>&nbsp;"+data[x].nonsal+"</td><td align=right>"+data[x].jual+"&nbsp;</td>";
		   txt += "<td align=right>&nbsp;"+data[x].saldohit+"</td><td align=right>"+data[x].saldokom+"&nbsp;</td>";
		   txt += "<td align=right>&nbsp;"+data[x].hasilso+"</td><td align=right>"+data[x].devaskhir+"&nbsp;</td>";
		   txt += "<td align=right><input style='width:100%' name=adj"+x+" size=3 class='input-qty' maxlength=5 id=adjust"+x+" value="+data[x].adjust+"></td><td align=right>"+data[x].devasli+"&nbsp;</td>";
			txt +="<input name=rc"+x+" type='hidden' value="+data[x].recid+">";        
           txt +="</tr>";
           
      }
      txt +="<input name=baris type='hidden' value="+x+">";   
	  txt +="<tr><td colspan=100 width=100% align=right><input type=submit name=save class='button button_green' value=Save ></td></tr>";
      txt +="</tbody></table>";        
      document.getElementById("tb-lokasi").innerHTML = txt;               
   }
 </script>~;  
 if (!$errormsg) {
    print qq~
    
    <form method=post  onsubmit="return warning('Proses')"> 
    <input name="pages" type="hidden" value=dev_aud>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="resto" id="resto" type="hidden" value="$s3s[5]">    
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <div id="tb-lokasi" class="table-scroll tb_1000" style='width:1200px; height:90%;font-size:10px'>&nbsp;  
    </div></form>~;
   } else {
    print qq~ $errormsg ~;
   }  
    print qq~
    <p>
    <hr width="100" />~.

    qq~
</center>
~; 
 
}

1


