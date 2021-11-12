sub fc_aud_1 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 
 style_module::use_warning();
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/control/tab_deviasi.pl"; 
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 &con_inv0;
 &con_inv2;
 &con_ass0;
 
 if ($in{cab} ) {
 #print $in{cab}.$in{tgl1}.$in{jenis};
   xml_module::view_table("ho/tb_fc_aud","ss=$in{ss}&cab=$in{cab}&tgl1=$in{tgl1}&jenis=$in{jenis}",1); #(script_view.pl, params, table cnt)
 }  
  
 
 style_module::use_calendar();
 if (!$in{tgl1}) {
   $in{tgl1}=$tt;
   }

use Date::Calc qw(Delta_Days);

 if ($in{save}) {
	#print $in{totdevfc}.$in{cab}.$in{tglopn};
	#$tot=$in{totdevfc};

    $errormsg = update_audit_fc ($in{cab},$in{totjml},$in{tglopn}) ; 	 		 
 }  

 
if ($in{simpan}) {
	
	for ($a=0;$a<=$in{baris};$a++) {
		 $recc=$in{"rc$a"};
   $adjustt=$in{"adj$a"};
   if ($adjustt) {
    #print $adjustt.$recc.'<br>';
    $errormsg1 = update_audit_fc1 ($recc,$adjustt) ; 	 
   } 
     }     
}
  
  $strv="ss=$in{ss}&cab=$in{cab}&jenis=$in{jenis}&all=$in{all}&tgl1=$in{tgl1}";

  print qq~
  <table width=1000 border=1 style="border-collapse: collapse;">
    <tr><td width=100%>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=fc_aud_1>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    	     		 <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=5 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
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
                $where="isaktif='Y' and store_bagian='STORE'";
                drop_down_1($dbh,'m_cab','store_nama','store_id',$where,'store_nama',$in{cab});
                print qq~                                       
                </select></td>
             </tr>
			 <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Jenis</td>
             <td align="left" class="huruf1"><select name="jenis" class="huruf1" id="jenis">
			 <option value='Normal' >Normal</option>
			 <option value='Dinnerware' >Dinnerware</option>
                                                  
             </select></td>
            </tr>
            <tr>
             <tr>
              <td align="left" >
              <input type=submit class="button button_grey" name=view value="GO"></td>
             </tr>
   	         </form>             
            </table>
    </td></tr>     
  </table>

  <script type='text/javascript' src='/js/jquery-ui.js'></script>
  <link rel="stylesheet" href="/css/jquery-ui.css">
  <script type="text/javascript">
 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1300px'>";
      txt += "<thead>";
      txt += "<tr>";   
      txt += "<th align='center' width=30>Tgl Opname</th>";
	  txt += "<th align='center' width=30>Tgl Opname Sebelum</th>";
	  txt += "<th align='center' width=30>Kode Barang</th>";
      txt += "<th align='center' width=30>Nama</th>";           
      txt += "<th align='center' width=15>Satuan</th>";
      txt += "<th align='center' width=30>Jenis</th>";  
      txt += "<th align='center' width=30>FC</th>";
	  txt += "<th align='center' width=30>Deviasi</th>";
      txt += "<th align='center' width=30>Deviasi X FC</th>";
	  txt += "<th align='center' width=30>Waste Karyawan</th>";
	  txt += "<th align='center' width=30>Waste Gumpil</th>";
	  txt += "<th align='center' width=30>Waste WIP X FC</th>";
	  txt += "<th align='center' width=30>Waste FG X FC</th>";
	  txt += "<th align='center' width=30>Auto Waste</th>";
	  txt += "<th align='center' >Adjust FC</th>";
	  txt += "<th align='center' width=30>Total</th>";
	     ~;
      #if (index($rws,'W') ne (-1)) {
       # print qq~ 
       # txt += "<th align='center' width=30>Action</th>";~;
      #}
      print qq~
      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";
	  
      var kat="";
      for (x in data) {
       if (kat != data[x].kategori) {
         txt += "<tr class=hurufcol style='background-color:black'><td align=center colspan=16>&nbsp;"+data[x].kategori+"</td></tr>";          
         kat = data[x].kategori; 
       }
		txt += "<tr class=huruf2><td align=left>&nbsp;"+data[x].opn_date+"</td><td align=center>"+data[x].tglopnawal+"&nbsp;</td>"; 
		txt += "<td align=right>"+data[x].brg_id+"&nbsp;</td>";
		txt += "<td align=left>&nbsp;"+data[x].brg_nama+"</td><td align=left>&nbsp;"+data[x].satuan+"</td><td align=left>&nbsp;"+data[x].jenis+"</td>";
		txt += "<td align=right>"+data[x].FC+"&nbsp;</td>";
		txt += "<td align=right>&nbsp;"+data[x].devasli+"&nbsp;</td><td align=right>"+data[x].devxfc+"&nbsp;</td>";
		txt += "<td align=right>"+data[x].wastekry+"</td>";
		txt += "<td align=right>"+data[x].wastegumpil+"</td>";
		txt += "<td align=right>"+data[x].wastewipxfc+"</td>";
		txt += "<td align=right>"+data[x].wastefgxfc+"</td>";
		txt += "<td align=right>"+data[x].autowaste+"</td>";
	    txt += "<td align=right><input style='width:100%' name=adj"+x+" size=3 class='input-qty' maxlength=5 id=adjust"+x+" value="+data[x].adjust+"></td><td align=right>"+data[x].total+"</td>";
		txt +="<input name=rc"+x+" type='hidden' value="+data[x].recid+">";		   
       txt +="</tr>";           
      }
      txt +="</tbody><tfoot>";
	     txt += "<tr class=huruf2>";	
	     txt += "<th align=right colspan=6>TOTAL</th>";	
	     txt += "<th align=right style='text-align:right'>"+data[x].totalfc+"&nbsp;</th>";
	     txt += "<th align=right style='text-align:right'>"+data[x].totaldev+"&nbsp;</th>";
	     txt += "<th align=right style='text-align:right'>"+data[x].totaldevxfc+"&nbsp;</th>";
		 txt += "<th align=right style='text-align:right'>"+data[x].totalkry+"&nbsp;</th>";
		 txt += "<th align=right style='text-align:right'>"+data[x].totalgumpil+"&nbsp;</th>";
		 txt += "<th align=right style='text-align:right'>"+data[x].totalwip+"&nbsp;</th>";
		 txt += "<th align=right style='text-align:right'>"+data[x].totalfg+"&nbsp;</th>";
		 txt += "<th align=right style='text-align:right'>"+data[x].totalauto+"&nbsp;</th>";
		 txt += "<th align=right style='text-align:right'>"+data[x].totaladjust+"&nbsp;</th>";
		txt += "<th align=right style='text-align:right'>"+data[x].totaljml+"&nbsp;</th></tr>";	  	    
   	  txt +="<input name='totjml' type='hidden' value="+data[x].totalall+">";
      txt +="<input name='tglopn' type='hidden' value="+data[x].tgltotal+">"; 
		txt +="<input name=baris type='hidden' value="+x+">"; 	
		 txt +="<tr><th colspan=13 width=100% align=left><input type=submit name=simpan class='button button_green' value=SaveAdj ><th colspan=2>Toleransi</th><th align=right style='text-align:right'>"+data[x].toleransi+"&nbsp;</th></tr>";	
	     txt +="<tr><th colspan=13 width=100% align=right><input type=submit name=save class='button button_green' value=Posting ></th><th colspan=2>Total Final</th><th align=right style='text-align:right'>"+data[x].totalfinal+"&nbsp;</th></tr>";
		 
      txt +="</tfoot></table>";        
      document.getElementById("tb-lokasi").innerHTML = txt;               
   }
  </script>~;  
  if (!$errormsg) {
    print qq~
    
    <form method=post  onsubmit="return warning('Proses')"> 
    <input name="pages" type="hidden" value=fc_aud_1>
    <input name="cab" type="hidden" value="$in{cab}">
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="resto" id="resto" type="hidden" value="$s3s[5]">    
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
	   <div id="tb-lokasi" class="table-scroll tb_1000" style='width:1000px; height:80vh;font-size:10px'>&nbsp;  
    </div></form>~;
  } else {
    print qq~ $errormsg ~;
  }

if (!$errormsg1) {
    print qq~
    
    <form method=post  onsubmit="return warning('Proses')"> 
    <input name="pages" type="hidden" value=fc_aud_1>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="resto" id="resto" type="hidden" value="$s3s[5]">    
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <div id="tb-lokasi" class="table-scroll tb_1000" style='width:1200px; height:90%;font-size:10px'>&nbsp;  
    </div></form>~;
   } else {
    print qq~ $errormsg1 ~;
   }  
  
  print qq~
  <p>
  <hr width="100" />
</center>
~; 
 
}

1



