sub at0011a {

genfuncast::view_header($in{ss}, $s3s[2], 'Tambah Warna');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{warna}=~ s/\'/\ /g;
   $in{warna}=~ s/\"/\ /g;
   $in{namawarna}=~ s/\'/\ /g;
   $in{namawarna}=~ s/\"/\ /g;
   $in{namawarna}= uc($in{namawarna});
   if ($in{warna} and $in{namawarna})
   {
        
        $query = $dba1->prepare("select warna, namawarna from warna where warna='$in{warna}' OR namawarna='$in{namawarna}' ");
        $query->execute();
        @row = $query->fetchrow_array();
        if ($row[0]) { $warning = "<div class='warning_not_ok'>Warna '$in{warna}' / Nama Warna '$in{namawarna}' sudah ada</div><br/> "; }
        else
        {  $q1 = $dba1->do("
            INSERT INTO WARNA (WARNA, NAMAWARNA, OPRCREATE) VALUES
            ('$in{warna}', '$in{namawarna}', '$s3s[0]');");
           #$dba1->commit;
           if($q1!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Warna</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Warna</div><br/> ";}

           $in{warna}='';
           $in{namawarna}='';

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
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=at0011>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">TAMBAH WARNA</h2> </td>
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
  <input type=hidden name=pages value=at0011a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
    <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Kode Warna </td>
    <td class="hurufcol" ><input type=text name=warna value='$in{warna}' class=huruf1  maxlength="10" size=12>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Nama Warna </td>
    <td class="hurufcol" ><input type=text name=namawarna value='$in{namawarna}' class=huruf1  maxlength="10" size=12 style="text-transform: uppercase">
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

