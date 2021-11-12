sub at004b {

genfuncast::view_header($in{ss}, $s3s[2], 'Add Submenu');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{child}=~ s/\'/\ /g;
   $in{child}=~ s/\"/\ /g;
   $in{ket}=~ s/\'/\ /g;
   $in{ket}=~ s/\"/\ /g;
   if ($in{kd} and $in{child} and $in{ket})
   {    $query = $dba1->prepare("select child from X0000005 where child='$in{child}'");
        $query->execute();
        @row = $query->fetchrow_array();
        if ($row[0]) { $warning = "<div class='warning_not_ok'> Child '$in{child}' sudah ada</div><br/> "; }
        else
        {  $postall = $dba1->do("
            INSERT INTO X0000005 (PARENT, CHILD, KETCHILD, OPRCREATE) VALUES ('$in{kd}', '$in{child}', '$in{ket}', '$s3s[0]'); ");
           #$dba1->commit;
           $warning = "<div class='warning_ok'>Sukses Add Submenu</div><br/> ";
           $in{child}='';
           $in{ket}='';
        }
   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
}

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Master Menu" class="huruf1"/>
      <input name="pages" type="hidden" value=at004>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">ADD SUBMENU</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;
print qq~
$warning
<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at004b>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value='$in{kd}'>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Parent </td>
    <td class="hurufcol" >$in{kd}
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Child </td>
    <td class="hurufcol" ><input type=text name=child value='$in{child}' class=huruf1 maxlength="12">
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Keterangan Child</td>
    <td class="hurufcol" ><input type=text name=ket value='$in{ket}' class=huruf1 maxlength="20">
    </td>
  </tr>
</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

