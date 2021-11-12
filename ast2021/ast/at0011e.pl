sub at0011e {

genfuncast::view_header($in{ss}, $s3s[2], 'Edit Warna');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');

if ($in{simpan})
{  $in{namawarna}=~ s/\'/\ /g;
   $in{namawarna}=~ s/\"/\ /g;
   $in{namawarna}= uc($in{namawarna});
   if ($in{kd} and $in{namawarna})
   {
        
        $postall = $dba1->do("
            UPDATE WARNA SET  namawarna='$in{namawarna}', oprupdate='$in{oprupdate}'
            WHERE warna='$in{kd}';");
        #$dba1->commit;
        $warning = "<div class='warning_ok'>Sukses Edit Warna</div><br/> ";

   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
}

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=at0011>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">EDIT WARNA</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;
$query = $dba1->prepare("select warna,namawarna from  warna  WHERE  warna='$in{kd}' ");
$query->execute();
@record = $query->fetchrow_array();
print qq~
$warning
<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0011e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Kode Warna </td>
    <td class="hurufcol" >$in{kd}
    </td>
  </tr>

  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Nama Warna </td>
    <td class="hurufcol" ><input type=text name=namawarna value='$record[1]' class=huruf1  maxlength="10" size=12 style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

