sub at007e {

genfuncast::view_header($in{ss}, $s3s[2], 'Edit Kelompok Jenis');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');

if ($in{simpan})
{  $in{namaklp}=~ s/\'/\ /g;
   $in{namaklp}=~ s/\"/\ /g;
   $in{namaklp}= uc($in{namaklp});
   if ($in{kd} and $in{namaklp})
   {
        $postall = $dba1->do("
            UPDATE KLPJENISINV SET  namaklp='$in{namaklp}', oprupdate='$in{oprupdate}'
            WHERE klpjenis='$in{kd}';");
        #$dba1->commit;
        $warning = "<div class='warning_ok'>Sukses Edit Jenis</div><br/> ";
   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
}

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at007>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">EDIT KELOMPOK JENIS</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;
$query = $dba1->prepare("select klpjenis, namaklp from klpjenisinv  WHERE  klpjenis='$in{kd}' ");
$query->execute();
@record = $query->fetchrow_array();
print qq~
$warning
<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at007e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Kode Kelompok Jenis </td>
    <td class="hurufcol" >$in{kd}
    </td>
  </tr>

  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Nama Kelompok Jenis </td>
    <td class="hurufcol" ><input type=text name=namaklp value='$record[1]' class=huruf1 maxlength="30" size=35 style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

