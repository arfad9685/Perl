sub at009a {

genfuncast::view_header($in{ss}, $s3s[2], 'Tambah Ukuran Inv');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{ukuran}=~ s/\'/\ /g;
   $in{ukuran}=~ s/\"/\ /g;
   $in{namaukuran}=~ s/\'/\ /g;
   $in{namaukuran}=~ s/\"/\ /g;
   $in{namaukuran}= uc($in{namaukuran});
   if ($in{ukuran} and $in{namaukuran} )
   {

        $query = $dba1->prepare("select ukuran, namaukuran from ukuraninv where ukuran='$in{ukuran}' OR namaukuran='$in{namaukuran}' ");
        $query->execute();
        @row = $query->fetchrow_array();
        if ($row[0]) { $warning = "<div class='warning_not_ok'>Ukuran Inv '$in{ukuran}' / Nama Ukuran '$in{namaukuran}' sudah ada</div><br/> "; }
        else
        {  $q1 = $dba1->do("
            INSERT INTO UKURANINV (UKURAN,NAMAUKURAN, OPRCREATE) VALUES
            ('$in{ukuran}', '$in{namaukuran}','$s3s[0]');");

           #$dba1->commit;
           if($q1!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Ukuran Inv</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Ukuran Inv</div><br/> ";}

           $in{ukuran}='';
           $in{namaukuran}='';

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
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at009>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">TAMBAH UKURAN INV</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;
print qq~
$warning
<script type="text/javascript" src="/keyboard.js" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="/keyboard.css">
<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at009a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='500px' border='0' cellspacing='1' cellpadding='1'>
   <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Kode Ukuran Inventori </td>
    <td class="hurufcol" ><input type=text name=ukuran value='$in{ukuran}' maxlength="6" size=10>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Nama Ukuran Inventori </td>
    <td class="hurufcol" ><input type=text name=namaukuran value='$in{namaukuran}' class=huruf1  maxlength="30" size=35 style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

