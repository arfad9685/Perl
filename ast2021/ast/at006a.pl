sub at006a {

genfuncast::view_header($in{ss}, $s3s[2], 'Tambah Tipe Inv');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{tipe}=~ s/\'/\ /g;
   $in{tipe}=~ s/\"/\ /g;
   $in{namatipe}=~ s/\'/\ /g;
   $in{namatipe}=~ s/\"/\ /g;
   $in{namatipe}= uc($in{namatipe});
   $in{tipe}= uc($in{tipe});
   if ($in{tipe}  )
   {

        $query = $dba1->prepare("select tipe, namatipe from tipeinv where tipe='$in{tipe}' OR namatipe='$in{namatipe}' ");
        $query->execute();
        @row = $query->fetchrow_array();
        if ($row[0]) { $warning = "<div class='warning_not_ok'>Tipe Inv '$in{tipe}' / Nama Tipe '$in{namatipe}' sudah ada</div><br/> "; }
        else
        {  $q1 = $dba1->do("
            INSERT INTO TIPEINV (TIPE,JENIS, OPRCREATE) VALUES
            ('$in{tipe}', '$in{kat}','$s3s[0]');");

           #$dba1->commit;
           if($q1!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Tipe Inv</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Tipe Inv</div><br/> ";}

           $in{tipe}='';
           $in{jenis}='';
           $in{namatipe}='';

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
      <input name="pages" type="hidden" value=at006>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">TAMBAH TIPE INV</h2> </td>
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
  <input type=hidden name=pages value=at006a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Jenis Inventori</td>
    <td class="hurufcol" ><select name="kat" class="huruf1" id="kat">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT jenis,namajenis FROM JENISINV ORDER BY namajenis");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{kat} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1] </option>~;
}
print qq~
    </select>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Tipe Inventori </td>
    <td class="hurufcol" ><input type=text name=tipe value='$in{tipe}' maxlength="20" size='25' style="text-transform: uppercase">
    </td>
  </tr>
</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

