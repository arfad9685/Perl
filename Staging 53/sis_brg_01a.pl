sub sis_brg_01a {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory 
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";     
 style_module::use_warning();
 &con_inv1;
 &con_log0;   
   
 if ($in{ubah}) {
     $cnt=0; $query1="";
	 	  $tbl_field = $dbh->prepare("select distinct atp.tabel_field, atp.field_select, atp.field_number,atp.field_tipe from m_access_div ad
        inner join m_access_tabel atp on atp.tabel_nama='M_PRODUK' and atp.recid=ad.field_id where (ad.div_strkid like ? or ad.div_strkid like ?) and ad.field_access='W'
        and atp.table_id='ALL'");    
      if (index($rws,'S')  ne  (-1)) {
		       $tbl_field->execute('%','0');     
      } else {
		       $tbl_field->execute($in{div}.'%','1');
      }         
     while (@rec=$tbl_field->fetchrow())
     {
        if ($cnt>0) {
           $query1.=',';
        }
        $query1.= $rec[0];
        $name[$cnt] = "$rec[0]";
        if ($rec[2]==0) {
          $tipe[$cnt]   = "c";
        } else {
          $tipe[$cnt]   = "n";         
        }        
        if ($rec[3] eq 'checkbox') {
                  $isi[$cnt]="";
                  @val = split("/", $rec[1]);         
                  for(my $c=0; $c<scalar(@val);$c++) {
                     $isi[$cnt] .= $in{"$name[$cnt]$c"};
                  }
                  $in{"$name[$cnt]"} = $isi[$cnt];
         
        }
        $cnt++;
     }  
     $kolom="";
     $cnt=0;
     for ( $i = 0 ; $i < scalar(@name) ; $i++ ) {
        if ($in{$name[$i]}) {
          $in{$name[$i]} =~ s/'/''/;
          if ($kolom) {
                $kolom.=',';          
          }
          if ($tipe[$i] eq 'n') {
                 $kolom .= $name[$i]."=$in{$name[$i]}";
          } else {
                 $in{$name[$i]} = uc($in{$name[$i]});           
                 $kolom .= $name[$i]."='$in{$name[$i]}'";              
          }
        }  
     }

      $kolom="UPDATE M_PRODUK_ALL  SET ".$kolom." WHERE BRG_ID='$in{id}'";
      $up_menu=$dbh->do($kolom);
      if ($up_menu==0) {
            style_module::use_chkerror($dbh);
            $errormsg='Error. Cancel Proses. Hubungi MIS';
       } else {
            $errormsg='Data berhasil disimpan.';
       }       
      
     $cnt=0; $query1="";@name=();
	 	  $tbl_field = $dbh->prepare("select distinct atp.tabel_field, atp.field_select, atp.field_number,atp.field_tipe from m_access_div ad
        inner join m_access_tabel atp on atp.tabel_nama='M_PRODUK' and atp.recid=ad.field_id where (ad.div_strkid like ? or ad.div_strkid like ?) and ad.field_access='W'
        and atp.table_id='FOOD'");
     if (index($rws,'S')  ne  (-1)) {
		       $tbl_field->execute('%','0');     
     } else {
		       $tbl_field->execute($in{div}.'%','1');
     }    
     while (@rec=$tbl_field->fetchrow())
     {
        if ($cnt>0) {
           $query1.=',';
        }
        $query1.= $rec[0];
        $name[$cnt] = "$rec[0]";
        if ($rec[2]==0) {
          $tipe[$cnt]   = "c";
        } else {
          $tipe[$cnt]   = "n";         
        }        
        if ($rec[3] eq 'checkbox') {
                  $isi[$cnt]="";
                  @val = split("/", $rec[1]);         
                  for(my $c=0; $c<scalar(@val);$c++) {
                     $isi[$cnt] .= $in{"$name[$cnt]$c"};
                  }
                  $in{"$name[$cnt]"} = $isi[$cnt];
         
        }
        $cnt++;
     }  
     $kolom="";
     $cnt=0;
     for ( $i = 0 ; $i < scalar(@name) ; $i++ ) {
       if ($in{$name[$i]}) {
          $in{$name[$i]} =~ s/'/''/;
          if ($kolom) {
                $kolom.=',';          
          }
          if ($tipe[$i] eq 'n') {
                 $kolom .= $name[$i]."=$in{$name[$i]}";
          } else {
                 $in{$name[$i]} = uc($in{$name[$i]});           
                 $kolom .= $name[$i]."='$in{$name[$i]}'";              
          }
       }  
     }
    if  (($in{jenis} eq 'RM') || ($in{jenis} eq 'WIP')) {     
      $kolom="UPDATE M_PRODUK_FOOD  SET ".$kolom." WHERE BRG_ID='$in{id}'";
      $up_menu=$dbh->do($kolom);             
      
      if ($up_menu==0) {
            style_module::use_chkerror($dbh);
            $errormsg='Error. Cancel Proses. Hubungi MIS';
      } else {
            $errormsg='Data berhasil disimpan.';
      }
    }  
 }
 
if ($in{addkonv} eq 'ADD') {
      $newsat=$in{satuan0};
      $newkonv=$in{konv0};      
      $sql="INSERT INTO M_SATUAN_KONV (KODEBRG, KONVERSI, SATUAN, USER_UPDATED) VALUES ('$in{id}',$newkonv,'$newsat','$s3s[0]')";
      $up_menu=$dbh->do($sql);  
} elsif ($in{addkonv} eq 'DEL') {
      $newsat=$in{"satuan$in{idsat}"};
      $sql="DELETE FROM M_SATUAN_KONV WHERE KODEBRG='$in{id}' AND SATUAN='$newsat'";
      $up_menu=$dbh->do($sql);  
}

print qq~
<script type="text/javascript">
function button_click(update,id)
{
       document.getElementById("addkonv").value=update;
       document.getElementById("idsat").value=id;       
       submit();       
} 
</script>

    <p><br>
    <table width=85% border="0" cellspacing="1" cellpadding="1">
     <tr height="24" bgcolor=$header>
            <td colspan=3 align=center class="hurufcol"><strong>DATA BARANG</strong></td>
     </tr>~;
     $cnt=0;$query1="";
     my %hash;
     if (($in{jenis} eq 'RM') || ($in{jenis} eq 'WIP')) {
	 	    $tbl_field = $dbh->prepare("select atp.tabel_field, atp.field_desc, atp.field_tipe,
             atp.field_size, atp.field_maxlength, atp.field_null, atp.field_select,
             atp.field_number, atp.qr_db, atp.qr_table, atp.qr_display, atp.qr_key,
             trim(atp.qr_kondisi), atp.qr_sort, field_line, max(ad.field_access),atp.field_groupdesc, atp.field_urut from
             m_access_tabel atp  left outer join m_access_div ad on ad.field_id=atp.recid and (ad.div_strkid like ? or ad.div_strkid=?)
         where atp.tabel_nama='M_PRODUK' and atp.field_tipe<>'AUTO'
         group by atp.tabel_field, atp.field_desc, atp.field_tipe,
             atp.field_size, atp.field_maxlength, atp.field_null, atp.field_select,
             atp.field_number, atp.qr_db, atp.qr_table, atp.qr_display, atp.qr_key,
             atp.qr_kondisi, atp.qr_sort, field_line,atp.field_groupdesc, atp.field_urut
         order by atp.field_groupdesc, atp.field_urut");
     } elsif  ($in{jenis} eq 'ISP') {
	 	    $tbl_field = $dbh->prepare("select atp.tabel_field, atp.field_desc, atp.field_tipe,
             atp.field_size, atp.field_maxlength, atp.field_null, atp.field_select,
             atp.field_number, atp.qr_db, atp.qr_table, atp.qr_display, atp.qr_key,
             trim(atp.qr_kondisi), atp.qr_sort, field_line, max(ad.field_access),atp.field_groupdesc, atp.field_urut from
             m_access_tabel atp  left outer join m_access_div ad on ad.field_id=atp.recid and (ad.div_strkid like ? or ad.div_strkid=?)
         where atp.tabel_nama='M_PRODUK' and atp.field_tipe<>'AUTO' and atp.table_id<>'FOOD'
         group by atp.tabel_field, atp.field_desc, atp.field_tipe,
             atp.field_size, atp.field_maxlength, atp.field_null, atp.field_select,
             atp.field_number, atp.qr_db, atp.qr_table, atp.qr_display, atp.qr_key,
             atp.qr_kondisi, atp.qr_sort, field_line,atp.field_groupdesc, atp.field_urut
         order by atp.field_groupdesc, atp.field_urut");      
     } elsif ($in{jenis} eq 'NF') {
	 	    $tbl_field = $dbh->prepare("select atp.tabel_field, atp.field_desc, atp.field_tipe,
             atp.field_size, atp.field_maxlength, atp.field_null, atp.field_select,
             atp.field_number, atp.qr_db, atp.qr_table, atp.qr_display, atp.qr_key,
             trim(atp.qr_kondisi), atp.qr_sort, field_line, max(ad.field_access),atp.field_groupdesc, atp.field_urut from
             m_access_tabel atp  left outer join m_access_div ad on ad.field_id=atp.recid and (ad.div_strkid like ? or ad.div_strkid=?)
         where atp.tabel_nama='M_PRODUK' and atp.field_tipe<>'AUTO' and atp.table_id='ALL'
         group by atp.tabel_field, atp.field_desc, atp.field_tipe,
             atp.field_size, atp.field_maxlength, atp.field_null, atp.field_select,
             atp.field_number, atp.qr_db, atp.qr_table, atp.qr_display, atp.qr_key,
             atp.qr_kondisi, atp.qr_sort, field_line,atp.field_groupdesc, atp.field_urut
         order by atp.field_groupdesc, atp.field_urut");            
     }
     if (index($rws,'S')  ne  (-1)) {
		       $tbl_field->execute('%','0');     
     } else {
		       $tbl_field->execute($in{div}.'%','1');
     }    
     while (@rec=$tbl_field->fetchrow())
     {
        if ($cnt>0) {
           $query1.=',';
        }
        $query1.= $rec[0];
        $name[$cnt] = "$rec[0]";
        $cols[$cnt]   = "$rec[1]";
        if (($rec[15] eq 'W') ) {

           if ($rec[2] eq 'query') {
	             $type[$cnt]  = "$rec[2]";
              if (index($rec[12],'=') ne (-1)) {
               $rec[12]=$rec[12]."'".$in{id}."'";
              }
              if ($rec[8] eq 'dbl') {
                 @{ $hash{'qr'.$cnt}} =  ($dbh1,"m_satuan_konv","$rec[10]","$rec[11]","$rec[12]","$rec[13]");               
             } else {
                 @{ $hash{'qr'.$cnt}} =  (${"$rec[8]"},"$rec[9]","$rec[10]","$rec[11]","$rec[12]","$rec[13]");
             }   
              $query[$cnt]   =  \@{ $hash{'qr'.$cnt}};              
            } else {
              $type[$cnt] = "$rec[2]";
              $query[$cnt]   =  "$rec[6]";          
            }

         
        } else {
         
           if ($rec[2] eq 'query' && $rec[8] ne 'dbl') {
	             $type[$cnt]  = "$rec[2]";
              if (index($rec[12],'=') ne (-1)) {
               $rec[12]=$rec[12].$in{id};
              }
              @{ $hash{'qr'.$cnt}} =  (${"$rec[8]"},"$rec[9]","$rec[10]","$rec[11]","$rec[12]","$rec[13]","","","readonly");
              $query[$cnt]   =  \@{ $hash{'qr'.$cnt}};              
            } else {
              $type[$cnt] = "readonly";
              $query[$cnt]   =  "";
            }                           
        }  
        $length[$cnt] = "$rec[3]";
        $nl[$cnt] = "$rec[14]";
        if ($rec[7]==1) { $align[$cnt]="right"; } else { $align[$cnt]="left"; }
        if ($rec[5]==1) { $must[$cnt]="Y"; } else { $must[$cnt]=""; }                                        
        $cnt++;
     }
    
     
 sub select_ccost {
		 ($d1) = @_;
    if  (($in{jenis} eq 'RM') || ($in{jenis} eq 'WIP')) {
	 	   $tbl_menu = $dbh->prepare("select $query1 FROM M_PRODUK_ALL A
       INNER JOIN M_PRODUK_FOOD F ON F.BRG_ID=A.BRG_ID WHERE trim(A.BRG_ID)='$d1' ");
    } elsif ($in{jenis} eq 'ISP') {
	 	   $tbl_menu = $dbh->prepare("select $query1 FROM M_PRODUK_ALL A
       INNER JOIN M_PRODUK_ISP F ON F.BRG_ID=A.BRG_ID WHERE trim(A.BRG_ID)='$d1' ");     
    } elsif ($in{jenis} eq 'NF') {
	 	   $tbl_menu = $dbh->prepare("select $query1 FROM M_PRODUK_ALL A
       INNER JOIN M_PRODUK_NONFOOD F ON F.BRG_ID=A.BRG_ID WHERE trim(A.BRG_ID)='$d1' ");     
    } 
		 $tbl_menu->execute();
		 @row = $tbl_menu->fetchrow_array();
		 return @row;
	}	
 
	if ( !$errormsg ) {
		@row = select_ccost($in{id});
		print qq~
            <form method=post action="/cgi-bin/colorbox.cgi" onSubmit="return warning('Simpan Data');">
                <input name="pages" type="hidden" value=sis_brg_01a>
                <input name="ss" type="hidden" value="$in{ss}">
                <input name="id" type="hidden" value="$in{id}">
                <input name="div" type="hidden" value="$in{div}">
                <input name="jenis" type="hidden" value="$in{jenis}">                                    
                <input name="lok_prg" type="hidden" value="$in{lok_prg}">
                <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
                <input name="menuid" type="hidden" value=$in{menuid}>
               ~;
                form_updata(\@cols,\@name,\@length,\@type,\@query,\@row,\@nl,\@align,\@must);
                print qq~
                <tr>
                    <td colspan=3 align="left">~;
                       print qq~<input type="submit" name="ubah" value="Simpan" class="button button_green">~;                     
                    print qq~
                    </td>
                </tr>
            </form>
 
    <form method=post action="/cgi-bin/colorbox.cgi">
    <input name="pages" type="hidden" value=sis_brg_01a>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="id" type="hidden" value="$in{id}">
	   <input name="jenis" type="hidden" value="$in{jenis}">
    <input id="idsat" name="idsat" type="hidden" value=0>
    <input id="addkonv" name="addkonv" type="hidden" value="">        
    <input name="div" type="hidden" value="$in{div}">                    
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>        
    <tr>
        <td align="center" valign="middle" bgcolor="#545454" class="hurufcol">&nbsp;Konversi<br>        
        </td>
        <td colspan=2>
         <table width=60% border=1 style="border-collapse:collapse">
         <tr bgcolor=grey> 
           <td align=center class="hurufcol" width=100>= </td>
           <td align=center class="hurufcol">Satuan</td>~;
           if (index($rws,'W') ne (-1)) {
             print qq~ 
             <td align=center class="hurufcol" width=100>Action</td>~;
           }
           print qq~
          </tr>~;
           if (index($rws,'W') ne (-1)) {
            print qq~ 
            <tr> 
              <td align=center class="hurufcol" width=100><input name=konv0 class=input-qty maxlength="5"></td>
              <td align=center class="hurufcol"><select name=satuan0>~;
              drop_down_1($dbh,'M_SATUAN','SATUAN','SATUAN','',1,'');
              print qq~
              </select></td>        
              <td align=center class="hurufcol" width=100>
               &nbsp;<input type='image' src='/images/add.png' onclick="if (warning('Add Data')) button_click('ADD',0)">
              </td>
             </tr>~;
           }  
          $cnt=1;
	 	       $tbl_konv = $dbh->prepare("select KONVERSI, SATUAN, RECID FROM M_SATUAN_KONV WHERE KODEBRG=? order by recid");   
		        $tbl_konv->execute($in{id});
		        while (@row = $tbl_konv->fetchrow_array()) 
          {
          print qq~
           <input id="satuan$cnt" name="satuan$cnt" type="hidden" value=$row[1]>              
           <tr> 
            <td align=right class="huruf2" width=100>$row[0]&nbsp;</td>
            <td align=left class="huruf2">&nbsp;$row[1]</td>~;
            if (index($rws,'W') ne (-1)) {
             print qq~
              <td align=center class="huruf2" width=100>
               &nbsp;<input type='image' src='/images/del.png' onclick="if (warning('Hapus Data')) button_click('DEL',$cnt)">
              </td>~;
            }
            print qq~
           </tr>~;
           $cnt++;
          }     
          print qq~                    
          </table>               
        </td>
    </tr>
    </form>~;
 }
 print qq~
    </table>
    <p> 
    <hr width="100" />
        $errormsg
</center>
~;
  if ($in{ubah}) {
   print qq~        
   <script language="javascript">       
    window.onload = parent.jQuery.fn.colorbox.resize({width:'400px' , height:'200px'});
   </script>~;
  } 

 style_module::use_numeral();   
}

1

