sub sis_sup_01s {
 use Date::Calc qw(Add_Delta_Days);
 
 style_module::use_warning();
 style_module::use_calendar();
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/style_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 
if ($in{jns} < 2) {
   &con_inv0; 
   $db=$dbh;
} else {
  &con_ass0; 
   $db=$dbs;
}
 
 if (!$s3s[7] && (($in{add} && $in{idbrg}) || ($in{edit} eq 'SAVE')))   {
         $in{harga} =~ s/,//g;
         if ($in{add}) {
           $insert_d = $db->do("INSERT INTO M_SUPPLIER_ITEM (VENDOR_ID, BRG_ID, APPR_PRICE, LAST_PRICE, OPR_CREATED)
                VALUES ('$in{id}', '$in{idbrg}', $in{harga},$in{harga},'$s3s[0]')");
         } else {
           $insert_d = $db->do("UPDATE M_SUPPLIER_ITEM SET APPR_PRICE=$in{harga} WHERE RECID=$in{recid}");
           $in{edit}="";
         } 
         if ($insert_d==0) {
            style_module::use_chkerror($db);
            return 'Cancel Proses.';            
          } else {
            $dbh->commit;
          }         
 }
 
 if ($in{del}) {        
          $errormsg = delete_db_id ($db, 'M_SUPPLIER_ITEM','RECID',$in{recid});         
}
 
$str="ss=$in{ss}";
 xml_module::view_table("ho/tb_sup_item","ss=$in{ss}&id=$in{id}&jns=$in{jns}",1);
 if ($in{jns} < 2) {
   xml_module::json_list("ho/tb_brg_food","$str","",1); #(script_view.pl, params, table cnt)
 } else {
   xml_module::json_list("ho/tb_brg_nfood","$str","",1); #(script_view.pl, params, table cnt)  
 } 
   
 print qq~
<script type='text/javascript' src="/js/jquery.chained.js"></script>
<script type='text/javascript' src='/js/jquery-ui.js'></script>
<link rel="stylesheet" href="/css/jquery-ui.css">

<script type="text/javascript">

function search_view1(arr) {
     \$( "#namabrg" ).autocomplete({      
       minLength: 2,    
       delay: 0,
       source: arr,
       select : function(e, ui) {
          e.preventDefault ()       
          \$("#idbrg").val(ui.item.value);
          \$("#satbrg").val(ui.item.sat);
          \$("#hrgbrg").val(ui.item.harga);                    
          \$(this).val(ui.item.label);
      }
    });
}

function button_click(update,id,cnt)
{
    if (update == 'ADD') {
       document.getElementById("add").value='ADD';
       submit();       
     }
     if (update == 'DEL') {
       document.getElementById("recid").value=id;
       document.getElementById("del").value='DEL';
       submit();       
     }
     if (update == 'EDIT') {
       document.getElementById("recid").value=id;
       document.getElementById("edit").value='EDIT';
       submit();       
     }
     if (update == 'SAVE') {
       document.getElementById("recid").value=id;
       document.getElementById("edit").value='SAVE';
       submit();       
     }
     if (update == 'CANCEL') {
       submit();       
     }
     
}
      
   function tab_view1(data) {
      var txt=" ";
      var x=0;y=0;need=0;
       txt += "<table id='main-table' class='main-table mobile-optimised'>";
       txt += "<thead>";
       txt += "<tr>";
       txt += "<th align=center class='hurufcol' width=50>Kode</th>";
       txt += "<th align=center class='hurufcol'>Nama Barang</th>";
       txt += "<th align=center class='hurufcol' width=100 >Satuan</th>";
       txt += "<th align=center class='hurufcol' width=100 >Harga Approve</th>";
       txt += "<th align=center class='hurufcol' width=100 >Harga Terakhir</th>";
       txt += "<th align=center class='hurufcol' width=50 >Action</th>";                     
       txt += "</tr>";
       txt += "</thead>";
       txt += "<tbody>";~;
       if (!$in{edit}) {
         print qq~
         txt += "<tr class='huruf2' bgcolor=#f6f7cd>";                       
         txt += "<td align=left class=huruf1><input id='idbrg' name='idbrg' style='width: 100%;margin: 0px;border: 1px solid #CCC;' readonly=readonly></td>";
         txt += "<td align=left><input name='namabrg' id='namabrg' style='width: 100%;margin: 0px;border: 1px solid #CCC;'></td>";
         txt += "<td align=left width=75><input id='satbrg' name='satbrg' style='width: 100%;margin: 0px;border: 1px solid #CCC;' readonly=readonly></td>";
         txt += "<td align=right><input name='harga'  size='10' class='input-harga' placeholder='Price' id='hrgbrg'></td>";
         txt += "<td align=right>&nbsp;</td>";                   
         txt += "<td align=center><input type=image src='/images/add.png' onclick='if (warning("+'"Tambah Data"'+")) button_click("+'"ADD"'+",0,0)'></td>";
         txt += "</tr>";~;
       }
       print qq~
        for (x in data) {
           ~;
          if ($in{edit} eq 'EDIT') {             
             print qq~
             if (data[x].RECID==$in{recid}) {
               txt += "<tr class=huruf2 style='background-color:#CCC;color:red'><td align=left>&nbsp;"+data[x].KODE+"</td>";
               txt += "<td align=left>&nbsp;"+data[x].NAMA+"</td>";
               txt += "<td align=left>&nbsp;"+data[x].SATUAN+"</td>";          
               txt += "<td align=right><input name='harga'  size='10' class='input-harga' value="+data[x].APPV_P+"></td>";
               txt += "<td align=right>"+(data[x].LAST_P)+"&nbsp;</td>";
               txt += "<td align=center><input type='image' src='/images/accept.png'  onclick='button_click("+'"SAVE"'+","+data[x].RECID+","+y+")'>&nbsp;";
               txt += "<input type='image' src='/images/cancel.png' onclick='button_click("+'"CANCEL"'+","+data[x].RECID+","+y+")'></td>";                                   
               txt += "</font></tr>";
             } else {
               txt += "<tr class=huruf2><td align=left>&nbsp;"+data[x].KODE+"</td>";
               txt += "<td align=left>&nbsp;"+data[x].NAMA+"</td>";
               txt += "<td align=left>&nbsp;"+data[x].SATUAN+"</td>";          
               txt += "<td align=right>"+(data[x].APPV_P)+"&nbsp;</td>";
               txt += "<td align=right>"+(data[x].LAST_P)+"&nbsp;</td>";          
               txt += "<td align=center>&nbsp;</td>";                    
               txt += "</tr>";              
             }        
             ~;
          } else {  
           print qq~
            txt += "<tr class=huruf2><td align=left>&nbsp;"+data[x].KODE+"</td>";
            txt += "<td align=left>&nbsp;"+data[x].NAMA+"</td>";
            txt += "<td align=left>&nbsp;"+data[x].SATUAN+"</td>";          
            txt += "<td align=right>"+(data[x].APPV_P).toLocaleString('en')+"&nbsp;</td>";
            txt += "<td align=right>"+(data[x].LAST_P).toLocaleString('en')+"&nbsp;</td>";          
            txt += "<td align=center><input type='image' src='/images/edit.png'  onclick='button_click("+'"EDIT"'+","+data[x].RECID+","+y+")'><input type='image' src='/images/del.png'  onclick='if (warning("+'"Hapus Data"'+")) button_click("+'"DEL"'+","+data[x].RECID+","+y+")'></td>";                    
            txt += "</tr>";~;
          }
          print qq~
       }     
       txt += "</tbody>";
//       txt +="<input name=baris type='hidden' value="+x+">";     
//       txt +="<tr><td colspan=4 width=100% align=left><input type=submit name=save class='button button_green' value=Save></td></tr>";      
       txt +="</table>";             
       document.getElementById("list-isp").innerHTML = txt;               
   }      
 </script>
    <p><br>
    <form method=post action="/cgi-bin/colorbox.cgi">
    <input name="pages" type="hidden" value=sis_sup_01s>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="recid" id=recid type="hidden" value=0>
    <input name="add" id=add type="hidden" value="">
    <input name="del" id=del type="hidden" value="">
    <input name="edit" id=edit type="hidden" value="">                
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <input name="id" type="hidden" value="$in{id}">
    <input name="jns" type="hidden" value="$in{jns}">                       
    <table width=700 border="0" cellspacing="1" cellpadding="1">
        <tr height="24" bgcolor=#0>
            <td colspan=3 align=center class="hurufcol"><strong>APPROVE ITEM SUPPLIER</strong></td>
        </tr>
    </table>
   <div id="list-isp" class="table-scroll tb_800" style='height:75%;background-color:#808080;width:700px'>&nbsp;</div>
   </form>
<p><br>~;
print qq~
   <script language="javascript">       
     window.onload = create_json();     
   </script>
~;
style_module::use_numeral();     
}

1


