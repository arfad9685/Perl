sub sis_hpp_01 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 style_module::use_colorbox('iframe',900,'Y');
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 require "/opt/sarirasa/core/chk_login.pl";
 style_module::use_calendar();
 
xml_module::popup_view("850 px", "85%","/cgi-bin/colorbox.cgi?pages=sis_hpp_01d&ss=$in{ss}&lok_prg=$in{lok_prg}&menuid=$menu[0]&jenis=$in{jenis}&resto=$in{resto}",1); #($width, $height,$url,$key)
 #xml_module::add_table(800, 400,"/cgi-bin/colorbox.cgi?pages=sis_lokasia&ss=$in{ss}&lok_prg=$in{lok_prg}&menuid=$menu[0]"); #($width, $height,$url)

$str="ss=$in{ss}";
if ($in{jenis}) {
   $str=$str."&jenis=$in{jenis}&tgl=$in{tgl}";
}

if ($in{resto}) {
  $str=$str."&resto=$in{resto}";
  xml_module::view_table("ho/tb_hpp2","$str",1); #(script_view.pl, params, table cnt)   
}

if (!$in{tgl}) {
   $in{tgl}=$tt;
}
# if ($in{del} eq 'Y') { delete_dbs('M_PROD_GUD','GUDANG_ID',$in{id}); }

print qq~
    <table width=800 border=1 style="border-collapse: collapse;">
    <tr><td width=100%>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=sis_hpp_01>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=3 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>             
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Jenis</td>
             <td align="left" class="huruf1"><select name="jenis" class="huruf1" id="jenis">~;
             @jenis_brg=('WIP','FG','ISP');
             for($i = 0; $i < scalar(@jenis_brg); $i++) {
               $selected[$i]=""; 
               if ($in{jenis} eq $jenis_brg[$i]) {
                      $selected[$i]='selected';
               }
               print qq~<option $selected[$i]>$jenis_brg[$i]</option>~;
             }  
             print qq~                                       
             </select></td>
            </tr>
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Jns Resto</td>
             <td align="left" class="huruf1"><select name="resto" class="huruf1" id="subkat">~;
             %koderesto=("SKS","1","SES","W","TST","D","GPK","G");
             @resto=('SKS','SES','TST','GPK');                          
             for($i = 0; $i < 4; $i++) {
               $selected[$i]=""; 
               if ($in{resto} eq $koderesto{$resto[$i]}) {
                      $selected[$i]='selected';
               }
               print qq~<option value=$koderesto{$resto[$i]} $selected[$i]>$resto[$i]</option>~;
             }
             print qq~
             </select></td>
            </tr>
            <tr>              
              <td width=100 align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Resep List</td>
              <td align="left" class="huruf1">~;
               style_module::input_calendar('tgl',$in{tgl},1);
               print qq~
              </td>
              <td width=350 rowspan=3 valign=top align="left"><input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>                       
            </table>
         </td>
      </tr></form>            
  </table><br>

<script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      var harga1,harga2=0;
      txt += "<table id='main-table' class='main-table mobile-optimised'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += " <th align='center'>Kategori</th>";      
      txt += " <th align='center'>Kode</th>";
      txt += " <th align='center'>Nama Barang</th>";      
      ~;
      if ($in{jenis} eq 'FG') {
        print qq~      
        txt += " <th align='center'>Harga Jual</th>";
        txt += " <th align='center'>HPP</th>";
        txt += " <th align='center'>Yield</th>";
        txt += " <th align='center'>Adj FC</th>";                
        txt += " <th align='center'>%FC</th>";~;
      } else {
        print qq~      
        txt += " <th align='center'>Harga RM</th>";
        txt += " <th align='center'>Satuan</th>";        
        txt += " <th align='center'>Yield</th>";
        txt += " <th align='center'>Adj FC</th>";~;               
      }
      print qq~
      txt += "</tr>";
      txt += "</thead>";
      txt += "<tbody>";
      
     for (x in data) {
           harga1=data[x].harga;
           harga2=data[x].hpp;
           harga1=parseInt(harga1.replace(/,/g, ''));
           harga2=parseInt(harga2.replace(/,/g, ''));
//           if (harga1>0) {
//              if ((harga2/harga1) >0.4) {
//                 warna="style='color:red'";
//               } else {
                    warna="";
//              }
//           }   
           txt += "<tr class=huruf2 "+warna+"><td align=left>&nbsp;"+data[x].kat+"</td><td align=left width=100>&nbsp;"+data[x].kode+"</td>";
           txt += "<td align=left>&nbsp;<span onclick=show1('kodebrg="+data[x].kode+"')><a href=#>"+data[x].nama+"</a></span></td>"; ~;
           if ($in{jenis} eq 'FG') {
             print qq~
             txt += "<td align=right>"+data[x].harga+"&nbsp;</td><td align=right>"+data[x].hpp+"&nbsp;</td>";
             txt += "<td align=right>1&nbsp;</td><td align=right>"+data[x].hpp+"&nbsp;</td>";             
             txt += "<td align=right>"+data[x].prosen+"&nbsp;</td>";~;
           } else {
             print qq~
             txt += "<td align=right>"+data[x].harga+"&nbsp;</td><td align=left>&nbsp;"+data[x].satuan+"&nbsp;</td>";
             txt += "<td align=right>1</td><td align=right>"+data[x].harga+"&nbsp;</td>";~;            
           }
           print qq~
           txt += "</tr>";
     }
     txt +="</tbody></table>";        
     document.getElementById("tb-prod").innerHTML = txt;               
   }
 </script>  
  
    <div id="tb-prod" class="table-scroll tb_800">&nbsp;  
    </div>
    <p>
    <hr width="100" />
</center>
~; 
 
}

1


