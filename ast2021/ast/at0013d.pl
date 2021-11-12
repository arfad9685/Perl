sub at0013d {

genfuncast::view_header($in{ss}, $s3s[2], 'Detail Terima Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');
&koneksi_ast2;

@kondisi = ('L','R');
@kondisitext = ('Layak','Rusak');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if($in{from})
{ $frompage=$in{from};
  if($in{sid}){  $addhidden=qq~<input name="sid" type="hidden" value=$in{sid}>~;  } #dari Serah Detail
  elsif($in{kd}){  $addhidden=qq~<input name="kd" type="hidden" value=$in{kd}>~; } #dari Detail Inventori
}
else {$frompage="at0012"; $addhidden=""; }

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=$frompage> $addhidden
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Detail Terima Inventori</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td> ~;
   print qq~
     </table>   $warning
~;

if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function toprint(n)
{  with(document.st)
   { pages.value='at0013p';
     recid.value=n;
     submit();
   }
}
</script>
 $warning_del
<FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='st'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0013p>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=recid value=>
 ~;
}


#print ("select nosurat, dtkirim,c.namacabang,jenis,nik,nlengkap,OPRCREATE from kirimh kh, getstruk c, getkry k where kh.cabang_tuj=c.kodecabang and kh.idlama_tuj=k.idlama and recid=$in{rid}");

if($in{rid})
{ $query = $dba1->prepare("select distinct kh.nosurat,kh.dtkirim,c.namacabang,kh.jenis,k.nik,k.nlengkap,kh.oprcreate, kh.batal,
kd.cabang_asal,kd.idlama_asal, kh.flagpinjam
 from kirimh kh
 left outer join kirimd kd on kh.recid=kd.kirimid
 left outer join getstruk c on kd.cabang_asal=c.kodecabang
 left outer join getkry k  on kd.idlama_asal=k.idlama
 where kh.recid=$in{rid}");
  $query->execute();
  @record = $query->fetchrow_array();
  $dto= genfuncast::mdytodmy($record[1]);
  
if($record[10] eq 'K'){ $record[10]='Y'; }
else { $record[10]='N'; }
print qq~
  <table width='600px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;No. Surat </td>
    <td class="hurufcol" > $record[0]    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tanggal Terima </td>
    <td class="hurufcol" > $dto    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Dari </td>
    <td class="hurufcol" >  $record[4] - $record[5]   </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Cabang Asal </td>
    <td class="hurufcol" >$record[8] - $record[2]  </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Jenis </td>
    <td class="hurufcol" >  $record[3]  </td>
    </tr>
  <tr bgcolor=#dddddd height=20>
    <td class="hurufcol"> &nbsp;Pengembalian </td>
    <td class="hurufcol" >  <b>$record[10]</b>  </td>
    </tr>
  </table>   <br/> <br/>

  <table width='900px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=80> Kode   </td>
   <td align='center' class="hurufcol" width=120> Nama Inv </td>
   <td align='center' class="hurufcol" width=40> Merek </td>
   <td align='center' class="hurufcol" width=40> Tipe </td>
   <td align='center' class="hurufcol" width=50> Ukuran </td>
   <td align='center' class="hurufcol" width=50> Warna </td>
   <td align='center' class="hurufcol" width=80> Kondisi </td>
   <td align='center' class="hurufcol" width=100> Keterangan </td>~;
if($record[10] eq 'Y'){ print qq~<td align='center' class="hurufcol" width=80> Dari Peminjaman </td>~; }
print qq~  </tr>~;

if($record[7] eq 'Y' ){ $bg='#ccc';  }
else { $bg=$colcolor; }

$query = $dba1->prepare("select namaklp, kode, namajenis, merek, tipe , ukuran, warna, kd.kondisi, kd.ket,
 kd.idlama_asal,curridlama,kd.kondisi_asal,kd.ket_asal,kd.cabang_asal from kirimd kd,
 inventori i, jenisinv j, klpjenisinv ki
 where  kd.kodeinv=i.kode and i.jenis=j.jenis and j.klpjenis=ki.klpjenis and kirimid=$in{rid} order by namaklp
");
  $query->execute();
  $no=1;
  $tmpnik=""; $tmpklp="";
  while (@row = $query->fetchrow_array())
  {  $pemilik=""; $kondisi_asal=""; $ket_asal="";
     if($row[7] ne $row[11]){ $kondisi_asal="Dulu : <b>$row[11]</b>"; }
     if($row[8] ne $row[12]){ $ket_asal="Dulu : <b>$row[12]</b>"; }
     if($row[9] != $row[10] and $row[9]!=0)
     { $q = $dba2->prepare("select  nik, nlengkap from getkry where idlama='$row[9]'");
       $q->execute();
       @row2 = $q->fetchrow_array();
        $pemilik="$row2[0] - $row2[1]";
     }
     
     if($tmpklp ne $row[0])
     { print qq~ <tr bgcolor='$colcolor2' height=20>
        <td align='left' class="hurufcol" valign='top' colspan=10><b>$row[0]</b></td>
       </tr>~;
     }
     print qq~
    <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='center' class="hurufcol" valign='top'><a class=huruflink href="sisasset.cgi?pages=at0010d&kd=$row[1]&ss=$in{ss}&from=at0013d&rid=$in{rid}">$row[1]</a></td>
     <td align='left' class="hurufcol" valign='top'>$row[2]</td>
     <td align='center' class="hurufcol" valign='top'>$row[3]</td>
     <td align='center' class="hurufcol" valign='top'>$row[4]</td>
     <td align='center' class="hurufcol" valign='top'>$row[5]</td>
     <td align='center' class="hurufcol" valign='top'>$row[6]</td>
      <td align='center' class="hurufcol" valign='top'>$row[7]<br/> $kondisi_asal</td>
     <td align='left' class="hurufcol" valign='top'>$row[8]<br/> $ket_asal</td>~;
    if($record[10] eq 'Y')
    {  $q = $dba2->prepare("select nosurat, h.recid from kirimh h, kirimd d where h.recid=d.kirimid and kodeinv='$row[1]' and kembaliid=$in{rid}");
       $q->execute();
       @row2 = $q->fetchrow_array();
       print qq~<td align='center' class="hurufcol" width=80> <a class=huruflink href="sisasset.cgi?pages=at0017d&sid=$row2[1]&ss=$in{ss}&from=at0013d&rid=$in{rid}">$row2[0]</a></td>~;
    }

    print qq~</tr> ~;
    $no++;
    $tmpklp=$row[0];
  }
  
  $no--;
  print qq~ </table>
   ~;
}

print qq~
    <hr width="100" />
</center>~;
}


1

