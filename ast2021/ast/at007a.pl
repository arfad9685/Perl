sub at007a {

genfuncast::view_header($in{ss}, $s3s[2], 'Add Kelompok Jenis');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{klpjenis}=~ s/\'/\ /g;
   $in{klpjenis}=~ s/\"/\ /g;
   $in{namaklp}=~ s/\'/\ /g;
   $in{namaklp}=~ s/\"/\ /g;
   $in{namaklp}= uc($in{namaklp});
   if ($in{klpjenis} and $in{namaklp})
   {
        
        $query = $dba1->prepare("select klpjenis, namaklp from klpjenisinv where klpjenis='$in{klpjenis}' OR namaklp='$in{namaklp}' ");
        $query->execute();
        @row = $query->fetchrow_array();
        if ($row[0]) { $warning = "<div class='warning_not_ok'>Jenis '$in{klpjenis}' / Nama Jenis '$in{namaklp}' sudah ada</div><br/> "; }
        else
        {  $q1 = $dba1->do("
            INSERT INTO KLPJENISINV (KLPJENIS, NAMAKLP, OPRCREATE) VALUES
            ('$in{klpjenis}', '$in{namaklp}', '$s3s[0]');");
           #$dba1->commit;
           if($q1!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Jenis</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Jenis</div><br/> ";}

           $in{klpjenis}='';
           $in{namaklp}='';

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
      <input name="pages" type="hidden" value=at007>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">TAMBAH KELOMPOK JENIS</h2> </td>
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
  <input type=hidden name=pages value=at007a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
    <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Kode Kelompok Jenis </td>
    <td class="hurufcol" ><input type=text name=klpjenis value='$in{klpjenis}' maxlength="6">
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Nama Kelompok Jenis </td>
    <td class="hurufcol" ><input type=text name=namaklp value='$in{namaklp}' class=huruf1 maxlength="30" size=35 style="text-transform: uppercase">
    </td>
  </tr>
     ~;


print qq~
    </td>
  </tr>
</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

