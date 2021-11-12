sub str_oh_02 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
  require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
  require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";  
  require "/opt/sarirasa/core/chk_login.pl";
  style_module::use_calendar(); 
if (length($s3s[10])>12) {
   $in{cab}=$s3s[4];
}
$str="ss=$in{ss}&cab=$in{cab}&tgl1=$in{tgl1}&tgl2=$in{tgl2}&all=$in{all}&brand=$s3s[5]";

if ($in{jenis}) {
   $str=$str."&jenis=$in{jenis}";
}

if ($in{cari}) {
    $in{nama}=uc($in{nama});
    $str=$str."&nama=$in{nama}";
 }    
if (!$in{tgl1}) { $in{tgl1}=$tt;}
if (!$in{tgl2}) { $in{tgl2}=$tt;}
  
 xml_module::konfirm();
 xml_module::view_table("store/tb_ksstr","$str",1); #(script_view.pl, params, table cnt)
 xml_module::popup_view("800 px", "85%","/cgi-bin/colorbox.cgi?pages=str_oh_02d&lok_prg=$in{lok_prg}&$str",1); #($width, $height,$url,$key)
 xml_module::popup_view("900 px", "85%","/cgi-bin/colorbox.cgi?pages=str_oh_02s&lok_prg=$in{lok_prg}&$str",2); #($width, $height,$url,$key)
 
print qq~
    <table width=1000 border=1 style="border-collapse: collapse;">
    <tr><td width=100%>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=str_oh_02>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=4 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=150>&nbsp;Periode</td>
             <td align="left" class="huruf1" width=150>~;
               style_module::input_calendar('tgl1',$in{tgl1},1);
               print qq~</td><td align="center" bgcolor=$colcolor class="hurufcol" width=75> sd </td>
               <td align="left" class="huruf1">~;
               style_module::input_calendar('tgl2',$in{tgl2},2);
               print qq~</td>                              
            </tr>             
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Jenis</td>
             <td align="left" class="huruf1"><select name="jenis" class="huruf1" id="jenis">~;
             @jenis_brg=('RM/WIP','ISP','NF');
             for($i = 0; $i < scalar(@jenis_brg); $i++) {
               $selected[$i]=""; 
               if ($in{jenis} eq $jenis_brg[$i]) {
                      $selected[$i]='selected';
               }
               print qq~<option $selected[$i]>$jenis_brg[$i]</option>~;
             }
             if ($in{all}) {
                $check='checked';
             } else { $check='';}
             print qq~                                       
             </select></td><td align="center" bgcolor=$colcolor class="hurufcol"> All Stok </td>
             <td><input type=checkbox name=all value=Y $check></td>
            </tr>~;
            
          if (length($s3s[10])<=12)
          {
            print qq~                        
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Jns Resto</td>
             <td align="left" class="huruf1" colspan=2><select name="cab" class="huruf1" id="cab">~;      
              $key="store_id";
              $display="store_nama";
              $class="";
              $whr="store_bagian='STORE' and isaktif='Y'";
              drop_down_1($dbh,'m_cab',$display,$key,$whr,'1',$in{cab},'');                          
              print qq~                               
              </select></td>
            </tr>~;
          } 
          print qq~
            <tr>              
              <td width=100 align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Nama Barang</td>
              <td align="left" class="huruf1"><input type=text size=30 name="nama" value="$in{nama}" class="huruf1" maxlength=40></td>
              <td width=350  valign=top align="left" colspan=2><input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>                       
            </table>
         </td>
      </tr></form>            
  </table><br>~;


print qq~

<script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' colspan=4>&nbsp;</th>";      
      txt += "<th align='center' colspan=3>Mutasi In</th>";
      txt += "<th align='center' colspan=4>Mutasi Out</th>";            
      txt += "<th align='center' colspan=3>&nbsp;</th>";
      txt += "</tr>";
      txt += "<tr>";
      txt += "<th align='center' width=50>Kode</th>";        
      txt += "<th align='center' >Nama Barang</th>";
      txt += "<th align='center' width=50>Satuan</th>";
      txt += "<th align='center' width=50>Awal</th>";      
      txt += "<th align='center' width=50>Audit</th>";        
      txt += "<th align='center' width=50>Beli</th>";
      txt += "<th align='center' width=50>Masuk</th>";
      txt += "<th align='center' width=50>Kirim</th>";
      txt += "<th align='center' width=50>Sales</th>";
      txt += "<th align='center' width=50>Waste</th>";      
      txt += "<th align='center' width=50>NonSal</th>";
      txt += "<th align='center' width=50>Akhir</th>";
      txt += "<th align='center' width=50>Adj</th>";
      txt += "<th align='center' width=50>OH</th>";            
      
      txt += "</tr>";
      txt += "</thead>";
      txt += "<tbody>";
      
     for (x in data) {
           var namabrg=(data[x].nama).replace(/ /g,"%20");
           
           txt += "<tr class=huruf2><td align=left>&nbsp;"+data[x].kode+"</td>";
           txt += "<td align=left>&nbsp;<span class=link onclick=show2('brgid="+data[x].kode+"&nama="+namabrg+"')>"+data[x].nama+"</span></td>";
           txt += "<td align=left>&nbsp;"+data[x].satuan+"</td><td align=right>"+data[x].awal+"&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_audit')>"+data[x].audit+"</span>&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_beli')>"+data[x].beli+"</span>&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_masuk')>"+data[x].masuk+"</span>&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_kirim')>"+data[x].kirim+"</span>&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_jual')>"+data[x].sales+"</span>&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_waste')>"+data[x].waste+"</span>&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_nonsal')>"+data[x].nonsales+"</span>&nbsp;</td>";
           txt += "<td align=right>"+data[x].akhir+"&nbsp;</td>";
           txt += "<td align=right><span class=link onclick=show1('brgid="+data[x].kode+"&nama="+namabrg+"&mutasi=jml_adj')>"+data[x].opm+"</span>&nbsp;</td>";
           txt += "<td align=right>"+data[x].oh+"&nbsp;</td>";
           txt += "</tr>";
     }
     txt +="</tbody></table>";        
     document.getElementById("tb-prod").innerHTML = txt;               
   }
 </script>  
    <div id="tb-prod" class="table-scroll tb_800" style='width:1000;height:80vh'>&nbsp;  
    </div>~;
    if ($in{cari}) {
      print qq~
      <div id="wait" style="position:absolute; width:100%; text-align:center; top:300px;z-index:9"><img src="/images/loading.gif" border=0></div>~;
    }
    print qq~
    <p>
    <hr width="100" />
</center>
~; 
 
}

1


