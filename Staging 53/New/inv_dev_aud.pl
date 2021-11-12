sub inv_dev_aud {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 style_module::use_warning();

 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/control/tab_deviasi.pl"; 
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 &con_inv0;
 &con_inv2;
 
 use Spreadsheet::WriteExcel;

($month,$day,$year,$aweekday) = &jdate(&today());
$month = substr "0$month",-2;
$day = substr "0$day",-2;

 
 if ($in{cab} ) {
 # print $in{cab}.$in{nama};
   xml_module::view_table("ho/tb_dev_kts","ss=$in{ss}&cab=$in{cab}&tgl1=$in{tgl1}",1); #(script_view.pl, params, table cnt)
 }  
   
style_module::use_calendar();
if (!$in{tgl1}) {
   $in{tgl1}=$tt;
}


if ($in{save}) {
	
	for ($a=0;$a<=$in{baris};$a++) {
		 $recc=$in{"rc$a"};
   $adjustt=$in{"adj$a"};
   if ($adjustt) {
    #print $adjustt.$recc.'<br>';
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
             <input name="pages" type="hidden" value=inv_dev_aud>
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
                $where="isaktif='Y' and store_bagian='STORE'";
                drop_down_1($dbh,'m_cab','store_nama','store_id',$where,'store_nama',$in{cab});
                print qq~                                       
                </select></td>
               </tr>
            <tr>
             <td align="left" >
              <input type=submit class="button button_grey" name=view value="GO"></td>
            </tr>
	           </form>            
            </table>
         </td>
 </tr>     
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
   txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1200px'>";
   txt += "<thead>";
   txt += "<tr>";
   txt += "<th align='center' >Nama</th>";           
   txt += "<th align='center' width=30>Satuan<br>kode</th>";
   txt += "<th align='center' width=90>Tgl Opn<br>/Sebelum</th>";
   txt += "<th align='center' width=30>Saldo<br>Awal</th>";
   txt += "<th align='center' width=30>Masuk</th>";
	  txt += "<th align='center' width=30>Beli</th>";
	  txt += "<th align='center' width=30>Kirim</th>";
	  txt += "<th align='center' width=30>Waste</th>";
      
	  txt += "<th align='center' width=30>Non<br>Sales</th>";
	  txt += "<th align='center' width=30>Jual</th>";
	  txt += "<th align='center' width=30>Saldo<br>Calc/Data</th>";
	  txt += "<th align='center' width=30>Hasil<br>SO</th>";
	  txt += "<th align='center' width=30>Dev<br>Akhir</th>";
	  txt += "<th align='center' width=50>Adjust</th>";
	  txt += "<th align='center' width=30>Dev<br>Asli</th>";
   txt += "</tr>";
   txt += "</thead>";     
   txt += "<tbody>";
	  
   var jenis='';
   for (x in data) {
     if (jenis !== data[x].jenis) {
        txt += "<tr class=huruf2>";
        txt += "<td colspan=15 bgcolor=#0 class=hurufcol align=center>"+data[x].jenis+"</td>";
        txt += "</tr>";
        jenis = data[x].jenis;
     }
     txt += "<tr class=huruf1>";      
     txt += "<td align=left rowspan=2>&nbsp;"+data[x].brg_nama+"</td><td align=left>&nbsp;"+data[x].satuan+"</td>";
		   txt += "<td align=center>"+data[x].opn_date+"</td>";
		   txt += "<td align=right rowspan=2>&nbsp;"+data[x].awal+"&nbsp;</td>";
		   txt += "<td align=right rowspan=2>&nbsp;"+data[x].masuk+"&nbsp;</td><td align=right rowspan=2>"+data[x].beli+"&nbsp;</td>";
		   txt += "<td align=right rowspan=2>&nbsp;"+data[x].kirim+"&nbsp;</td><td align=right rowspan=2>"+data[x].waste+"&nbsp;</td>";	
		   txt += "<td align=right rowspan=2>&nbsp;"+data[x].nonsal+"&nbsp;</td><td align=right rowspan=2>"+data[x].jual+"&nbsp;</td>";
		   txt += "<td align=right>&nbsp;"+data[x].saldohit+"&nbsp;</td>";
		   txt += "<td align=right rowspan=2>&nbsp;"+data[x].hasilso+"&nbsp;</td><td align=right rowspan=2>"+data[x].devaskhir+"&nbsp;</td>";
		   txt += "<td align=right rowspan=2 bgcolor='#FFFF99'><input style='width: 100%;height:100%;margin:0px;padding:3px;border: 1px solid;background-color: #FFFF99' name=adj"+x+" size=3 class='input-qty' maxlength=5 id=adjust"+x+" value="+data[x].adjust+"></td>";
     txt += "<td align=right rowspan=2>"+data[x].devasli+"&nbsp;</td>";
			  txt +="<input name=rc"+x+" type='hidden' value="+data[x].recid+">";        
     txt +="</tr>";
     txt +="<tr class=huruf1>";
     txt +="<td align=left>&nbsp;"+data[x].brg_id+"</td>";
     txt +="<td align=center>"+data[x].tglopnawal+"</td>";
     txt +="<td align=right>"+data[x].saldokom+"&nbsp;</td>";     
     txt +="</tr>"
     txt +="<tr>";
     txt +="</tr>";
           
   }
   txt +="<input name=baris type='hidden' value="+x+">";   
   txt +="</tbody><tfoot><tr><th colspan=15><input type=submit name=save class='button button_green' value=Save ></th></tr>";
   txt +="<tr><th colspan=15><input type=submit name=export class='button button_green' value=Export ></th></tr>";
   txt +="</tfoot></table>"; 
   
   document.getElementById("tb-lokasi").innerHTML = txt;               
 }
 </script>~;  
 if (!$errormsg) {
    print qq~
    
    <form method=post  onsubmit="return warning('Proses')"> 
    <input name="pages" type="hidden" value=inv_dev_aud>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="resto" id="resto" type="hidden" value="$s3s[5]">    
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <div id="tb-lokasi" class="table-scroll tb_1000" style='width:1200px; height:75vh;font-size:10px'>&nbsp;  
    </div></form>~;
   } else {
    print qq~ $errormsg ~;
   }  
   
 if($in{export})
{
@kolom=('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');	
$temp01='/home/sarirasa/htdocs/txt/RD'.$in{store_id}.$month.$day.$year.'.xls';
$temp02='RD'.$in{cab}.$month.$day.$year.'.xls';

my $workbook  = Spreadsheet::WriteExcel->new($temp01);
my $worksheet = $workbook->add_worksheet();

  $worksheet->write(0, 0,  "Nama Barang");
  $worksheet->write(0, 1,  "Satuan");
  $worksheet->write(0, 2,  "Kode Barang");
  $worksheet->write(0, 3,  "Tgl Opn");
  $worksheet->write(0, 4,  "Tgl Sebelum");
  $worksheet->write(0, 5,  "Saldo Awal");
  $worksheet->write(0, 6,  "Masuk");
  $worksheet->write(0, 7,  "Beli");
  $worksheet->write(0, 8,  "Kirim");
  $worksheet->write(0, 9,  "Waste");
  $worksheet->write(0, 10,  "Non Sales");
  $worksheet->write(0, 11,  "Jual");
  $worksheet->write(0, 12,  "Saldo");
  $worksheet->write(0, 13,  "Data");
  $worksheet->write(0, 14,  "Hasil SO");
  $worksheet->write(0, 15,  "Dev Akhir");
  $worksheet->write(0, 16,  "Adjusment");
  $worksheet->write(0, 17,  "Dev Asli");

$query=$dbh->prepare("select ");

 
    print qq~
    <p>
    <hr width="100" />~.

    qq~
</center>
~; 
 
style_module::use_numeral();     
 
}

1


